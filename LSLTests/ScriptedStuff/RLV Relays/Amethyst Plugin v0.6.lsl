//== RestrainedLife Viewer Relay Script
//==  by Felis Darwin
//== Based on Reference Implementation by Marine Kelley
 
integer DEBUG = FALSE;
 
// ---------------------------------------------------
//              Amethyst Plugin Variables
// ---------------------------------------------------
 
key nullkey = NULL_KEY;
string nullstr = "";
 
integer secaccess=0; //== Do secondary owners have access to the RL functions?
 
// Internal variables
key ownerkey = nullkey;
list secowners = [];
 
key setby = nullkey; //== Who set the RLV Relay status?
 
integer lockstatus; //== Has the collar been locked by the RLV plugin?
 
string ownerexcept = "@sendim @sendim_sec @tplure @tplure_sec"; //== List of restrictions owner (not wearer) will always be exempt from
 
// ---------------------------------------------------
//                     Constants
// ---------------------------------------------------
 
integer RLVRS_PROTOCOL_VERSION = 1100; // version of the protocol, stated on the specification page
string RLVRS_IMPL_VERSION = "Felis Darwin's implementation (Amethyst Plugin version)";
 
integer MAX_TIME_AUTOACCEPT_AFTER_FORCESIT = 60; // seconds
 
integer PERMISSION_DIALOG_TIMEOUT = 30;
 
integer LOGIN_DELAY_WAIT_FOR_PONG = 20;
 
integer PING_INTERVAL = 60; //== Time between pings, and time waiting for force-sit
 
// ---------------------------------------------------
//                      Variables
// ---------------------------------------------------
 
integer nMode;
 
list lRestrictions; // restrictions currently applied (without the "=n" part)
key kSource;        // UUID of the object I'm commanded by, always equal to nullkey if lRestrictions is empty, always set if not
key kController;    // UUID of the person controlling the object, if passed to us by the !who command
 
list WhiteBlack = []; //== A combined white/black list of residents.  Whitelisting exempts them from ask mode.  Blacklisting prevents their objects from even interacting with you.
 
string sPendingName; // name of initiator of pending request (first request of a session in mode 1)
key sPendingId;      // UUID of initiator of pending request (first request of a session in mode 1)
string sPendingMessage; // message of pending request (first request of a session in mode 1)
integer sPendingTime;
 
// used on login
integer timerTickCounter; // count the number of time events on login (forceSit has to be delayed a bit)
integer loginWaitingForPong;
integer loginPendingForceSit;
 
integer noping = 0;
 
key     lastForceSitDestination = nullkey;
integer lastForceSitTime;
 
integer stop = 0; //== Allows the relay to stop mid-command execution if directed to by another command
 
// ---------------------------------------------------
//               Low Level Communication
// ---------------------------------------------------
 
 
debug(string x)
{
    if (DEBUG)
    {
        llOwnerSay("DEBUG: " + x);
    }
}
 
// acknowledge or reject
ack(string cmd_id, key id, string cmd, string ack)
{
    if(id != nullkey)
        llShout(-1812221819, cmd_id + "," + (string)id + "," + cmd + "," + ack);
}
 
 
// get current mode as string
string getModeDescription()
{
    if (nMode == 0) return "RLV Relay is OFF"; 
    if (nMode == 1) return "RLV Relay is ON (permission needed)";
    if (nMode == 2) return "RLV Relay is ON (auto-accept)"; 
    return "RLV Relay is ON (owners + whitelist only)";
}
 
// ---------------------------------------------------
//               Permission Handling
// ---------------------------------------------------
 
// are we already under command by this object?
integer isObjectKnow(key id)
{
    // are we not under command by any object but were we forced to sit on this object recently?
    if (id != nullkey && (kSource == id || ((kSource == nullkey) && (id == lastForceSitDestination) && (lastForceSitTime + MAX_TIME_AUTOACCEPT_AFTER_FORCESIT > llGetUnixTime()))))
    {
        return TRUE;
    }
 
    return FALSE;
}
 
 
// check whether the object is in llSay distance.
// The specification requires llSay instead of llShout or llRegionSay
// to be used to limit the range. But this has to be checked here again
// because the objects are not trustworthy.
integer isObjectNear(key id)
{
    vector myPosition = llGetRootPosition();
    list temp = llGetObjectDetails(id, ([OBJECT_POS]));
    vector objPosition = llList2Vector(temp,0);
    if(temp == []) objPosition = <1000.0, 1000.0, -1000.0>;
    float distance = llVecDist(objPosition, myPosition);
    return distance <= 100;
}
 
// do a basic check on the identity of the object trying to issue a command
integer isObjectIdentityTrustworthy(key id)
{
    key parcel_owner=llList2Key (llGetParcelDetails (llGetPos (), [PARCEL_DETAILS_OWNER]), 0);
    key parcel_group=llList2Key (llGetParcelDetails (llGetPos (), [PARCEL_DETAILS_GROUP]), 0);
    key object_owner=llGetOwnerKey(id);
    key object_group=llList2Key (llGetObjectDetails (id, [OBJECT_GROUP]), 0);
 
    debug("owner= " + (string) parcel_owner + " / " + (string) object_owner);
    debug("group= " + (string) parcel_group + " / " + (string) object_group);
 
    if (object_owner==llGetOwner ()        // IF I am the owner of the object
      || object_owner==parcel_owner        // OR its owner is the same as the parcel I'm on
      || (object_owner==ownerkey && ownerkey != nullkey) //== Is this my owner's stuff?
      || ~llListFindList(secowners, [object_owner]) //== ...or my owners' stuff?
      || (object_group==parcel_group && object_group != nullkey)       // OR its group is the same as the parcel I'm on
    )
    {
        return TRUE;
    }
    return FALSE;
}
 
 
// Is this a simple request for information or a meta command like !release?
integer isSimpleRequest(list list_of_commands) 
{
    integer len = llGetListLength(list_of_commands);
    integer i;
 
    debug("Checking simplicity of commands...");
 
    // now check every single atomic command
    for (i=0; i < len; ++i)
    {
        string command = llList2String(list_of_commands, i);
        if (!isSimpleAtomicCommand(command))
        {
           debug("Command "+ command +" fails simplicity check.");
           return FALSE;
        }
    }
 
    // all atomic commands passed the test
    return TRUE;
}
 
// is this a simple atmar command
// (a command which only queries some information or releases restrictions)
// (e. g.: cmd ends with "=" and a number (@version, @getoutfit, @getattach) or is a !-meta-command)
integer isSimpleAtomicCommand(string cmd)
{    
    // check right hand side of the "=" - sign
    integer index = llSubStringIndex (cmd, "=");
    // check for a number after the "="
    string param = llGetSubString (cmd, index + 1, -1);
    if ((((((integer)param!=0 || param=="0") && llSubStringIndex(param, "n") <= -1 && llSubStringIndex(param, "add")<= -1) || param == "y" || param == "rem") || index == -1) || llSubStringIndex(cmd, "!") == 0 || cmd == "@clear") // is it an integer (channel number) or empty?
    {
        return TRUE;
    }
 
    // this one is not "simple".
    return FALSE;
}
 
// If we already have commands from this object pending
// because of a permission request dialog, just add the
// new commands at the end.
// Note: We use a timeout here because the player may
// have "ignored" the dialog.
integer tryToGluePendingCommands(key id, string commands)
{
    if (kSource == nullkey && (sPendingId == id) && (sPendingTime + PERMISSION_DIALOG_TIMEOUT > llGetUnixTime()) && llGetFreeMemory() > 500)
    {
        debug("Gluing " + sPendingMessage + " with " + commands);
        sPendingMessage = (sPendingMessage=nullstr) + sPendingMessage + "|" + commands;
        return TRUE;
    }
    return FALSE;
}
 
// verifies the permission. This includes mode 
// (off, permission, auto) of the relay and the
// identity of the object (owned by parcel people).
integer verifyPermission(key id, string name, string message)
{
    debug("Verifying permission for command "+ message);
 
    // extract the commands-part
    list tokens = llParseString2List (message, [","], []);
    if (llGetListLength (tokens) < 3 || nMode == 0 || ~llListFindList(WhiteBlack, ["-"+(string)llGetOwnerKey(id)]) || ~llListFindList(WhiteBlack, ["-"+(string)kController]) || (nMode == 3 && llGetOwnerKey(id) != ownerkey && !~llListFindList(secowners, [llGetOwnerKey(id)]) && !~llListFindList(WhiteBlack,[llGetOwnerKey(id)])))
    {
        kController = nullkey;
        return FALSE;
    }
    string commands = llList2String(tokens, 2);
    list list_of_commands = llParseString2List(commands, ["|"], []);
 
    // accept harmless commands silently
    if (isSimpleRequest(list_of_commands) || ~llListFindList(WhiteBlack, [llGetOwnerKey(id)]))
    {
        debug("simple command or Owner in Whitelist, executing.");
        return TRUE;
    }
 
    // if we are already having a pending permission-dialog request for THIS object,
    // just add the new commands at the end of the pending command list.
    if (tryToGluePendingCommands(id, commands))
    {
        debug("Appending to store of commands pending approval.");
        return FALSE; //== Glue the commands and process them later
    }
 
    // check whether this object belongs here
    integer trustworthy = isObjectIdentityTrustworthy(id);
    string warning = nullstr;
    if (!trustworthy)
    {
        warning = "\n\nWARNING: This object is not owned by the people owning this parcel. Unless you know the owner, you should deny this request.";
    }
 
    // ask in permission-request-mode and/OR in case the object identity is suspisous.
    if ((nMode == 1 || !trustworthy))
    {
        sPendingId=id;
        sPendingName=name;
        sPendingMessage=message;
        sPendingTime = llGetUnixTime();
 
        list opts = ["Yes", "No"];
 
        llSetTimerEvent(2.0);
 
        if(llKey2Name(llGetOwnerKey(id)) != nullstr)
        {
            name += " (owned by "+llKey2Name(llGetOwnerKey(id))+")";
            opts += ["Never", "Always"];
        }
 
        if(llKey2Name(kController) != nullstr)
        {
            name = llKey2Name(kController) +", using "+ name +",";
            opts += ["Never"];
        }
 
        llDialog (llGetOwner(), name + " would like control your viewer." + warning + "\n\nDo you accept ?", llList2List(opts,0,3), -1812220409);
        debug("Asking for permission");
        return FALSE;
    }
    return TRUE;
}
 
 
// ---------------------------------------------------
//               Executing of commands
// ---------------------------------------------------
 
// execute a non-parsed message
// this command could be denied here for policy reasons, (if it were implemenetd)
// but this time there will be an acknowledgement
execute(string name, key id, string message)
{
    stop = 0;
 
    list tokens=llParseString2List (message, [","], []);
    if (llGetListLength (tokens)==3) // this is a normal command
    {
        string cmd_id=llList2String (tokens, 0); // CheckAttach
        key target=llList2Key (tokens, 1); // UUID
        if (target==llGetOwner ()) // talking to me ?
        {
            list list_of_commands=llParseString2List (llList2String (tokens, 2), ["|"], []);
            integer len=llGetListLength (list_of_commands);
            integer i;
            string command;
            string prefix;
            for (i=0; i<len; ++i) // execute every command one by one
            {
                if(stop) return;
 
                // a command is a RL command if it starts with '@' or a metacommand if it starts with '!'
                command=llList2String (list_of_commands, i);
                prefix=llGetSubString (command, 0, 0);
 
                if(command == "@clear")
                {
                    releaseRestrictions();
                    ack(cmd_id, id, command, "ok");   
                }
                else if (prefix=="@") // this is a RL command
                {
                    executeRLVCommand(cmd_id, id, command);
                }
                else if (prefix=="!") // this is a metacommand, aimed at the relay itself
                {
                    executeMetaCommand(cmd_id, id, command);
                }
            }
        }
    }
}
 
// executes a command for the restrained life viewer 
// with some additinal magic like book keeping
executeRLVCommand(string cmd_id, string id, string command)
{
    // we need to know whether whether is a rule or a simple command
    list tokens_command=llParseString2List (command, ["="], []);
    string behav=llList2String (tokens_command, 0); // @getattach:skull
    string param=llList2String (tokens_command, 1); // 2222
    integer ind=llListFindList (lRestrictions, [behav]);
 
    debug("behav = "+ behav +"; param=" + param);
 
    //== Stop the public chat exploits, and disregard commands issued with no variable (clear is handled elsewhere)
    if(param == nullstr || (~llSubStringIndex(behav, "@get") || ~llSubStringIndex(behav, "@findfolder") || ~llSubStringIndex(behav, "@version")) && ((integer)param <= 0))
    {
        ack(cmd_id, id, command, "ko");
        return;   
    } 
    if (param=="n" || param=="add") // add to lRestrictions
    {
        if (ind<0)
        {
            if(~llSubStringIndex(behav, ":") && llGetFreeMemory() <= 1024)
            {
                llOwnerSay("Relay is running dangerously low on memory; some restrictions will not be processed.");
            }
            else
                lRestrictions = (lRestrictions=[]) + lRestrictions + [behav];
 
            if(~llSubStringIndex(ownerexcept,behav)) //== Handle owner exceptions
            {
                //== Trim off the _sec part so exceptions can be passed
                if(~llSubStringIndex(behav, "_sec"))
                    behav = llGetSubString(behav, 0, -5);
 
                if(ownerkey != nullkey)
                    llOwnerSay("@"+behav+":"+(string)ownerkey+"=add");
                if(secaccess || ownerkey == nullkey)
                {
                    integer i;
                    for(i = 0; i < llGetListLength(secowners); i++)
                        llOwnerSay("@"+behav+":"+llList2String(secowners,i)+"=add");
                }
            }
        }
 
        if(kSource == nullkey)
        {
            llSetTimerEvent(2.0);
            if(!lockstatus)
                llOwnerSay("@detach=n");
        }
 
        kSource=id; // we know that kSource is either nullkey or id already
    }
    else if (param=="y" || param=="rem") // remove from lRestrictions
    {
        if (ind>-1)
                lRestrictions=llDeleteSubList ((lRestrictions=[]) + lRestrictions, ind, ind);
 
        //== Unlisted Owner Exceptions are NEVER removed, for safety
        //==  Nor is the public chat exploit fixer
 
        //== NOTE TO SELF: Find a memory-efficient way to add this protection for secowners
        else if(~llSubStringIndex(behav, ownerkey) || behav == "@a-relay")
        {
            ack(cmd_id, id, command, "ko");
            return;
        }
 
        if (llGetListLength (lRestrictions) == 0 && !lockstatus)
            llOwnerSay("@detach=y");
 
    }
 
    rememberForceSit(command);
    if(llGetListLength(lRestrictions) == 1)
        llOwnerSay("@a-relay=n");
    llOwnerSay(command); // execute command
    ack(cmd_id, id, command, "ok"); // acknowledge
}
 
 
// remembers the time and object if this command is a force sit
//== Changed to work a little differently
rememberForceSit(string command)
{
    command = llStringTrim(command, STRING_TRIM);
    string param = llGetSubString(command, -6, -1);
 
    if (param != "=force")
    {
        //== If we're seated on the kSource and it's restricting us, it's probably the sit target
        if(lastForceSitDestination == nullkey && (command == "@unsit=n" || command == "@unsit=add") && llGetAgentInfo(llGetOwner()) & AGENT_SITTING)
            lastForceSitDestination = kSource;
 
        return;
    }
 
    string behav = llGetSubString(command, 0, 4);
    param = llGetSubString(command, 5, 40);
 
    debug("'force'-command:" + behav + "/" + param);
 
    //== If this somehow isn't a sit command (or there's no valid target) then return
    if(behav != "@sit:" || llStringLength(param) != 36)
        return;
 
 
    lastForceSitDestination = (key) param;
    lastForceSitTime = llGetUnixTime();
    debug("remembered force sit");
}
 
// executes a meta command which is handled by the relay itself
executeMetaCommand(string cmd_id, string id, string command)
{
    if (command=="!version") // checking relay version
    {
        ack(cmd_id, id, command, (string)RLVRS_PROTOCOL_VERSION);
    }
    else if (command == "!implversion") // checking relay version
    {
        ack(cmd_id, id, command, RLVRS_IMPL_VERSION);
    }
    else if (command=="!release") // release all the restrictions (end session)
    {
        ack(cmd_id, id, command, "ok");
        kSource = nullkey; //== So only one release message is sent
        releaseRestrictions();
    }
 
    //== Depreciated but still supported here because it's easy
    if (llGetSubString(command,0,4) == "!who/")
    {
        kController = (key)llGetSubString(command, 5, -1);
    }
    if (llGetSubString(command,0,9) == "!handover/")
    {
        list tokens = llParseString2List(command, ["/"], []);
        if(!llList2Integer(tokens, 2))
            releaseRestrictions();
        kSource = llList2Key(tokens,1);
        pingWorldObjectIfUnderRestrictions();
    }
}
 
// lift all the restrictions (called by !release and by turning the relay off)
releaseRestrictions ()
{
    ack("Relay Release Notification", kSource, "!release", "ok");
 
    kSource=nullkey;
    if(!lockstatus)
        llOwnerSay("@detach=y");
 
    //== Do this in reverse order because 1) it saves memory, and 2) the spec says so
    integer len;
    for (len = (llGetListLength(lRestrictions) - 1); len >= 0; len--)
    {
        llOwnerSay(llList2String (lRestrictions, len)+"=y");
 
        if(~llSubStringIndex(ownerexcept,llList2String(lRestrictions,len)))
            llOwnerSay("@clear="+llGetSubString(llList2String(lRestrictions, len),1,-1));
    }
    lRestrictions = [];
 
    loginPendingForceSit = FALSE;
    lastForceSitDestination = nullkey;
    loginWaitingForPong = FALSE;
    llSetTimerEvent(0.0);
    ack("Relay Release Notification", sPendingId, "!release", "ok");
 
    llMessageLinked(LINK_SET, 356, nullstr, nullkey);
 
    if(kController != nullkey && sPendingId != nullkey)
        llDialog(kController, llKey2Name(llGetOwner()) +" has not accepted your attempt to control their viewer via " + sPendingName +".", [], 99);
 
    sPendingId = nullkey;
    sPendingName = nullstr;
    sPendingMessage = nullstr;
    kController = nullkey;
}
 
 
// ---------------------------------------------------
//            initialisation and login handling
// ---------------------------------------------------
 
init() {
    debug("RLV Plugin Free Memory at "+ (string)llGetFreeMemory());
    nMode=1;
    kSource=nullkey;
    lRestrictions=[];
    sPendingId=nullkey;
    sPendingName=nullstr;
    sPendingMessage=nullstr;
    llListen (-1812221819, nullstr, nullstr, nullstr);
    llListen (-1812220409, nullstr, llGetOwner(), nullstr);
    llOwnerSay (getModeDescription());
}
 
// sends the known restrictions (again) to the RL-viewer
// (call this functions on login)
reinforceKnownRestrictions()
{
    integer i;
    integer len=llGetListLength(lRestrictions);
    string restr;
 
    if(len > 0)
    {
        llOwnerSay("@a-relay=n");
        llOwnerSay("@detach=n");
    }
 
    debug("kSource=" + (string) kSource);
    for (i=0; i<len; ++i)
    {
        restr=llList2String(lRestrictions, i);
        debug("restr=" + restr);
        llOwnerSay(restr+"=n");
        if (restr=="@unsit" && lastForceSitDestination != nullkey)
        {
            loginPendingForceSit = TRUE;
        }
    }
}
 
// send a ping request and start a timer
pingWorldObjectIfUnderRestrictions()
{
    loginWaitingForPong = FALSE;
    if (kSource != nullkey)
    {
        ack("ping", kSource, "ping", "ping");
        timerTickCounter = 0;
        llSetTimerEvent(1.0);
        loginWaitingForPong = TRUE;
    }
}
 
// Handle commands
HandleCommand(string message, key id)
{
    list templist = llParseString2List(llToLower(message), [" "], []);
    string cmd = llList2String(templist, 0);
 
    if(cmd == "relay" && (id == ownerkey || (llListFindList(secowners, [id]) > -1 && (ownerkey == nullkey || secaccess)) || (id == llGetOwner() && (setby == nullkey || setby == llGetOwner() || (setby != ownerkey && llListFindList(secowners, [setby]) <= -1)))))
    {
        integer change = 0;
 
        string second = llList2String(templist, 1);
        string third = llList2String(templist, 2);
 
        if(kSource != nullkey && id == llGetOwner())
        {
            llOwnerSay("You cannot change relay modes while the relay is locked.");
            return;   
        }
 
        if(id == ownerkey && (second == "secondaries" || second == "sec"))
        {
            if(third == "on" || third == "auto" || (third == nullstr && !secaccess))
            {
                secaccess = 1;
                llWhisper(0, "Secondary owners can now adjust Restrained Life Relay settings.");
            }
            else
            {
                secaccess = 0;
                llWhisper(0, "Secondary owners cannot adjust Restrained Life Relay settings.");
            }
        }
 
        else if((secaccess || id == ownerkey || (id == llGetOwner() && kSource == nullkey)) && second == "ping")
        {
            if(third == "off" || (third == nullstr && !noping))
            {
                noping = 1;
                llWhisper(0,"Restrained Life Relay no longer requires regular object communication.  CAUTION: Relay will NOT detect if the control object has crashed or been removed, and in that instance will continue to enforce the last known restrictions until the wearer logs off.");
            }
            else
            {
                noping = 0;
                llWhisper(0,"Restrained Life Relay now requires regular object communication."); 
            }  
        }
 
        if(second == "on" || second == "auto")
        {
            nMode = 2;
            change = 1;
        }
        if(second == "off")
        {
            nMode = 0;
            change = 1;   
        }
        if(second == "ask")
        {
            nMode = 1;
            change = 1;   
        }
        if(second == "owner" || second == "wl")
        {
            nMode = 3;
            change = 1;   
        }
 
        if(second == nullstr || second == "mode")
        {
            nMode++;
            if(nMode > 3) nMode = 0;
            change = 1;  
        }
 
        if(second == "wbclear")
        {
            WhiteBlack = [];
            llWhisper(0,"Relay Whitelist and Blacklist cleared.");
        }
 
        if(change)
        {
            setby = nullkey;
            if (nMode == 0)
            {
                llSetTimerEvent(0.0);
                releaseRestrictions();
                setby = nullkey;
            }
            else
            {
                llSetTimerEvent((float)PING_INTERVAL);
                if(nMode >= 2) setby = id;
            }
            if(id == llGetOwner())
                llOwnerSay(getModeDescription());   
            else
                llSay(0, getModeDescription());
 
            llMessageLinked(LINK_THIS, 63, nullstr, nullstr);
        }
    }
    else if(cmd == "relay" && id == llGetOwner())
    {
        llOwnerSay("Sorry, only your owner can deactivate the relay once they enable it.");   
    }
}
 
default
{
    state_entry()
    {
        // Request owner list from the collar
        llMessageLinked(LINK_THIS, 47, nullstr, nullstr);
        // Reset the plugin list
        llMessageLinked(LINK_THIS, 62, nullstr, nullstr);
        init();
    }
 
    // Handle messages from the collar script
    link_message(integer sender, integer num, string str, key id)
    {
        if(num == 47)
        {
            list templist = llParseString2List(str, [","], []);
            integer x;
            integer count = llGetListLength(templist);
 
            // Handle owner list reply
            ownerkey = id;
            secowners = [];
            for(x=0;x<count;x++)
            {
                secowners = secowners + [ (key)llList2String(templist, x) ];
            }
        }
        // Prefixless commands
        else if(num == 48 || num == 828)
        {
            if(llSubStringIndex(id,"|") != -1) //== Strip out the combo info from the 828 reply
                id = (key)(llGetSubString(id,0,35));   
            // Handle Commands on the public or alternate channel
            HandleCommand(str, id);
        }
        else if(num == 33 && id != nullkey)
        {
            // Collar script is giving us an owner
            ownerkey = id;
        }
        else if(num == 34 && id != nullkey)
        {
            // Collar script is giving us a secondary owner
            secowners = secowners + [ id ];
        }
        else if(num == 35)
        {
            // Collar script is clearing owners
            ownerkey = nullkey;
            secowners = [];
        }
        else if(num == 36)
        {
            // Collar script is clearing secondary owners
            secowners = [];
        }
        // Handle plugin update
        else if(num == 62)
        {
            string buttons = "Relay Mode";
 
            if(str == nullstr && (id == nullstr || id == nullkey))
            {
                // Add for owner and owners (key)
                llMessageLinked(LINK_SET, 62, "Relay Sec", buttons);
                // Add for sub and unowned sub (key)
                llMessageLinked(LINK_SET, 63, buttons, nullstr);
            }
        }
        else if(num == 65)
        {
            lockstatus = (integer)str;  
        }
        else if(num == 66) //== Safeword, unlock
        {
            releaseRestrictions();
            setby = nullkey;
            nMode = 0;
            llOwnerSay(getModeDescription());
        }
        else if(num == 355)
            reinforceKnownRestrictions();
    }
 
    attach(key id)
    {
        if(id == nullkey)
            llOwnerSay("@clear");   
    }
 
    on_rez(integer start_param)
    {
        // relogging, we must refresh the viewer and ping the object if any
        // if mode is not OFF, fire all the stored restrictions
        if (nMode)
        {
            reinforceKnownRestrictions();
            pingWorldObjectIfUnderRestrictions();
        }
        // remind the current mode to the user
        llOwnerSay(getModeDescription());
    }
 
 
    timer()
    {
        timerTickCounter++;   
 
        debug("timer (" + (string) timerTickCounter + "): waiting for pong: " + (string) loginWaitingForPong + " pendingForceSit: " + (string) loginPendingForceSit);
        if (loginWaitingForPong && (timerTickCounter >= LOGIN_DELAY_WAIT_FOR_PONG))
        {
            llWhisper(0, "Lucky Day: " + llKey2Name(llGetOwner()) + " is freed because the device is not available or is not responding to pings.");
            loginWaitingForPong = FALSE;
            loginPendingForceSit = FALSE;
            releaseRestrictions();
        }
 
        if (loginPendingForceSit)
        {
            integer agentInfo = llGetAgentInfo(llGetOwner());
            if (agentInfo & AGENT_SITTING)
            {
                loginPendingForceSit = FALSE;
                debug("is sitting now");
            }
            else if (timerTickCounter >= PING_INTERVAL) //== Force Sit check
            {
                llWhisper(0, "Lucky Day: " + llKey2Name(llGetOwner()) + " is freed because sitting down again was not possible.");
                loginPendingForceSit = FALSE;
                releaseRestrictions();
            }
            else if(!loginWaitingForPong)
            {
                 llOwnerSay ("@sittp=y,sit:"+(string)lastForceSitDestination+"=force");
            }
        }
 
        if(sPendingId != nullkey && sPendingTime + PERMISSION_DIALOG_TIMEOUT <= llGetUnixTime())
        {
            llDialog(llGetOwner(),"Request to control your viewer by "+ sPendingName +" automatically denied due to timeout.", ["OK"], -1812220409);
            sPendingId = nullkey;
            sPendingName = nullstr;
            sPendingMessage = nullstr;
        }  
 
        if(timerTickCounter == 0 && !noping)
            pingWorldObjectIfUnderRestrictions(); 
 
        if (!loginPendingForceSit && !loginWaitingForPong && sPendingId == nullkey)
        {
            timerTickCounter = -1;
            if(!noping)
            {
                llSetTimerEvent((float)PING_INTERVAL);
                return;
            }
            llSetTimerEvent(0.0);
        }
    }
 
    listen(integer channel, string name, key id, string message)
    {
        if (channel==-1812221819)
        {
            debug("LISTEN: " + message);
 
            //=== ALWAYS accept a lone "!release" command, no matter the distance
            list tokens = llCSV2List(message);
            if (!(llGetListLength(tokens) == 3 && llList2String(tokens, 1) == llGetOwner()) || (!isObjectNear(id) && llGetSubString(message, -9, -1) != ",!release"))
            {
               return;
            }
            tokens = [];
 
            if (nMode== 0)
            {
                debug("deactivated - ignoring commands");
                return; // mode is 0 (off) => reject
            }
 
            debug("Got message (active world object " + (string) kSource + "): name=" + name+ "; id=" + (string) id + "; message=" + message);
 
            if (kSource != nullkey && kSource != id)
            {
                debug("already used by another object => reject");
                return;
            }
 
            if(!loginPendingForceSit && sPendingId == nullkey)
            {
                llSetTimerEvent(0.0);
                llSetTimerEvent((float)PING_INTERVAL);
            }
 
            loginWaitingForPong = FALSE; // whatever the message, it is for me => it satisfies the ping request
//            timerTickCounter = -1;
 
            if (!isObjectKnow(id))
                if(!verifyPermission(id, name, message))
                    return;
 
            debug("Executing: " + (string) kSource);
            execute(name, id, message);
        }
        else if (channel==-1812220409 && id == llGetOwner())
        {
            if (sPendingId!=nullkey)
            {                
                if (message=="Yes" || message == "Always") // pending request authorized => process it
                {
                    //== Process Whitelist entry
                    if(message == "Always") WhiteBlack += [llGetOwnerKey(sPendingId)];
                    debug("Got approval of restrictions from wearer");
                    execute(sPendingName, sPendingId, sPendingMessage);
                }
                else if(kSource == sPendingId)
                    releaseRestrictions();
 
                //== Process Blacklist entry
                if(kController == nullkey) kController = llGetOwnerKey(sPendingId);
                if(message == "Never") WhiteBlack += ["-"+(string)llGetOwnerKey(kController)];
 
                // clear pending request
                sPendingName=nullstr;
                sPendingId=nullkey;
                sPendingMessage=nullstr;
            }
        }
    }
 
    changed(integer change)
    {
        if (change & CHANGED_OWNER) 
        {
             llResetScript();
        }
    }
}