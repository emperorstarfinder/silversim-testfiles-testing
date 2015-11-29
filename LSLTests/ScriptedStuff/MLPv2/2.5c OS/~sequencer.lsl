//MPLV2 Version 2.3 by Learjeff Innis, based on 
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

// Allow programmed sequences of poses

// This script resets whenever any of its config cards change.

integer MAX_AVS = 6;

list    SeqNames;           // name of each sequence
list    SeqSteps;           // CSV of steps for each seq, indexed as SeqNames
list    SeqOpts;            // sequence options, inxexed as SeqNames
list    CurSeqSteps;

string  CurSeqName;
string  CurSeqOpts;
integer CurSeqStepIx;
string  CurMenu;
string  CurPose;

integer Chat        = TRUE; // whether narration is enabled
float   Volume      = 1.;   // global sound volume
integer Memory;

// debugs:
// 1 = sequence start/stop
// 2 = echo each step as executed
// 4 = av hop on/off
// 8 = avwait check
// 0x10 = debug config


integer Debug;

list    DELIMS = ["  |  ","  | "," |  "," | "," |","| ","|"];

list    COMMANDS = [
      "MENU"
    , "POSE"
    , "WAIT"
    , "REPEAT"
    , "LABEL"
    , "GOTO"
    , "STOP"
    , "WHISPER"
    , "SAY"
    , "AVWAIT"
    , "SOUND"
    ];

parse_config_line(string data) {
    if (llGetSubString(data,0,0) == "/" || llStringLength(data) == 0) {          // skip comments and blank lines
        return;
    }

    list    ldata = llParseStringKeepNulls(data, DELIMS, []);
    string  cmd     = llList2String(ldata, 0);
    string  arg1    = llList2String(ldata, 1);
    string  arg2    = llList2String(ldata, 2);
    string  arg3    = llList2String(ldata, 3);

    if (cmd == "MEMORY") {
        Memory = (integer) arg1;
    } else if (cmd == "SEQUENCE") {
        seq_save();         // save previous sequence, if any
        CurSeqName = arg1;        
        CurSeqSteps = [];
        CurSeqOpts = arg2;
    } else if (llListFindList(COMMANDS, (list)cmd) >= 0) {
        if (cmd == "LABEL") {
            CurSeqSteps += (list) (cmd + "|" + arg1);
        } else {
            CurSeqSteps += (list) (cmd + "|" + arg1 + "|" + arg2 + "|" + arg3);
        }
        if (cmd == "AVWAIT") {
            CurSeqSteps += (list) "WAIT|2|";
        }
        if (cmd == "SOUND" && llGetInventoryType(arg1) != INVENTORY_SOUND) {
            llWhisper(0, "WARNING: animation not in inventory: '" + arg1 + "'");
        }
    } else if (cmd == "debug") {
        Debug += (integer)arg1;
    } else {
        llWhisper(0, "Unknown sequence command: '" + cmd + "' - ignoring");
    }
}


list    Avnames;    // one for each ball
integer Avwait;
list    AvwaitBalls;

// List of avatar names per ball: adding/removing/checking

addAv(string name, integer ballIx) {
    Avnames = llListReplaceList(Avnames, (list)name, ballIx, ballIx);
    if (Avwait && avs_seated()) {
        Avwait = FALSE;
        llSetTimerEvent(0.1);
    }
}

removeAv(integer ballIx) {
    addAv("", ballIx);
}

integer avs_seated() {
    integer ix;
    integer ball;
    for (ix = llGetListLength(AvwaitBalls) - 1; ix >= 0; --ix) {
        ball = llList2Integer(AvwaitBalls, ix);
        if (llList2String(Avnames, ball) == "") {
            debug(8, "Nobody on ball " + (string) ball);
            return FALSE;
        }
    }
    debug(8, "All avs seated");
    return TRUE;
}


// In 'src', replace 'target' string with 'replacement' string,
// and return the result.

string replace_text(string src, string target, string replacement)
{
    string  text = src;
    integer ix;

    ix = llSubStringIndex(text, target);

    while (ix >= 0) {
        text = llDeleteSubString(text, ix, ix + llStringLength(target) - 1); 
        text = llInsertString(text, ix, replacement);
        ix = llSubStringIndex(text, target);
    }        
    
    return (text);
}

string firstname(string name) {
    return llList2String(llParseString2List(name, [" "], []), 0);
}

string customize(string src) {
    integer avix;
    string avname;
    for (avix = 0; avix < MAX_AVS; ++avix) {
        avname = firstname(llList2String(Avnames, avix));
        if (avname == "") avname = "somebody";
        src = replace_text(src, "/"+(string)avix, avname);
    }
    return src;
}


send_cmd(string cmd) {
    llMessageLinked(LINK_THIS, -12002, cmd, (key)"");
}

push_opts(string opts) {
    send_cmd("[PUSH] " + opts);
}

pop_opts() {
    send_cmd("[POP]");
}

seq_save() {
    if (CurSeqName ==  "") {
        return;
    }
    SeqNames += CurSeqName;
    SeqSteps += llDumpList2String(CurSeqSteps, "||");
    SeqOpts  += CurSeqOpts;
}

seq_start(string name) {
    if (CurSeqName != "") {
        seq_stop();
    }

    CurSeqName = name;
    Avwait = FALSE;
    integer ix = llListFindList(SeqNames, (list)name);
    if (ix < 0) {
        llWhisper(0, "No such sequence: '" + name + "'");
        CurSeqSteps = [];
        CurSeqStepIx = -1;
        return;
    }
    debug(1, "Start sequence " + name);
    
    CurSeqStepIx = 0;
    CurSeqSteps = llParseString2List(llList2String(SeqSteps, ix), ["||"], []);
    CurSeqOpts = llList2String(SeqOpts, ix);
    if (CurSeqOpts != "") {
        push_opts(CurSeqOpts);
    }
    seq_execute();
}

seq_advance() {
    if (++CurSeqStepIx >= llGetListLength(CurSeqSteps)) {
        debug(1, "sequence end");
        seq_stop();
    }
}

seq_execute() {
    list    step;
    string  cmd;
    string  arg1;
    string  arg2;
    string  arg3;
    
    string  objname;

    while (CurSeqStepIx >= 0) {
        step = llParseString2List(llList2String(CurSeqSteps, CurSeqStepIx), DELIMS, []);
        cmd     = llList2String(step, 0);
        arg1    = llList2String(step, 1);
        arg2    = llList2String(step, 2);
        arg3    = llList2String(step, 3);

        debug(2, cmd + "|" + arg1);
        
        if (cmd == "MENU") {
            CurMenu = arg1;
            send_cmd(CurMenu);
            seq_advance();
        } else if (cmd == "POSE") {
            // llSleep(.5);
            CurPose = arg1;
            send_cmd(arg1);
            if (arg3 != "" && Chat) {
                objname = llGetObjectName();
                llSetObjectName(":");
                llWhisper((integer)arg2, "/me " + customize(arg3));
                llSetObjectName(objname);
            }
            seq_advance();
        } else if (cmd == "WAIT") {
            llSetTimerEvent((float) arg1);
            seq_advance();
            return;
        } else if (cmd == "REPEAT") {
            CurSeqStepIx = 0;
        } else if (cmd == "LABEL") {
            seq_advance();
        } else if (cmd == "GOTO") {
            CurSeqStepIx = llListFindList(CurSeqSteps, (list)("LABEL|" + arg1));
            if (CurSeqStepIx < 0) {
                llWhisper(0, "No such sequence label: '" + arg1 + "'");
                seq_stop();
                return;
            }
        } else if (cmd == "WHISPER") {
            if (Chat) {
                objname = llGetObjectName();
                llSetObjectName(":");
                llWhisper((integer)arg1, "/me " + customize(arg2));
                llSetObjectName(objname);
            }
            seq_advance();
        } else if (cmd == "SAY") {
            if (Chat) {
                objname = llGetObjectName();
                llSetObjectName(":");
                llSay((integer)arg1, "/me " + customize(arg2));
                llSetObjectName(objname);
            }
            seq_advance();
        } else if (cmd == "AVWAIT") {
            integer argix;
            integer ballix;
            AvwaitBalls = [];
            list balls = llParseString2List(arg1, [" "], []);
            for (argix = llGetListLength(balls) - 1; argix >= 0; --argix) {
                ballix = (integer)llList2String(balls, argix);
                AvwaitBalls += (list)(ballix);
            }   

            seq_advance();
            if (! avs_seated()) {
                llSetTimerEvent(0.);        // just to be sure
                if (arg2 != "") {
                    llWhisper(0, customize(arg2));
                }
                Avwait = TRUE;
                return;
            }
        } else if (cmd == "SOUND") {
            llPlaySound(arg1, Volume * (float)arg2);
            seq_advance();
        } else {
            send_cmd(cmd);
            seq_advance();
        }
    }
}

seq_stop() {
    Avwait = FALSE;
    debug(1, "stopping sequence");
    if (CurSeqName != "" && CurSeqOpts != "") {
        pop_opts();
    }
    CurSeqName = "";
    CurSeqStepIx = -1;
    CurPose = "";
    CurMenu = "";
    llSetTimerEvent(0.);
}

debug(integer level, string txt) {
    if (Debug & level) {
        llWhisper(0, llGetScriptName() + ": " + txt);
    }
}

string plural(string singular, string plural, integer count) {
    if (count != 1) {
        return plural;
    }
    return singular;
}


// Globals for reading card config
integer ConfigLineIndex;
list    ConfigCards;        // list of names of config cards
string  ConfigCardName;     // name of card being read
integer ConfigCardIndex;    // index of next card to read
key     ConfigQueryId;
string  ConfigCardKeys;     // to see if anything changed

string get_cards() {
    ConfigCards = [];
    string keys = "";
    string item;

    integer ix = llGetInventoryNumber(INVENTORY_NOTECARD);
    while (ix-- > 0) {
        item = llGetInventoryName(INVENTORY_NOTECARD, ix);
        if (llSubStringIndex(item, ".SEQUENCES") >= 0) {
            ConfigCards += (list) item;
            keys += (string)llGetInventoryKey(item);
        }
    }
    return keys;
}

integer next_card()
{
    if (ConfigCardIndex >= llGetListLength(ConfigCards)) {
        ConfigCards = [];
        return (FALSE);
    }
    
    ConfigLineIndex = 0;
    ConfigCardName = llList2String(ConfigCards, ConfigCardIndex);
    ConfigCardIndex++;
    ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);
    llOwnerSay("Reading " + ConfigCardName);
    return (TRUE);
}                             


default {
    state_entry() {
        SeqNames    = [];
        SeqSteps    = [];
        Debug       = 0;
        Memory      = 2000;
        ConfigCardKeys = get_cards();
        ConfigCardIndex = 0;
        ConfigCards = llListSort(ConfigCards, 1, TRUE);
        if (! next_card()) {
            state on;
        }
    }

    dataserver(key query_id, string data) {
        if (query_id != ConfigQueryId) {
            return;
        }                                
        if (data == EOF) {
            if (next_card()) {
                return;
            }
            state on;
        }

        parse_config_line(llStringTrim(data, STRING_TRIM));
        ++ConfigLineIndex;
        ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);       //read next line of positions notecard
    }
}

state on {
    state_entry() {
        seq_save();             // save last sequence, if any
        CurSeqName = "";
        CurSeqOpts = "";
        CurSeqStepIx = -1;
        CurPose = "";
        CurMenu = "";
        debug(0x10, "Sequences: " + llList2CSV(SeqNames));
        Avnames = [];
        integer ix;
        for (ix = 0; ix < MAX_AVS; ++ix) {
            Avnames += (list)"";
        }
        integer count = llGetListLength(SeqNames);
        if (count == 0) Memory = 200;
        if (Memory) llSetMemoryLimit(llGetUsedMemory() + Memory);
        llOwnerSay((string)count
            + plural(" sequence (", " sequences (", count)
            + llGetScriptName()
            + ": "
            + (string)llGetFreeMemory() + " bytes free, "
            + (string)llGetMemoryLimit() + " limit)");
    }

    on_rez(integer arg) {
        seq_stop();

        Avnames = [];
        integer ix;
        for (ix = 0; ix < MAX_AVS; ++ix) {
            Avnames += (list)"";
        }
    }
    
    link_message(integer from, integer num, string str, key dkey) {

        if (str == "PRIMTOUCH") {
            return;
        }

        if (str == "VOLUME") {
            Volume = (float)((string)dkey);
            return;
        }
        
        if (str == "MEMORY") {
            llOwnerSay(llGetScriptName() + ": " + (string) llGetFreeMemory() + " bytes free.");
            return;
        }
        
        if (CurSeqStepIx >= 0 && num == 0 && str == "POSEB") {
            if ((string)dkey != CurPose) {
                debug(1, "user stopped or selected a pose");
                seq_stop();
            }
            return;
        }

        if (num == -11000) {
            // av hopped on
            list parms = llParseStringKeepNulls(str, ["|"], []);
            integer ballnum = (integer)llList2String(parms, 0);
            // string anim = llList2String(parms, 1);     // anim name parameter, if desired
            debug(4, llKey2Name(dkey) + ": on ball " + (string)ballnum);
            addAv(llKey2Name(dkey), ballnum);
            return;

        } else if (num == -11001) {
            // av hopped off
            debug(4, llKey2Name(dkey) + ": off ball " + str);
            removeAv((integer)str);
            return;

        } else if (num != -12001) {
            return;
        }
        
        list ldata = llParseString2List(str, [" "], []);
        string cmd = llList2String(ldata, 0);
        if (cmd == "SEQUENCE") {
            seq_start(llList2String(ldata, 1));
        } else if (cmd == "PAUSE") {
            debug(1, "pausing");
            llSetTimerEvent(0.);
        } else if (cmd == "RESUME") {
            debug(1, "resuming");
            llSetTimerEvent(.1);
        } else if (cmd == "NARRATION") {
            Chat = !Chat;
            string chatting = "off";
            if (Chat) {
                chatting = "on";
            }
            llWhisper(0, "Sequence narration " + chatting);
        }
    }

    timer() {
        seq_execute();
    }
    
    changed(integer change) {
        if (change & CHANGED_INVENTORY) {
            if (get_cards() != ConfigCardKeys) {
                llResetScript();
            }
        }
    }
}
