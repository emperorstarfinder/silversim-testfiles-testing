// LSL script generated: FSServices.lslp Sun Jan 24 18:17:34 Mitteleuropäische Zeit 2016

key ownerKey = NULL_KEY;
integer copyFromLinkId = 0;
integer waitMenuLinkId = 0;
integer waitSequenceId = -1;
integer waitMaxSequence = -1;
integer activeMenuLinkid = 0;
integer lasttarget = 0;
list tmpList = [];
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
HandleListOfUserMenus(string name,integer forLinkid){
    integer cmd = llList2Integer(tmpList,0);
    integer length = 10;
    string s;
    integer i;
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex > length) || (startIndex < 0))) llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS",name,length,0,0,forLinkid],"|"),((key)""));
        else  {
            if (((startIndex + number) > (length + 1))) (number = ((length - startIndex) + 1));
            (tmpList = [llDumpList2String(["#1 Back",forLinkid,0],"|")]);
            for ((i = 0); (i < (number - 1)); (++i)) {
                (s = llDumpList2String([(((("#" + ((string)((i + startIndex) + 2))) + " ") + "Menu ") + ((string)(i + 1))),forLinkid,(i + 1)],"|"));
                (tmpList = (((tmpList = []) + tmpList) + [s]));
            }
            (s = llDumpList2String(tmpList,"|||"));
            integer selectedItem = 0;
            if (((waitMenuLinkId != 0) && (12123418 == forLinkid))) (selectedItem = (waitMenuLinkId - 305410560));
            if (((activeMenuLinkid != 0) && (12123427 == forLinkid))) (selectedItem = (activeMenuLinkid - 305410560));
            if ((selectedItem == 0)) llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS",name,(length + 1),startIndex,0,forLinkid],"|"),((key)s));
            else  llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS",name,(length + 1),startIndex,0,forLinkid,selectedItem],"|"),((key)s));
            (tmpList = []);
            (s = "");
            return;
        }
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 0) && (cmd <= length))) {
            if ((cmd > 0)) {
                if ((12123417 == forLinkid)) llMessageLinked(LINK_THIS,(305410560 + cmd),((string)107),((key)""));
                if ((12123418 == forLinkid)) {
                    (waitMenuLinkId = (305410560 + cmd));
                    (waitSequenceId = (-1));
                    (waitMaxSequence = (-1));
                    llMessageLinked(LINK_THIS,waitMenuLinkId,llDumpList2String([103,(-1),12123418,10000],"|"),((key)""));
                }
                if ((12123422 == forLinkid)) {
                    (copyFromLinkId = (305410560 + cmd));
                    llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123423)));
                    return;
                }
                if ((12123423 == forLinkid)) {
                    if (((305410560 + cmd) == copyFromLinkId)) {
                        OwnerSay("MMSG009",[(copyFromLinkId - 305410560),cmd]);
                        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123423)));
                        return;
                    }
                    llMessageLinked(LINK_THIS,copyFromLinkId,((string)109),((key)((string)(305410560 + cmd))));
                    llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                    return;
                }
                if ((12123427 == forLinkid)) {
                    (i = (305410560 + cmd));
                    llMessageLinked(LINK_THIS,12123408,((string)18),((key)((string)i)));
                    llMessageLinked(LINK_THIS,12123412,llDumpList2String([115,i],"|"),"");
                    (activeMenuLinkid = i);
                    llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                    return;
                }
            }
            else  llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        }
        else  {
            OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        }
        return;
    }
    if (((forLinkid == 12123418) && (llList2String(tmpList,0) == "ITEMS"))) {
        (s = llList2String(tmpList,1));
        if ((llList2Integer(tmpList,2) > 0)) {
            (waitSequenceId = 0);
            (waitMaxSequence = llList2Integer(tmpList,2));
            OwnerSay("WMSG002",[s,waitMaxSequence]);
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
            return;
        }
        (waitMenuLinkId = 0);
        OwnerSay("WMSG001",[s,"stand_1"]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
    }
}
RecenterHUD(integer forceRecenter){
    integer i;
    integer target = llGetAttached();
    if (((target == lasttarget) && (!forceRecenter))) return;
    if ((0 == target)) {
        OwnerSay("MMSG010",["DanceHUD OpenSource",llGetObjectName()]);
        return;
    }
    (lasttarget = target);
    integer targetIndex = llListFindList([35,31,34,33,32,36,37,38],[target]);
    if ((targetIndex == (-1))) return;
    float bottomLocation = 0.0;
    float primWidth = 0.0;
    list tmpList;
    vector primLocation;
    for ((i = 1); ((i < llGetNumberOfPrims()) && (bottomLocation == 0.0)); (++i)) {
        if (("None,HScroll" == llGetLinkName((i + 1)))) {
            (tmpList = llGetLinkPrimitiveParams((i + 1),[PRIM_SIZE,PRIM_POSITION]));
            (primLocation = llList2Vector(tmpList,1));
            (primLocation = (primLocation - llGetRootPosition()));
            (bottomLocation = primLocation.z);
            (primLocation = llList2Vector(tmpList,0));
            (bottomLocation = (bottomLocation - primLocation.z));
            (primWidth = (primLocation.y / 2));
        }
    }
    if ((bottomLocation < 0.0)) (bottomLocation = (-bottomLocation));
    (bottomLocation += 2.5e-2);
    float Y = llList2Float([(1 - (primWidth * 2)),((-1) + (primWidth * 2)),(-primWidth),0.0,primWidth,(-primWidth),0.0,primWidth],targetIndex);
    float Z = llList2Float([(bottomLocation / 2),(bottomLocation / 2),(-4.5e-2),(-2.5e-2),(-2.5e-2),bottomLocation,bottomLocation,bottomLocation],targetIndex);
    vector newtarget = <0.0,Y,Z>;
    llSetPos(newtarget);
}
default {

 state_entry() {
        (ownerKey = llGetOwner());
        llOwnerSay((((("Fleursoft" + " ") + "DanceHUD OpenSource") + " revision:") + "1.3"));
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if (((-1) == llListFindList([12123417,12123418,12123422,12123423,12123407,12123427,0],[num]))) {
            return;
        }
        (tmpList = llParseString2List(str,["|"],[]));
        if ((12123417 == num)) {
            HandleListOfUserMenus("Select menu to clear",12123417);
            return;
        }
        if ((12123418 == num)) {
            HandleListOfUserMenus("Select wait sequence menu",12123418);
            return;
        }
        if ((12123422 == num)) {
            HandleListOfUserMenus("Copy dances/times from menu",12123422);
            return;
        }
        if ((12123423 == num)) {
            HandleListOfUserMenus("Copy dances/times to menu",12123423);
            return;
        }
        if ((12123427 == num)) {
            HandleListOfUserMenus("Select menu",12123427);
            return;
        }
        if ((num == 12123407)) {
            integer i = ((integer)str);
            if ((1 == i)) {
                if (((waitMenuLinkId > 0) && (waitSequenceId != (-1)))) {
                    llMessageLinked(LINK_THIS,waitMenuLinkId,llDumpList2String([51,waitSequenceId],"|"),((key)((string)2)));
                    (waitSequenceId++);
                    if ((waitSequenceId >= waitMaxSequence)) (waitSequenceId = 0);
                }
                else  {
                    string s;
                    (s = llDumpList2String([llDumpList2String([2,"stand_1",1,1,0],"|"),llDumpList2String([3,3000],"|"),20],"|||"));
                    llMessageLinked(LINK_THIS,12123402,llDumpList2String(["WAITSEQ","Default wait",12123411],"|"),((key)s));
                }
                return;
            }
            if ((2 == i)) {
                RecenterHUD(TRUE);
                return;
            }
            if ((3 == i)) {
                (activeMenuLinkid = ((integer)((string)id)));
                return;
            }
        }
        if (((0 == num) && (str == "RESET"))) {
            llResetScript();
        }
    }

 attach(key attached) {
        if ((attached != NULL_KEY)) {
            if ((ownerKey != llGetOwner())) llMessageLinked(LINK_THIS,0,"RESET",((key)""));
            RecenterHUD(FALSE);
        }
    }

 on_rez(integer r) {
        if ((ownerKey != llGetOwner())) llMessageLinked(LINK_THIS,0,"RESET",((key)""));
    }
}
