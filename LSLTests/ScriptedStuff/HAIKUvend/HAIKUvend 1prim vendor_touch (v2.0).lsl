//
//          HAIKUvend 1prim vendor
//          version 2.0
//
//          You may not resell any part of this system, nor give it away.
//          Please forward other people towards http://code.google.com/p/haikuvend/ if you want to recommend this system.
//
//          An up-to-date version will always be available at:
//          http://code.google.com/p/haikuvend/
//
//          Please report any errors in the code to "haikuvend Resident"
//          and feel free to contact me if you have any improvements
//
//          This is the main touch script, it is NOT optional!
//

key NOTECARD_QUERY;
integer NOTECARD_LINE;

string VENDOR_NAME;
string URL_MENU_INFO;
string URL_MENU_LINK;
list FOLDER_NAMES;

integer menuChannel;
integer listenHandle;
list dialog_buttons = [ "Size@Rez", "Size@Setup", "Turn Off", "-0.1%", "-1%", "-10%", "+0.1%", "+1%", "+10%", "ResetVendor" ];
string dialog_info = "\nYou can change the vendor size or turn off the vendor or reset the scripts.\n\n\n";

float fabsizeX; float rezsizeX; vector rs;

say(string str) { llOwnerSay("/me ["+llGetScriptName()+"]: " + str); }

open_dialog( vector vr )
{
    string s="Size is currently "+(string)((integer)(100.0*vr.x/fabsizeX))+"%";
    llDialog(llGetOwner(), dialog_info + s , dialog_buttons, menuChannel);
    llSetTimerEvent(30.0);
}

integer dimTest( vector vr )
{
    return !( vr.x<0.01 || vr.y<0.01 || vr.z<0.01 || vr.x>10.0 || vr.y>10.0 || vr.z>10.0 );
}

primloop( float scal )
{
    integer primindx;
    integer validDim=TRUE;
    list primP;
    if (llGetNumberOfPrims()<2)
        validDim = validDim && dimTest( scal*llGetScale());
    else
        for ( primindx = 1; primindx <= llGetNumberOfPrims(); primindx++ )
        {
            primP = llGetLinkPrimitiveParams( primindx, [PRIM_SIZE]);
            validDim = validDim && dimTest( scal*llList2Vector( primP, 0 ));
        }
    if ( validDim )
    {
        if (llGetNumberOfPrims()<2)
            llSetScale( scal*llGetScale());
        else
            for ( primindx = 1; primindx <= llGetNumberOfPrims(); primindx++ )
            {
                primP = llGetLinkPrimitiveParams( primindx, [PRIM_SIZE, PRIM_POSITION]);
                vector primScale = scal*llList2Vector( primP, 0 );
                vector primPos = scal*(llList2Vector( primP, 1 )-llGetPos());
                if ( primindx == 1 )
                    llSetLinkPrimitiveParamsFast( primindx, [PRIM_SIZE, primScale]);
                else
                    llSetLinkPrimitiveParamsFast( primindx, [PRIM_SIZE, primScale, PRIM_POSITION, primPos/llGetRootRotation()]);
            }
    }
    else
        say("No resize! Out of limit sizes are not accepted");
}

init()
{
    URL_MENU_INFO = "Visit the SecondLife Website!";
    URL_MENU_LINK = "http://www.secondlife.com";
    VENDOR_NAME = "My vendor in '" + llGetRegionName() + "'";
    NOTECARD_QUERY = llGetNotecardLine("HAIKUvend 1prim.cfg",NOTECARD_LINE);
}

config_dump()
{
    say("Vendor name reset to: " + VENDOR_NAME);
    say("URL menu info: " + URL_MENU_INFO);
    say("URL menu link: " + URL_MENU_LINK);
}

config_parse(string input_string)
{
    string line = llStringTrim(input_string,STRING_TRIM);
    if (llGetSubString(line,0,1) != "//" && line != "")
    {
        list ldata  = llParseStringKeepNulls(line, ["=","#"], [""]);
        string cmd  = llToUpper(llStringTrim(llList2String(ldata,0),STRING_TRIM));
        string arg1  = llStringTrim(llList2String(ldata,1),STRING_TRIM);
        if (cmd == "VENDOR_NAME") { VENDOR_NAME = arg1; }
        else if (cmd == "URL_MENU_INFO") { URL_MENU_INFO = arg1; }
        else if (cmd == "URL_MENU_LINK") { URL_MENU_LINK = arg1; }
        else if (cmd == "FOLDER1") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER2") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER3") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER4") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER5") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER6") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER7") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER8") { FOLDER_NAMES += [arg1]; }
        else if (cmd == "FOLDER9") { FOLDER_NAMES += [arg1]; }
    }
}

default
{
    on_rez(integer start_param) { llResetScript(); }

    state_entry() { init(); }

    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) llResetScript(); }

    dataserver(key requested, string data)
    {
        if (requested == NOTECARD_QUERY)
        {
            if (data != EOF)
            {
                config_parse(data);
                ++NOTECARD_LINE;
                NOTECARD_QUERY = llGetNotecardLine("HAIKUvend 1prim.cfg",NOTECARD_LINE);
            }
            else
            {
                llSetTimerEvent((float)FALSE);
                config_dump();
                state idle_state;
            }
        }
    }

    timer()
    {
        llSetTimerEvent((float)FALSE);
        say("Time-out during notecard reading, resetting script now...");
        llResetScript();
    }

    state_exit()
    {
        llSetTimerEvent((float)FALSE);
    }
}

state idle_state
{
    on_rez(integer startParam) { llResetScript(); }

    state_entry()
    {
        rs = llGetScale();
        fabsizeX = rs.x;
        rezsizeX = fabsizeX;
        say("Size at setup is set to Current size");
        llMessageLinked(LINK_SET, 0, "1a1", NULL_KEY);
        llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,0) + ")");
    }

    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) { llResetScript(); } }

    touch_start(integer num_detected)
    {
        if (llDetectedTouchFace(0) == 2 && llDetectedKey(0) == llGetOwner())
        {
            menuChannel = (integer)llFrand(DEBUG_CHANNEL)*-1;
            listenHandle = llListen(menuChannel, "", llGetOwner(), "");
            say("Choose 'Turn Off' to disable your vendor or 'Reset' to reset the vendor script.");
            open_dialog(llGetScale());
        }
        else if  (llDetectedTouchFace(0) == 6)
        {
            vector UV = llDetectedTouchST(0);
            float U = UV.x;
            float V = UV.y;
            if (V > 0.95) { llLoadURL(llDetectedKey(0), URL_MENU_INFO, URL_MENU_LINK); }
            else if (V > 0.68 && V < 0.95 && U < 0.33) { llMessageLinked(LINK_SET, 0, "1a1", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,0) + ")"); }
            else if (V > 0.68 && V < 0.95 && U > 0.33 && U < 0.66) { llMessageLinked(LINK_SET, 0, "2a2", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,1) + ")"); }
            else if (V > 0.68 && V < 0.95 && U > 0.66) { llMessageLinked(LINK_SET, 0, "3a3", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,2) + ")"); }
            else if (V > 0.39 && V < 0.68 && U < 0.33) { llMessageLinked(LINK_SET, 0, "4a4", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,3) + ")"); }
            else if (V > 0.39 && V < 0.68 && U > 0.33 && U < 0.66) { llMessageLinked(LINK_SET, 0, "5a5", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,4) + ")"); }
            else if (V > 0.39 && V < 0.68 && U > 0.66) { llMessageLinked(LINK_SET, 0, "6a6", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,5) + ")"); }
            else if (V > 0.11 && V < 0.39 && U < 0.33) { llMessageLinked(LINK_SET, 0, "7a7", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,6) + ")"); }
            else if (V > 0.11 && V < 0.39 && U > 0.33 && U < 0.66) { llMessageLinked(LINK_SET, 0, "8a8", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,7) + ")"); }
            else if (V > 0.11 && V < 0.39 && U > 0.66) { llMessageLinked(LINK_SET, 0, "9a9", NULL_KEY); llSetObjectName(VENDOR_NAME + " (" + llList2String(FOLDER_NAMES,8) + ")"); }
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == menuChannel)
        {
            if (llListFindList(dialog_buttons, [message]) != -1)
            {
                say(" You have selected: '" + message + "'.");
                rs = llGetScale();
                if (message == "ResetVendor") { llMessageLinked(LINK_SET, 1000, "", NULL_KEY); }
                else if (message == "Turn Off") { llMessageLinked(LINK_SET, 1100, "", NULL_KEY); }
                else if ( message == "+0.1%" ) primloop(1.001);
                else if ( message == "+1%" ) primloop(1.01);
                else if ( message == "+10%" ) primloop(1.1);
                else if ( message == "-0.1%" ) primloop(0.999);
                else if ( message == "-1%" ) primloop(0.99);
                else if ( message == "-10%" ) primloop(0.9);
                else if ( message == "Size@Rez" ) primloop(rezsizeX/rs.x);
                else if ( message == "Size@Setup" ) primloop(fabsizeX/rs.x);
                open_dialog(llGetScale());
            }
            else
                llSay(PUBLIC_CHANNEL, name + " picked invalid option '" + llToLower(message) + "'.");
           }
    }
    
    timer()
    {
        llSetTimerEvent((float)FALSE);
        llListenRemove(listenHandle);
    }
}