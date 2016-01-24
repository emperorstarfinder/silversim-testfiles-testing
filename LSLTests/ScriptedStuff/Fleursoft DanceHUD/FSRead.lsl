// LSL script generated: FSRead.lslp Sun Jan 24 18:17:34 Mitteleuropäische Zeit 2016
list Define_GroupNames = ["ALL","FEMALE","MALE","LEAD","LEFT","CENTER","RIGHT","GROUP1","GROUP2","GROUP3","GROUP4","GROUP5"];
list Define_GroupBits = [1,2,4,8,16,32,64,128,256,512,1024,2048];
list Define_GroupAliases = ["|","|","|","|","|","|","|","|","|","|","|","|"];
list keywordTable = ["|","ALIAS","DANCE","DELAY","DIALOG","END","GIVE","GROUP","IM","LOOP","MENU","MENUSTYLE","MESSAGE","MIX","NAME","NEXTSEQUENCE","OWNER_SAY","RAND","RANDOM","REGION_SAY","REPEAT","SAY","SETNAME","SHOUT","STOP","STYLE","WHISPER","ZZZDEFER"];
list optionsTable = [0,12,1032,1042,1032,128,1032,76,1032,65,2057,2057,1545,65,8,1288,1032,1074,65,1545,1280,1545,1032,1545,1280,8,1545,5128];
integer loadingNotecard = FALSE;
string notecard = "";
key readLineId = NULL_KEY;
integer line = 0;
integer menuNumber = 1;
integer sequenceCount = 0;
integer unnamedCount = 0;
integer sequenceDances = 0;
integer resetSequence = TRUE;
list sequence = [];
list missingDances = [];
string sequenceName = "";
integer previousWasADance = FALSE;
list menuStyles = [];
list loops = [];
integer loopsInGroup = 0;
integer warnMissingAnims = FALSE;
integer keepBlankLines = FALSE;
integer keepCommentLines = FALSE;
integer rememberSeq = FALSE;
integer keyword;
list params;
string s;
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
Initialize(){
    (Define_GroupAliases = []);
    for ((line = 0); (line < llGetListLength(Define_GroupBits)); (line++)) (Define_GroupAliases = (((Define_GroupAliases = []) + Define_GroupAliases) + ["|"]));
    for ((line = 0); (line < 10); (line++)) (menuStyles = (((menuStyles = []) + menuStyles) + ["|"]));
}
SaveKeyword(integer keywordType,string parameters){
    if ((previousWasADance && (keywordType != 3))) (sequence = (((sequence = []) + sequence) + [((((string)3) + "|") + ((string)-1))]));
    if (((-1) == llListFindList([5,24,20],[keywordType]))) (sequence = (((sequence = []) + sequence) + [((((string)keywordType) + "|") + parameters)]));
    else  (sequence = (((sequence = []) + sequence) + [((string)keywordType)]));
    if (((14 == keywordType) || ((sequenceName == "") && (2 == keywordType)))) (sequenceName = parameters);
    if ((keywordType == 2)) (sequenceDances++);
    (previousWasADance = (keywordType == 2));
}
integer CheckStartOfLoop(string token){
    integer i;
    list loopInfo;
    if ((llGetListLength(loops) == 0)) {
        (s = ((((((string)keyword) + "|") + ((string)(llGetListLength(sequence) - 1))) + "|") + ((string)sequenceDances)));
        (loops = (((loops = []) + loops) + [s]));
        return TRUE;
    }
    (loopInfo = llParseString2List(llList2String(loops,0),["|"],[]));
    (i = llList2Integer(loopInfo,0));
    if ((keyword == 7)) {
        if ((i == 7)) {
            OwnerSay("NCMSG021",[line,token]);
            return FALSE;
        }
    }
    else  {
        if (((-1) != llListFindList([9,13,18],[i]))) {
            OwnerSay("NCMSG020",[line,token]);
            return FALSE;
        }
        if ((loopsInGroup >= 1)) {
            OwnerSay("NCMSG022",[line,token]);
            return FALSE;
        }
        (loopsInGroup++);
    }
    (s = ((((((string)keyword) + "|") + ((string)(llGetListLength(sequence) - 1))) + "|") + ((string)sequenceDances)));
    (loops = (((loops = []) + loops) + [s]));
    return TRUE;
}
integer CheckEndOfLoops(string token){
    list loopStart;
    integer i;
    integer j;
    integer loopRepeatCount;
    integer loopsLen = llGetListLength(loops);
    if ((loopsLen == 0)) {
        OwnerSay("NCMSG028",[((string)line),token]);
        return FALSE;
    }
    (loopStart = llParseString2List(llList2String(loops,(-1)),["|"],[]));
    (i = llList2Integer(loopStart,0));
    if ((i == 7)) {
        (loopsInGroup = 0);
    }
    else  {
        if ((i != 9)) {
            (s = llList2String(keywordTable,i));
            (i = llList2Integer(loopStart,2));
            (j = llList2Integer(loopStart,1));
            (loopRepeatCount = llList2Integer(llParseString2List(llList2String(sequence,j),["|"],[]),1));
            if ((loopRepeatCount > (sequenceDances - i))) {
                OwnerSay("NCMSG029",[((string)line),token,s,loopRepeatCount,(sequenceDances - i)]);
                (loopStart = llParseString2List(llList2String(sequence,j),["|"],[]));
                (loopStart = ((loopStart = []) + llListReplaceList(loopStart,[(sequenceDances - i)],1,1)));
                (s = llDumpList2String(loopStart,"|"));
                (sequence = ((sequence = []) + llListReplaceList(sequence,[s],j,j)));
            }
        }
    }
    if ((loopsLen > 1)) (loops = [llList2String(loops,0)]);
    else  (loops = []);
    return TRUE;
}
integer ValidateKeywordParams(string token){
    integer i;
    integer j;
    if ((keyword == 2)) {
        (s = llList2String(params,0));
        if ((warnMissingAnims && (INVENTORY_ANIMATION != llGetInventoryType(s)))) {
            if ((llListFindList(missingDances,[s]) == (-1))) (missingDances = (((missingDances = []) + missingDances) + [s]));
            if ((llGetListLength(missingDances) >= 100)) {
                (missingDances = ((missingDances = []) + llListSort(missingDances,1,TRUE)));
                OwnerSay("NCMSG032",[((string)llGetListLength(missingDances))]);
                OwnerSay("NCMSG005b",[llDumpList2String(missingDances,",")]);
                (missingDances = []);
            }
            OwnerSay("NCMSG014",[line,token,s]);
            return TRUE;
        }
        return TRUE;
    }
    if ((keyword == 10)) {
        (menuNumber = llList2Integer(params,0));
        llMessageLinked(LINK_THIS,(305410560 + menuNumber),llDumpList2String([108,llList2String(params,1)],"|"),((key)""));
        return TRUE;
    }
    if ((keyword == 1)) {
        (s = llList2String(params,0));
        (i = llListFindList(Define_GroupNames,[s]));
        if ((i < 1)) {
            OwnerSay(llList2String(["NCMSG012","NCMSG25"],(i + 1)),[line,token]);
            return FALSE;
        }
        (params += [i]);
        (i = (llList2Integer(params,1) - 1));
        (s = llList2String(params,2));
        (Define_GroupAliases = ((Define_GroupAliases = []) + llListReplaceList(Define_GroupAliases,[s],i,i)));
        return TRUE;
    }
    if ((keyword == 7)) {
        string s2 = llList2String(params,0);
        if (((-1) == llListFindList(["SAME","DIFFERENT"],[s2]))) {
            OwnerSay("NCMSG011",[line,token]);
            return FALSE;
        }
        (s = llStringTrim(llGetSubString(token,llSubStringIndex(token,llList2String(params,1)),(-1)),STRING_TRIM));
        (i = llListFindList(Define_GroupNames,[llToUpper(s)]));
        if ((i == (-1))) {
            (i = llListFindList(Define_GroupAliases,[llToUpper(s)]));
            if ((i == (-1))) {
                OwnerSay("NCMSG016",[line,token,s]);
                return FALSE;
            }
        }
        (params = [s2,llList2Integer(Define_GroupBits,i),s,llList2String(Define_GroupNames,i)]);
        (loopsInGroup = 0);
        return TRUE;
    }
    if ((keyword == 9)) {
        (i = llList2Integer(params,0));
        if ((i < 2)) {
            OwnerSay("NCMSG023",[((string)line),token,i]);
            return FALSE;
        }
        if ((i > 10)) {
            OwnerSay("NCMSG024",[((string)line),token,i,10]);
            return FALSE;
        }
        return TRUE;
    }
    if ((keyword == 11)) {
        (i = llList2Integer(params,0));
        (s = llToUpper(llList2String(params,1)));
        (j = llListFindList(menuStyles,[s]));
        if (((j != (-1)) && (j != (i - 1)))) {
            (menuStyles = ((menuStyles = []) + llListReplaceList(menuStyles,["|"],j,j)));
        }
        (menuStyles = ((menuStyles = []) + llListReplaceList(menuStyles,[s],(i - 1),(i - 1))));
        return TRUE;
    }
    if ((keyword == 4)) {
        (i = llGetListLength(llParseString2List(llList2String(params,0),[","],[])));
        if ((i < 3)) {
            OwnerSay("NCMSG015",[line,token]);
            return FALSE;
        }
        return TRUE;
    }
    if ((keyword == 25)) {
        (s = llToUpper(llList2String(params,0)));
        (i = llListFindList(menuStyles,[s]));
        if ((i != (-1))) (menuNumber = (i + 1));
        else  {
            (i = llListFindList(menuStyles,["|"]));
            if ((i != (-1))) {
                (menuStyles = ((menuStyles = []) + llListReplaceList(menuStyles,[s],i,i)));
                (menuNumber = (i + 1));
                OwnerSay("NCMSG027",[line,menuNumber,s]);
            }
            else  OwnerSay("NCMSG030",[line,token,menuNumber,s]);
        }
        return TRUE;
    }
    return TRUE;
}
integer processToken(string input){
    list outer;
    list inner;
    integer options;
    integer i;
    integer j;
    float f;
    string token;
    if ((INVENTORY_ANIMATION == llGetInventoryType(input))) {
        SaveKeyword(2,input);
        return TRUE;
    }
    (outer = llParseString2List(input,["[","]"],[]));
    (inner = llParseString2List(llStringTrim(llList2String(outer,0),STRING_TRIM),[" ",",",":"],[]));
    (token = llStringTrim(llList2String(inner,0),STRING_TRIM));
    (keyword = llListFindList(keywordTable,[llToUpper(token)]));
    if ((keyword == (-1))) {
        OwnerSay("NCMSG007",[line,input]);
        return FALSE;
    }
    (options = llList2Integer(optionsTable,keyword));
    if ((options & 4096)) {
        OwnerSay("NCMSG007",[line,input]);
        return FALSE;
    }
    (i = llGetListLength(inner));
    (params = []);
    if ((options & 1)) {
        if ((i > 1)) {
            (j = ((integer)llStringTrim(llList2String(inner,1),STRING_TRIM)));
            if (((j < 0) && (!(options & 512)))) {
                OwnerSay("NCMSG008",[line,input]);
                return FALSE;
            }
            if (((j == 0) && ((-1) == llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(llStringTrim(llList2String(inner,1),STRING_TRIM),0,0)])))) {
                OwnerSay("NCMSG009",[line,input]);
                return FALSE;
            }
            if (((options & 2048) && ((j < 1) || (j > 10)))) {
                OwnerSay("NCMSG026",[line,input,j,10]);
                return FALSE;
            }
        }
        else  (j = llList2Integer([0,0,0,0,0,0,0,0,2,menuNumber,menuNumber,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0],keyword));
        (params = [j]);
    }
    if ((options & 2)) {
        (f = ((float)llStringTrim(llList2String(inner,1),STRING_TRIM)));
        if ((f < 0.1)) {
            OwnerSay("NCMSG010",[line,input]);
            return FALSE;
        }
        if (((f == 0.0) && ((-1) == llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(llStringTrim(llList2String(inner,1),STRING_TRIM),0,0)])))) {
            OwnerSay("NCMSG010",[line,input]);
            return FALSE;
        }
        (params = [((integer)(f * 10.0))]);
        if (((i > 2) && (options & 32))) {
            (f = ((float)llStringTrim(llList2String(inner,2),STRING_TRIM)));
            if ((f < 0.1)) {
                OwnerSay("NCMSG010",[line,input]);
                return FALSE;
            }
            if (((f == 0.0) && ((-1) == llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(llStringTrim(llList2String(inner,2),STRING_TRIM),0,0)])))) {
                OwnerSay("NCMSG010",[line,input]);
                return FALSE;
            }
            (params += [((integer)(f * 10.0))]);
        }
    }
    if ((options & 4)) {
        if ((keyword == 7)) {
            if ((i > 1)) (params = [llToUpper(llStringTrim(llList2String(inner,1),STRING_TRIM))]);
            else  (params = ["SAME"]);
        }
        if ((keyword == 1)) {
            if ((i > 1)) (params = [llToUpper(llStringTrim(llList2String(inner,1),STRING_TRIM))]);
            else  {
                OwnerSay("NCMSG013",[line,input]);
                return FALSE;
            }
        }
    }
    if ((options & 8)) {
        (s = llStringTrim(llList2String(outer,1),STRING_TRIM));
        if ((llGetListLength(outer) > 1)) (params += [s]);
        else  {
            (s = llList2String(keywordTable,keyword));
            OwnerSay("NCMSG018",[line,input,s]);
            return FALSE;
        }
    }
    if ((!ValidateKeywordParams(input))) return FALSE;
    SaveKeyword(keyword,llDumpList2String(params,"|"));
    if ((options & 64)) if ((!CheckStartOfLoop(input))) (sequence = ((sequence = []) + llDeleteSubList(sequence,(-1),(-1))));
    if ((options & 128)) if ((!CheckEndOfLoops(input))) (sequence = ((sequence = []) + llDeleteSubList(sequence,(-1),(-1))));
    (i = FALSE);
    if ((options & 256)) (i = TRUE);
    return i;
}
processLine(string data){
    integer i;
    string token;
    list tokens = [];
    integer j;
    integer dataLen = llStringLength(data);
    integer numberTokens;
    integer lineCompleted = FALSE;
    (tokens = llParseStringKeepNulls(data,["|"],[]));
    (data = "");
    (numberTokens = llGetListLength(tokens));
    for ((i = 0); ((i < numberTokens) && (!lineCompleted)); (i++)) {
        (token = llStringTrim(llList2String(tokens,i),STRING_TRIM));
        if ((token != "")) {
            if ((llGetSubString(token,0,0) != "[")) {
                if ((INVENTORY_ANIMATION == llGetInventoryType(token))) {
                    SaveKeyword(2,token);
                }
                else  {
                    (j = ((integer)(((float)token) * 10.0)));
                    if ((j != 0)) {
                        if ((j < 0)) OwnerSay("NCMSG008",[line,token]);
                        else  SaveKeyword(3,((string)j));
                    }
                    else  {
                        SaveKeyword(2,token);
                        if ((warnMissingAnims && (llListFindList(missingDances,[token]) == (-1)))) {
                            (missingDances = (((missingDances = []) + missingDances) + [token]));
                            if ((llGetListLength(missingDances) >= 100)) {
                                (missingDances = ((missingDances = []) + llListSort(missingDances,1,TRUE)));
                                OwnerSay("NCMSG032",[((string)llGetListLength(missingDances))]);
                                OwnerSay("NCMSG005b",[llDumpList2String(missingDances,",")]);
                                (missingDances = []);
                            }
                        }
                        if (((i == (numberTokens - 1)) && (dataLen == 255))) OwnerSay("NCMSG006",[((string)line),token]);
                    }
                }
            }
            else  (lineCompleted = processToken(token));
        }
    }
    if ((lineCompleted && (i < numberTokens))) OwnerSay("NCMSG019",[line,token]);
    if (resetSequence) {
        if (previousWasADance) SaveKeyword(3,((string)-1));
        (j = llGetListLength(loops));
        if ((j > 0)) {
            for ((i = 0); (i < j); (i++)) processToken("[END]");
        }
        (i = llGetListLength(sequence));
        if ((i > 0)) {
            if ((sequenceName == "")) (sequenceName = ("Sequence " + ((string)(++unnamedCount))));
            if ((2 == i)) {
                (tokens = llParseString2List(llList2String(sequence,0),["|"],[]));
                if ((llList2Integer(tokens,0) == 2)) {
                    (tokens = llParseString2List(llList2String(sequence,1),["|"],[]));
                    if (((llList2Integer(tokens,0) == 3) && (llList2Integer(tokens,1) == (-1)))) (sequence = (((sequence = []) + sequence) + [20]));
                }
            }
            llMessageLinked(LINK_THIS,(305410560 + menuNumber),llDumpList2String([101,sequenceName],"|"),((key)llDumpList2String(sequence,"|||")));
            if (rememberSeq) llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)(305410560 + menuNumber))));
            (++sequenceCount);
        }
        else  {
            if (keepBlankLines) llMessageLinked(LINK_THIS,(305410560 + menuNumber),((string)110),"");
        }
    }
}
default {

 state_entry() {
        Initialize();
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if (((num == 0) && (str == "RESET"))) llResetScript();
        if ((12123401 == num)) {
            list msg;
            (msg = llParseString2List(str,["|"],[]));
            if ((llToUpper(llList2String(msg,0)) == "LOAD")) {
                (menuNumber = (llList2Integer(msg,2) - 305410560));
                (rememberSeq = FALSE);
                if (loadingNotecard) OwnerSay("NCMSG001",[notecard,llList2String(msg,1)]);
                else  {
                    (notecard = llList2String(msg,1));
                    if ((llGetInventoryType(notecard) == INVENTORY_NOTECARD)) {
                        if ((llGetSubString(notecard,0,2) == "~FS")) {
                            OwnerSay("NCMSG033",[notecard]);
                            return;
                        }
                        (loadingNotecard = TRUE);
                        OwnerSay("NCMSG002",[notecard,menuNumber]);
                        (sequenceCount = 0);
                        (resetSequence = TRUE);
                        (line = 0);
                        (readLineId = llGetNotecardLine(notecard,line));
                    }
                    else  OwnerSay("NCMSG003",[notecard]);
                }
                return;
            }
            if ((llToUpper(llList2String(msg,0)) == "REMEMBER")) {
                if (loadingNotecard) OwnerSay("NCMSG001",[notecard,llList2String(msg,1)]);
                else  {
                    (sequenceName = "");
                    (sequence = []);
                    (sequenceDances = 0);
                    (previousWasADance = FALSE);
                    (sequenceCount = 0);
                    (resetSequence = TRUE);
                    (notecard = "");
                    (menuNumber = (llList2Integer(msg,1) - 305410560));
                    (rememberSeq = TRUE);
                    processLine(id);
                }
                return;
            }
            if ((llToUpper(llList2String(msg,0)) == "REDIRECT")) {
                (menuNumber = (llList2Integer(msg,1) - 305410560));
                return;
            }
            if ((llToUpper(llList2String(msg,0)) == "MISSING")) {
                (warnMissingAnims = llList2Integer(msg,1));
                return;
            }
            if ((llToUpper(llList2String(msg,0)) == "BLANK")) {
                (keepBlankLines = llList2Integer(msg,1));
                return;
            }
            if ((llToUpper(llList2String(msg,0)) == "COMMENT")) {
                (keepCommentLines = llList2Integer(msg,1));
                return;
            }
            if ((llToUpper(llList2String(msg,0)) == "ALIASES")) {
                (keyword = ((integer)((string)id)));
                (s = llDumpList2String(Define_GroupAliases,","));
                llMessageLinked(LINK_THIS,keyword,"ALIASES",((key)s));
                (s = "");
                return;
            }
        }
    }

 dataserver(key request_id,string data) {
        if ((request_id == readLineId)) {
            if ((data != EOF)) {
                (++line);
                if (((line % 50) == 0)) {
                    OwnerSay("NCMSG031",[line]);
                }
                if ((data != "")) {
                    if ((llGetSubString(data,0,0) != "#")) {
                        if (resetSequence) {
                            (sequenceName = "");
                            (sequence = []);
                            (sequenceDances = 0);
                            (previousWasADance = FALSE);
                        }
                        (resetSequence = TRUE);
                        if ((llGetSubString(data,(-1),(-1)) == "\\")) {
                            (resetSequence = FALSE);
                            (data = llGetSubString(data,0,(-2)));
                        }
                        processLine(data);
                    }
                    else  {
                        if ((keepCommentLines && (llStringLength(data) > 1))) llMessageLinked(LINK_THIS,(305410560 + menuNumber),((string)111),((key)llGetSubString(data,1,(-1))));
                    }
                }
                else  {
                    if (keepBlankLines) llMessageLinked(LINK_THIS,(305410560 + menuNumber),((string)110),"");
                }
                (readLineId = llGetNotecardLine(notecard,line));
                return;
            }
            if ((llGetListLength(missingDances) > 0)) {
                (missingDances = ((missingDances = []) + llListSort(missingDances,1,TRUE)));
                OwnerSay("NCMSG005",[((string)llGetListLength(missingDances))]);
                OwnerSay("NCMSG005b",[llDumpList2String(missingDances,",")]);
            }
            OwnerSay("NCMSG004",[notecard,((string)sequenceCount)]);
            llMessageLinked(LINK_THIS,12123408,"LOADED",((key)notecard));
            (s = llDumpList2String(Define_GroupAliases,","));
            llMessageLinked(LINK_THIS,(303181824 + 1),"ALIASES",((key)s));
            (s = "");
            (loadingNotecard = FALSE);
        }
    }
}
