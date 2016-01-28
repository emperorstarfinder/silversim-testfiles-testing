// LSL script generated: FSDanceControl.lslp Sun Jan 24 18:17:29 Mitteleuropäische Zeit 2016

list timeSequence = ["2|stand_1","3|3000","19"];
integer timeSeqLength = 3;
integer timeSeqIndex = 0;
string seqName = "startup wait";
float delayValue = 0.0;
float shortenDelayBy = 2.0e-2;
list seqItem = [];
integer danceFromMenu = 12123411;
integer danceStopsOthers = 0;
integer currentKeyword = 0;
integer accurateTimer = 1;
string lastAnimStarted = "stand_1";
float danceElapsedTime = 0.0;
integer deferredStarted = FALSE;
integer useDefaultDuration = FALSE;
integer defaultDanceDuration = 30;
list remembered = [];
integer rememberFlag = FALSE;
string rememberDance = "";
integer rememberMenu = 0;
integer lastSyncPoint = 0;
list giveFromSequence = [];
integer warnMissingAnim = TRUE;
integer disableRepeat = FALSE;
integer danceSequenceFlag = TRUE;
string tmpStr = "";
list tmpList = [];
integer i = 0;
integer j = 0;
integer k = 0;
float t;
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
ActionForDance(){
    (i = llList2Integer(seqItem,3));
    
    if ((i == 1)) {
        (tmpStr = llList2String(seqItem,1));
        (i = llList2Integer(seqItem,2));
        (k = llList2Integer(seqItem,4));
        if ((warnMissingAnim && (tmpStr != "stand_1"))) {
            if ((INVENTORY_ANIMATION != llGetInventoryType(tmpStr))) {
                OwnerSay("DCMSG019",[tmpStr,seqName,"stand_1"]);
                (tmpStr = "stand_1");
            }
        }
        llMessageLinked(LINK_THIS,(303181824 + i),((string)1),((key)llDumpList2String([k,tmpStr,danceStopsOthers],"|")));
        (danceStopsOthers = 0);
        if ((i == 1)) {
            (lastAnimStarted = tmpStr);
            (rememberDance = tmpStr);
            if (rememberFlag) {
                (tmpStr = llDumpList2String([2,tmpStr],"|"));
                (remembered = (((remembered = []) + remembered) + [tmpStr]));
            }
        }
        if ((k == 0)) (lastSyncPoint = timeSeqIndex);
        llResetTime();
        (danceElapsedTime = 0.0);
    }
    else  {
        if ((i == 2)) {
            (i = llList2Integer(seqItem,2));
            (j = llList2Integer(seqItem,4));
            llMessageLinked(LINK_THIS,(303181824 + i),((string)2),((key)((string)j)));
        }
    }
}
ActionForDelay(){
    float currentTime = llGetAndResetTime();
    (k = llList2Integer(seqItem,1));
    if (((-1) == k)) (k = 3000);
    (danceElapsedTime += currentTime);
    (delayValue = ((((float)k) / 10.0) - currentTime));
    (t = (delayValue - (shortenDelayBy * ((float)accurateTimer))));
    if ((useDefaultDuration && danceSequenceFlag)) {
        if (((danceElapsedTime + t) > ((float)defaultDanceDuration))) (t = (((float)defaultDanceDuration) - danceElapsedTime));
    }
    llSetTimerEvent(t);
}
ActionForDialog(){
    (seqItem = llParseString2List(llList2String(seqItem,1),[","],[]));
    (tmpStr = llList2String(seqItem,0));
    (i = llList2Integer(seqItem,(-1)));
    (j = llGetListLength(seqItem));
    (seqItem = ((seqItem = []) + llDeleteSubList(seqItem,0,0)));
    (seqItem = ((seqItem = []) + llDeleteSubList(seqItem,(-1),(-1))));
    llDialog(llGetOwner(),tmpStr,seqItem,i);
}
ActionForGive(){
    if (((-1) == llListFindList(giveFromSequence,[timeSeqIndex]))) {
        (giveFromSequence = (((giveFromSequence = []) + giveFromSequence) + [timeSeqIndex]));
        (tmpStr = llList2String(seqItem,1));
        if ((INVENTORY_NONE != llGetInventoryType(tmpStr))) {
            if (((llGetInventoryPermMask(tmpStr,MASK_OWNER) & (PERM_TRANSFER | PERM_COPY)) == (PERM_TRANSFER | PERM_COPY))) llMessageLinked(LINK_THIS,(303181824 + 1),((string)9),((key)tmpStr));
            else  OwnerSay("DCMSG021",[tmpStr]);
        }
        else  OwnerSay("DCMSG020",[tmpStr]);
    }
}
ActionForIM(){
    (tmpStr = llList2String(seqItem,1));
    llMessageLinked(LINK_THIS,(303181824 + 1),((string)7),((key)tmpStr));
}
ActionForMessage(){
    llSay(llList2Integer(seqItem,1),llList2String(seqItem,2));
}
ActionForNextSequence(){
    (tmpStr = llList2String(seqItem,1));
    (timeSeqIndex = (-2));
    llMessageLinked(LINK_THIS,danceFromMenu,llDumpList2String([52,tmpStr],"|"),((key)((string)0)));
}
ActionForOwner_say(){
    llOwnerSay(llList2String(seqItem,1));
}
ActionForRand(){
    (tmpList = llParseString2List(llList2String(seqItem,1),[" "],[]));
    (delayValue = llFrand((llList2Float(tmpList,0) / 10.0)));
    if ((llGetListLength(tmpList) > 1)) (delayValue += (llList2Float(tmpList,1) / 10.0));
    if ((delayValue < (shortenDelayBy * accurateTimer))) (delayValue += (2.0 * (shortenDelayBy * ((float)accurateTimer))));
    float currentTime = llGetAndResetTime();
    (danceElapsedTime += currentTime);
    (t = (delayValue - (shortenDelayBy * ((float)accurateTimer))));
    if ((useDefaultDuration && danceSequenceFlag)) {
        if (((danceElapsedTime + t) > ((float)defaultDanceDuration))) (t = (((float)defaultDanceDuration) - danceElapsedTime));
    }
    llSetTimerEvent(t);
}
ActionForRegion_say(){
    (i = llList2Integer(seqItem,1));
    if ((i == 0)) llShout(0,llList2String(seqItem,2));
    else  llRegionSay(i,llList2String(seqItem,2));
}
ActionForRepeat(){
    if ((!disableRepeat)) {
        llMessageLinked(LINK_THIS,(303181824 + 1),((string)2),((key)((string)1024)));
        (timeSeqIndex = (-1));
    }
}
ActionForSay(){
    llSay(llList2Integer(seqItem,1),llList2String(seqItem,2));
}
ActionForSetname(){
    llSetObjectName(llList2String(seqItem,1));
}
ActionForShout(){
    llShout(llList2Integer(seqItem,1),llList2String(seqItem,2));
}
ActionForStop(){
}
ActionForWhisper(){
    llWhisper(llList2Integer(seqItem,1),llList2String(seqItem,2));
}
ActionForZZZDefer(){
    llMessageLinked(LINK_THIS,12123408,((string)3),((key)llDumpList2String([llList2String(seqItem,1),llList2Integer(seqItem,2)],"|")));
}
integer ActionKeyword(integer k){
    if ((k <= 2)) {
        ActionForDance();
        return 0;
    }
    else  {
        if ((k <= 17)) {
            if ((k <= 8)) {
                if ((k <= 4)) {
                    if ((k == 3)) {
                        ActionForDelay();
                        return 1;
                    }
                    else  {
                        ActionForDialog();
                        return 0;
                    }
                }
                else  {
                    if ((k == 6)) {
                        ActionForGive();
                        return 0;
                    }
                    else  {
                        ActionForIM();
                        return 0;
                    }
                }
            }
            else  {
                if ((k <= 15)) {
                    if ((k == 12)) {
                        ActionForMessage();
                        return 0;
                    }
                    else  {
                        ActionForNextSequence();
                        return 0;
                    }
                }
                else  {
                    if ((k == 16)) {
                        ActionForOwner_say();
                        return 0;
                    }
                    else  {
                        ActionForRand();
                        return 0;
                    }
                }
            }
        }
        else  {
            if ((k <= 22)) {
                if ((k <= 20)) {
                    if ((k == 19)) {
                        ActionForRegion_say();
                        return 0;
                    }
                    else  {
                        ActionForRepeat();
                        return 0;
                    }
                }
                else  {
                    if ((k == 21)) {
                        ActionForSay();
                        return 0;
                    }
                    else  {
                        ActionForSetname();
                        return 0;
                    }
                }
            }
            else  {
                if ((k <= 24)) {
                    if ((k == 23)) {
                        ActionForShout();
                        return 0;
                    }
                    else  {
                        ActionForStop();
                        return 0;
                    }
                }
                else  {
                    if ((k == 26)) {
                        ActionForWhisper();
                        return 0;
                    }
                    else  {
                        ActionForZZZDefer();
                        return 0;
                    }
                }
            }
        }
    }
}
SendFreestyleSequence(){
    if ((llGetListLength(remembered) > 0)) {
        (tmpStr = llDumpList2String(remembered,"|||"));
        llMessageLinked(LINK_THIS,rememberMenu,((string)104),((key)llDumpList2String(remembered,"|||")));
        (remembered = []);
    }
}
LoopThroughSequence(){
    (currentKeyword = (-1));
    while ((((timeSeqIndex < timeSeqLength) && (timeSeqIndex != (-2))) && ((-1) == llListFindList([3,17,24],[currentKeyword])))) {
        (seqItem = llParseString2List(llList2String(timeSequence,timeSeqIndex),["|"],[]));
        (currentKeyword = llList2Integer(seqItem,0));
        ActionKeyword(currentKeyword);
        if (((timeSeqIndex != (-2)) && ((-1) == llListFindList([3,17],[currentKeyword])))) (++timeSeqIndex);
    }
    if (((24 == currentKeyword) || (timeSeqIndex >= timeSeqLength))) {
        SendFreestyleSequence();
        if (useDefaultDuration) {
            llMessageLinked(LINK_THIS,12123408,((string)16),((key)""));
            return;
        }
        llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)12123402)));
    }
}
default {

 state_entry() {
    }

 link_message(integer sender_num,integer num,string str,key id) {
        integer i2;
        if (((-1) == llListFindList([12123402,0],[num]))) {
            return;
        }
        if ((num == 12123402)) {
            (tmpList = llParseString2List(str,["|"],[]));
            (i2 = llListFindList(["SEQUENCE","DEFERRED","WAITSEQ"],[llList2String(tmpList,0)]));
            if (((-1) != i2)) {
                if ((((0 == i2) || (2 == i2)) || ((!deferredStarted) && (1 == i2)))) {
                    if (rememberFlag) if ((llGetListLength(remembered) > 0)) {
                        (danceElapsedTime += llGetAndResetTime());
                        (tmpStr = llDumpList2String([3,((integer)(danceElapsedTime * 10.0))],"|"));
                        (remembered = (((remembered = []) + remembered) + [tmpStr]));
                    }
                    (danceSequenceFlag = TRUE);
                    if ((2 == i2)) {
                        SendFreestyleSequence();
                        (danceSequenceFlag = FALSE);
                    }
                    (seqName = llList2String(tmpList,1));
                    (danceFromMenu = llList2Integer(tmpList,2));
                    (timeSequence = llParseString2List(((string)id),["|||"],[]));
                    (danceStopsOthers = 1);
                    (timeSeqLength = llGetListLength(timeSequence));
                    (timeSeqIndex = 0);
                    (lastSyncPoint = 0);
                    (giveFromSequence = []);
                    (deferredStarted = llList2Integer([FALSE,TRUE],i2));
                }
                else  {
                    (timeSequence = (((timeSequence = []) + timeSequence) + [llDumpList2String([27,llList2String(tmpList,1),llList2Integer(tmpList,2)],"|")]));
                    (timeSequence = (((timeSequence = []) + timeSequence) + llParseString2List(((string)id),["|||"],[])));
                    (timeSeqLength = llGetListLength(timeSequence));
                    OwnerSay("DCMSG012",[llList2String(tmpList,1)]);
                }
                llMessageLinked(LINK_THIS,12123408,((string)3),((key)llDumpList2String([seqName,danceFromMenu],"|")));
                LoopThroughSequence();
                return;
            }
            (i2 = ((integer)str));
            if ((1 == i2)) {
                llSetTimerEvent(0.0);
                if (rememberFlag) {
                    if ((currentKeyword == 3)) {
                        (danceElapsedTime += llGetAndResetTime());
                        (tmpStr = llDumpList2String([3,((integer)(danceElapsedTime * 10.0))],"|"));
                        (remembered = (((remembered = []) + remembered) + [tmpStr]));
                    }
                    SendFreestyleSequence();
                    (remembered = []);
                    (rememberFlag = FALSE);
                    (rememberMenu = 0);
                    llMessageLinked(LINK_THIS,12123408,((string)4),((key)((string)rememberFlag)));
                    OwnerSay("DCMSG002",[]);
                }
                llMessageLinked(LINK_THIS,(303181824 + 1),((string)2),((key)((string)1024)));
                if (((integer)((string)id))) llMessageLinked(LINK_THIS,12123428,((string)8),"");
                return;
            }
            if ((10 == i2)) {
                (tmpList = llParseString2List(((string)id),["|"],[]));
                (i2 = llList2Integer(tmpList,0));
                (tmpList = ((tmpList = []) + llDeleteSubList(tmpList,0,0)));
                (tmpList = (((tmpList = []) + tmpList) + [lastAnimStarted]));
                llMessageLinked(LINK_THIS,i2,((string)3),((key)llDumpList2String(tmpList,"|")));
                return;
            }
            if ((5 == i2)) {
                llMessageLinked(LINK_THIS,(303181824 + 1),((string)7),((key)id));
                return;
            }
            if ((i2 == 4)) {
                
                if ((rememberFlag && (currentKeyword == 3))) {
                    (danceElapsedTime += llGetAndResetTime());
                    (tmpStr = llDumpList2String([3,((integer)(danceElapsedTime * 10.0))],"|"));
                    (remembered = (((remembered = []) + remembered) + [tmpStr]));
                }
                (danceStopsOthers = 2);
                (timeSeqIndex = lastSyncPoint);
                LoopThroughSequence();
                return;
            }
            if ((2 == i2)) {
                (accurateTimer = ((integer)((string)id)));
                return;
            }
            if ((3 == i2)) {
                (remembered = []);
                list p = llParseString2List(((string)id),["|"],[]);
                if (llList2Integer(p,1)) {
                    (rememberFlag = TRUE);
                    (rememberMenu = llList2Integer(p,0));
                    OwnerSay("DCMSG001",[(rememberMenu - 305410560)]);
                }
                else  {
                    (rememberFlag = FALSE);
                    (rememberMenu = 0);
                    OwnerSay("DCMSG002",[]);
                }
                return;
            }
            if ((6 == i2)) {
                (warnMissingAnim = ((integer)((string)id)));
                (warnMissingAnim = (warnMissingAnim ^ TRUE));
                return;
            }
            if ((7 == i2)) {
                (disableRepeat = ((integer)((string)id)));
                return;
            }
            if ((8 == i2)) {
                (useDefaultDuration = ((integer)((string)id)));
                return;
            }
            if ((9 == i2)) {
                (defaultDanceDuration = ((integer)((string)id)));
                return;
            }
        }
        if (((num == 0) && ("RESET" == str))) {
            llResetScript();
        }
    }

 timer() {
        llSetTimerEvent(0.0);
        float currentTime = llGetAndResetTime();
        float offset;
        (++timeSeqIndex);
        (danceElapsedTime += currentTime);
        if (accurateTimer) {
            float timeleft = (delayValue - currentTime);
            integer count = 0;
            (offset = timeleft);
            while (((timeleft > 1.0e-2) && (count < 100))) {
                (timeleft -= llGetAndResetTime());
                (count++);
            }
            if ((offset > 1.0e-2)) (danceElapsedTime += offset);
            if (((offset < 0.0) || (offset > 0.1))) (shortenDelayBy = ((shortenDelayBy - offset) + 5.0e-3));
        }
        if (rememberFlag) {
            (tmpStr = llDumpList2String([3,((integer)(danceElapsedTime * 10.0))],"|"));
            (remembered = (((remembered = []) + remembered) + [tmpStr]));
        }
        if (useDefaultDuration) {
            if ((danceElapsedTime > ((float)defaultDanceDuration))) {
                llMessageLinked(LINK_THIS,12123408,((string)16),((key)""));
                return;
            }
        }
        LoopThroughSequence();
    }
}
