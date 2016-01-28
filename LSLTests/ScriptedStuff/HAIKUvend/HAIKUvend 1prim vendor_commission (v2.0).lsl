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
//          This is the commission script
//

key AVATAR_01_A; float percentage01a;
key AVATAR_01_B; float percentage01b;
key AVATAR_01_C; float percentage01c;
key AVATAR_02_A; float percentage02a;
key AVATAR_02_B; float percentage02b;
key AVATAR_02_C; float percentage02c;
key AVATAR_03_A; float percentage03a;
key AVATAR_03_B; float percentage03b;
key AVATAR_03_C; float percentage03c;
key AVATAR_04_A; float percentage04a;
key AVATAR_04_B; float percentage04b;
key AVATAR_04_C; float percentage04c;
key AVATAR_05_A; float percentage05a;
key AVATAR_05_B; float percentage05b;
key AVATAR_05_C; float percentage05c;
key AVATAR_06_A; float percentage06a;
key AVATAR_06_B; float percentage06b;
key AVATAR_06_C; float percentage06c;
key AVATAR_07_A; float percentage07a;
key AVATAR_07_B; float percentage07b;
key AVATAR_07_C; float percentage07c;
key AVATAR_08_A; float percentage08a;
key AVATAR_08_B; float percentage08b;
key AVATAR_08_C; float percentage08c;
key AVATAR_09_A; float percentage09a;
key AVATAR_09_B; float percentage09b;
key AVATAR_09_C; float percentage09c;
list FOLDER_NAMES; list FOLDER_PRICES;

key NOTECARD_QUERY;
integer NOTECARD_LINE;

say(string str) { llOwnerSay("/me ["+llGetScriptName()+"]: " + str); }

init()
{
    llSetTimerEvent(30.0);
    AVATAR_01_A = llGetOwner(); percentage01a = (float)FALSE;
    AVATAR_01_B = llGetOwner(); percentage01b = (float)FALSE;
    AVATAR_01_C = llGetOwner(); percentage01c = (float)FALSE;
    AVATAR_02_A = llGetOwner(); percentage02a = (float)FALSE;
    AVATAR_02_B = llGetOwner(); percentage02b = (float)FALSE;
    AVATAR_02_C = llGetOwner(); percentage02c = (float)FALSE;
    AVATAR_03_A = llGetOwner(); percentage03a = (float)FALSE;
    AVATAR_03_B = llGetOwner(); percentage03b = (float)FALSE;
    AVATAR_03_C = llGetOwner(); percentage03c = (float)FALSE;
    AVATAR_04_A = llGetOwner(); percentage04a = (float)FALSE;
    AVATAR_04_B = llGetOwner(); percentage04b = (float)FALSE;
    AVATAR_04_C = llGetOwner(); percentage04c = (float)FALSE;
    AVATAR_05_A = llGetOwner(); percentage05a = (float)FALSE;
    AVATAR_05_B = llGetOwner(); percentage05b = (float)FALSE;
    AVATAR_05_C = llGetOwner(); percentage05c = (float)FALSE;
    AVATAR_06_A = llGetOwner(); percentage06a = (float)FALSE;
    AVATAR_06_B = llGetOwner(); percentage06b = (float)FALSE;
    AVATAR_06_C = llGetOwner(); percentage06c = (float)FALSE;
    AVATAR_07_A = llGetOwner(); percentage07a = (float)FALSE;
    AVATAR_07_B = llGetOwner(); percentage07b = (float)FALSE;
    AVATAR_07_C = llGetOwner(); percentage07c = (float)FALSE;
    AVATAR_08_A = llGetOwner(); percentage08a = (float)FALSE;
    AVATAR_08_B = llGetOwner(); percentage08b = (float)FALSE;
    AVATAR_08_C = llGetOwner(); percentage08c = (float)FALSE;
    AVATAR_09_A = llGetOwner(); percentage09a = (float)FALSE;
    AVATAR_09_B = llGetOwner(); percentage09b = (float)FALSE;
    AVATAR_09_C = llGetOwner(); percentage09c = (float)FALSE;
    NOTECARD_QUERY  = llGetNotecardLine("HAIKUvend 1prim.cfg",NOTECARD_LINE);
}

config_parse(string input_string)
{
    string line = llStringTrim(input_string,STRING_TRIM);
    if (llGetSubString(line,0,1) != "//" && line != "")
    {
        list ldata  = llParseStringKeepNulls(line, ["=","#"], [""]);
        string cmd  = llToUpper(llStringTrim(llList2String(ldata,0),STRING_TRIM));
        string arg1  = llStringTrim(llList2String(ldata,1),STRING_TRIM);
        string arg2  = llStringTrim(llList2String(ldata,2),STRING_TRIM);
        string arg3  = llStringTrim(llList2String(ldata,3),STRING_TRIM);
        if (cmd == "FOLDER1") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER2") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER3") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER4") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER5") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER6") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER7") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER8") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "FOLDER9") { FOLDER_NAMES += [arg1]; FOLDER_PRICES += [(integer)arg3];}
        else if (cmd == "%01A") { percentage01a = (float)arg1; AVATAR_01_A = (key)arg2; }
        else if (cmd == "%01B") { percentage01b = (float)arg1; AVATAR_01_B = (key)arg2; }
        else if (cmd == "%01C") { percentage01c = (float)arg1; AVATAR_01_C = (key)arg2; }
        else if (cmd == "%02A") { percentage02a = (float)arg1; AVATAR_02_A = (key)arg2; }
        else if (cmd == "%02B") { percentage02b = (float)arg1; AVATAR_02_B = (key)arg2; }
        else if (cmd == "%02C") { percentage02c = (float)arg1; AVATAR_02_C = (key)arg2; }
        else if (cmd == "%03A") { percentage03a = (float)arg1; AVATAR_03_A = (key)arg2; }
        else if (cmd == "%03B") { percentage03b = (float)arg1; AVATAR_03_B = (key)arg2; }
        else if (cmd == "%03C") { percentage03c = (float)arg1; AVATAR_03_C = (key)arg2; }
        else if (cmd == "%04A") { percentage04a = (float)arg1; AVATAR_04_A = (key)arg2; }
        else if (cmd == "%04B") { percentage04b = (float)arg1; AVATAR_04_B = (key)arg2; }
        else if (cmd == "%04C") { percentage04c = (float)arg1; AVATAR_04_C = (key)arg2; }
        else if (cmd == "%05A") { percentage05a = (float)arg1; AVATAR_05_A = (key)arg2; }
        else if (cmd == "%05B") { percentage05b = (float)arg1; AVATAR_05_B = (key)arg2; }
        else if (cmd == "%05C") { percentage05c = (float)arg1; AVATAR_05_C = (key)arg2; }
        else if (cmd == "%06A") { percentage06a = (float)arg1; AVATAR_06_A = (key)arg2; }
        else if (cmd == "%06B") { percentage06b = (float)arg1; AVATAR_06_B = (key)arg2; }
        else if (cmd == "%06C") { percentage06c = (float)arg1; AVATAR_06_C = (key)arg2; }
        else if (cmd == "%07A") { percentage07a = (float)arg1; AVATAR_07_A = (key)arg2; }
        else if (cmd == "%07B") { percentage07b = (float)arg1; AVATAR_07_B = (key)arg2; }
        else if (cmd == "%07C") { percentage07c = (float)arg1; AVATAR_07_C = (key)arg2; }
        else if (cmd == "%08A") { percentage08a = (float)arg1; AVATAR_08_A = (key)arg2; }
        else if (cmd == "%08B") { percentage08b = (float)arg1; AVATAR_08_B = (key)arg2; }
        else if (cmd == "%08C") { percentage08c = (float)arg1; AVATAR_08_C = (key)arg2; }
        else if (cmd == "%09A") { percentage09a = (float)arg1; AVATAR_09_A = (key)arg2; }
        else if (cmd == "%09B") { percentage09b = (float)arg1; AVATAR_09_B = (key)arg2; }
        else if (cmd == "%09C") { percentage09c = (float)arg1; AVATAR_09_C = (key)arg2; }
    }
}

config_dump()
{
    if (percentage01a != 0) { say("Avatar with key '" + (string)AVATAR_01_A + "' gets " + (string)percentage01a + "% of the money for folder 1 (" + llList2String(FOLDER_NAMES,0) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,0)*percentage01a/100))+ " of " + llList2String(FOLDER_PRICES,0) + " Lindens."); }
    if (percentage01b != 0) { say("Avatar with key '" + (string)AVATAR_01_B + "' gets " + (string)percentage01b + "% of the money for folder 1 (" + llList2String(FOLDER_NAMES,0) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,0)*percentage01b/100))+ " of " + llList2String(FOLDER_PRICES,0) + " Lindens."); }
    if (percentage01c != 0) { say("Avatar with key '" + (string)AVATAR_01_C + "' gets " + (string)percentage01c + "% of the money for folder 1 (" + llList2String(FOLDER_NAMES,0) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,0)*percentage01c/100))+ " of " + llList2String(FOLDER_PRICES,0) + " Lindens."); }
    if (percentage02a != 0) { say("Avatar with key '" + (string)AVATAR_02_A + "' gets " + (string)percentage02a + "% of the money for folder 2 (" + llList2String(FOLDER_NAMES,1) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,1)*percentage02a/100))+ " of " + llList2String(FOLDER_PRICES,1) + " Lindens."); }
    if (percentage02b != 0) { say("Avatar with key '" + (string)AVATAR_02_B + "' gets " + (string)percentage02b + "% of the money for folder 2 (" + llList2String(FOLDER_NAMES,1) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,1)*percentage02b/100))+ " of " + llList2String(FOLDER_PRICES,1) + " Lindens."); }
    if (percentage02c != 0) { say("Avatar with key '" + (string)AVATAR_02_C + "' gets " + (string)percentage02c + "% of the money for folder 2 (" + llList2String(FOLDER_NAMES,1) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,1)*percentage02c/100))+ " of " + llList2String(FOLDER_PRICES,1) + " Lindens."); }
    if (percentage03a != 0) { say("Avatar with key '" + (string)AVATAR_03_A + "' gets " + (string)percentage03a + "% of the money for folder 3 (" + llList2String(FOLDER_NAMES,2) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,2)*percentage03a/100))+ " of " + llList2String(FOLDER_PRICES,2) + " Lindens."); }
    if (percentage03b != 0) { say("Avatar with key '" + (string)AVATAR_03_B + "' gets " + (string)percentage03b + "% of the money for folder 3 (" + llList2String(FOLDER_NAMES,2) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,2)*percentage03b/100))+ " of " + llList2String(FOLDER_PRICES,2) + " Lindens."); }
    if (percentage03c != 0) { say("Avatar with key '" + (string)AVATAR_03_C + "' gets " + (string)percentage03c + "% of the money for folder 3 (" + llList2String(FOLDER_NAMES,2) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,2)*percentage03c/100))+ " of " + llList2String(FOLDER_PRICES,2) + " Lindens."); }
    if (percentage04a != 0) { say("Avatar with key '" + (string)AVATAR_04_A + "' gets " + (string)percentage04a + "% of the money for folder 4 (" + llList2String(FOLDER_NAMES,3) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,3)*percentage04a/100))+ " of " + llList2String(FOLDER_PRICES,3) + " Lindens."); }
    if (percentage04b != 0) { say("Avatar with key '" + (string)AVATAR_04_B + "' gets " + (string)percentage04b + "% of the money for folder 4 (" + llList2String(FOLDER_NAMES,3) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,3)*percentage04b/100))+ " of " + llList2String(FOLDER_PRICES,3) + " Lindens."); }
    if (percentage04c != 0) { say("Avatar with key '" + (string)AVATAR_04_C + "' gets " + (string)percentage04c + "% of the money for folder 4 (" + llList2String(FOLDER_NAMES,3) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,3)*percentage04c/100))+ " of " + llList2String(FOLDER_PRICES,3) + " Lindens."); }
    if (percentage05a != 0) { say("Avatar with key '" + (string)AVATAR_05_A + "' gets " + (string)percentage05a + "% of the money for folder 5 (" + llList2String(FOLDER_NAMES,4) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,4)*percentage05a/100))+ " of " + llList2String(FOLDER_PRICES,4) + " Lindens."); }
    if (percentage05b != 0) { say("Avatar with key '" + (string)AVATAR_05_B + "' gets " + (string)percentage05b + "% of the money for folder 5 (" + llList2String(FOLDER_NAMES,4) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,4)*percentage05b/100))+ " of " + llList2String(FOLDER_PRICES,4) + " Lindens."); }
    if (percentage05c != 0) { say("Avatar with key '" + (string)AVATAR_05_C + "' gets " + (string)percentage05c + "% of the money for folder 5 (" + llList2String(FOLDER_NAMES,4) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,4)*percentage05c/100))+ " of " + llList2String(FOLDER_PRICES,4) + " Lindens."); }
    if (percentage06a != 0) { say("Avatar with key '" + (string)AVATAR_06_A + "' gets " + (string)percentage06a + "% of the money for folder 6 (" + llList2String(FOLDER_NAMES,5) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,5)*percentage06a/100))+ " of " + llList2String(FOLDER_PRICES,5) + " Lindens."); }
    if (percentage06b != 0) { say("Avatar with key '" + (string)AVATAR_06_B + "' gets " + (string)percentage06b + "% of the money for folder 6 (" + llList2String(FOLDER_NAMES,5) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,5)*percentage06b/100))+ " of " + llList2String(FOLDER_PRICES,5) + " Lindens."); }
    if (percentage06c != 0) { say("Avatar with key '" + (string)AVATAR_06_C + "' gets " + (string)percentage06c + "% of the money for folder 6 (" + llList2String(FOLDER_NAMES,5) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,5)*percentage06c/100))+ " of " + llList2String(FOLDER_PRICES,5) + " Lindens."); }
    if (percentage07a != 0) { say("Avatar with key '" + (string)AVATAR_07_A + "' gets " + (string)percentage07a + "% of the money for folder 7 (" + llList2String(FOLDER_NAMES,6) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,6)*percentage07a/100))+ " of " + llList2String(FOLDER_PRICES,6) + " Lindens."); }
    if (percentage07b != 0) { say("Avatar with key '" + (string)AVATAR_07_B + "' gets " + (string)percentage07b + "% of the money for folder 7 (" + llList2String(FOLDER_NAMES,6) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,6)*percentage07b/100))+ " of " + llList2String(FOLDER_PRICES,6) + " Lindens."); }
    if (percentage07c != 0) { say("Avatar with key '" + (string)AVATAR_07_C + "' gets " + (string)percentage07c + "% of the money for folder 7 (" + llList2String(FOLDER_NAMES,6) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,6)*percentage07c/100))+ " of " + llList2String(FOLDER_PRICES,6) + " Lindens."); }
    if (percentage08a != 0) { say("Avatar with key '" + (string)AVATAR_08_A + "' gets " + (string)percentage08a + "% of the money for folder 8 (" + llList2String(FOLDER_NAMES,7) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,7)*percentage08a/100))+ " of " + llList2String(FOLDER_PRICES,7) + " Lindens."); }
    if (percentage08b != 0) { say("Avatar with key '" + (string)AVATAR_08_B + "' gets " + (string)percentage08b + "% of the money for folder 8 (" + llList2String(FOLDER_NAMES,7) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,7)*percentage08b/100))+ " of " + llList2String(FOLDER_PRICES,7) + " Lindens."); }
    if (percentage08c != 0) { say("Avatar with key '" + (string)AVATAR_08_C + "' gets " + (string)percentage08c + "% of the money for folder 8 (" + llList2String(FOLDER_NAMES,7) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,7)*percentage08c/100))+ " of " + llList2String(FOLDER_PRICES,7) + " Lindens."); }
    if (percentage09a != 0) { say("Avatar with key '" + (string)AVATAR_09_A + "' gets " + (string)percentage09a + "% of the money for folder 9 (" + llList2String(FOLDER_NAMES,8) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,8)*percentage09a/100))+ " of " + llList2String(FOLDER_PRICES,8) + " Lindens."); }
    if (percentage09b != 0) { say("Avatar with key '" + (string)AVATAR_09_B + "' gets " + (string)percentage09b + "% of the money for folder 9 (" + llList2String(FOLDER_NAMES,8) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,8)*percentage09b/100))+ " of " + llList2String(FOLDER_PRICES,8) + " Lindens."); }
    if (percentage09c != 0) { say("Avatar with key '" + (string)AVATAR_09_C + "' gets " + (string)percentage09c + "% of the money for folder 9 (" + llList2String(FOLDER_NAMES,8) + "). Which is " + (string)llFloor((llList2Integer(FOLDER_PRICES,8)*percentage09c/100))+ " of " + llList2String(FOLDER_PRICES,8) + " Lindens."); }
}

config_check()
{
    integer are_perms_ok = TRUE;
    
    if (percentage01a < 0.0 || 100.0 < percentage01a ||
        percentage01b < 0.0 || 100.0 < percentage01b ||
        percentage01c < 0.0 || 100.0 < percentage01c ||
        percentage02a < 0.0 || 100.0 < percentage02a ||
        percentage02b < 0.0 || 100.0 < percentage02b ||
        percentage02c < 0.0 || 100.0 < percentage02c ||
        percentage03a < 0.0 || 100.0 < percentage03a ||
        percentage03b < 0.0 || 100.0 < percentage03b ||
        percentage03c < 0.0 || 100.0 < percentage03c ||
        percentage04a < 0.0 || 100.0 < percentage04a ||
        percentage04b < 0.0 || 100.0 < percentage04b ||
        percentage04c < 0.0 || 100.0 < percentage04c ||
        percentage05a < 0.0 || 100.0 < percentage05a ||
        percentage05b < 0.0 || 100.0 < percentage05b ||
        percentage05c < 0.0 || 100.0 < percentage05c ||
        percentage06a < 0.0 || 100.0 < percentage06a ||
        percentage06b < 0.0 || 100.0 < percentage06b ||
        percentage06c < 0.0 || 100.0 < percentage06c ||
        percentage07a < 0.0 || 100.0 < percentage07a ||
        percentage07b < 0.0 || 100.0 < percentage07b ||
        percentage07c < 0.0 || 100.0 < percentage07c ||
        percentage08a < 0.0 || 100.0 < percentage08a ||
        percentage08b < 0.0 || 100.0 < percentage08b ||
        percentage08c < 0.0 || 100.0 < percentage08c ||
        percentage09a < 0.0 || 100.0 < percentage09a ||
        percentage09b < 0.0 || 100.0 < percentage09b ||
        percentage09c < 0.0 || 100.0 < percentage09c)
    are_perms_ok = FALSE;

    if (!are_perms_ok)
    {
        say("You have set a percentage for a commission below 0.0% or above 100.0%, please make sure the percentages for the commissions are within the limits!");
        llResetScript();
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
                config_check();
                state perms_check;
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

state perms_check
{
        on_rez(integer start_param) { llResetScript(); }

        state_entry()
        {
            llSetTimerEvent(30.0);
            say("Commission script is requesting debit permissions...");
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        }

        changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) { llResetScript(); } }
        
        run_time_permissions (integer perm)
    {
        if(perm & PERMISSION_DEBIT)
        {
            llSetTimerEvent((float)FALSE);
            state share;
        }
        else
        {
            llSetTimerEvent((float)FALSE);
            say("\n \nResetting script now!!!\n \n"
                    + "YOU MUST GRANT DEBIT PERMISSIONS NEXT TIME!\n");
            llResetScript();
        }
    }

    timer()
    {
        llSetTimerEvent((float)FALSE);
        say("\n \nResetting script now!!!\n \n"
              + "YOU MUST GRANT DEBIT PERMISSIONS NEXT TIME!\n");
        llResetScript();
    }

    state_exit()
    {
        llSetTimerEvent((float)FALSE);
    }
}

state share
{
    on_rez(integer start_param) { llResetScript(); }
    
    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) { llResetScript(); } }
    
    link_message(integer sender,integer num,string str,key id)
    {
        if (str == "totalsold1")
        {
            if (0.0 < percentage01a && percentage01a < 100.0)
            {
                float comfl01a = num*percentage01a/100.0;
                integer comm01a = llFloor(comfl01a);
                llGiveMoney(AVATAR_01_A,comm01a);
            }
            if (0.0 < percentage01b && percentage01b < 100.0)
            {
                float comfl01b = num*percentage01b/100.0;
                integer comm01b = llFloor(comfl01b);
                llGiveMoney(AVATAR_01_B,comm01b);
            }
            if (0.0 < percentage01c && percentage01c < 100.0)
            {
                float comfl01c = num*percentage01c/100.0;
                integer comm01c = llFloor(comfl01c);
                llGiveMoney(AVATAR_01_C,comm01c);
            }
        }
        else if (str == "totalsold2")
        {
            if (0.0 < percentage02a && percentage02a < 100.0)
            {
                float comfl02a = num*percentage02a/100.0;
                integer comm02a = llFloor(comfl02a);
                llGiveMoney(AVATAR_02_A,comm02a);
            }
            if (0.0 < percentage02b && percentage02b < 100.0)
            {
                float comfl02b = num*percentage02b/100.0;
                integer comm02b = llFloor(comfl02b);
                llGiveMoney(AVATAR_02_B,comm02b);
            }
            if (0.0 < percentage02c && percentage02c < 100.0)
            {
                float comfl02c = num*percentage02c/100.0;
                integer comm02c = llFloor(comfl02c);
                llGiveMoney(AVATAR_02_C,comm02c);
            }
        }
        else if (str == "totalsold3")
        {
            if (0.0 < percentage03a && percentage03a < 100.0)
            {
                float comfl03a = num*percentage03a/100.0;
                integer comm03a = llFloor(comfl03a);
                llGiveMoney(AVATAR_03_A,comm03a);
            }
            if (0.0 < percentage03b && percentage03b < 100.0)
            {
                float comfl03b = num*percentage03b/100.0;
                integer comm03b = llFloor(comfl03b);
                llGiveMoney(AVATAR_03_B,comm03b);
            }
            if (0.0 < percentage03c && percentage03c < 100.0)
            {
                float comfl03c = num*percentage03c/100.0;
                integer comm03c = llFloor(comfl03c);
                llGiveMoney(AVATAR_03_C,comm03c);
            }
        }
        else if (str == "totalsold4")
        {
            if (0.0 < percentage04a && percentage04a < 100.0)
            {
                float comfl04a = num*percentage04a/100.0;
                integer comm04a = llFloor(comfl04a);
                llGiveMoney(AVATAR_04_A,comm04a);
            }
            if (0.0 < percentage04b && percentage04b < 100.0)
            {
                float comfl04b = num*percentage04b/100.0;
                integer comm04b = llFloor(comfl04b);
                llGiveMoney(AVATAR_04_B,comm04b);
            }
            if (0.0 < percentage04c && percentage04c < 100.0)
            {
                float comfl04c = num*percentage04c/100.0;
                integer comm04c = llFloor(comfl04c);
                llGiveMoney(AVATAR_04_C,comm04c);
            }
        }
        else if (str == "totalsold5")
        {
            if (0.0 < percentage05a && percentage05a < 100.0)
            {
                float comfl05a = num*percentage05a/100.0;
                integer comm05a = llFloor(comfl05a);
                llGiveMoney(AVATAR_05_A,comm05a);
            }
            if (0.0 < percentage05b && percentage05b < 100.0)
            {
                float comfl05b = num*percentage05b/100.0;
                integer comm05b = llFloor(comfl05b);
                llGiveMoney(AVATAR_05_B,comm05b);
            }
            if (0.0 < percentage05c && percentage05c < 100.0)
            {
                float comfl05c = num*percentage05c/100.0;
                integer comm05c = llFloor(comfl05c);
                llGiveMoney(AVATAR_05_C,comm05c);
            }
        }
        else if (str == "totalsold6")
        {
            if (0.0 < percentage06a && percentage06a < 100.0)
            {
                float comfl06a = num*percentage06a/100.0;
                integer comm06a = llFloor(comfl06a);
                llGiveMoney(AVATAR_06_A,comm06a);
            }
            if (0.0 < percentage06b && percentage06b < 100.0)
            {
                float comfl06b = num*percentage06b/100.0;
                integer comm06b = llFloor(comfl06b);
                llGiveMoney(AVATAR_06_B,comm06b);
            }
            if (0.0 < percentage06c && percentage06c < 100.0)
            {
                float comfl06c = num*percentage06c/100.0;
                integer comm06c = llFloor(comfl06c);
                llGiveMoney(AVATAR_06_C,comm06c);
            }
        }
        else if (str == "totalsold7")
        {
            if (0.0 < percentage07a && percentage07a < 100.0)
            {
                float comfl07a = num*percentage07a/100.0;
                integer comm07a = llFloor(comfl07a);
                llGiveMoney(AVATAR_07_A,comm07a);
            }
            if (0.0 < percentage07b && percentage07b < 100.0)
            {
                float comfl07b = num*percentage07b/100.0;
                integer comm07b = llFloor(comfl07b);
                llGiveMoney(AVATAR_07_B,comm07b);
            }
            if (0.0 < percentage07c && percentage07c < 100.0)
            {
                float comfl07c = num*percentage07c/100.0;
                integer comm07c = llFloor(comfl07c);
                llGiveMoney(AVATAR_07_C,comm07c);
            }
        }
        else if (str == "totalsold8")
        {
            if (0.0 < percentage08a && percentage08a < 100.0)
            {
                float comfl08a = num*percentage08a/100.0;
                integer comm08a = llFloor(comfl08a);
                llGiveMoney(AVATAR_08_A,comm08a);
            }
            if (0.0 < percentage08b && percentage08b < 100.0)
            {
                float comfl08b = num*percentage08b/100.0;
                integer comm08b = llFloor(comfl08b);
                llGiveMoney(AVATAR_08_B,comm08b);
            }
            if (0.0 < percentage08c && percentage08c < 100.0)
            {
                float comfl08c = num*percentage08c/100.0;
                integer comm08c = llFloor(comfl08c);
                llGiveMoney(AVATAR_08_C,comm08c);
            }
        }
        else if (str == "totalsold9")
        {
            if (0.0 < percentage09a && percentage09a < 100.0)
            {
                float comfl09a = num*percentage09a/100.0;
                integer comm09a = llFloor(comfl09a);
                llGiveMoney(AVATAR_09_A,comm09a);
            }
            if (0.0 < percentage09b && percentage09b < 100.0)
            {
                float comfl09b = num*percentage09b/100.0;
                integer comm09b = llFloor(comfl09b);
                llGiveMoney(AVATAR_09_B,comm09b);
            }
            if (0.0 < percentage09c && percentage09c < 100.0)
            {
                float comfl09c = num*percentage09c/100.0;
                integer comm09c = llFloor(comfl09c);
                llGiveMoney(AVATAR_09_C,comm09c);
            }
        }
    }
}