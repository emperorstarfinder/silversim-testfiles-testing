// LSL script generated: FSDancer.lslp Sun Jan 24 18:17:30 Mitteleuropäische Zeit 2016
list Define_GroupNames = ["ALL","FEMALE","MALE","LEAD","LEFT","CENTER","RIGHT","GROUP1","GROUP2","GROUP3","GROUP4","GROUP5"];
list Define_GroupBits = [1,2,4,8,16,32,64,128,256,512,1024,2048];
list Define_GroupAliases = ["|","|","|","|","|","|","|","|","|","|","|","|"];
integer scriptNumber = 0;
integer linkId = 0;
integer secondLinkId = 0;
integer linkFlags = 1;
list animList = [];
list animIndex = [];
integer animStarted = 0;
string dancerName = "";
key dancerKey = NULL_KEY;
key permKey = NULL_KEY;
integer activeDancer = FALSE;
integer showTimer = FALSE;
string lastPrimaryDance = "";
integer channelNumber = 0;
integer channelHandle = 0;
integer autoInvite = FALSE;
integer bits = 0;
integer cmdNumber = 0;
list cmdParms = [];
integer stopParam = 0;
string startingDance = "";
list preloadList = [];
integer preloadIndex = 0;
integer timerType = 0;
integer i = 0;
integer j = 0;
integer k = 0;
string s;
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
DancerGone(string errMsg,float delay){
    if ((!autoInvite)) {
        OwnerSay(errMsg,[dancerName,delay]);
    }
    llMessageLinked(LINK_THIS,12123428,((string)2),((key)llDumpList2String([dancerKey,FALSE],"|")));
    llResetScript();
    llSleep(0.1);
}
StartDancing(){
    integer i2;
    (k = llList2Integer(cmdParms,0));
    
    if ((ZERO_VECTOR == llGetAgentSize(dancerKey))) DancerGone("DMSG008",0.0);
    if (((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == 0)) DancerGone("DMSG004",0.0);
    if ((animStarted == 0)) {
        (i = (-1));
    }
    else  {
        (i = llListFindList(animIndex,[k]));
        (i2 = llList2Integer(cmdParms,2));
        if ((i2 == 1)) {
            if ((animStarted > 1)) {
                for ((j = 0); (j < animStarted); (++j)) {
                    if ((j != i)) {
                        (s = llList2String(animList,j));
                        llStopAnimation(s);
                        
                    }
                }
                (animList = [llList2String(animList,i)]);
                (animIndex = [k]);
                (animStarted = 1);
                (i = 0);
            }
        }
        if ((i != (-1))) {
            if ((showTimer && (k == 0))) OwnerSay("DMSG001",[lastPrimaryDance,llGetAndResetTime()]);
            (s = llList2String(animList,i));
            llStopAnimation(s);
            
        }
        if ((i2 == 2)) {
            llStartAnimation("stand_1");
            llSleep(0.5);
            llStopAnimation("stand_1");
        }
    }
    (startingDance = llList2String(cmdParms,1));
    if ((k == 0)) (lastPrimaryDance = startingDance);
    llStartAnimation(startingDance);
    
    if ((animStarted == 0)) {
        (animList = [startingDance]);
        (animIndex = [k]);
        (animStarted = 1);
        return;
    }
    if ((i != (-1))) {
        (animList = ((animList = []) + llListReplaceList(animList,[startingDance],i,i)));
        return;
    }
    else  {
        (animList = (((animList = []) + animList) + [startingDance]));
        (animIndex = (((animIndex = []) + animIndex) + [k]));
        (++animStarted);
        return;
    }
}
StopDancing(){
    if ((animStarted == 0)) return;
    if ((ZERO_VECTOR == llGetAgentSize(dancerKey))) DancerGone("DMSG008",0.0);
    if (((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == 0)) DancerGone("DMSG004",0.0);
    if ((stopParam != 1024)) {
        (i = llListFindList(animIndex,[stopParam]));
        if ((i != (-1))) {
            if ((showTimer && (i == 0))) OwnerSay("DMSG001",[lastPrimaryDance,llGetAndResetTime()]);
            (s = llList2String(animList,i));
            llStopAnimation(s);
            if ((animStarted == 1)) {
                (animList = []);
                (animIndex = []);
                (animStarted = 0);
                return;
            }
            else  {
                (animList = ((animList = []) + llDeleteSubList(animList,i,i)));
                (animIndex = ((animIndex = []) + llDeleteSubList(animIndex,i,i)));
                (--animStarted);
                return;
            }
        }
        
        return;
    }
    else  {
        if ((animStarted > 0)) {
            if (showTimer) OwnerSay("DMSG001",[lastPrimaryDance,llGetAndResetTime()]);
            for ((i = 0); (i < animStarted); (++i)) {
                (s = llList2String(animList,i));
                llStopAnimation(s);
            }
        }
        (animList = []);
        (animIndex = []);
        (animStarted = 0);
    }
}
AddDancer(){
    (startingDance = llList2String(cmdParms,0));
    if (activeDancer) {
        
        (stopParam = 1024);
        StopDancing();
    }
    (dancerName = startingDance);
    (dancerKey = llList2Key(cmdParms,1));
    (channelNumber = llList2Integer(cmdParms,2));
    (autoInvite = llList2Integer(cmdParms,3));
    (startingDance = llList2String(cmdParms,4));
    (activeDancer = FALSE);
    llRequestPermissions(dancerKey,PERMISSION_TRIGGER_ANIMATION);
    if ((!autoInvite)) {
        (timerType = 1);
        llSetTimerEvent(120.0);
    }
}
HandleChangeFlags(){
    integer cmd = llList2Integer(cmdParms,0);
    integer length = llGetListLength(Define_GroupBits);
    string s2;
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(cmdParms,1);
        integer returnLinkid = llList2Integer(cmdParms,2);
        integer number = llList2Integer(cmdParms,3);
        if (((startIndex > length) || (startIndex < 0))) llMessageLinked(LINK_THIS,returnLinkid,llDumpList2String(["ITEMS",("Changing settings for:" + dancerName),length,0,0,secondLinkId],"|"),((key)""));
        else  {
            if (((startIndex + number) > length)) (number = (length - startIndex));
            (cmdParms = [llDumpList2String(["#1 Back",secondLinkId,0],"|")]);
            for ((i = 1); (i < number); (++i)) {
                (s2 = llList2String(Define_GroupNames,(i + startIndex)));
                if ((llList2String(Define_GroupAliases,(i + startIndex)) != "|")) (s2 = ((((s2 = "") + s2) + "/") + llList2String(Define_GroupAliases,(i + startIndex))));
                (s = "Off");
                (cmd = llList2Integer(Define_GroupBits,(i + startIndex)));
                if (((linkFlags & cmd) == cmd)) (s = "On");
                (s2 = ((((s2 = "") + s2) + ":") + s));
                (s = llDumpList2String([((("#" + ((string)((i + startIndex) + 2))) + " ") + s2),secondLinkId,(i + startIndex)],"|"));
                (cmdParms = (((cmdParms = []) + cmdParms) + [s]));
            }
            (s = llDumpList2String(cmdParms,"|||"));
            llMessageLinked(LINK_THIS,returnLinkid,llDumpList2String(["ITEMS",("Changing settings for:" + dancerName),(number + 1),startIndex,0,secondLinkId],"|"),((key)s));
            return;
        }
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(cmdParms,1));
        if (((cmd >= 0) && (cmd < length))) {
            if ((cmd == 0)) (cmd = 12123415);
            else  {
                (linkFlags = (linkFlags ^ llList2Integer(Define_GroupBits,cmd)));
                (cmd = secondLinkId);
            }
        }
        else  {
            OwnerSay("DCMSG007",[llList2String(cmdParms,1)]);
            (cmd = secondLinkId);
        }
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)cmd)));
    }
}
default {

 state_entry() {
        string script;
        (script = llGetScriptName());
        if ((llStringLength(script) > 3)) {
            (scriptNumber = llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(script,(-1),(-1))]));
            if ((scriptNumber != (-1))) {
                (i = llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(script,(-2),(-2))]));
                if ((i != (-1))) (scriptNumber += (10 * i));
            }
        }
        if ((scriptNumber < 1)) {
            OwnerSay("DMSG006",[script]);
            llRemoveInventory(script);
            return;
        }
        (linkId = (121234200 + scriptNumber));
        (secondLinkId = (linkId + 200));
        
    }

 link_message(integer sender_num,integer num,string str,key id) {
        (bits = 0);
        if (((num & 2147479552) == 303181824)) (bits = (num & 4095));
        if (((linkId == num) || (bits & linkFlags))) {
            (cmdNumber = ((integer)str));
            (cmdParms = llParseString2List(((string)id),["|"],[]));
            if (activeDancer) {
                if ((cmdNumber == 1)) {
                    StartDancing();
                    return;
                }
                if ((cmdNumber == 2)) {
                    (stopParam = llList2Integer(cmdParms,0));
                    StopDancing();
                    return;
                }
                if ((cmdNumber == 7)) {
                    llInstantMessage(dancerKey,((string)id));
                    return;
                }
                if ((cmdNumber == 9)) {
                    llGiveInventory(dancerKey,((string)id));
                    return;
                }
                if ((cmdNumber == 4)) {
                    llMessageLinked(LINK_THIS,llList2Integer(cmdParms,0),llDumpList2String(["MCFLAGS",dancerName],"|"),((key)((string)linkFlags)));
                    return;
                }
                if ((cmdNumber == 5)) {
                    (linkFlags = llList2Integer(cmdParms,0));
                    return;
                }
                if ((cmdNumber == 6)) {
                    llMessageLinked(LINK_THIS,llList2Integer(cmdParms,0),"DANCERNAME",((key)llDumpList2String([dancerName,linkId],"|")));
                    return;
                }
                if ((cmdNumber == 8)) {
                    if ((llGetOwner() == dancerKey)) {
                        (showTimer = llList2Integer(cmdParms,0));
                        if (showTimer) llResetTime();
                    }
                    return;
                }
                if ((cmdNumber == 10)) {
                    (stopParam = 1024);
                    StopDancing();
                    (preloadList = cmdParms);
                    (preloadIndex = 1);
                    (cmdParms = [0,llList2String(preloadList,1),0]);
                    StartDancing();
                    (timerType = 2);
                    llSetTimerEvent(0.1);
                    return;
                }
                if (("ALIASES" == str)) {
                    (Define_GroupAliases = llParseString2List(((string)id),[","],[]));
                    return;
                }
            }
            if ((cmdNumber == 3)) {
                AddDancer();
                return;
            }
            if (((cmdNumber == 11) && (autoInvite && (timerType == 1)))) {
                DancerGone("DMSG002",0.0);
                return;
            }
        }
        if ((num == secondLinkId)) {
            (cmdParms = llParseString2List(str,["|"],[]));
            HandleChangeFlags();
            return;
        }
        if ((((-1) != llListFindList([0,linkId],[num])) && (str == "RESET"))) {
            if ((animStarted > 0)) {
                (stopParam = 1024);
                StopDancing();
            }
            llResetScript();
        }
    }

 run_time_permissions(integer perms) {
        (timerType = 0);
        llSetTimerEvent(0.0);
        if ((perms & PERMISSION_TRIGGER_ANIMATION)) {
            (permKey = dancerKey);
            (activeDancer = TRUE);
            (cmdParms = [0,startingDance,0]);
            StartDancing();
            if ((dancerKey != llGetOwner())) {
                (channelHandle = llListen(channelNumber,"",dancerKey,""));
            }
            OwnerSay("DMSG005",[dancerName]);
            OwnerSay(("IM001|" + ((string)dancerKey)),[channelNumber]);
            if ((dancerKey != llGetOwner())) {
                OwnerSay(("IM002|" + ((string)dancerKey)),[channelNumber]);
            }
            (k = llGetListLength(llGetAnimationList(llGetPermissionsKey())));
            if ((k >= 3)) {
                OwnerSay("DMSG009",[dancerName,k]);
                OwnerSay(("IM003|" + ((string)dancerKey)),[k]);
            }
            llMessageLinked(LINK_THIS,12123401,"ALIASES",((key)((string)linkId)));
            return;
        }
        DancerGone("DMSG002",0.0);
    }

 timer() {
        integer prevType = timerType;
        (timerType = 0);
        llSetTimerEvent(0.0);
        if ((prevType == 1)) {
            if (((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == 0)) {
                DancerGone("DMSG003",120.0);
            }
            return;
        }
        if ((prevType == 2)) {
            (++preloadIndex);
            if ((preloadIndex < llGetListLength(preloadList))) {
                (cmdParms = [0,llList2String(preloadList,preloadIndex),0]);
                StartDancing();
                (timerType = 2);
                llSetTimerEvent(0.1);
            }
            else  {
                if (llList2Integer(preloadList,0)) llMessageLinked(LINK_THIS,12123406,((string)4),((key)""));
                (preloadList = []);
                (preloadIndex = 0);
            }
        }
    }

 listen(integer channel,string name,key id,string message) {
        if (((channel == channelNumber) && (id == dancerKey))) {
            (cmdParms = llParseStringKeepNulls(message,[" "],[]));
            (i = llListFindList(["STOP"],[llToUpper(llStringTrim(llList2String(cmdParms,0),STRING_TRIM))]));
            if ((i != (-1))) {
                if ((i == 0)) {
                    (stopParam = 1024);
                    StopDancing();
                    DancerGone("DMSG004",0.0);
                }
            }
        }
    }
}
