// LSL script generated: FSDebug.lslp Sun Jan 24 18:17:31 Mitteleuropäische Zeit 2016
list Define_GroupNames = ["ALL","FEMALE","MALE","LEAD","LEFT","CENTER","RIGHT","GROUP1","GROUP2","GROUP3","GROUP4","GROUP5"];
list Define_GroupBits = [1,2,4,8,16,32,64,128,256,512,1024,2048];
list keywordTable = ["|","ALIAS","DANCE","DELAY","DIALOG","END","GIVE","GROUP","IM","LOOP","MENU","MENUSTYLE","MESSAGE","MIX","NAME","NEXTSEQUENCE","OWNER_SAY","RAND","RANDOM","REGION_SAY","REPEAT","SAY","SETNAME","SHOUT","STOP","STYLE","WHISPER","ZZZDEFER"];
list msgs = [];
integer count = 0;
list sequence = [];
integer capture = FALSE;
integer printEveryMsg = FALSE;
PrintBigString(string str){
    integer i;
    integer j;
    (j = llStringLength(str));
    if ((j > 1000)) {
        for ((i = 0); (i < j); (i += 1000)) {
            if (((i + 1023) < j)) llOwnerSay((llGetSubString(str,i,(i + 999)) + "\\"));
            else  llOwnerSay(llGetSubString(str,i,(-1)));
        }
    }
    else  llOwnerSay(str);
}
ShowSequence(string prefix){
    integer i;
    integer j;
    integer k;
    string str;
    list item;
    integer cmd;
    list output;
    (j = llGetListLength(sequence));
    (output = []);
    for ((i = 0); (i < j); (++i)) {
        (item = llParseString2List(llList2String(sequence,i),["|"],[]));
        (cmd = llList2Integer(item,0));
        (k = llListFindList([2,3],[cmd]));
        if (((-1) != k)) {
            if ((k == 1)) {
                (str = llList2String(item,1));
                (output = (((output = []) + output) + [((llGetSubString(str,0,(-2)) + ".") + llGetSubString(str,(-1),(-1)))]));
            }
            else  {
                if ((llGetListLength(item) == 2)) (output = (((output = []) + output) + [llList2String(item,1)]));
                else  {
                    (str = ((((((llList2String(item,1) + "(group=") + llList2String((["Unknown"] + Define_GroupNames),(llListFindList(Define_GroupBits,[llList2Integer(item,2)]) + 1))) + llList2String(["","",", start",", stop"],(llList2Integer(item,3) + 1))) + ", dance index=") + ((string)llList2Integer(item,4))) + ")"));
                    (output = (((output = []) + output) + [str]));
                }
            }
        }
        else  {
            if (((-1) != llListFindList([4,8,11,14,15,16,22,25],[cmd]))) (output = (((output = []) + output) + [((("[" + llList2String(keywordTable,cmd)) + "]") + llList2String(item,1))]));
            else  {
                if (((-1) != llListFindList([9,13,17,18],[cmd]))) (output = (((output = []) + output) + [(((("[" + llList2String(keywordTable,cmd)) + " ") + llList2String(item,1)) + "]")]));
                else  {
                    if (((-1) != llListFindList([1,7,10,12,19,21,23,26],[cmd]))) (output = (((output = []) + output) + [((((("[" + llList2String(keywordTable,cmd)) + " ") + llList2String(item,1)) + "]") + llList2String(item,2))]));
                    else  (output = (((output = []) + output) + [(("[" + llList2String(keywordTable,cmd)) + "]")]));
                }
            }
        }
    }
    PrintBigString((prefix + llDumpList2String(output,"|")));
}
default {

 link_message(integer sender_num,integer num,string str,key id) {
        if ((num == 12123404)) {
            list cmd = llParseString2List(str,["|"],[]);
            integer debugCmd = llList2Integer(cmd,0);
            if ((debugCmd == 1)) {
                (sequence = llParseString2List(((string)id),["|||"],[]));
                ShowSequence((("Sequence: " + llList2String(cmd,1)) + ":"));
            }
            if ((debugCmd == 2)) {
                (capture = TRUE);
                llOwnerSay("Debug - started capturing debugging information");
            }
            if ((debugCmd == 3)) {
                (capture = FALSE);
                llOwnerSay("Debug - stopped capturing debugging information");
            }
            if ((debugCmd == 4)) {
                (printEveryMsg = TRUE);
                llOwnerSay("Debug - started printing debug information");
            }
            if ((debugCmd == 5)) {
                (printEveryMsg = FALSE);
                llOwnerSay("Debug - stopped printing debug information");
            }
            if ((debugCmd == 6)) {
                integer i;
                for ((i = 0); (i < count); (++i)) PrintBigString(("FSD:" + llList2String(msgs,i)));
            }
            return;
        }
        if (capture) {
            string tmp = llDumpList2String([llGetTime(),num,str,id],"@");
            (msgs = (((msgs = []) + msgs) + [tmp]));
            if (printEveryMsg) PrintBigString(("FSD:" + tmp));
            (++count);
            if ((count >= 10)) {
                (msgs = ((msgs = []) + llDeleteSubList(msgs,0,0)));
                (--count);
            }
        }
    }
}
