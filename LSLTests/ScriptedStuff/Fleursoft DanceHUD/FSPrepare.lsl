// LSL script generated: FSPrepare.lslp Sun Jan 24 18:17:33 Mitteleuropäische Zeit 2016

integer returnLink;
string sequencename = "";
list timeSequence = [];
list loops = [];
list loopsLength = [];
integer loopActive = FALSE;
integer loopStartsAt = 0;
list prevSelect = [];
list prevSelectLength = [];
integer prevLoopNumOptions = 0;
integer prevLoopStarts = 0;
list groupSequence = [];
integer groupStartsAt = 0;
integer groupActive = 0;
integer activeGroupBits = 1;
integer previousWasGroup = FALSE;
integer previousGroupStartsAt = 0;
integer usePrevSelections = -1;
integer groupDuration = 0;
integer groupStartedInSeqAt = -1;
integer prevGroupStartedInSeqAt = -1;
integer groupCounter = 0;
list startSeq = [];
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
StoreIntoSequence(integer start,integer length){
    if ((!groupActive)) {
        if ((length == 2)) {
            (timeSequence = (((timeSequence = []) + timeSequence) + [(((((llList2String(startSeq,start) + "|") + ((string)activeGroupBits)) + "|") + ((string)1)) + "|0")]));
            (timeSequence = (((timeSequence = []) + timeSequence) + [llList2String(startSeq,(start + 1))]));
            (timeSequence = (((timeSequence = []) + timeSequence) + [(((((llList2String(startSeq,start) + "|") + ((string)activeGroupBits)) + "|") + ((string)2)) + "|0")]));
        }
        else  {
            (timeSequence = (((timeSequence = []) + timeSequence) + [llList2String(startSeq,start)]));
        }
    }
    else  {
        if ((length == 2)) {
            (groupSequence = (((groupSequence = []) + groupSequence) + [((((((llList2String(startSeq,start) + "|") + ((string)activeGroupBits)) + "|") + ((string)1)) + "|") + ((string)groupCounter))]));
            (groupSequence = (((groupSequence = []) + groupSequence) + [llList2String(startSeq,(start + 1))]));
            (groupSequence = (((groupSequence = []) + groupSequence) + [((((((llList2String(startSeq,start) + "|") + ((string)activeGroupBits)) + "|") + ((string)2)) + "|") + ((string)groupCounter))]));
        }
        else  {
            (groupSequence = (((groupSequence = []) + groupSequence) + [llList2String(startSeq,start)]));
        }
    }
}
integer SelectPreviousForLoop(){
    list loopItem;
    integer loopKeyword;
    integer i;
    integer j;
    list tempList;
    integer loopsLen;
    integer loopOption;
    (loopItem = llParseString2List(llList2String(startSeq,loopStartsAt),["|"],[]));
    (loopKeyword = llList2Integer(loopItem,0));
    (tempList = llParseString2List(llList2String(startSeq,prevLoopStarts),["|"],[]));
    if ((llList2Integer(tempList,0) != loopKeyword)) {
        
        return 1;
    }
    (i = llList2Integer(loopItem,1));
    if ((llList2Integer(tempList,1) != i)) {
        
        return 1;
    }
    if ((llGetListLength(loops) != prevLoopNumOptions)) {
        
        return 1;
    }
    if ((loopKeyword == 9)) {
        (loopOption = llList2Integer(loopItem,1));
        (loopsLen = llGetListLength(loops));
        
        for ((i = 0); (i < loopOption); (++i)) {
            for ((j = 0); (j < loopsLen); (++j)) {
                StoreIntoSequence(llList2Integer(loops,j),llList2Integer(loopsLength,j));
            }
        }
        return 0;
    }
    if ((loopKeyword == 13)) {
        (loopOption = llList2Integer(loopItem,1));
        (loopsLen = llGetListLength(loops));
        
        for ((i = 0); (i < loopOption); (++i)) {
            StoreIntoSequence(llList2Integer(loops,llList2Integer(prevSelect,i)),llList2Integer(prevSelectLength,i));
        }
        return 0;
    }
    if ((loopKeyword == 18)) {
        (loopOption = llList2Integer(loopItem,1));
        (loopsLen = llGetListLength(loops));
        
        for ((i = 0); (i < loopOption); (++i)) {
            StoreIntoSequence(llList2Integer(loops,llList2Integer(prevSelect,i)),llList2Integer(prevSelectLength,i));
        }
        return 0;
    }
    
    return 1;
}
SelectForLoop(){
    list loopItem;
    integer loopKeyword;
    integer i;
    integer j;
    integer k;
    integer l;
    integer loopsLen;
    integer loopOption;
    (loopItem = llParseString2List(llList2String(startSeq,loopStartsAt),["|"],[]));
    (loopKeyword = llList2Integer(loopItem,0));
    if ((usePrevSelections != (-1))) {
        if ((SelectPreviousForLoop() == 0)) {
            
            return;
        }
        (previousGroupStartsAt = (-1));
        (usePrevSelections = (-1));
        (prevLoopStarts = 0);
        (prevLoopNumOptions = 0);
        (prevSelect = []);
        (prevSelectLength = []);
    }
    if ((loopKeyword == 9)) {
        (loopOption = llList2Integer(loopItem,1));
        (loopsLen = llGetListLength(loops));
        
        for ((i = 0); (i < loopOption); (++i)) {
            for ((j = 0); (j < loopsLen); (++j)) {
                StoreIntoSequence(llList2Integer(loops,j),llList2Integer(loopsLength,j));
            }
        }
        return;
    }
    if ((loopKeyword == 13)) {
        (loopOption = llList2Integer(loopItem,1));
        (loopsLen = llGetListLength(loops));
        (prevSelect = []);
        (prevSelectLength = []);
        
        for ((i = 0); (i < loopOption); (++i)) {
            (j = ((integer)llFrand(((float)loopsLen))));
            (k = 0);
            while (((0 == llList2Integer(loopsLength,j)) && (k < loopsLen))) {
                (j = ((integer)llFrand(((float)loopsLen))));
                (++k);
            }
            if ((k == loopsLen)) {
                (j = 1);
                while ((0 == llList2Integer(loopsLength,j))) {
                    (++j);
                }
            }
            (k = llList2Integer(loops,j));
            (l = llList2Integer(loopsLength,j));
            StoreIntoSequence(k,l);
            (prevSelect = (((prevSelect = []) + prevSelect) + [j]));
            (prevSelectLength = (((prevSelectLength = []) + prevSelectLength) + [l]));
            (loopsLength = ((loopsLength = []) + llListReplaceList(loopsLength,[0],j,j)));
        }
        return;
    }
    if ((loopKeyword == 18)) {
        (loopOption = llList2Integer(loopItem,1));
        (loopsLen = llGetListLength(loops));
        
        for ((i = 0); (i < loopOption); (++i)) {
            (j = ((integer)llFrand(((float)loopsLen))));
            (k = llList2Integer(loops,j));
            (l = llList2Integer(loopsLength,j));
            (prevSelect = (((prevSelect = []) + prevSelect) + [j]));
            (prevSelectLength = (((prevSelectLength = []) + prevSelectLength) + [l]));
            StoreIntoSequence(k,l);
        }
        return;
    }
    
    return;
}
MergeGroupSequence(){
    integer i;
    integer timeOffset;
    integer timeSeqIndex;
    integer timeSeqLength;
    integer groupSeqLength = llGetListLength(groupSequence);
    string groupItem;
    list groupItemList;
    list timeItemList;
    integer timeEnded = FALSE;
    integer flag;
    integer timeSeqDelay;
    integer groupSeqDelay;
    integer advanceGroup;
    integer loopAgain = TRUE;
    if ((!previousWasGroup)) {
        (groupDuration = 0);
        for ((i = 0); (i < groupSeqLength); (++i)) {
            (groupItem = llList2String(groupSequence,i));
            (groupItemList = llParseString2List(groupItem,["|"],[]));
            if ((llList2Integer(groupItemList,0) == 3)) {
                (groupDuration += llList2Integer(groupItemList,1));
            }
        }
        
        (timeSequence = (((timeSequence = []) + timeSequence) + groupSequence));
        (groupSequence = []);
        return;
    }
    
    (timeOffset = 0);
    (timeSeqIndex = previousGroupStartsAt);
    
    (advanceGroup = TRUE);
    (i = 0);
    while ((((i < groupSeqLength) && (timeOffset <= groupDuration)) && loopAgain)) {
        if (advanceGroup) {
            (groupItem = llList2String(groupSequence,i));
            (groupItemList = llParseString2List(groupItem,["|"],[]));
        }
        else  {
            (advanceGroup = TRUE);
        }
        if ((!timeEnded)) {
            (timeSeqLength = llGetListLength(timeSequence));
            (flag = TRUE);
            
            for (; ((timeSeqIndex < timeSeqLength) && flag); (++timeSeqIndex)) {
                (timeItemList = llParseString2List(llList2String(timeSequence,timeSeqIndex),["|"],[]));
                if ((llList2Integer(timeItemList,0) == 3)) {
                    (flag = FALSE);
                    (--timeSeqIndex);
                }
            }
            if ((!flag)) {
                
                if ((llList2Integer(groupItemList,0) != 3)) {
                    (timeSequence = ((timeSequence = []) + llListInsertList(timeSequence,[groupItem],timeSeqIndex)));
                    (++timeSeqIndex);
                }
                else  {
                    (groupSeqDelay = llList2Integer(groupItemList,1));
                    (timeSeqDelay = llList2Integer(timeItemList,1));
                    
                    if ((groupSeqDelay == timeSeqDelay)) {
                        
                        (timeOffset += groupSeqDelay);
                        (++timeSeqIndex);
                    }
                    else  {
                        if ((groupSeqDelay < timeSeqDelay)) {
                            
                            (flag = (timeSeqDelay - groupSeqDelay));
                            (groupItemList = [((((string)3) + "|") + ((string)groupSeqDelay)),((((string)3) + "|") + ((string)flag))]);
                            (timeSequence = ((timeSequence = []) + llListReplaceList(timeSequence,groupItemList,timeSeqIndex,timeSeqIndex)));
                            (++timeSeqIndex);
                            (timeOffset += groupSeqDelay);
                        }
                        else  {
                            
                            (flag = (groupSeqDelay - timeSeqDelay));
                            (timeSequence = ((timeSequence = []) + llListReplaceList(timeSequence,[((((string)3) + "|") + ((string)timeSeqDelay))],timeSeqIndex,timeSeqIndex)));
                            (groupItem = ((((string)3) + "|") + ((string)flag)));
                            (groupItemList = [3,flag]);
                            (++timeSeqIndex);
                            (timeOffset += timeSeqDelay);
                            (advanceGroup = FALSE);
                        }
                    }
                }
            }
            else  {
                (timeEnded = TRUE);
                if ((llList2Integer(groupItemList,0) != 3)) {
                    
                    (timeSequence = (((timeSequence = []) + timeSequence) + [groupItem]));
                }
                else  {
                    
                    (loopAgain = FALSE);
                    (timeOffset += llList2Integer(groupItemList,1));
                    if (((i + 1) < groupSeqLength)) {
                        (groupItem = llList2String(groupSequence,(i + 1)));
                        (groupItemList = llParseString2List(groupItem,["|"],[]));
                        if (((llList2Integer(groupItemList,0) == 2) && (llList2Integer(groupItemList,3) == 2))) {
                            
                            (timeSequence = (((timeSequence = []) + timeSequence) + [groupItem]));
                        }
                    }
                }
            }
        }
        else  {
            if ((llList2Integer(groupItemList,0) != 3)) {
                
                (timeSequence = (((timeSequence = []) + timeSequence) + [groupItem]));
            }
            else  {
                
                (loopAgain = FALSE);
                (timeOffset += llList2Integer(groupItemList,1));
                if (((i + 1) < groupSeqLength)) {
                    (groupItem = llList2String(groupSequence,(i + 1)));
                    (groupItemList = llParseString2List(groupItem,["|"],[]));
                    if (((llList2Integer(groupItemList,0) == 2) && (llList2Integer(groupItemList,3) == 2))) {
                        
                        (timeSequence = (((timeSequence = []) + timeSequence) + [groupItem]));
                    }
                }
            }
        }
        if (advanceGroup) (++i);
    }
    
    if (((timeOffset != groupDuration) || (i < groupSeqLength))) {
        (timeOffset = 0);
        for ((i = 0); (i < groupSeqLength); (++i)) {
            (groupItem = llList2String(groupSequence,i));
            (groupItemList = llParseString2List(groupItem,["|"],[]));
            if ((llList2Integer(groupItemList,0) == 3)) {
                (timeOffset += llList2Integer(groupItemList,1));
            }
        }
        (groupItem = llList2String(llParseString2List(llList2String(startSeq,groupStartedInSeqAt),["|"],[]),3));
        if ((timeOffset > groupDuration)) {
            OwnerSay("LMSG011",[sequencename,groupItem,((string)(((float)timeOffset) / 10.0)),llList2String(llParseString2List(llList2String(startSeq,prevGroupStartedInSeqAt),["|"],[]),3),((string)(((float)groupDuration) / 10.0)),groupItem]);
        }
        else  {
            OwnerSay("LMSG013",[sequencename,groupItem,((string)(((float)timeOffset) / 10.0)),llList2String(llParseString2List(llList2String(startSeq,prevGroupStartedInSeqAt),["|"],[]),3),((string)(((float)groupDuration) / 10.0)),groupItem]);
        }
    }
    (groupSequence = []);
    return;
}
ReorderSequenceToTimeSequence(){
    integer startSeqLen;
    integer i;
    list seqItem;
    integer keyword;
    (loops = []);
    (loopsLength = []);
    (loopActive = FALSE);
    (loopStartsAt = 0);
    (groupSequence = []);
    (groupStartsAt = 0);
    (activeGroupBits = 1);
    (groupActive = FALSE);
    (previousWasGroup = FALSE);
    (groupCounter = 0);
    (startSeqLen = llGetListLength(startSeq));
    for ((i = 0); (i < startSeqLen); (++i)) {
        (seqItem = llParseString2List(llList2String(startSeq,i),["|"],[]));
        (keyword = llList2Integer(seqItem,0));
        if (((!groupActive) && (!loopActive))) {
            if ((keyword == 2)) {
                StoreIntoSequence(i,2);
                (++i);
            }
            if (((-1) != llListFindList([3,4,6,8,12,16,17,19,21,22,23,26,15,20,24],[keyword]))) {
                StoreIntoSequence(i,1);
            }
            if ((keyword == 7)) {
                
                (groupStartsAt = llGetListLength(timeSequence));
                (groupActive = TRUE);
                (activeGroupBits = llList2Integer(seqItem,2));
                if ((previousWasGroup && (llList2String(seqItem,1) == "SAME"))) {
                    
                    (usePrevSelections = 0);
                    (++groupCounter);
                    if ((prevGroupStartedInSeqAt == (-1))) {
                        (prevGroupStartedInSeqAt = groupStartedInSeqAt);
                    }
                }
                else  {
                    
                    (previousGroupStartsAt = (-1));
                    (prevGroupStartedInSeqAt = (-1));
                    (usePrevSelections = (-1));
                    (prevLoopStarts = 0);
                    (prevLoopNumOptions = 0);
                    (prevSelect = []);
                    (prevSelectLength = []);
                    (groupCounter = 0);
                }
                (groupStartedInSeqAt = i);
            }
            else  {
                if (previousWasGroup) {
                    (previousWasGroup = FALSE);
                    (previousGroupStartsAt = (-1));
                    (prevGroupStartedInSeqAt = (-1));
                    (usePrevSelections = (-1));
                    (prevLoopStarts = 0);
                    (prevLoopNumOptions = 0);
                    (prevSelect = []);
                    (prevSelectLength = []);
                    (groupCounter = 0);
                }
            }
            if (((-1) != llListFindList([9,13,18],[keyword]))) {
                
                (loopStartsAt = i);
                (loopActive = TRUE);
                (loops = []);
                (loopsLength = []);
            }
        }
        else  {
            if (loopActive) {
                if ((keyword == 2)) {
                    
                    (loops = (((loops = []) + loops) + [i]));
                    (loopsLength = (((loopsLength = []) + loopsLength) + [2]));
                    (++i);
                }
                else  {
                    if (((-1) != llListFindList([3,4,6,8,12,16,17,19,21,22,23,26,15,20,24],[keyword]))) {
                        
                        (loops = (((loops = []) + loops) + [i]));
                        (loopsLength = (((loopsLength = []) + loopsLength) + [1]));
                    }
                    if ((keyword == 5)) {
                        
                        if ((groupActive && (previousGroupStartsAt == (-1)))) {
                            (prevLoopNumOptions = llGetListLength(loops));
                            
                        }
                        SelectForLoop();
                        (activeGroupBits = 1);
                        (loopActive = FALSE);
                    }
                }
            }
            else  {
                if (groupActive) {
                    if ((keyword == 2)) {
                        StoreIntoSequence(i,2);
                        (++i);
                    }
                    if (((-1) != llListFindList([3,4,6,8,12,16,17,19,21,22,23,26,15,20,24],[keyword]))) {
                        
                        StoreIntoSequence(i,1);
                    }
                    if (((-1) != llListFindList([9,13,18],[keyword]))) {
                        
                        (loopActive = TRUE);
                        (loopStartsAt = i);
                        if ((previousGroupStartsAt == (-1))) {
                            (prevLoopStarts = i);
                        }
                        (loops = []);
                        (loopsLength = []);
                    }
                    if ((keyword == 5)) {
                        
                        (groupActive = FALSE);
                        MergeGroupSequence();
                        (previousWasGroup = TRUE);
                        (activeGroupBits = 1);
                        if ((previousGroupStartsAt == (-1))) {
                            (previousGroupStartsAt = groupStartsAt);
                        }
                    }
                }
            }
        }
    }
}
OptimizeTimeSequence(){
    integer i;
    integer j;
    integer k;
    integer danceIndex;
    list itemList;
    integer len;
    list deleteUs = [];
    integer deleteUsLen = 0;
    integer notDoneYet;
    integer lastDanceStop = (-1);
    (len = llGetListLength(timeSequence));
    for ((i = 0); (i < len); (++i)) {
        (itemList = llParseString2List(llList2String(timeSequence,i),["|"],[]));
        if ((llList2Integer(itemList,0) == 2)) {
            if ((llList2Integer(itemList,3) == 2)) {
                (danceIndex = llList2Integer(itemList,4));
                if ((danceIndex == 0)) {
                    (lastDanceStop = i);
                }
                (notDoneYet = TRUE);
                for ((j = (i + 1)); ((j < len) && notDoneYet); (++j)) {
                    (itemList = llParseString2List(llList2String(timeSequence,j),["|"],[]));
                    (k = llList2Integer(itemList,0));
                    if ((k == 3)) {
                        (notDoneYet = FALSE);
                    }
                    else  {
                        if ((llList2Integer(itemList,0) == 2)) {
                            if (((llList2Integer(itemList,3) == 1) && (llList2Integer(itemList,4) == danceIndex))) {
                                (deleteUs = (((deleteUs = []) + deleteUs) + [i]));
                                (++deleteUsLen);
                                (notDoneYet = FALSE);
                                if ((i == lastDanceStop)) {
                                    (lastDanceStop = (-1));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if ((lastDanceStop != (-1))) {
        (deleteUs = (((deleteUs = []) + deleteUs) + [lastDanceStop]));
        (++deleteUsLen);
    }
    if ((deleteUsLen > 0)) {
        
        for ((i = 0); (i < deleteUsLen); (++i)) {
            (j = llList2Integer(deleteUs,((deleteUsLen - 1) - i)));
            (timeSequence = ((timeSequence = []) + llDeleteSubList(timeSequence,j,j)));
        }
    }
}
default {

 state_entry() {
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if ((12123403 == num)) {
            (startSeq = llParseString2List(str,["|"],[]));
            if ((1 == llList2Integer(startSeq,0))) {
                string replyStr;
                (sequencename = llList2String(startSeq,1));
                (returnLink = llList2Integer(startSeq,2));
                (replyStr = llList2String(startSeq,3));
                integer fromLinkId = llList2Integer(startSeq,4);
                (startSeq = llParseString2List(((string)id),["|||"],[]));
                ReorderSequenceToTimeSequence();
                OptimizeTimeSequence();
                llMessageLinked(LINK_THIS,returnLink,((((replyStr + "|") + sequencename) + "|") + ((string)fromLinkId)),((key)llDumpList2String(timeSequence,"|||")));
                (sequencename = "");
                (timeSequence = []);
                (loops = []);
                (loopsLength = []);
                (prevSelect = []);
                (prevSelectLength = []);
                (groupSequence = []);
                (startSeq = []);
            }
            return;
        }
        if (((num == 0) && (str == "RESET"))) llResetScript();
    }
}
