// LSL script generated: FSMenu.lslp Sun Jan 24 18:17:33 Mitteleuropäische Zeit 2016

integer scriptNumber = 0;
integer linkId = 305410560;
list sequences = [];
list seqnames = [];
string menuName = "";
integer numberSequences = 0;
integer freeStyleCounter = 0;
integer seqIndex = -1;
list msg = [];
string tmp = "";
string tmp2 = "";
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
AddSequence(string name,string sequence){
    integer i = 0;
    (i = llGetFreeMemory());
    if ((i < 8192)) {
        if ((scriptNumber < 10)) {
            OwnerSay("DCMSG015",[i,scriptNumber,name,((linkId + 1) - 305410560)]);
            llMessageLinked(LINK_THIS,(linkId + 1),llDumpList2String([101,name],"|"),((key)sequence));
            llMessageLinked(LINK_THIS,12123401,("REDIRECT|" + ((string)(linkId + 1))),((key)""));
            return;
        }
        OwnerSay("DCMSG016",[i,scriptNumber,name]);
        return;
    }
    if ((numberSequences >= 150)) {
        if ((scriptNumber < 10)) {
            OwnerSay("DCMSG017",[scriptNumber,numberSequences,name,((linkId + 1) - 305410560)]);
            llMessageLinked(LINK_THIS,(linkId + 1),llDumpList2String([101,name],"|"),((key)sequence));
            llMessageLinked(LINK_THIS,12123401,("REDIRECT|" + ((string)(linkId + 1))),((key)""));
            return;
        }
        OwnerSay("DCMSG018",[scriptNumber,numberSequences,name]);
        return;
    }
    (seqnames = (((seqnames = []) + seqnames) + [name]));
    (sequences = (((sequences = []) + sequences) + [sequence]));
    (++numberSequences);
}
CopyDancesToMenu(integer toLinkid){
    integer i;
    integer j;
    list p;
    list sendUs = [];
    OwnerSay("DCMSG010",[(linkId - 305410560),(toLinkid - 305410560),numberSequences]);
    for ((i = 0); (i < numberSequences); (++i)) {
        (msg = llParseString2List(llList2String(sequences,i),["|||"],[]));
        for ((j = 0); (j < llGetListLength(msg)); (++j)) {
            (tmp = llList2String(msg,j));
            (p = llParseString2List(tmp,["|"],[]));
            if ((llList2Integer(p,0) == 2)) {
                (sendUs = (((sendUs = []) + sendUs) + [tmp]));
                (tmp2 = llList2String(p,1));
            }
            else  {
                if ((llList2Integer(p,0) == 3)) {
                    if ((llGetListLength(sendUs) > 0)) {
                        (sendUs = (((sendUs = []) + sendUs) + [tmp]));
                        (tmp = llDumpList2String(sendUs,"|||"));
                        llMessageLinked(LINK_THIS,toLinkid,llDumpList2String([102,tmp2],"|"),((key)tmp));
                        (sendUs = []);
                    }
                }
            }
        }
    }
    (tmp = "");
    (tmp2 = "");
    OwnerSay("DCMSG011",[]);
}
ParseLinkMessage(string input,string input2,integer toLink){
    integer i;
    (msg = llParseString2List(input,["|"],[]));
    (i = llList2Integer(msg,0));
    if ((i == 103)) {
        integer startIndex = llList2Integer(msg,1);
        integer linkid = llList2Integer(msg,2);
        integer number = llList2Integer(msg,3);
        if (((startIndex >= numberSequences) || (startIndex < 0))) {
            llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS",menuName,numberSequences,0,1,linkId],"|"),((key)""));
            return;
        }
        else  {
            if (((startIndex + number) > numberSequences)) (number = (numberSequences - startIndex));
            (msg = []);
            for ((i = 0); (i < number); (++i)) {
                (tmp2 = llList2String(sequences,(i + startIndex)));
                if ((tmp2 != "")) {
                    (tmp2 = llList2String(seqnames,(i + startIndex)));
                    (tmp = llDumpList2String([((("#" + ((string)((startIndex + i) + 1))) + " ") + tmp2),linkId,(startIndex + i)],"|"));
                }
                else  (tmp = llDumpList2String([tmp2,12123426,(startIndex + i)],"|"));
                (msg = (((msg = []) + msg) + [tmp]));
            }
            (tmp = llDumpList2String(msg,"|||"));
            llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS",menuName,numberSequences,startIndex,1,linkId],"|"),((key)tmp));
            (msg = []);
            (tmp = "");
            (tmp2 = "");
            return;
        }
    }
    if ((i == 51)) {
        (i = llList2Integer(msg,1));
        if (((i >= 0) && (i < numberSequences))) {
            (tmp = llList2String(seqnames,i));
            (tmp2 = llList2String(sequences,i));
            if ((tmp2 != "")) {
                (i = ((integer)input2));
                llMessageLinked(LINK_THIS,12123403,llDumpList2String([1,tmp,12123402,llList2String(["SEQUENCE","DEFERRED","WAITSEQ"],((integer)input2)),linkId],"|"),((key)tmp2));
            }
            else  {
                if ((((integer)input2) == 2)) llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)linkId)));
            }
            (tmp = "");
            (tmp2 = "");
            return;
        }
        (tmp = llList2String(msg,1));
        OwnerSay("DCMSG007",[tmp]);
        return;
    }
    if ((i == 52)) {
        (tmp = llStringTrim(llDumpList2String(llDeleteSubList(msg,0,0),"|"),STRING_TRIM));
        (i = (-1));
        if ((llGetSubString(tmp,0,0) == "#")) {
            (tmp2 = llStringTrim(llGetSubString(tmp,1,(-1)),STRING_TRIM));
            if (((-1) != llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(tmp2,0,0)]))) {
                (i = (((integer)tmp2) - 1));
            }
        }
        if ((i == (-1))) (i = llListFindList(seqnames,[tmp]));
        if (((i >= 0) && (i < numberSequences))) {
            (tmp = llList2String(seqnames,i));
            (tmp2 = llList2String(sequences,i));
            if ((tmp2 != "")) llMessageLinked(LINK_THIS,12123403,llDumpList2String([1,tmp,12123402,"SEQUENCE",linkId],"|"),((key)tmp2));
            (tmp = "");
            (tmp2 = "");
            return;
        }
        if ((toLink != 305410560)) OwnerSay("DCMSG007",[tmp]);
        (tmp = "");
        (tmp2 = "");
        return;
    }
    if ((i == 113)) {
        integer notFound = TRUE;
        integer selected = (-1);
        integer attempts = 0;
        (msg = llParseString2List(input2,["|"],[]));
        (selected = llList2Integer(msg,1));
        while (notFound) {
            if (llList2Integer(msg,0)) (selected = ((integer)llFrand(numberSequences)));
            else  (selected++);
            if ((selected >= numberSequences)) (selected = 0);
            (tmp = llList2String(seqnames,selected));
            (tmp2 = llList2String(sequences,selected));
            if ((tmp2 != "")) (notFound = FALSE);
            (attempts++);
            if ((attempts >= numberSequences)) {
                OwnerSay("MMSG003",[]);
                return;
            }
        }
        llMessageLinked(LINK_THIS,12123403,llDumpList2String([1,tmp,12123402,"SEQUENCE",linkId],"|"),((key)tmp2));
        (tmp = "");
        (tmp2 = "");
        return;
    }
    if ((i == 101)) {
        AddSequence(llList2String(msg,1),input2);
        return;
    }
    if ((i == 102)) {
        AddSequence(llList2String(msg,1),input2);
        return;
    }
    if ((i == 110)) {
        AddSequence(" ","");
        return;
    }
    if ((i == 111)) {
        AddSequence(input2,"");
        return;
    }
    if ((i == 104)) {
        (i = llListFindList(seqnames,[("FreeStyle " + ((string)(freeStyleCounter + 1)))]));
        while ((i != (-1))) {
            (++freeStyleCounter);
            (i = llListFindList(seqnames,[("FreeStyle " + ((string)(freeStyleCounter + 1)))]));
        }
        (tmp = ("FreeStyle " + ((string)(freeStyleCounter + 1))));
        AddSequence(tmp,input2);
        (++freeStyleCounter);
        llMessageLinked(LINK_THIS,12123408,"FREESTYLEADDED",llDumpList2String([tmp,linkId],"|"));
        return;
    }
    (seqIndex = (-2));
    if (((i >= 1) && (i <= 50))) (seqIndex = llListFindList(seqnames,[llList2String(msg,1)]));
    else  {
        if (((i >= 51) && (i <= 101))) {
            (seqIndex = llList2Integer(msg,1));
            if (((seqIndex < 1) || (seqIndex > numberSequences))) (seqIndex = (-1));
        }
    }
    if ((seqIndex == (-1))) {
        OwnerSay("MMSG001",[llList2String(msg,1),menuName]);
        return;
    }
    if ((i == 2)) {
        (seqnames = ((seqnames = []) + llDeleteSubList(seqnames,seqIndex,seqIndex)));
        (sequences = ((sequences = []) + llDeleteSubList(sequences,seqIndex,seqIndex)));
        (--numberSequences);
        llMessageLinked(LINK_THIS,12123408,"FORGOTSEQ",((key)""));
        return;
    }
    if ((i == 1)) {
        (tmp = llList2String(seqnames,seqIndex));
        (tmp2 = llList2String(sequences,seqIndex));
        llMessageLinked(LINK_THIS,12123404,llDumpList2String([1,tmp],"|"),((key)tmp2));
        (tmp = "");
        (tmp2 = "");
        return;
    }
    if ((i == 105)) {
        if ((numberSequences == 0)) {
            OwnerSay("MMSG005",[]);
            return;
        }
        for ((seqIndex = 0); (seqIndex < numberSequences); (++seqIndex)) {
            (tmp = llList2String(seqnames,seqIndex));
            (tmp2 = llList2String(sequences,seqIndex));
            llMessageLinked(LINK_THIS,12123404,llDumpList2String([1,tmp],"|"),((key)tmp2));
            (tmp = "");
            (tmp2 = "");
        }
        return;
    }
    if ((i == 107)) {
        OwnerSay("DCMSG014",[scriptNumber]);
        llMessageLinked(LINK_THIS,12123408,"CLEAREDMENU",((key)""));
        llResetScript();
        return;
    }
    if ((i == 109)) {
        CopyDancesToMenu(((integer)input2));
        return;
    }
    if ((i == 108)) {
        (menuName = llList2String(msg,1));
        return;
    }
    
    return;
}
default {

 state_entry() {
        list numberCheck = ["0","1","2","3","4","5","6","7","8","9"];
        string script;
        integer i;
        (script = llGetScriptName());
        (scriptNumber = 0);
        (i = llListFindList(numberCheck,[llGetSubString(script,(-1),(-1))]));
        if ((i != (-1))) {
            (scriptNumber += i);
            (i = llListFindList(numberCheck,[llGetSubString(script,(-2),(-2))]));
            if ((i != (-1))) (scriptNumber += (10 * i));
        }
        
        (linkId = (305410560 + scriptNumber));
        (menuName = ("Menu " + ((string)scriptNumber)));
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if ((linkId == num)) ParseLinkMessage(str,((string)id),num);
        if ((305410560 == num)) ParseLinkMessage(str,((string)id),num);
        if (((num == 0) && (str == "RESET"))) llResetScript();
    }
}
