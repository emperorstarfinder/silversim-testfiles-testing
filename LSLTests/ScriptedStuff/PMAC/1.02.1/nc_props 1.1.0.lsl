// props_debug v1.1.0
// v0.1 adapted to send absolute position
// v0.2 added debug switching via description
// v0.3 changed debug output
// v1.0 added debug output for derez on timeout
// v1.1.0 starting to convert into no_listener design
// written by Neo Cortex for use with the PMAC addon NC-props

// Put this script inside any PMAC prop.
// Supports saving the prop's position
// Dies on region restart

key MasterObject;

integer gi_Debug                       =FALSE;
NCDebug(string txt) {
    if (gi_Debug) {
        llOwnerSay(txt);
    }
}

default {
    on_rez(integer rez_arg) {
        gi_Debug = (llSubStringIndex(llGetObjectDesc(),"debug") != -1); // enable debug if object description contains 'debug'
 
        MasterObject = osGetRezzingObject(); // who rezzed me?

        osMessageObject(MasterObject,"NC_PROP_REZZED"); // tell Master who i am
    }
    dataserver(key who,string msg)
    {
        NCDebug("nc_prop received: " + msg + " from: " + (string) who);
        if (msg=="NC_PROP_DIE") llDie();
        if (msg == "NC_PROP_SAVE") { // report position
            osMessageObject(MasterObject,"NC_PROP_POSITION::" + (string)(llGetPos()) + "::" + (string)llGetRot());
//            NCDebug("Pos: " + (string)(llGetPos()) + " Rot:" + (string)llGetRot());
        }

    }
    changed(integer change)
    {
        if (change & CHANGED_REGION_START) llDie();
    }
}

