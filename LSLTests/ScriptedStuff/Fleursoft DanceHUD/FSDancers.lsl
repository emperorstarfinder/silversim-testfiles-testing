// LSL script generated: FSDancers.lslp Sun Jan 24 18:17:30 Mitteleuropäische Zeit 2016

list dancers = [];
list dancerKeys = [];
list dancersLinks = [];
list controllersAvailable = [];
integer controllersEnabled = 0;
list controllerScripts = [];
list controllersLinkIds = [];
list refusedDance = [];
integer ownerChatChannel = 98;
list nearbyAVs = [];
list nearbyAVsKeys = [];
integer autoInvite = FALSE;
string tmpStr = "";
list tmpList = [];
integer i = 0;
integer j = 0;
integer k = 0;
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
SetScriptState(string s,integer flag){
    llSetScriptState(s,flag);
}
DoSetActiveDancers(){
    integer ctlLinkId;
    (k = llGetListLength(controllersAvailable));
    for ((i = 0); (i < k); (++i)) {
        (j = llListFindList(controllersLinkIds,[llList2Integer(controllersAvailable,i)]));
        (tmpStr = llList2String(controllerScripts,j));
        if ((!llGetScriptState(tmpStr))) SetScriptState(tmpStr,TRUE);
    }
    (k = llGetListLength(controllersLinkIds));
    for ((i = 0); (i < k); (++i)) {
        (ctlLinkId = llList2Integer(controllersLinkIds,i));
        if ((((-1) == llListFindList(dancersLinks,[ctlLinkId])) && ((-1) == llListFindList(controllersAvailable,[ctlLinkId])))) {
            (tmpStr = llList2String(controllerScripts,i));
            if (llGetScriptState(tmpStr)) SetScriptState(tmpStr,FALSE);
        }
    }
}
integer GetDanceController(){
    if ((llGetListLength(controllersAvailable) > 0)) {
        (i = llList2Integer(controllersAvailable,0));
        (controllersAvailable = ((controllersAvailable = []) + llDeleteSubList(controllersAvailable,0,0)));
        return i;
    }
    if ((!autoInvite)) {
        if ((controllersEnabled < llGetListLength(controllersLinkIds))) OwnerSay("DCMSG004",[controllersEnabled,llGetListLength(controllersLinkIds)]);
        else  OwnerSay("DCMSG005",[llGetListLength(controllersLinkIds)]);
    }
    return (-1);
}
ChangeActiveControllers(integer numberOfScripts){
    integer ctlIndex;
    integer newLinkId;
    if ((numberOfScripts == controllersEnabled)) return;
    if ((numberOfScripts < controllersEnabled)) {
        (j = (controllersEnabled - numberOfScripts));
        for ((i = 0); (i < j); (i++)) (controllersAvailable = ((controllersAvailable = []) + llDeleteSubList(controllersAvailable,0,0)));
    }
    else  {
        (j = (numberOfScripts - controllersEnabled));
        (ctlIndex = 0);
        for ((i = 0); (i < j); (i++)) {
            (newLinkId = llList2Integer(controllersLinkIds,ctlIndex));
            while ((((-1) != llListFindList(dancersLinks,[newLinkId])) || ((-1) != llListFindList(controllersAvailable,[newLinkId])))) {
                (ctlIndex++);
                (newLinkId = llList2Integer(controllersLinkIds,ctlIndex));
            }
            (controllersAvailable = (((controllersAvailable = []) + controllersAvailable) + [newLinkId]));
            (ctlIndex++);
        }
    }
    (controllersEnabled = numberOfScripts);
    (k = llGetListLength(controllersAvailable));
    for ((i = 0); (i < k); (++i)) {
        (j = llListFindList(controllersLinkIds,[llList2Integer(controllersAvailable,i)]));
        (tmpStr = llList2String(controllerScripts,j));
        if ((!llGetScriptState(tmpStr))) SetScriptState(tmpStr,TRUE);
    }
    (k = llGetListLength(controllersLinkIds));
    for ((i = 0); (i < k); (++i)) {
        (j = llList2Integer(controllersLinkIds,i));
        if ((((-1) == llListFindList(dancersLinks,[j])) && ((-1) == llListFindList(controllersAvailable,[j])))) {
            (tmpStr = llList2String(controllerScripts,i));
            if (llGetScriptState(tmpStr)) SetScriptState(tmpStr,FALSE);
        }
    }
    OwnerSay("DCMSG024",[controllersEnabled,llGetListLength(controllersLinkIds)]);
}
DoAddDancer(string avname,key avkey,integer controllerLinkid){
    if ((controllerLinkid != (-1))) {
        if (((-1) == llListFindList(dancers,[avname]))) {
            (dancers = (((dancers = []) + dancers) + [avname]));
            (dancerKeys = (((dancerKeys = []) + dancerKeys) + [avkey]));
            (dancersLinks = (((dancersLinks = []) + dancersLinks) + [controllerLinkid]));
            llMessageLinked(LINK_THIS,12123402,((string)10),((key)llDumpList2String([controllerLinkid,avname,avkey,ownerChatChannel,autoInvite],"|")));
        }
        else  (controllersAvailable = ((controllersAvailable = []) + llListInsertList(controllersAvailable,[controllerLinkid],0)));
    }
    return;
}
DoReleaseDancer(integer index,integer resetFlag){
    if ((index == (-1))) {
        return;
    }
    (j = llList2Integer(dancersLinks,index));
    if (resetFlag) llMessageLinked(LINK_THIS,j,"RESET",((key)""));
    (controllersAvailable = ((controllersAvailable = []) + llListInsertList(controllersAvailable,[j],0)));
    if (autoInvite) {
        (tmpStr = llList2String(dancerKeys,index));
        (refusedDance = (((refusedDance = []) + refusedDance) + [tmpStr]));
        if ((llGetListLength(refusedDance) > 50)) {
            (refusedDance = ((refusedDance = []) + llDeleteSubList(refusedDance,0,0)));
        }
    }
    (tmpStr = llList2String(dancers,index));
    (dancers = ((dancers = []) + llDeleteSubList(dancers,index,index)));
    (dancerKeys = ((dancerKeys = []) + llDeleteSubList(dancerKeys,index,index)));
    (dancersLinks = ((dancersLinks = []) + llDeleteSubList(dancersLinks,index,index)));
    OwnerSay("DCMSG003",[tmpStr]);
    (tmpStr = "");
}
HandleAddDancer(){
    integer cmd = llList2Integer(tmpList,0);
    integer controllerLinkid = 0;
    if ((cmd == 103)) {
        (nearbyAVs = tmpList);
        (tmpList = []);
        llSensor("",NULL_KEY,AGENT,50.0,PI);
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 0) && (cmd < (llGetListLength(nearbyAVs) + 3)))) {
            if ((cmd == 0)) {
                (nearbyAVs = []);
                (nearbyAVsKeys = []);
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 1)) {
                for ((cmd = 2); ((cmd < (llGetListLength(nearbyAVs) + 2)) && (controllerLinkid != (-1))); (cmd++)) {
                    (controllerLinkid = GetDanceController());
                    if ((controllerLinkid != (-1))) {
                        OwnerSay("DCMSG008",[llList2String(nearbyAVs,(cmd - 2))]);
                        DoAddDancer(llList2String(nearbyAVs,(cmd - 2)),llList2Key(nearbyAVsKeys,(cmd - 2)),controllerLinkid);
                    }
                }
            }
            else  {
                if ((cmd > 2)) {
                    (controllerLinkid = GetDanceController());
                    OwnerSay("DCMSG008",[llList2String(nearbyAVs,(cmd - 3))]);
                    DoAddDancer(llList2String(nearbyAVs,(cmd - 3)),llList2Key(nearbyAVsKeys,(cmd - 3)),controllerLinkid);
                }
            }
        }
        else  OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        (tmpList = []);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123413)));
    }
}
HandleRemoveDancer(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetListLength(dancersLinks);
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex >= length) || (startIndex < 0))) llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        else  {
            if (((startIndex + number) > (length + 1))) (number = (length - startIndex));
            if ((number > 0)) {
                (tmpList = [llDumpList2String(["#1 Back",12123414,0],"|")]);
                for ((i = 0); (i < number); (++i)) {
                    (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 2))) + " ") + llList2String(dancers,(i + startIndex))),12123414,((startIndex + i) + 1)],"|"));
                    (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
                }
                (tmpStr = llDumpList2String(tmpList,"|||"));
                llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Remove which dancer?",(length + 1),startIndex,0,12123414],"|"),((key)tmpStr));
                return;
            }
            (tmpList = []);
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
            return;
        }
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 0) && (cmd < (length + 1)))) {
            if ((cmd == 0)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            else  DoReleaseDancer((cmd - 1),TRUE);
        }
        else  OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123414)));
    }
}
HandleChangeGroups(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetListLength(dancersLinks);
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex >= length) || (startIndex < 0))) llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Change settings for?",(length + 1),0,0,12123415],"|"),((key)""));
        else  {
            if (((startIndex + number) > (length + 1))) (number = (length - startIndex));
            if ((number > 0)) {
                (tmpList = [llDumpList2String(["#1 Back",12123415,0],"|")]);
                for ((i = 0); (i < number); (++i)) {
                    (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 2))) + " ") + llList2String(dancers,(i + startIndex))),12123415,((i + startIndex) + 1)],"|"));
                    (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
                }
                (tmpStr = llDumpList2String(tmpList,"|||"));
                llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Change settings for?",(length + 1),startIndex,0,12123415],"|"),((key)tmpStr));
                return;
            }
            OwnerSay("DCMSG009",[]);
            (tmpList = []);
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
            return;
        }
    }
    if ((cmd == 51)) {
        (i = llList2Integer(tmpList,1));
        if (((i >= 0) && (i < (length + 1)))) {
            if ((i == 0)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            else  {
                (cmd = (llList2Integer(dancersLinks,(i - 1)) + 200));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)cmd)));
                return;
            }
        }
        else  OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
    }
}
ScanForDancerScripts(){
    integer scriptsTotal;
    integer scriptNumber;
    integer baseLen = llStringLength("~FSDancer");
    list numberCheck = ["0","1","2","3","4","5","6","7","8","9"];
    (scriptsTotal = llGetInventoryNumber(INVENTORY_SCRIPT));
    for ((i = 0); (i < scriptsTotal); (++i)) {
        (scriptNumber = (-1));
        (tmpStr = llGetInventoryName(INVENTORY_SCRIPT,i));
        if ((llStringLength(tmpStr) > baseLen)) {
            if ((llGetSubString(tmpStr,0,(baseLen - 1)) == "~FSDancer")) {
                (j = llListFindList(numberCheck,[llGetSubString(tmpStr,(-1),(-1))]));
                if ((j != (-1))) {
                    (k = llListFindList(numberCheck,[llGetSubString(tmpStr,(-2),(-2))]));
                    if ((k != (-1))) (scriptNumber = ((10 * k) + j));
                    else  (scriptNumber = j);
                }
            }
        }
        if ((scriptNumber > 0)) {
            if (((-1) == llListFindList(controllersLinkIds,[(121234200 + scriptNumber)]))) {
                (controllersLinkIds = (((controllersLinkIds = []) + controllersLinkIds) + [(121234200 + scriptNumber)]));
                (controllerScripts = (((controllerScripts = []) + controllerScripts) + [tmpStr]));
            }
        }
    }
    (scriptNumber = llGetListLength(controllersLinkIds));
    for ((i = 0); (i < scriptNumber); (i++)) {
        if ((INVENTORY_NONE == llGetInventoryType(llList2String(controllerScripts,i)))) {
            (scriptsTotal = llListFindList(dancersLinks,[llList2Integer(controllersLinkIds,i)]));
            if (((-1) != scriptsTotal)) {
                OwnerSay("DCMSG013",[llList2String(controllerScripts,i),llList2String(dancers,scriptsTotal)]);
                (dancers = ((dancers = []) + llDeleteSubList(dancers,scriptsTotal,scriptsTotal)));
                (dancerKeys = ((dancerKeys = []) + llDeleteSubList(dancerKeys,scriptsTotal,scriptsTotal)));
                (dancersLinks = ((dancersLinks = []) + llDeleteSubList(dancersLinks,scriptsTotal,scriptsTotal)));
            }
            (controllerScripts = ((controllerScripts = []) + llDeleteSubList(controllerScripts,i,i)));
            (controllersLinkIds = ((controllersLinkIds = []) + llDeleteSubList(controllersLinkIds,i,i)));
        }
    }
    (scriptsTotal = controllersEnabled);
    if ((scriptsTotal > llGetListLength(controllerScripts))) (scriptsTotal = llGetListLength(controllerScripts));
    if (((scriptsTotal < 10) && (llGetListLength(controllerScripts) >= 10))) (scriptsTotal = 10);
    ChangeActiveControllers(scriptsTotal);
    DoSetActiveDancers();
}
integer CheckForOwner(integer linkid){
    integer i2;
    integer j2;
    integer controllerLinkid;
    list p;
    string s;
    if (((-1) == llListFindList(dancerKeys,[llGetOwner()]))) {
        (nearbyAVsKeys = ((nearbyAVsKeys = []) + llListInsertList(nearbyAVsKeys,[llGetOwner()],0)));
        (nearbyAVs = ((nearbyAVs = []) + llListInsertList(nearbyAVs,[llKey2Name(llGetOwner())],0)));
    }
    (i2 = llGetListLength(nearbyAVs));
    if ((!autoInvite)) {
        if ((i2 > 0)) {
            (p = [llDumpList2String(["#1 Back",12123413,0],"|")]);
            (p += [llDumpList2String(["#2 All",12123413,1],"|")]);
            (p += [llDumpList2String(["#3 Refresh list",12123413,2],"|")]);
            (i = 3);
            for ((j2 = 0); (j2 < i2); (++j2)) {
                (++i);
                (s = llDumpList2String([((("#" + ((string)i)) + " ") + llList2String(nearbyAVs,j2)),12123413,(j2 + 3)],"|"));
                (p = (((p = []) + p) + [s]));
            }
            (s = llDumpList2String(p,"|||"));
            (p = []);
            llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Invite which dancer?",i,0,0,12123413],"|"),((key)s));
            (s = "");
            return TRUE;
        }
        return FALSE;
    }
    else  {
        for ((j2 = 0); (j2 < i2); (++j2)) {
            (controllerLinkid = GetDanceController());
            if ((controllerLinkid != (-1))) {
                OwnerSay("DCMSG008",[llList2String(nearbyAVs,j2)]);
                DoAddDancer(llList2String(nearbyAVs,j2),llList2Key(nearbyAVsKeys,j2),controllerLinkid);
            }
        }
        return TRUE;
    }
}
default {

 state_entry() {
        ScanForDancerScripts();
    }

 link_message(integer sender_num,integer num,string str,key id) {
        integer i2;
        integer j2;
        integer k2;
        if (((-1) == llListFindList([12123428,12123413,12123414,12123415,0],[num]))) {
            return;
        }
        if ((num == 12123428)) {
            (tmpList = llParseString2List(str,["|"],[]));
            (i2 = ((integer)str));
            if ((1 == i2)) {
                (tmpList = llParseString2List(((string)id),["|"],[]));
                (i2 = GetDanceController());
                DoAddDancer(llList2String(tmpList,0),llList2Key(tmpList,1),i2);
                return;
            }
            if ((2 == i2)) {
                list p = llParseString2List(((string)id),["|"],[]);
                DoReleaseDancer(llListFindList(dancerKeys,[llList2Key(p,0)]),llList2Integer(p,1));
                return;
            }
            if ((3 == i2)) {
                ChangeActiveControllers(((integer)((string)id)));
                return;
            }
            if ((4 == i2)) {
                (ownerChatChannel = ((integer)((string)id)));
                llMessageLinked(LINK_THIS,12123406,((string)1),((key)((string)ownerChatChannel)));
                return;
            }
            if ((5 == i2)) {
                llOwnerSay((((((((("There are " + ((string)llGetListLength(dancersLinks))) + " active dancers, with ") + ((string)controllersEnabled)) + " dancers enabled and a total of ") + ((string)llGetListLength(controllersLinkIds))) + " dancer scripts (") + "~FSDancer") + " ##)"));
                for ((i2 = 0); (i2 < llGetListLength(dancersLinks)); (++i2)) llOwnerSay((((((("    Dancer " + ((string)(i2 + 1))) + ":") + llList2String(dancers,i2)) + " (on script number ") + ((string)(llList2Integer(dancersLinks,i2) - 121234200))) + ")"));
                llOwnerSay("Available dancer scripts are:");
                for ((i2 = 0); (i2 < llGetListLength(controllersAvailable)); (++i2)) llOwnerSay(((("   Available " + ((string)(i2 + 1))) + " is script number ") + ((string)(llList2Integer(controllersAvailable,i2) - 121234200))));
                llOwnerSay((((("Fleursoft" + " ") + "DanceHUD OpenSource") + " ") + "1.3"));
                return;
            }
            if ((6 == i2)) {
                llMessageLinked(LINK_THIS,12123406,((string)3),((key)llDumpList2String(dancersLinks,"|")));
                return;
            }
            if ((7 == i2)) {
                (autoInvite = ((integer)((string)id)));
                if (autoInvite) {
                    (refusedDance = []);
                    llSetTimerEvent(5.0);
                    llSensor("",NULL_KEY,AGENT,50.0,PI);
                }
                else  {
                    llSensorRemove();
                    llSetTimerEvent(0.0);
                    llMessageLinked(LINK_THIS,(303181824 + 1),((string)11),((key)""));
                }
            }
            if ((8 == i2)) {
                (j2 = llGetListLength(dancersLinks));
                for ((i2 = 0); (i2 < j2); (i2++)) DoReleaseDancer(0,TRUE);
                return;
            }
        }
        if ((12123413 == num)) {
            (tmpList = llParseString2List(str,["|"],[]));
            HandleAddDancer();
            return;
        }
        if ((12123414 == num)) {
            (tmpList = llParseString2List(str,["|"],[]));
            HandleRemoveDancer();
            return;
        }
        if ((12123415 == num)) {
            (tmpList = llParseString2List(str,["|"],[]));
            HandleChangeGroups();
            return;
        }
        if (((num == 0) && ("RESET" == str))) {
            (j2 = llGetListLength(controllersLinkIds));
            for ((i2 = 0); (i2 < j2); (++i2)) {
                (k2 = llList2Integer(controllersLinkIds,i2));
                if ((((-1) == llListFindList(dancersLinks,[k2])) && ((-1) == llListFindList(controllersAvailable,[k2])))) SetScriptState(llList2String(controllerScripts,i2),TRUE);
            }
            llSleep(1);
            for ((i2 = 0); (i2 < j2); (++i2)) {
                (k2 = llList2Integer(controllersLinkIds,i2));
                if ((((-1) == llListFindList(dancersLinks,[k2])) && ((-1) == llListFindList(controllersAvailable,[k2])))) llMessageLinked(LINK_THIS,k2,"RESET",((key)""));
            }
            llSensorRemove();
            llResetScript();
        }
    }

 sensor(integer count) {
        key newKey;
        integer i2;
        integer i3;
        integer linkid = llList2Integer(nearbyAVs,2);
        (nearbyAVs = []);
        (nearbyAVsKeys = []);
        for ((i2 = 0); (i2 < count); (++i2)) {
            (newKey = llDetectedKey(i2));
            if (((-1) == llListFindList(dancerKeys,[newKey]))) {
                (i3 = TRUE);
                if (autoInvite) {
                    if (((-1) != llListFindList(refusedDance,[newKey]))) (i3 = FALSE);
                }
                if (i3) {
                    (nearbyAVs = (((nearbyAVs = []) + nearbyAVs) + [llDetectedName(i2)]));
                    (nearbyAVsKeys = (((nearbyAVsKeys = []) + nearbyAVsKeys) + [((string)newKey)]));
                }
            }
        }
        if (CheckForOwner(linkid)) return;
        if ((!autoInvite)) {
            OwnerSay("DCMSG006",[50.0]);
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        }
    }

 no_sensor() {
        integer linkid = llList2Integer(nearbyAVs,2);
        (nearbyAVs = []);
        (nearbyAVsKeys = []);
        if (CheckForOwner(linkid)) return;
        if ((!autoInvite)) {
            OwnerSay("DMSG007",[50.0]);
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        }
    }

 timer() {
        llSensor("",NULL_KEY,AGENT,50.0,PI);
    }

 changed(integer flags) {
        if ((flags & (CHANGED_TELEPORT | CHANGED_REGION))) DoSetActiveDancers();
        if ((flags & CHANGED_INVENTORY)) ScanForDancerScripts();
    }
}
