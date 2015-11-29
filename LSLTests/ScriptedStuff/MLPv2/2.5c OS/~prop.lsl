// MLPV2 by Learjeff Innis.

// Put this script inside any MLPV2 prop.
// Supports saving the prop's position
// Dies on timeout if MLPV2 object is removed.

integer ChatChan;
vector  OrigPos;


default {
    on_rez(integer rez_arg) {
        ChatChan = rez_arg;
        OrigPos = llGetPos();
        if (ChatChan != 0) {
            llListen(ChatChan, "", NULL_KEY, "");
            llSetTimerEvent(180.0);
        }
    }

    listen(integer chan, string name, key id, string msg) {
        if (msg == "SAVE") {
            // report change in location since rezzed
            llSay(ChatChan, (string)(llGetPos() - OrigPos) + "/" + (string)llGetRot());
            OrigPos = llGetPos();
        } else if (msg == "DIE") {
            llDie();
        } else if (msg == "LIVE") {
            llSetTimerEvent(180.0);
        }
    }

    timer() {       // Haven't heard "LIVE" from menu for a while
        llDie();
    }
}
