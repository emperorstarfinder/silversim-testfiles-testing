// NC_PROPS ADD-ON FOR PMAC
// adds the ability to rez additional props, like pillows or extra furniture for positions
// v0.1 rezzes and kills props
// v0.2 adds functionality to request prop position in edit mode (via store addon button) to copy/paste into .menu card
// v0.3 adds debug switch via 'debug' in object description
// v0.31 fix issue with rotations
// v0.4 adds communication with PMAC Core to update positions
// v1.00 clean up, release first public version
// v1.01 send link message to LINK_THIS so it works in linked sets, move llListen to rez part
// v1.1.0 switch to direct communication with prop via osMessageObject and dataserver
// v1.1.1 clean up
// v1.1.2 moved determination of RefPos to the places where positions are calculated, so moving the pmac base object is taken into account

// by Neo Cortex in April 2015 based on Aine's work as seen in
// EXPRESSIONS ADD-ON FOR PMAC 1.0
// by Aine Caoimhe (Mata Hari)(c. LACM) January 2015
// and on
//MPLV2 Version 2.3 by Learjeff Innis, based on
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

// This script handles props (object rezzed for a given pose)

// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Command format for this addon:
// NC_PROP{prop::pos::rot}
// where for each position you need to supply all
//      prop = prop to rez
//      pos = position
//      rot = rotation of the prop
// DO NOT include any extra spaces between the separators or before/after the curly braces

integer gi_Debug                       =FALSE;
NCDebug(string txt) {
    if (gi_Debug) {
        llOwnerSay(txt);
    }
}

integer ChatChan;               // chan for talking to object

list currentProp;
string prop;
list previousProp;
key Prop_id = NULL_KEY;

vector RefPos;
rotation RefRot;

init()
{
    gi_Debug = (llSubStringIndex(llGetObjectDesc(),"debug") != -1);
    NCDebug("Object description contains 'debug', enabling debug output for NC_PROPS addon!\n");
}

string round(float number, integer places) {
    float shifted;
    integer rounded;
    string s;
    shifted = number * llPow(10.0,(float)places);
    rounded = llRound(shifted);
    s = (string)((float)rounded / llPow(10.0,(float)places));
    s = llGetSubString(s,0,llSubStringIndex(s, ".")+places);
    return s;
}

// round a vector's components and return as vector value string
string vround(vector vec) {
    return ("<"+round(vec.x, 3)+","+round(vec.y, 3)+","+round(vec.z, 3)+">");
}

zeroAll()
{
    currentProp=[];
    previousProp=[];
    if(Prop_id != NULL_KEY) osMessageObject(Prop_id,"NC_PROP_DIE");
    Prop_id = NULL_KEY;
}

default
{
    state_entry()
    {
        zeroAll();  // even though they already should be
        init();
    }

    link_message (integer sender, integer num, string message, key id)
    {
        list parsed=llParseString2List(message,["|"],[]);
        string command=llList2String(parsed,0);
//        NCDebug("nc_prop received link_message: sender: " + (string) sender + " num: " + (string) num + "\nmessage: " + message +"\nid: " + (string) id);
//        NCDebug("Command: " + command);
        if (command=="GLOBAL_NEXT_AN")
        {
            list commandBlock=llParseString2List(llList2String(parsed,1),["{","}"],[]);
            integer myBlock=llListFindList(commandBlock,["NC_PROP"]);
            if(myBlock>=0)
            {
                currentProp=[]+llParseString2List(llList2String(commandBlock,myBlock+1),["::"],[]);
                prop=llList2String(currentProp,0);
                vector pos=(vector)llList2String(currentProp,1);
                vector erot=(vector)llList2String(currentProp,2);
                if((string)previousProp!=(string)currentProp)
                {
                    RefPos = llGetPos();   // get base position
                    RefRot = llGetRot();

                        if(Prop_id != NULL_KEY)
                        {
                            osMessageObject(Prop_id,"NC_PROP_DIE"); // kill old prop
                            Prop_id = NULL_KEY;
                        }
                    pos = pos * RefRot + RefPos;
                    rotation rot = llEuler2Rot(erot*DEG_TO_RAD) * RefRot;
                    //                    NCDebug("rezzing '" + prop + "' at " + (string) pos);
                    llRezAtRoot(prop, pos, <0.0,0.0,0.0>, rot, ChatChan);
                    previousProp=currentProp;
                }

            }
            else
            {
                zeroAll();
            }
        }
        else if (command=="GLOBAL_SYSTEM_RESET") llResetScript();
        else if (command=="GLOBAL_SYSTEM_GOING_DORMANT") zeroAll();
        else if (command=="GLOBAL_STORE_ADDON_NOTICE")
        {
            if(Prop_id != NULL_KEY) osMessageObject(Prop_id,"NC_PROP_SAVE"); // ask prop to send its actual position
        }
    }

    dataserver(key who,string msg)
    {
//        NCDebug("Dataserver: " + (string) who + " sends:" + msg);
        list ldata = llParseString2List(msg, ["::"], []);
        if (llList2String(ldata, 0) == "NC_PROP_REZZED")
        {
            Prop_id = who;
            NCDebug("Object rezzed: " + (string) who);
        }
        if (llList2String(ldata, 0) == "NC_PROP_POSITION")
        {
            RefPos = llGetPos();   // get base position
            RefRot = llGetRot();
            vector pos = (vector) llList2String(ldata, 1);
            rotation rot = (rotation)llList2String(ldata, 2);
            pos = (pos - RefPos) / RefRot;
            vector erot = llRot2Euler(rot/RefRot) * RAD_TO_DEG;
            string data = prop + "::" + vround(pos) + "::" + vround(erot);
            llMessageLinked(LINK_THIS, -1, "NC_PROP_UPDATE " + data, (key)""); // send data to main script
            NCDebug("sent new position data to Core: " + data);
        }

    }
}

