/*
LICENSE:

This script and the nPose scripts are licensed under the GPLv2
(http://www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject
to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you
      must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in
Second Life and/or other virtual world platforms derived from Second Life (such
as OpenSim).  If the platform should allow more fine-grained permissions, then
"full perms" will mean the most permissive possible set of permissions allowed
by the platform.
*/

// --- constants and configuration
integer CAPTURE_RANGE = 8; // sensor range to find potential capture victims

integer DOMENU               = -800; // dialog control back to npose
integer DIALOG               = -900; // start dialog
integer DIALOG_RESPONSE      = -901; // eval dialog response
integer DIALOG_TIMEOUT       = -902; // got dialog timeout
integer SENSOR_START         = -233;
integer SENSOR_END           = -234;
integer SEND_CURRENT_VICTIMS = -237;
integer SEND_VICTIM_LIST     = -238;
integer MEM_USAGE            = 34334;
integer SEAT_UPDATE          = 35353;

integer RLV_RELAY_CHANNEL    = -1812221819;

string  BACKBTN      = "^";
string  ROOTMENU      = "RLVMain";
list    ROOT_BUTTONS = [ "Capture", "Victims" ]; // RLV menu default buttons

// the following rlv restrictions can be controlled with this plugin
list    RLV_RESTRICTIONS = [
    "- Chat/IM",   "sendchat,chatshout,chatnormal,recvchat,recvemote,sendim,startim,recvim",
    "- Inventory", "showinv,viewnote,viewscript,viewtexture,edit,rez,unsharedwear,unsharedunwear", 
    "- Touch",     "fartouch,touchall,touchworld,touchattach",
    "- World",     "shownames,showhovertextall,showworldmap,showminimap,showloc",
    "- Debug/Env", "setgroup,setdebug,setenv"
];

list IGNORED_RLV_RESTRICTIONS = [ "acceptpermission", "detach", "unsit",
                                  "sittp", "tploc", "tplure", "tplm" ];

list CLOTHING_LAYERS = [
    "gloves", "jacket", "pants", "shirt", "shoes", "skirt", "socks",
    "underpants", "undershirt", "", "", "", "", "alpha", "tattoo"
];

list ATTACHMENT_POINTS = [
    "", "chest", "skull", "left shoulder", "right shoulder", "left hand",
    "right hand", "left foot", "right foot", "spine", "pelvis", "mouth", "chin",
    "left ear", "right ear", "left eyeball", "right eyeball", "nose",
    "r upper arm", "r forearm", "l upper arm", "l forearm", "right hip",
    "r upper leg", "r lower leg", "left hip", "l upper leg", "l lower leg",
    "stomach", "left pec", "right pec", "", "", "", "", "", "", "", "", "neck",
    "root"
];

// --- global variables

// list of seated avatars cache
list    SeatedAvatarList = [];

// random channel for RLV responses
integer RlvReplyChannel;         
integer RlvReplyChannelClothing;
integer RlvReplyChannelAttachment;
integer RlvReplyListenHandle;

// objectKey as string for this prim, generated in state_entry and on_rez.
// used as RLV command caption and for force sit
string  MyKeyAsString;

string  RlvPingCommand; // cached RLV command to be able to respond to RLV ping
list    DialogStoreStrided; // storing dialog IDs stride: id, toucher, Path

string  Path;           // contains dialog path for RLV
key     NPosetoucherID; // who touched me
string  NPosePath;      // which npose dialog to show when rlv part finished

key     VictimKey;  // contains active victim key

// 2 strided list in form of name, key used to create menu of people to grab,
// and process responses.
list    VictimListStrided2; 
list    TempVictimsList    = [];

// for RLV base restrictions and reading them from a notecard
integer RlvBaseRestrictFlag = 0;
string  RlvBaseRestrictions;
key     NcQueryId;

// --- functions

string StringReplace( string str, string search, string replace )
{
    return llDumpList2String(
        llParseStringKeepNulls( str, [ search ], [] ), replace );
}

// returns the list of uuid's of seated AVs
list SeatedAvs()
{ 
    SeatedAvatarList = [];
    integer counter  = llGetNumberOfPrims();
    while( llGetAgentSize( llGetLinkKey(counter) ) != ZERO_VECTOR )
    {
        SeatedAvatarList += [ llGetLinkKey(counter) ];
        counter--;
    }    
    return SeatedAvatarList;
}

// write interface to npose Dialog script
key Dialog( key rcpt, string prompt, list choices, list utilitybuttons, integer page )
{
    
    key id = llGenerateKey();
    if( VictimKey != rcpt ){
        llMessageLinked( LINK_SET, DIALOG,
            (string)rcpt + "|" + prompt + "|" + (string)page + "|"
            + llDumpList2String( choices, "`" ) + "|"
            + llDumpList2String( utilitybuttons, "`" ), id);
    }
    return id;
}

// other rlv dialogs
AdminMenu( key toucher, string prompt, list buttons )
{
    list utilityBtns = [ BACKBTN ];
    key id           = Dialog( toucher, prompt + "\n" + Path + "\n",
                               buttons, utilityBtns, 0 );
    list addme       = [ id, toucher, Path ];
    integer index    = llListFindList( DialogStoreStrided, [ toucher ] );
    if( index == -1 )
    {
        DialogStoreStrided += addme;
    }
    else
    {
        DialogStoreStrided = llListReplaceList( DialogStoreStrided, addme, index - 1, index + 1 );
    }
}

// RLV start dialog
RlvRootMenu( key toucher )
{
    string victimName = llKey2Name( VictimKey );
    if( victimName == "" )
    {
        AdminMenu( toucher, "No victim active", ROOT_BUTTONS );
        return;
    }
    QueryRlvGetStatus( );
}

RlvRootMenuForControlledAvatar( key toucher, list activeRestrictions)
{
    string title = "Active victim is " + llKey2Name( VictimKey )
          + "\nActive restrictions: " + llDumpList2String( activeRestrictions, ", " )
          + "\n\n☑ ... set restriction active"
          + "\n☐ ... set restriction inactive\n"
          + "(Maybe not all retrictions can't be set inactive)\n";

    if( Path == ROOTMENU )
    {
        list additionalButtons = [ "Release", "Unsit", "- Undress", "- Attachments" ];
        // Jesa: todo: add button for undress/detach in future
        
        integer restrictionLength = llGetListLength( RLV_RESTRICTIONS );
        integer i=0;
        for( ; i < restrictionLength; i+=2 )
        {
            string restrictionGroup = llList2String( RLV_RESTRICTIONS, i );
            additionalButtons += [ restrictionGroup ];
        }
        AdminMenu( toucher, title, ROOT_BUTTONS + additionalButtons );
        return;    
    }

    // must be a submenu    
    list pathparts           = llParseString2List( Path, [":"], [] );
    string restrictionGroup  = llList2String( pathparts, 1 );
    integer restrictionIndex = llListFindList( RLV_RESTRICTIONS, [ restrictionGroup ] );
    list additionalButtons;
    if( -1 != restrictionIndex )
    {
        list    restrictions = llCSV2List(
            llList2String( RLV_RESTRICTIONS, restrictionIndex + 1 ) );
        integer restrictionLength = llGetListLength( restrictions );
        integer i;
        for( i=0; i < restrictionLength; i+=1 )
        {
            string restrictionName = llList2String( restrictions, i );
            if( -1 == llListFindList( activeRestrictions, [ restrictionName ] ) )
            {
                additionalButtons += [ "☐ " + restrictionName ];
            }
            else
            {
                additionalButtons += [ "☑ " + restrictionName ];
            }
        }
        AdminMenu( toucher, title, additionalButtons );
    }
}

RlvMenuClothingUnwear( key toucher, list clothingLayersWorn )
{
    string title = "The following clothing layers are worn:\n"
       + llDumpList2String( clothingLayersWorn, ", " )
       + "\n\nClick a button to try to detach this layer\n"
       + "(Beware some might be locked and can't be removed)\n";
    Path = ROOTMENU + ":Undress";
    AdminMenu( toucher, title, clothingLayersWorn );       
}

RlvMenuAttachmentDetach( key toucher, list attachmentPointsWorn )
{
    string title = "The following attachment points are worn:\n"
        + llDumpList2String( attachmentPointsWorn, ", " )
        + "\n\nClick a button to try to detach this attachment\n"    
       + "(Beware some might be locked and can't be removed)\n";
    Path = ROOTMENU + ":Detach";
    AdminMenu( toucher, title, attachmentPointsWorn );       
}

// send rlv commands to the RLV relay, usable for common format (not ping)
SendToRlvRelay( key victim, string rlvCommand )
{
    llSay( RLV_RELAY_CHANNEL, MyKeyAsString + "," + (string)victim + "," + rlvCommand );
}

QueryRlvGetStatus() {
    // query list of current RLV restrictions        
    llListenRemove( RlvReplyListenHandle );
    RlvReplyChannel = 10000 + (integer)llFrand(30000);
    RlvReplyListenHandle = llListen( RlvReplyChannel, "", NULL_KEY, "" );
    SendToRlvRelay( VictimKey, "@getstatus=" + (string)RlvReplyChannel );
    // => continue in event listen      
}

QueryWornClothes()
{
    // query list of current RLV restrictions        
    llListenRemove( RlvReplyListenHandle );
    RlvReplyChannelClothing = 10000 + (integer)llFrand(30000);
    RlvReplyListenHandle = llListen( RlvReplyChannelClothing, "", NULL_KEY, "" );
    SendToRlvRelay( VictimKey, "@getoutfit=" + (string)RlvReplyChannelClothing );
    // => continue in event listen      
}

QueryWornAttachments()
{
    // query list of current RLV restrictions        
    llListenRemove( RlvReplyListenHandle );
    RlvReplyChannelAttachment = 10000 + (integer)llFrand(30000);
    RlvReplyListenHandle = llListen( RlvReplyChannelAttachment, "", NULL_KEY, "" );
    SendToRlvRelay( VictimKey, "@getattach=" + (string)RlvReplyChannelAttachment );
    // => continue in event listen      
}

// release RLV victim and remove it from the victim list
ReleaseRlvVictim()
{
    SendToRlvRelay( VictimKey, "!release" );

    integer victimIndex = llListFindList( VictimListStrided2, [ VictimKey ] );
    if( victimIndex != -1 ) {
        VictimListStrided2  = llDeleteSubList( VictimListStrided2, victimIndex - 1, victimIndex );
    }
    
    VictimKey           = llList2Key( VictimListStrided2, -1 );
    llMessageLinked( LINK_SET, SEND_VICTIM_LIST, llList2CSV( VictimListStrided2 ), "" );
}

list ParseClothingOrAttachmentLayersWorn( string message, list names )
{           
    integer length = llStringLength( message );
    list    layersWorn = [];
    integer i;
    for( i=0; i < length; i+=1 )
    {
        string isWorn = llGetSubString( message, i, i );
        if( isWorn == "1" )
        {
            string layerName = llList2String( names, i );
            if( layerName != "" )
            {
                layersWorn += [ layerName ];
            }   
        }
    }    
    return layersWorn;
}

// --- states

default
{
    
    state_entry()
    {
        MyKeyAsString          = (string)llGetKey();

        // listen for RLV pings
        RlvPingCommand = "ping," + MyKeyAsString + ",ping,ping";
        llListen( RLV_RELAY_CHANNEL, "", NULL_KEY, RlvPingCommand ); 
        
        // reset npose core to get chatchannel from it
        llMessageLinked( LINK_SET, 999999, "", "" );
    }    
    
    link_message( integer sender, integer num, string str, key id )
    {
        list   params      = llParseString2List( str,     [ "," ], [] );
        string commandlist = llList2String(      params,  1 );
        list   params1     = llParseString2List( str,     [ "|" ], [] );
        string selection   = llList2String(      params1, 1 );  
        
        if( num == DIALOG_RESPONSE )
        {
            integer index  = llListFindList( DialogStoreStrided, [ id ] );
            Path           = llList2String(  DialogStoreStrided, index + 2 );
            NPosetoucherID = llList2Key(     DialogStoreStrided, index + 1 );
            list pathparts = llParseString2List( Path, [":"], [] );
            
            // llOwnerSay( "Path: '" + Path + "' Selection: " + selection );
            
            if( Path == ROOTMENU )
            {
                if( selection == "Capture" )
                {
                    Path += ":" + selection;
                    llSensor( "", NULL_KEY, AGENT, CAPTURE_RANGE, PI );
                    return;
                }

                else if( selection == "Victims" )
                {
                    // get current list of names for victims menu buttons
                    list victimsButtons;
                    integer stop = llGetListLength( VictimListStrided2 ) / 2;
                    integer n;
                    for( n = 0; n < stop; ++n )
                    {
                        victimsButtons += llList2String( VictimListStrided2, n * 2 );
                    }

                    // only menu up the victims if we have any else remenu current menu path
                    if( llGetListLength( victimsButtons ) > 0 )
                    {
                        Path += ":" + selection;
                        AdminMenu( NPosetoucherID, "Current active victim is "
                            + llKey2Name( VictimKey ) + ".\nSelect new active victim.",
                            victimsButtons );
                    }
                    else
                    {
                        RlvRootMenu( NPosetoucherID );
                    }
                    return;
                }

                else if( selection == "Release" )
                {
                    ReleaseRlvVictim();
                    RlvRootMenu( NPosetoucherID );
                    return;
                }
            
                else if( selection == "Unsit" )
                {
                    SendToRlvRelay( VictimKey, "@unsit=force" );
                    return;
                }
                
                else if( selection == "- Undress" )
                {
                    QueryWornClothes();
                    return;
                }
                else if( selection == "- Attachments" )
                {
                    QueryWornAttachments();
                    return;    
                }
                
                // restriction group menu selected?
                else if( llListFindList( RLV_RESTRICTIONS, [ selection ] ) != -1 )
                {
                    Path += ":" + selection;                            
                    QueryRlvGetStatus();
                    return;
                }
                
            } // Path == ROOTMENU
            
            else if( Path == ROOTMENU + ":Capture" )
            {
                index          = llListFindList( TempVictimsList, [ selection ] );
                if( index != -1 )
                {
                    // this is intended to capture menu selection. Send self the
                    // link message to grab
                    llMessageLinked( LINK_SET, RLV_RELAY_CHANNEL,
                        MyKeyAsString + "," + llList2String( TempVictimsList, index + 1 )
                        + ",grab", "" );
                
                    // clear all but our selected potential victim from TempVictimsList
                    // list for further processing
                    TempVictimsList = [ llList2String( TempVictimsList, index ),
                        llList2Key( TempVictimsList, index + 1 ) ];
                
                    // send them back to the nPose menu cause current victim doesn't
                    // update real time.  this will give time to update
                    Path = "";
                    llMessageLinked( LINK_SET, DOMENU, NPosePath, NPosetoucherID );
                    llSetTimerEvent( 30.0 );
                    return;
                }
            }
            
            else if( Path == ROOTMENU + ":Undress" )
            {
                if( -1 != llListFindList( CLOTHING_LAYERS, [ selection ] ) )
                {
                    SendToRlvRelay( VictimKey, "@remoutfit:" + selection + "=force" );  
                    llSleep( 0.5 );
                    QueryWornClothes();
                    return;
                }
                
                Path = ROOTMENU;    
                RlvRootMenu( NPosetoucherID );
                return;                 
            }
            
            else if( Path == ROOTMENU + ":Detach" )
            {
                if( -1 != llListFindList( ATTACHMENT_POINTS, [ selection ] ) )
                {
                    SendToRlvRelay( VictimKey, "@remattach:" + selection + "=force" );
                    llSleep( 0.5 );
                    QueryWornAttachments();    
                    return;
                }    
                
                Path = ROOTMENU;    
                RlvRootMenu( NPosetoucherID );
                return;                 
            }
            
            if( selection == BACKBTN && llListFindList( DialogStoreStrided, [ id ] ) != -1 )
            {
                // back button hit and Path is at root menu, remenu nPose
                if( Path == ROOTMENU )
                {
                    Path = "";
                    llMessageLinked( LINK_SET, DOMENU, NPosePath, NPosetoucherID );
                    integer index = llListFindList( DialogStoreStrided, [ NPosetoucherID ] );
                    if( index != -1 )
                    {
                        DialogStoreStrided = llDeleteSubList( DialogStoreStrided, index - 1, index + 1 );
                    }
                }

                else
                {
                    Path = ROOTMENU;    
                    RlvRootMenu( NPosetoucherID );
                }
            }
            
            // someone changed current victim..
            else if( llList2String( llParseString2List( Path, [":"], [] ), -1 ) == "Victims" )
            {
                integer victimIndex = llListFindList( VictimListStrided2, [ selection ] ) + 1;
                VictimKey = (key)llList2String( VictimListStrided2, victimIndex );
                llMessageLinked( LINK_SET, SEND_CURRENT_VICTIMS, VictimKey, "" );
                Path = ROOTMENU;
                RlvRootMenu( NPosetoucherID );
            }
            
            // add RLV restriction
            else if( llGetSubString( selection, 0, 0 ) == "☐" )
            {
                // string restrictionGroup = llList2String( pathparts, 1 );
                string restriction = llDeleteSubString( selection, 0, 1 );
                SendToRlvRelay( VictimKey, "@" + restriction + "=n" );    
                QueryRlvGetStatus();    
            }
            
            // remove RLV restriction
            else if( llGetSubString( selection, 0, 0 ) == "☑" )
            {
                // string restrictionGroup = llList2String( pathparts, 1 );
                string restriction = llDeleteSubString( selection, 0, 1 );    
                SendToRlvRelay( VictimKey, "@" + restriction + "=y" );
                QueryRlvGetStatus();    
            }
            
        } // end of DIALOG_RESPONSE

        // messages comming in from BTN notecard commands
        else if( num == RLV_RELAY_CHANNEL )
        {            
            if( llList2String(params, 0) == "release" )
            {
                // left here for legacy builds
                VictimKey = (key)llList2String( params, 1 );
                ReleaseRlvVictim();
//                llMessageLinked( LINK_SET, SEND_VICTIM_LIST, llList2CSV( VictimListStrided2 ), "" );
//                llInstantMessage(VictimKey, "Your restraints have been removed!");
            }
            
            else if( llList2String( params, 0 ) == "RlVcommand" )
            {
                string restraints = StringReplace( commandlist, "/","|" );
                if( restraints == "@clear" || restraints == "!release" )
                {
                    ReleaseRlvVictim();
//                    llMessageLinked( LINK_SET, SEND_VICTIM_LIST, llList2CSV( VictimListStrided2 ), "" );
                }
                else
                {
                    SendToRlvRelay( VictimKey, restraints );
                }
            }
            else if( llList2String( params, 0 ) == "menuUP" )
            {
                // we are on, so time to menu up with RLV stuff
                Path = ROOTMENU;
                RlvRootMenu( NPosetoucherID );
            }
            
            else if( llList2String( params, 0 ) == "read" )
            {
                // we've been asked to read a base restrictions card
                string rlvRestrictionsNotecard = llList2String( params, 1 );
                if( llGetInventoryType( rlvRestrictionsNotecard ) != -1 )
                {
                    NcQueryId = llGetNotecardLine( rlvRestrictionsNotecard, 0 );
                }
                else
                {
                    llWhisper( 0, "Error: rlvRestrictions Notecard + "
                        + rlvRestrictionsNotecard + " not found" );    
                }
            }
            
            else if( llList2String( params, 0 ) == "RLV=on" )
            {
                RlvBaseRestrictFlag = 1;
            }
            
            else if( llList2String( params, 0 ) == "RLV=off" )
            {
                RlvBaseRestrictFlag = 0;
            }
            
            // this option is expected to be used in a SATMSG for a trap
            // or automatic capture when someone sits
            else if( llList2String(params,2) == "grab" )
            {
                key potentialvictim = (key)llList2String( params, 1 );               
                if( llListFindList(SeatedAvs(), [ potentialvictim ] ) != -1
                    && llListFindList( VictimListStrided2, [ potentialvictim ] ) == -1 )
                {
                    // deal with seated AV's who are not in the victims list, SATMSG driven
                    VictimKey = potentialvictim;
                    llMessageLinked( LINK_SET, SEND_CURRENT_VICTIMS, VictimKey, "" );
                    // add them to victims list
                    VictimListStrided2 += [ llKey2Name( VictimKey ), VictimKey ]; 
                    
                    // clear the tempvictim list.. we done
                    TempVictimsList     = [];                            
                    if( RlvBaseRestrictFlag == 1 )
                    {
                        SendToRlvRelay( VictimKey, "!release" );
                        SendToRlvRelay( VictimKey, RlvBaseRestrictions );
                    }
                }
                
                else
                {
                    // this is used for the capture... don't remove it again howard !
                    SendToRlvRelay( potentialvictim, "@sit:" + MyKeyAsString + "=force" );
                }
                llMessageLinked( LINK_SET, SEND_VICTIM_LIST, llList2CSV( VictimListStrided2 ), "" );
            }
        
        } // end of RLV_RELAY_CHANNEL
                
        else if( num == DIALOG_TIMEOUT ) // menu not clicked and dialog timed out
        {
            integer index = llListFindList( DialogStoreStrided, [ id ] );
            if( index != -1 )
            {
                DialogStoreStrided = llDeleteSubList( DialogStoreStrided, index, index + 2 );
            }
        }
        
        // list of potential victims' names for buttons
        else if( num == SENSOR_END )
        {
            AdminMenu( NPosetoucherID, "Pick a victim to attempt capturing.", llCSV2List(str) );
        }
        
        // legacy version of menu: menu asking for a list of potential victims
        else if( num == SENSOR_START )
        { 
            llSensor( "", NULL_KEY, AGENT, CAPTURE_RANGE, PI );
        }
        
        // Jesa: what does -239 mean? => constant
        // request from menu to change current victim
        
        //modified by howard. if str and found in victims list, consider this a request to change current victim to another.
        //if str not found in victims list, send out existing current victim.
        else if( num == -239 )
        {
            integer index = llListFindList( VictimListStrided2, [str] );
            if (index != -1){
                 llList2Key( VictimListStrided2, index + 1 );
                llOwnerSay("menu changed victim, victim key: " + (string)VictimKey);
            }
            llMessageLinked( LINK_SET, SEND_CURRENT_VICTIMS, VictimKey, "" );
        }
        
        // Jesa: what does -802 mean? => constant
        // we get current nPose path and id here. use it to remenu nPose once we are finished.
        else if( num == -802 )
        {
            NPosePath      = str;
            NPosetoucherID = id;
        }

        else if( num == SEAT_UPDATE )
        {
            list slotsList    = llParseStringKeepNulls( str, ["^"], [] );
            integer seatCount = llGetListLength( slotsList ) / 8;
            integer x;
            for( x=0; x < seatCount; ++x )
            {
                key thisPotentialVic = (key)llList2String( slotsList, x * 8 + 4 );
                if( llListFindList( VictimListStrided2, [thisPotentialVic] ) != -1 ){
                    // this AV is already a victim
                    if( RlvBaseRestrictFlag == 1 )
                    {
                        SendToRlvRelay( thisPotentialVic, "!release" );
                        SendToRlvRelay( thisPotentialVic, RlvBaseRestrictions );
                    }
                }
                
                // this AV is in TempVictimsList list and has sat. make them
                // current victim and add them to victims list. This is assuming
                // the AV who just sat is being captured... find a fix
                else if( llListFindList( TempVictimsList, [ thisPotentialVic ] ) != -1 )
                {
                    VictimKey = thisPotentialVic;
                    llMessageLinked( LINK_SET, SEND_CURRENT_VICTIMS, VictimKey, "" );
                    VictimListStrided2 += [ llKey2Name( VictimKey ), VictimKey ]; // add them to victims list
                    if( RlvBaseRestrictFlag == 1 )
                    {
                        SendToRlvRelay( VictimKey, "!release" );
                        SendToRlvRelay( VictimKey, RlvBaseRestrictions );
                    }
                    TempVictimsList = [];
                    llSetTimerEvent( 0.0 );
                }
                
                // update the menu script to control who gets menu since we've captured this sitter
                llMessageLinked( LINK_SET, SEND_VICTIM_LIST, llList2CSV( VictimListStrided2 ), "" );
            }
        }
        
        else if( num == MEM_USAGE )
        {
            llSay( 0, "Memory Used by " + llGetScriptName() + ": "
                + (string)llGetUsedMemory() + " of " + (string)llGetMemoryLimit()
                + ", Leaving " + (string)llGetFreeMemory() + " memory free." );
        }        
        
        
                
    } // link_message
    
    changed( integer change )
    {
        if( change & CHANGED_OWNER )
        {
            llResetScript();
        }
        
        // clear out any victim who is no longer seated.
        SeatedAvatarList = SeatedAvs();
        integer stop     = llGetListLength( VictimListStrided2 ) / 2;
        integer n;
        for( n = 0; n < stop; ++n )
        {
            key thisSeatedAV = llList2Key( VictimListStrided2, ( n * 2 ) + 1 );
            integer index = llListFindList( SeatedAvatarList, [ thisSeatedAV ] );
            if( index == -1 )
            {
                // Jesa: is this the same as in ReleaseRlvVictim? it not,
                //       does this mean the same and which is better?
                SendToRlvRelay( thisSeatedAV, "!release" );
                VictimListStrided2 = llDeleteSubList( VictimListStrided2, n * 2, n * 2 + 1 );
                
                if( llListFindList( VictimListStrided2, [ VictimKey ] ) == -1 )
                {
                    if( llGetListLength( VictimListStrided2 ) >= 1 )
                    {
                        VictimKey = llList2Key( VictimListStrided2, -1 );
                        llMessageLinked( LINK_SET, SEND_CURRENT_VICTIMS, VictimKey, "" );
                    }
                    else
                    {
                        VictimKey = "";
                    }
                }
                --n;
                --stop;
            }
        }
        llMessageLinked( LINK_SET, SEND_VICTIM_LIST, llList2CSV(VictimListStrided2), "" );
    }    
    
    dataserver( key id, string data )
    {
        if( id == NcQueryId )
        {
            RlvBaseRestrictions = StringReplace( data, "/", "|" );
        }
    }    

    listen( integer channel, string name, key id, string message )
    {
        if( channel == RLV_RELAY_CHANNEL )
        {
            if( message == RlvPingCommand )
            {
                // Jesa: implementation of nobody sat is missing, comment seems faulty
                // pong if no one sat
                llSay( RLV_RELAY_CHANNEL, "ping," + (string)llGetOwnerKey(id) + ",!pong" );
            }
        }
        else if( channel == RlvReplyChannel )
        {
            llListenRemove( RlvReplyListenHandle );
            list restrictions = llParseString2List( message, [ "/" ], [] );

            list usedRestrictions = [];
            integer length = llGetListLength( restrictions );
            integer i;
            for( i=0; i < length; i+=1 ) {
                string restrictionName = llList2String( restrictions, i );
                if( llSubStringIndex( restrictionName, ":" ) != -1 )
                {
//                    llOwnerSay( "ignoring: " + restrictionName );
                }
                else if( -1 != llListFindList( IGNORED_RLV_RESTRICTIONS, [ restrictionName ] ) )
                {
//                    llOwnerSay( "ignoring: " + restrictionName );
                }
                else {
                    usedRestrictions += [ restrictionName ];    
                }
            } // for i
            
            
             
            RlvRootMenuForControlledAvatar( NPosetoucherID, usedRestrictions );    
        }
        
        else if( channel == RlvReplyChannelClothing )
        {
            llListenRemove( RlvReplyListenHandle );
            // gloves,jacket,pants,shirt,shoes,skirt,socks,underpants,undershirt,skin,eyes,hair,shape,alpha,tattoo
            list clothingLayersWorn = ParseClothingOrAttachmentLayersWorn( message, CLOTHING_LAYERS );
            RlvMenuClothingUnwear( NPosetoucherID, clothingLayersWorn );
        }
        
        else if( channel == RlvReplyChannelAttachment )
        {
            llListenRemove( RlvReplyChannelAttachment );
            // none,chest,skull,left shoulder,right shoulder,left hand,right hand,left foot,right foot,spine,
            // pelvis,mouth,chin,left ear,right ear,left eyeball,right eyeball,nose,r upper arm,r forearm,
            // l upper arm,l forearm,right hip,r upper leg,r lower leg,left hip,l upper leg,l lower leg,stomach,left pec,
            // right pec,center 2,top right,top,top left,center,bottom left,bottom,bottom right,neck,root
            list attachmentPointsWorn = ParseClothingOrAttachmentLayersWorn( message, ATTACHMENT_POINTS );
            RlvMenuAttachmentDetach( NPosetoucherID, attachmentPointsWorn );
        }
        
        
    } // listen

    timer()
    {
        // wait 30 seconds and then clear out the TempVictimsList list. this will
        // effectively disable grabbing someone else if intended victim didn't
        // sit possible reason: no RLV relay so they don't get grabbed,
        TempVictimsList = [];
        if( llListFindList( SeatedAvs(), [ VictimKey ] ) == -1 )
        {
            VictimKey = llList2Key( VictimListStrided2, -1 );
            llMessageLinked( LINK_SET, SEND_CURRENT_VICTIMS, VictimKey, "" );
        }
        llSetTimerEvent( 0.0 );
    }
    
    sensor( integer num )
    {
        // give menu the list of potential victims
        TempVictimsList     = [];
        list victimsbuttons = [];
        integer n;
        for( n=0; n<num; ++n )
        {
            victimsbuttons   = victimsbuttons + [ llGetSubString( llDetectedName(n), 0, 20) ]; 
            TempVictimsList += [ llGetSubString( llDetectedName(n), 0, 20), llDetectedKey(n) ];
        }
        llMessageLinked( LINK_SET, SENSOR_END, llList2CSV( victimsbuttons ), NPosetoucherID );
    }    

    no_sensor()
    {
        TempVictimsList = [];
        llMessageLinked( LINK_SET, SENSOR_END, "", "" );
    }
    
    on_rez( integer param )
    {
        MyKeyAsString = (string)llGetKey();
        llMessageLinked( LINK_SET, -390390, "RUThere", "" );
        llMessageLinked( LINK_SET, 999999, "", "" );
    }
    
} // state default

/*
USAGE

put this script into an object together with at least the following npose scripts:
- nPose Core
- nPose Dialog
- nPose menu
- nPose Slave
- nPose SAT/NOSAT handler

Add a notecard with name:
BTN:-RLV-
and content:
LINKMSG|-1812221819|menuUP|%AVKEY%

Add a notecard with the name
MyBaseRLVrestrictions(firstSet)
and content:
@unsit=n/@sittp=n/@tploc=n/@tplure=n/@tplm=n/@acceptpermission=add

Add something like the following to your DEFAULT notecard:
LINKMSG|-1812221819|read,MyBaseRLVrestrictions(firstSet)
LINKMSG|-240|menuonsit=off~2default=off~facialExp=on~sit2getmenu=on~rlvbaser=on~permit=Public

Finished

You can also use the old behaviour with the BTN or SET commands, but then you need to use a
different menu name (not -RLV-, depending on the BTN:-RLV-).

*/
