// LSL script generated: FSLists.lslp Sun Jan 24 18:17:32 Mitteleuropäische Zeit 2016

integer adminOptions = 0;
string aoName = "<none loaded>";
integer defaultDanceDuration = 30;
integer menuLinkid = 0;
integer recordToLinkid = 0;
list tmpList = [];
string tmpStr;
integer i;
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
integer IsAdminBitSet(integer flag){
    return ((adminOptions & flag) == flag);
}
FlipAdminBit(integer flag){
    (adminOptions = (adminOptions ^ flag));
}
HandleAdminMenu(){
    integer cmd = llList2Integer(tmpList,0);
    integer j;
    if ((cmd == 103)) {
        integer linkid = llList2Integer(tmpList,2);
        (j = 0);
        if (IsAdminBitSet(1024)) {
            if (IsAdminBitSet(2048)) (j = 2);
            else  (j = 1);
        }
        (tmpList = [((("#1 Back|" + ((string)12123412)) + "|") + ((string)0)),((("#2 Sync|" + ((string)12123412)) + "|") + ((string)1)),((("#3 Add dancers|" + ((string)12123412)) + "|") + ((string)2)),((("#4 Remove dancers|" + ((string)12123412)) + "|") + ((string)3)),((("#5 Change dancer groups|" + ((string)12123412)) + "|") + ((string)4)),((("#6 Load notecard|" + ((string)12123412)) + "|") + ((string)5)),((("#7 Set wait sequence menu|" + ((string)12123412)) + "|") + ((string)6)),((("#8 Copy dances/delays|" + ((string)12123412)) + "|") + ((string)7)),((("#9 Clear menu|" + ((string)12123412)) + "|") + ((string)8)),((("#10 Set theme|" + ((string)12123412)) + "|") + ((string)9)),((("#11 Change HUD height|" + ((string)12123412)) + "|") + ((string)10)),((("#12 Change HUD width|" + ((string)12123412)) + "|") + ((string)11)),((("#13 Load all animations|" + ((string)12123412)) + "|") + ((string)25)),((("#14 Reset|" + ((string)12123412)) + "|") + ((string)13)),((("#15 Read Getting started|" + ((string)12123412)) + "|") + ((string)14)),(((" |" + ((string)12123426)) + "|") + ((string)15)),((("Settings (click to change):|" + ((string)12123426)) + "|") + ((string)15)),(((("#18 Dance selection:" + llList2String(["Manual|","All|","Random|"],j)) + ((string)12123412)) + "|") + ((string)16)),(((("#19 Default dance duration:" + llList2String(["N/A|",(((string)defaultDanceDuration) + "|"),(((string)defaultDanceDuration) + "|")],j)) + ((string)12123412)) + "|") + ((string)17)),(((("#20 Missing dance warnings:" + llList2String(["On load notecard|","While dancing|"],IsAdminBitSet(64))) + ((string)12123412)) + "|") + ((string)18)),(((("#21 Keep blank lines:" + llList2String(["No|","Yes|"],IsAdminBitSet(128))) + ((string)12123412)) + "|") + ((string)19)),(((("#22 Keep comment lines:" + llList2String(["No|","Yes|"],IsAdminBitSet(256))) + ((string)12123412)) + "|") + ((string)20)),(((("#23 Repeat sequences:" + llList2String(["Enabled|","Disabled|"],IsAdminBitSet(512))) + ((string)12123412)) + "|") + ((string)21)),(((("#24 Freestyle recording:" + llList2String(["Off|",(("On (menu " + ((string)(recordToLinkid - 305410560))) + ")|")],IsAdminBitSet(16))) + ((string)12123412)) + "|") + ((string)22)),(((("#25 Time animations:" + llList2String(["Off|","On|"],IsAdminBitSet(32))) + ((string)12123412)) + "|") + ((string)23)),((((("#26 Active menu:" + ((string)(menuLinkid - 305410560))) + "|") + ((string)12123412)) + "|") + ((string)24))]);
        (tmpStr = llDumpList2String(tmpList,"|||"));
        llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Administrative Menu",(25 + 2),0,0,12123412],"|"),((key)tmpStr));
        (tmpList = []);
        (tmpStr = "");
        return;
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 0) && (cmd <= 25))) {
            if ((cmd == 1)) llMessageLinked(LINK_THIS,12123402,((string)4),((key)""));
            if ((cmd == 2)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123413)));
                return;
            }
            if ((cmd == 3)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123414)));
                return;
            }
            if ((cmd == 4)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123415)));
                return;
            }
            if ((cmd == 5)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123416)));
                return;
            }
            if ((cmd == 18)) {
                FlipAdminBit(64);
                llMessageLinked(LINK_THIS,12123401,("MISSING|" + ((string)IsAdminBitSet(64))),((key)""));
                llMessageLinked(LINK_THIS,12123402,((string)6),((key)((string)IsAdminBitSet(64))));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 19)) {
                FlipAdminBit(128);
                llMessageLinked(LINK_THIS,12123401,("BLANK|" + ((string)IsAdminBitSet(128))),((key)""));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 20)) {
                FlipAdminBit(256);
                llMessageLinked(LINK_THIS,12123401,("COMMENT|" + ((string)IsAdminBitSet(256))),((key)""));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 21)) {
                FlipAdminBit(512);
                llMessageLinked(LINK_THIS,12123401,("COMMENT|" + ((string)IsAdminBitSet(512))),((key)""));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 16)) {
                (j = 0);
                if (IsAdminBitSet(1024)) {
                    if (IsAdminBitSet(2048)) (j = 2);
                    else  (j = 1);
                }
                (j++);
                if ((j > 2)) (j = 0);
                if ((j == 0)) {
                    FlipAdminBit(1024);
                    FlipAdminBit(2048);
                }
                else  {
                    if ((j == 1)) FlipAdminBit(1024);
                    else  FlipAdminBit(2048);
                }
                llMessageLinked(LINK_THIS,12123402,((string)8),((key)((string)IsAdminBitSet(1024))));
                llMessageLinked(LINK_THIS,12123408,((string)15),((key)((string)IsAdminBitSet(2048))));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 17)) {
                llMessageLinked(LINK_THIS,12123406,((string)2),((key)"DCMSG023"));
                return;
            }
            if ((cmd == 7)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123422)));
                return;
            }
            if ((cmd == 10)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123424)));
                return;
            }
            if ((cmd == 11)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123425)));
                return;
            }
            if ((cmd == 8)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123417)));
                return;
            }
            if ((cmd == 23)) {
                FlipAdminBit(32);
                llMessageLinked(LINK_THIS,(303181824 + 1),((string)8),((key)((string)IsAdminBitSet(32))));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 22)) {
                FlipAdminBit(16);
                (recordToLinkid = menuLinkid);
                llMessageLinked(LINK_THIS,12123408,((string)4),((key)((string)IsAdminBitSet(16))));
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 15)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if ((cmd == 13)) {
                llMessageLinked(LINK_THIS,0,"RESET",((key)""));
                return;
            }
            if ((cmd == 9)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123420)));
                return;
            }
            if ((cmd == 6)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123418)));
                return;
            }
            if ((cmd == 24)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123427)));
                return;
            }
            if ((cmd == 25)) {
                llMessageLinked(LINK_THIS,12123428,((string)6),"");
                return;
            }
            if ((cmd == 14)) {
                llGiveInventory(llGetOwner(),"~FS Readme - DanceHUD - Getting started");
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
        }
        else  OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        llMessageLinked(LINK_THIS,12123408,((string)1),((key)""));
        return;
    }
    if ((114 == cmd)) {
        (defaultDanceDuration = llList2Integer(tmpList,1));
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        return;
    }
    if ((115 == cmd)) {
        (menuLinkid = llList2Integer(tmpList,1));
        return;
    }
}
SendOneAnimationItemSequence(string name,integer linkid,integer fromLinkId){
    string s;
    (s = llDumpList2String([llDumpList2String([2,name,1,1,0],"|"),llDumpList2String([3,3000],"|"),20],"|||"));
    llMessageLinked(LINK_THIS,linkid,llDumpList2String(["SEQUENCE",name,fromLinkId],"|"),((key)s));
}
HandleInventoryAnimations(string randomParams){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetInventoryNumber(INVENTORY_ANIMATION);
    integer selected = (-1);
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex > length) || (startIndex < 0))) llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Inventory animations",length,0,1,12123411],"|"),((key)""));
        else  {
            if (((startIndex + number) > length)) (number = (length - startIndex));
            (tmpList = []);
            for ((i = 0); (i < number); (++i)) {
                (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 1))) + " ") + llGetInventoryName(INVENTORY_ANIMATION,(startIndex + i))),12123411,(startIndex + i)],"|"));
                (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
            }
            (tmpStr = llDumpList2String(tmpList,"|||"));
            llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Inventory animations",length,startIndex,1,12123411],"|"),((key)tmpStr));
            (tmpList = []);
            (tmpStr = "");
        }
        return;
    }
    if ((cmd == 51)) {
        (selected = llList2Integer(tmpList,1));
        if (((selected >= 0) && (selected < length))) {
            SendOneAnimationItemSequence(llGetInventoryName(INVENTORY_ANIMATION,selected),12123402,12123411);
            return;
        }
        OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123411)));
        return;
    }
    if ((cmd == 52)) {
        (tmpStr = llDumpList2String(llDeleteSubList(tmpList,0,0),"|"));
        if ((llGetSubString(tmpStr,0,0) == "#")) {
            string s;
            (s = llStringTrim(llGetSubString(tmpStr,1,(-1)),STRING_TRIM));
            if (((-1) != llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(s,0,0)]))) {
                (selected = (((integer)s) - 1));
            }
        }
        if ((selected == (-1))) {
            if ((INVENTORY_ANIMATION == llGetInventoryType(tmpStr))) {
                for ((cmd = 0); ((cmd < length) && (selected == (-1))); (cmd++)) {
                    if ((llGetInventoryName(INVENTORY_ANIMATION,cmd) == tmpStr)) (selected = cmd);
                }
            }
        }
        if (((selected >= 0) && (selected < length))) {
            SendOneAnimationItemSequence(llGetInventoryName(INVENTORY_ANIMATION,selected),12123402,12123411);
            return;
        }
        OwnerSay("DCMSG007",[tmpStr]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123411)));
    }
    if ((cmd == 113)) {
        (tmpList = llParseString2List(randomParams,["|"],[]));
        (selected = llList2Integer(tmpList,1));
        if (llList2Integer(tmpList,0)) (selected = ((integer)llFrand(length)));
        else  (selected++);
        if ((selected >= length)) (selected = 0);
        SendOneAnimationItemSequence(llGetInventoryName(INVENTORY_ANIMATION,selected),12123402,12123411);
        return;
    }
}
LoadNotecard(string notecard){
    if ((llGetSubString(notecard,0,2) == "~FS")) {
        OwnerSay("NCMSG033",[notecard]);
        return;
    }
    if (("~" == llGetSubString(notecard,0,0))) {
        llMessageLinked(LINK_THIS,12123409,llDumpList2String(["ZHAO_LOAD",notecard],"|"),((key)""));
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123410)));
        return;
    }
    llMessageLinked(LINK_THIS,12123408,((string)5),((key)notecard));
    llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
}
HandleInventoryNotecards(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetInventoryNumber(INVENTORY_NOTECARD);
    integer selected = (-1);
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex > length) || (startIndex < 0))) llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Load which notecard?",(length + 1),0,0,12123416],"|"),((key)""));
        else  {
            if (((startIndex + number) > (length + 1))) (number = ((length - startIndex) + 1));
            (tmpList = [llDumpList2String([(("#" + ((string)(startIndex + 1))) + " Back"),12123416,0],"|")]);
            for ((i = 0); (i < (number - 1)); (++i)) {
                (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 2))) + " ") + llGetInventoryName(INVENTORY_NOTECARD,(startIndex + i))),12123416,((startIndex + i) + 1)],"|"));
                (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
            }
            (tmpStr = llDumpList2String(tmpList,"|||"));
            llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Load which notecard?",(length + 1),startIndex,0,12123416],"|"),((key)tmpStr));
            (tmpList = []);
            (tmpStr = "");
        }
        return;
    }
    if ((cmd == 51)) {
        (selected = llList2Integer(tmpList,1));
        if (((selected >= 0) && (selected < (length + 1)))) {
            if ((selected > 0)) {
                LoadNotecard(llGetInventoryName(INVENTORY_NOTECARD,(selected - 1)));
                return;
            }
        }
        else  OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
        return;
    }
    if ((cmd == 52)) {
        (tmpStr = llStringTrim(llDumpList2String(llDeleteSubList(tmpList,0,0),"|"),STRING_TRIM));
        if ((llToUpper(tmpStr) == "BACK")) {
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
            return;
        }
        if ((llGetSubString(tmpStr,0,0) == "#")) {
            string s;
            (s = llStringTrim(llGetSubString(tmpStr,1,(-1)),STRING_TRIM));
            if (((-1) != llListFindList(["0","1","2","3","4","5","6","7","8","9"],[llGetSubString(s,0,0)]))) {
                (selected = ((integer)s));
            }
        }
        if ((selected == (-1))) {
            if ((INVENTORY_NOTECARD == llGetInventoryType(tmpStr))) {
                for ((cmd = 0); ((cmd < length) && (selected == (-1))); (cmd++)) {
                    if ((llGetInventoryName(INVENTORY_NOTECARD,cmd) == tmpStr)) (selected = cmd);
                }
            }
        }
        if (((selected >= 0) && (selected < length))) {
            LoadNotecard(llGetInventoryName(INVENTORY_NOTECARD,selected));
            return;
        }
        else  OwnerSay("DCMSG007",[tmpStr]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
    }
}
HandleAOMenu(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetListLength([1,2,3,4,5,6,7,8,9,10]);
    string s;
    if ((103 == cmd)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex >= length) || (startIndex < 0))) llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Animation Override Menu",length,0,0,12123410],"|"),((key)""));
        else  {
            if (((startIndex + number) > length)) (number = (length - startIndex));
            (tmpList = []);
            for ((i = 0); (i < number); (++i)) {
                (s = llList2String(["AO:","Next stand","Stand order:","Sit:","Sit anywhere:","Stand:","Load Notecard","Select sit","Select walk","Select ground sit"],(i + startIndex)));
                (cmd = llList2Integer([1,2,3,4,5,6,7,8,9,10],(startIndex + i)));
                if ((cmd == 1)) (s += aoName);
                if ((cmd == 3)) (s += llList2String(["Sequential","Random"],IsAdminBitSet(2)));
                if ((cmd == 4)) (s += llList2String(["Off","On"],IsAdminBitSet(1)));
                if ((cmd == 5)) (s += llList2String(["Off","On"],IsAdminBitSet(4)));
                if ((cmd == 6)) (s += llList2String(["Off","On"],IsAdminBitSet(8)));
                (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 1))) + " ") + s),12123410,cmd],"|"));
                (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
            }
            (tmpStr = llDumpList2String(tmpList,"|||"));
            llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Animation Override Menu",length,startIndex,0,12123410],"|"),((key)tmpStr));
            (tmpList = []);
            (tmpStr = "");
            return;
        }
    }
    if ((51 == cmd)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 2) && (cmd <= 10))) {
            if ((cmd == 2)) llMessageLinked(LINK_THIS,12123409,"ZHAO_NEXTSTAND",((key)""));
            if ((cmd == 3)) {
                FlipAdminBit(2);
                if (IsAdminBitSet(2)) llMessageLinked(LINK_THIS,12123409,"ZHAO_RANDOMSTANDS",((key)""));
                else  llMessageLinked(LINK_THIS,12123409,"ZHAO_SEQUENTIALSTANDS",((key)""));
            }
            if ((cmd == 4)) {
                FlipAdminBit(1);
                if (IsAdminBitSet(1)) llMessageLinked(LINK_THIS,12123409,"ZHAO_SITON",((key)""));
                else  llMessageLinked(LINK_THIS,12123409,"ZHAO_SITOFF",((key)""));
            }
            if ((cmd == 5)) {
                FlipAdminBit(5);
                if (IsAdminBitSet(4)) llMessageLinked(LINK_THIS,12123409,"ZHAO_SITANYWHERE_ON",((key)""));
                else  llMessageLinked(LINK_THIS,12123409,"ZHAO_SITANYWHERE_OFF",((key)""));
            }
            if ((cmd == 6)) {
                FlipAdminBit(8);
                if (IsAdminBitSet(8)) llMessageLinked(LINK_THIS,12123409,"ZHAO_STANDON",((key)""));
                else  llMessageLinked(LINK_THIS,12123409,"ZHAO_STANDOFF",((key)""));
            }
            if ((cmd == 7)) {
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123416)));
                return;
            }
            if ((cmd == 8)) {
                llMessageLinked(LINK_THIS,12123409,"ZHAO_SITS",((key)""));
                return;
            }
            if ((cmd == 9)) {
                llMessageLinked(LINK_THIS,12123409,"ZHAO_WALKS",((key)""));
                return;
            }
            if ((cmd == 10)) {
                llMessageLinked(LINK_THIS,12123409,"ZHAO_GROUNDSITS",((key)""));
                return;
            }
        }
        else  OwnerSay("DCMSG007",[llList2String(tmpList,1)]);
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123410)));
        return;
    }
    if ((112 == cmd)) {
        (aoName = llList2String(tmpList,1));
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123410)));
    }
}
default {

 state_entry() {
        FlipAdminBit(64);
        (menuLinkid = (305410560 + 1));
        (recordToLinkid = menuLinkid);
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if (((-1) == llListFindList([12123412,12123411,12123416,12123410,0],[num]))) {
            return;
        }
        (tmpList = llParseString2List(str,["|"],[]));
        if ((12123412 == num)) {
            HandleAdminMenu();
            return;
        }
        if ((12123411 == num)) {
            HandleInventoryAnimations(id);
            return;
        }
        if ((12123416 == num)) {
            HandleInventoryNotecards();
            return;
        }
        if ((12123410 == num)) {
            HandleAOMenu();
            return;
        }
        if (((0 == num) && (str == "RESET"))) llResetScript();
    }
}
