// LSL script generated: FSChat.lslp Sun Jan 24 18:17:27 Mitteleuropäische Zeit 2016

integer listenChannel = 98;
integer listenHandle = 0;
integer emergencyListenHandle = 0;
key ownerKey = NULL_KEY;
integer helpDialog = FALSE;
list fkeyCounts = [];
list loadingItems = [];
list dancerLinkids = [];
integer numDancers = 0;
integer numAnims = 0;
integer animIndex = 0;
float loadAnimsStart = 0.0;
integer i;
integer j;
list p;
string tmp;
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
DoSelect(){
    (i = ((integer)llStringTrim(llGetSubString(tmp,1,(-1)),STRING_TRIM)));
    llMessageLinked(LINK_THIS,12123408,((string)9),((key)((string)i)));
}
DoHelp(){
    (helpDialog = TRUE);
    llDialog(llGetOwner(),"How can I help?\n#1) Get HUD on screen\n#2) Show me everything\n#3) Stop everything\n#4) Reset",["#2","#3","#4","#1"],listenChannel);
    return;
}
DoHelp1(){
    llMessageLinked(LINK_THIS,12123407,((string)2),((key)""));
}
DoHelp2(){
    llOwnerSay("The chat commands are:");
    for ((i = 0); (i < llGetListLength([10,10,10,20,30,40,40,60,50,50,100,100,100,105,105,110,110,120,130,130,140,80,80,90,90,70,150,150,160,160])); (++i)) llOwnerSay((("    " + llList2String(["D","DANCE","N","DEBUG","DEFER","DEFAULTDURATION","DD","FKEY","F","GIVE","HELP","H","?","LIST","L","MENU","M","MODE","RESET","R","REMEMBER","SETDANCERS","SD","SETCHANNEL","SC","STOP","SYNC","S","WAIT","W"],i)) + llList2String([" DANCENAME or #3 - start dancing DANCENAME or dance #3"," DANCENAME or #3 - same as DANCE command"," DANCENAME or #3 - same as DANCE command"," [START|ON|STOP|OFF|PRINT|PRINTOFF|SHOW] - change debugging settings (handy for Fleur to find problems)"," - toggle deferred freestyle dance mode on or off"," # - set the default dance duration (only useful in All or Random dance selection)"," # - same as DEFAULTDURATION"," - function key command - handy for toggling between menus or scripting something (see website for more details)"," - same as FKEY command"," itemName - Give the itemName from DanceHUD inventory to all of the current dancers"," - This helpful message"," - same as HELP command"," - same as HELP command"," [ANIMATIONS|A|DANCES|D] - list all the animations or list the dance sequences of the current menu"," - same as the LIST command"," [1-10|INVENTORY|I|ADMIN|A] - set menu to user menu 1 through 10 or inventory(I or INVENTORY) or administrative(A or ADMIN)"," - same as MENU command"," [OFF|ON|DANCE|DANCING|D|AO] - set mode to off, dancing (ON,DANCE,DANCING or D) or animation override"," - Completely reset every script"," - same as RESET command"," <sequence> - handy for adding a sequence to a menu dynamically"," # - set number of possible dancers to # (need to have that many ~FS Dancer scripts in the HUD)"," - same as SETDANCERS"," # - set the chat channel for the HUD to listen to for chat commands"," - same as SETCHANNEL"," - Stop dancing and start a wait sequence (also stops AO and starts a wait sequence)"," - Synchronize all the dancers to the last major animation started"," - Same as SYNC command"," - Start a wait sequence"," - Same as WAIT command"],i)));
    llOwnerSay(("Listening for commands on channel:" + ((string)listenChannel)));
    llOwnerSay((("Listening for commands on emergency channel:" + ((string)121234)) + " (which can not be changed)"));
    llMessageLinked(LINK_THIS,12123408,((string)12),((key)""));
}
DoHelp3(){
    llMessageLinked(LINK_THIS,12123408,((string)8),((key)llDumpList2String([0,TRUE],"|")));
}
DoList(){
    integer count;
    (i = llListFindList(["ANIMATIONS","A","DANCES","D"],[llToUpper(tmp)]));
    if ((i == (-1))) {
        (i = 0);
    }
    (j = llList2Integer([1,1,2,2],i));
    if ((j == 1)) {
        (j = llGetInventoryNumber(INVENTORY_ANIMATION));
        (count = 0);
        for ((i = 0); (i < j); (++i)) {
            (tmp = llGetInventoryName(INVENTORY_ANIMATION,i));
            (count++);
            (p = (((p = []) + p) + [tmp]));
            if ((count >= 15)) {
                llOwnerSay(llDumpList2String(p,"\n"));
                (p = []);
            }
        }
        if ((count > 0)) {
            llOwnerSay(llDumpList2String(p,"\n"));
            (p = []);
        }
        llOwnerSay((((string)j) + " animations in inventory"));
    }
    else  llMessageLinked(LINK_THIS,12123408,((string)17),((key)""));
}
DoMenu(){
    (j = (-1));
    (i = ((integer)tmp));
    if (((i >= 1) && (i <= 10))) {
        (j = (305410560 + i));
    }
    else  {
        (i = llListFindList(["INVENTORY","I","ADMIN","A"],[llToUpper(tmp)]));
        if ((i != (-1))) {
            (j = llList2Integer([12123411,12123411,12123412,12123412],i));
        }
    }
    if ((j != (-1))) llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)j)));
    else  OwnerSay("CMSG002",[tmp,((string)10)]);
}
DoMode(){
    (j = llListFindList(["OFF","ON","DANCE","DANCING","D","AO"],[llToUpper(tmp)]));
    if ((j != (-1))) {
        (j = llList2Integer([0,1,1,1,1,2],j));
        llMessageLinked(LINK_THIS,12123408,((string)8),((key)llDumpList2String([j,FALSE],"|")));
    }
    else  OwnerSay("CMSG007",[tmp]);
}
ParseCommand(){
    integer cmd = (-1);
    (tmp = llList2String(p,0));
    while (((tmp == "") && (llGetListLength(p) > 0))) {
        (p = ((p = []) + llDeleteSubList(p,0,0)));
        (tmp = llList2String(p,0));
    }
    if ((llGetListLength(p) == 0)) {
        
        return;
    }
    if ((!helpDialog)) {
        (i = llListFindList(["D","DANCE","N","DEBUG","DEFER","DEFAULTDURATION","DD","FKEY","F","GIVE","HELP","H","?","LIST","L","MENU","M","MODE","RESET","R","REMEMBER","SETDANCERS","SD","SETCHANNEL","SC","STOP","SYNC","S","WAIT","W"],[llToUpper(tmp)]));
        if ((i != (-1))) {
            (cmd = llList2Integer([10,10,10,20,30,40,40,60,50,50,100,100,100,105,105,110,110,120,130,130,140,80,80,90,90,70,150,150,160,160],i));
            (p = ((p = []) + llDeleteSubList(p,0,0)));
        }
        else  {
            if ((llGetSubString(tmp,0,0) == "#")) {
                (tmp = llDumpList2String(p," "));
                DoSelect();
                return;
            }
        }
    }
    else  {
        (helpDialog = FALSE);
        (i = llListFindList(["#2","#3","#4","#1"],[llToUpper(tmp)]));
        if ((i != (-1))) (cmd = llList2Integer([1510,1520,130,1500],i));
    }
    (tmp = llStringTrim(llDumpList2String(p," "),STRING_TRIM));
    if ((cmd == 10)) {
        if ((llGetSubString(tmp,0,0) == "#")) {
            DoSelect();
        }
        else  llMessageLinked(LINK_THIS,12123408,((string)10),((key)tmp));
        return;
    }
    if ((cmd == 160)) {
        llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)12123402)));
        return;
    }
    if ((cmd == 110)) {
        DoMenu();
        return;
    }
    if ((cmd == 120)) {
        DoMode();
        return;
    }
    if ((cmd == 150)) {
        llMessageLinked(LINK_THIS,12123402,((string)4),((key)""));
        return;
    }
    if ((cmd == 50)) {
        (i = ((integer)tmp));
        if (((i < 1) || (i > 12))) {
            OwnerSay("CMSG001",[tmp,((string)12)]);
            return;
        }
        (p = llParseString2List(tmp,["|"],[]));
        (j = llList2Integer(fkeyCounts,(i - 1)));
        if (((++j) >= llGetListLength(p))) (j = 1);
        (tmp = llStringTrim(llList2String(p,j),STRING_TRIM));
        (fkeyCounts = ((fkeyCounts = []) + llListReplaceList(fkeyCounts,[j],(i - 1),(i - 1))));
        (p = llParseStringKeepNulls(tmp,[" "],[]));
        
        ParseCommand();
        return;
    }
    if ((cmd == 105)) {
        DoList();
        return;
    }
    if ((cmd == 20)) {
        (i = llListFindList(["START","ON","STOP","OFF","PRINT","PRINTOFF","SHOW"],[llToUpper(tmp)]));
        if ((i != (-1))) {
            (j = llList2Integer([2,2,3,3,4,5,6],i));
            llMessageLinked(LINK_THIS,12123404,((string)j),((key)""));
        }
        else  OwnerSay("CMSG006",["DEBUG",tmp]);
        return;
    }
    if ((cmd == 30)) {
        (i = llListFindList(["START","ON","STOP","OFF"],[llToUpper(tmp)]));
        if ((i != (-1))) {
            (j = llList2Integer([1,1,0,0],i));
            llMessageLinked(LINK_THIS,12123408,((string)11),((key)((string)j)));
        }
        else  OwnerSay("CMSG006",["DEFER",tmp]);
        return;
    }
    if ((cmd == 60)) {
        if ((INVENTORY_NONE != llGetInventoryType(tmp))) {
            if (((llGetInventoryPermMask(tmp,MASK_OWNER) & (PERM_TRANSFER | PERM_COPY)) == (PERM_TRANSFER | PERM_COPY))) llMessageLinked(LINK_THIS,(303181824 + 1),((string)9),((key)tmp));
            else  OwnerSay("DCMSG021",[tmp]);
        }
        else  OwnerSay("DCMSG020",[tmp]);
        return;
    }
    if ((cmd == 130)) {
        llOwnerSay((("Resetting " + "DanceHUD OpenSource") + "..."));
        llMessageLinked(LINK_THIS,0,"RESET",((key)""));
        llResetScript();
    }
    if ((cmd == 140)) {
        llMessageLinked(LINK_THIS,12123408,((string)14),((key)tmp));
        return;
    }
    if ((cmd == 80)) {
        (i = ((integer)tmp));
        llMessageLinked(LINK_THIS,12123428,((string)3),((key)((string)i)));
        return;
    }
    if ((cmd == 90)) {
        (i = ((integer)tmp));
        if ((i != 0)) llMessageLinked(LINK_THIS,12123428,((string)4),((key)((string)i)));
        else  OwnerSay("CMSG005",[tmp]);
        return;
    }
    if ((cmd == 40)) {
        (i = ((integer)tmp));
        if (((i > 0) && (i < 300))) {
            llMessageLinked(LINK_THIS,12123402,((string)9),((key)((string)i)));
            llMessageLinked(LINK_THIS,12123412,llDumpList2String([114,i],"|"),"");
            OwnerSay("CMSG011",[i]);
        }
        else  OwnerSay("CMSG010",[i,300]);
        return;
    }
    if ((cmd == 70)) {
        llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)12123402)));
        return;
    }
    if ((cmd == 100)) {
        DoHelp();
        return;
    }
    if ((cmd == 1500)) {
        DoHelp1();
        return;
    }
    if ((cmd == 1510)) {
        DoHelp2();
        return;
    }
    if ((cmd == 1520)) {
        DoHelp3();
        return;
    }
    llMessageLinked(LINK_THIS,12123408,((string)10),((key)tmp));
}
CompletedLoadingAnimations(string errorMsg){
    OwnerSay(errorMsg,[animIndex,numAnims,numDancers,(llGetTime() - loadAnimsStart)]);
    llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)12123402)));
    (tmp = "");
    (p = []);
    (dancerLinkids = []);
    (loadingItems = []);
    (numDancers = 0);
    (numAnims = 0);
    (animIndex = 0);
    (loadAnimsStart = 0.0);
    llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
}
PreloadAllAnimations(){
    integer listLen;
    integer startFlag = FALSE;
    string tmp2;
    if ((numAnims == 0)) {
        (numDancers = llGetListLength(dancerLinkids));
        (numAnims = llGetInventoryNumber(INVENTORY_ANIMATION));
        (animIndex = 0);
        (loadAnimsStart = llGetTime());
        if ((numAnims == 0)) {
            OwnerSay("CMSG013",["DanceHUD OpenSource"]);
            return;
        }
    }
    (loadingItems = []);
    for ((j = 0); ((j < numDancers) && (animIndex < numAnims)); (++j)) {
        (listLen = 0);
        (p = []);
        if ((animIndex < numAnims)) {
            do  {
                (tmp = llGetInventoryName(INVENTORY_ANIMATION,(animIndex++)));
                (p = (((p = []) + p) + [tmp]));
                (++listLen);
            }
            while (((animIndex < numAnims) && (listLen < 20)));
            (startFlag = TRUE);
            (tmp = llDumpList2String(p,"|"));
            llMessageLinked(LINK_THIS,llList2Integer(dancerLinkids,j),((string)10),((key)((((string)(j == 0)) + "|") + tmp)));
            if ((j < (30 - 2))) {
                (tmp = llList2String(p,0));
                (tmp2 = llList2String(p,(-1)));
                (p = []);
                if ((llStringLength(tmp) > 3)) (tmp = (llGetSubString(tmp,0,2) + "..."));
                if ((llStringLength(tmp2) > 3)) (tmp2 = (llGetSubString(tmp2,0,2) + "..."));
                (p = ["Dancer ",(j + 1),":",tmp," to ",tmp2]);
                (tmp = llDumpList2String(p,""));
                (loadingItems = (((loadingItems = []) + loadingItems) + [tmp]));
            }
        }
    }
    if (startFlag) {
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123428)));
        llSetTimerEvent(5.0);
        return;
    }
    CompletedLoadingAnimations("CMSG014");
}
HandleLoadingMenu(){
    integer cmd = llList2Integer(p,0);
    integer length = llGetListLength(loadingItems);
    if ((103 == cmd)) {
        integer linkid = llList2Integer(p,2);
        (p = []);
        for ((i = 0); (i < length); (++i)) {
            (tmp = ((((llList2String(loadingItems,i) + "|") + ((string)12123426)) + "|") + ((string)15)));
            (p = (((p = []) + p) + [tmp]));
        }
        (tmp = (((" |" + ((string)12123426)) + "|") + ((string)15)));
        (p = (((p = []) + p) + [tmp]));
        (tmp = ((("Cancel loading animations|" + ((string)12123428)) + "|") + ((string)1)));
        (p = (((p = []) + p) + [tmp]));
        (tmp = llDumpList2String(p,"|||"));
        llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Loading animations...",(length + 2),0,0,12123428],"|"),((key)tmp));
    }
    if ((51 == cmd)) {
        (cmd = llList2Integer(p,1));
        if ((cmd == 1)) {
            llSetTimerEvent(0.0);
            CompletedLoadingAnimations("CMSG015");
        }
    }
    (p = []);
    (tmp = "");
}
Initialize(){
    if ((listenHandle != 0)) llListenRemove(listenHandle);
    (listenChannel = 98);
    (ownerKey = llGetOwner());
    (listenHandle = llListen(listenChannel,"",ownerKey,""));
    if ((emergencyListenHandle != 0)) llListenRemove(emergencyListenHandle);
    (emergencyListenHandle = llListen(121234,"",ownerKey,""));
    (fkeyCounts = []);
    for ((i = 0); (i < 12); (++i)) (fkeyCounts = (((fkeyCounts = []) + fkeyCounts) + [0]));
}
default {

 state_entry() {
        Initialize();
    }

 listen(integer channel,string name,key id,string message) {
        (p = llParseStringKeepNulls(message,[" ","\t"],[]));
        if ((((-1) != llListFindList([listenChannel,121234],[channel])) && (id == ownerKey))) ParseCommand();
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if (((0 == num) && (str == "RESET"))) {
            llResetScript();
        }
        if ((num == 12123406)) {
            (i = ((integer)str));
            if ((1 == i)) {
                if ((listenHandle != 0)) llListenRemove(listenHandle);
                (listenChannel = ((integer)((string)id)));
                (listenHandle = llListen(listenChannel,"",ownerKey,""));
                OwnerSay("CMSG004",[listenChannel]);
                return;
            }
            if ((2 == i)) {
                OwnerSay(((string)id),[listenChannel]);
                return;
            }
            if ((3 == i)) {
                (dancerLinkids = llParseString2List(((string)id),["|"],[]));
                if ((llGetListLength(dancerLinkids) > 0)) PreloadAllAnimations();
                else  {
                    OwnerSay("CMSG012",[]);
                    llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                }
                return;
            }
            if ((4 == i)) {
                llSetTimerEvent(0.0);
                PreloadAllAnimations();
                return;
            }
            if ((str == "CMD")) {
                (p = llParseStringKeepNulls(id,[" ","\t"],[]));
                ParseCommand();
            }
            return;
        }
        if ((12123428 == num)) {
            (p = llParseString2List(str,["|"],[]));
            HandleLoadingMenu();
            return;
        }
    }

 timer() {
        llSetTimerEvent(0.0);
        PreloadAllAnimations();
    }
}
