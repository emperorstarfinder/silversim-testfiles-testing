// LSL script generated: FSLists2.lslp Sun Jan 24 18:17:32 Mitteleuropäische Zeit 2016

list tmpList = [];
string tmpStr;
integer i;
HandleHUDVerticalSize(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetListLength([0,1,2,3,4,5,6,7,8]);
    string s;
    vector primSize;
    vector primPos;
    integer primChangePosition = 0;
    integer primChangeSize = 0;
    integer defaultMenuItem = (-1);
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex + number) > length)) (number = (length - startIndex));
        (primSize = llList2Vector(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_SIZE]),0));
        for ((i = 1); ((i < length) && (primChangeSize == 0)); (++i)) {
            (s = llGetLinkName(((length - i) + 1)));
            if (("None,HScroll" == s)) {
                (primSize = llList2Vector(llGetLinkPrimitiveParams(((length - i) + 1),[PRIM_SIZE]),0));
                (primChangeSize = llRound((primSize.z * 10000.0)));
            }
        }
        (tmpList = []);
        for ((i = 0); (i < number); (++i)) {
            (s = llList2String(["Back","▁▁▁","▂▂▂","▃▃▃","▄▄▄","▅▅▅","▆▆▆","▇▇▇","███"],(i + startIndex)));
            (cmd = llList2Integer([0,1,2,3,4,5,6,7,8],(startIndex + i)));
            (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 1))) + " ") + s),12123424,cmd],"|"));
            (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
            if ((i >= 1)) if ((llList2Integer([144,158,172,186,200,214,228,242],(i - 1)) == primChangeSize)) (defaultMenuItem = i);
        }
        (tmpStr = llDumpList2String(tmpList,"|||"));
        llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Set HUD vertical size",length,startIndex,0,12123424,defaultMenuItem],"|"),((key)tmpStr));
        (tmpList = []);
        (tmpStr = "");
        return;
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 1) && (cmd <= 8))) {
            (length = llGetNumberOfPrims());
            for ((i = 1); ((i < length) && (primChangePosition == 0)); (++i)) {
                (s = llGetLinkName(((length - i) + 1)));
                if (("MenuItem:1" == s)) {
                    (tmpList = llGetLinkPrimitiveParams(((length - i) + 1),[PRIM_SIZE,PRIM_POSITION]));
                    (primSize = llList2Vector(tmpList,0));
                    (primPos = (llList2Vector(tmpList,1) - llGetRootPosition()));
                    (primChangePosition = (llRound((primPos.z * 10000.0)) - (llRound((primSize.z * 10000.0)) / 2)));
                }
            }
            (primChangeSize = llList2Integer([144,158,172,186,200,214,228,242],(cmd - 1)));
            (primChangePosition -= (primChangeSize / 2));
            while ((i < length)) {
                (s = llGetLinkName(((length - i) + 1)));
                if (((((-1) != llSubStringIndex(s,"MenuItem")) || ((-1) != llSubStringIndex(s,"MenuText"))) || (s == "None,HScroll"))) {
                    (tmpList = llGetLinkPrimitiveParams(((length - i) + 1),[PRIM_SIZE,PRIM_POSITION]));
                    (primSize = llList2Vector(tmpList,0));
                    (primSize.z = (((float)primChangeSize) / 10000.0));
                    (primPos = (llList2Vector(tmpList,1) - llGetRootPosition()));
                    (primPos.z = (((float)primChangePosition) / 10000.0));
                    llSetLinkPrimitiveParamsFast(((length - i) + 1),[PRIM_SIZE,primSize,PRIM_POSITION,primPos]);
                    (primChangePosition -= primChangeSize);
                }
                (++i);
            }
            llMessageLinked(LINK_THIS,12123407,((string)2),((key)""));
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123424)));
            return;
        }
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
    }
}
HandleHUDHorozontalSize(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetListLength([0,1,2,3,4,5,6,7,8]);
    string s;
    float width;
    vector primSize;
    integer lookingFor;
    integer defaultMenuItem = (-1);
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex + number) > length)) (number = (length - startIndex));
        (primSize = llList2Vector(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_SIZE]),0));
        (lookingFor = llRound((primSize.y * 1000.0)));
        (tmpList = []);
        for ((i = 0); (i < number); (++i)) {
            (s = llList2String(["Back","▏","▎","▍","▌","▋","▊","▉","█"],(i + startIndex)));
            (cmd = llList2Integer([0,1,2,3,4,5,6,7,8],(startIndex + i)));
            (tmpStr = llDumpList2String([((("#" + ((string)((i + startIndex) + 1))) + " ") + s),12123425,cmd],"|"));
            (tmpList = (((tmpList = []) + tmpList) + [tmpStr]));
            if ((i >= 1)) if ((llList2Integer([184,214,246,276,308,338,370,400],(i - 1)) == lookingFor)) (defaultMenuItem = i);
        }
        (tmpStr = llDumpList2String(tmpList,"|||"));
        llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Set HUD width",length,startIndex,0,12123425,defaultMenuItem],"|"),((key)tmpStr));
        (tmpList = []);
        (tmpStr = "");
        return;
    }
    if ((cmd == 51)) {
        (cmd = llList2Integer(tmpList,1));
        if (((cmd >= 1) && (cmd <= 8))) {
            (length = llGetNumberOfPrims());
            (width = (llList2Float([184,214,246,276,308,338,370,400],(cmd - 1)) / 1000.0));
            for ((cmd = 0); (cmd < length); (++cmd)) {
                (primSize = llList2Vector(llGetLinkPrimitiveParams((cmd + 1),[PRIM_SIZE]),0));
                (primSize.y = width);
                llSetLinkPrimitiveParamsFast((cmd + 1),[PRIM_SIZE,primSize]);
            }
            llMessageLinked(LINK_THIS,12123407,((string)2),((key)""));
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123425)));
            return;
        }
        llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
    }
}
HandleThemeSetting(){
    integer cmd = llList2Integer(tmpList,0);
    integer length = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer selected = (-1);
    string s;
    vector color;
    float alpha;
    list p2;
    string primTexture;
    vector primTextColorNormal;
    vector primTextColorHighlight;
    vector primBackgroundColor;
    float primBackgroundAlpha;
    float primTextColorAlpha;
    float primTextColorHighlightAlpha;
    if ((cmd == 103)) {
        integer startIndex = llList2Integer(tmpList,1);
        integer linkid = llList2Integer(tmpList,2);
        integer number = llList2Integer(tmpList,3);
        if (((startIndex + number) > (length + 1))) (number = ((length - startIndex) + 1));
        (tmpList = [llDumpList2String(["Back",12123420,0],"|")]);
        for ((i = 0); (i < (number - 1)); (++i)) {
            (s = llDumpList2String([llGetInventoryName(INVENTORY_TEXTURE,(startIndex + i)),12123420,((startIndex + i) + 1)],"|"));
            (tmpList = (((tmpList = []) + tmpList) + [s]));
        }
        (s = llDumpList2String(tmpList,"|||"));
        llMessageLinked(LINK_THIS,linkid,llDumpList2String(["ITEMS","Select theme texture",length,startIndex,0,12123420],"|"),((key)s));
        (tmpList = []);
        return;
    }
    if ((cmd == 51)) {
        (selected = llList2Integer(tmpList,1));
        if (((selected > 0) && (selected <= length))) {
            (primTexture = llGetInventoryName(INVENTORY_TEXTURE,(selected - 1)));
            (tmpList = llParseString2List(primTexture,["/"],[]));
            (primTextColorNormal = <1.0,1.0,1.0>);
            (primTextColorHighlight = <0.0,1.0,0.0>);
            (primBackgroundColor = <0.0,0.0,0.0>);
            (primBackgroundAlpha = 1.0);
            (primTextColorAlpha = 1.0);
            (primTextColorHighlightAlpha = 1.0);
            for ((i = 1); (i < cmd); (i++)) {
                (p2 = llParseString2List(llList2String(tmpList,i),["=",","],[]));
                if ((llGetListLength(p2) >= 4)) {
                    (color.x = (llList2Float(p2,1) / 255.0));
                    (color.y = (llList2Float(p2,2) / 255.0));
                    (color.z = (llList2Float(p2,3) / 255.0));
                    (alpha = 1.0);
                    if ((llGetListLength(p2) > 4)) (alpha = (llList2Float(p2,4) / 255.0));
                    (selected = llListFindList(["B","T","H"],[llToUpper(llStringTrim(llList2String(p2,0),STRING_TRIM))]));
                    if ((selected == 0)) {
                        (primBackgroundColor = color);
                        (primBackgroundAlpha = alpha);
                    }
                    if ((selected == 1)) {
                        (primTextColorNormal = color);
                        (primTextColorAlpha = alpha);
                    }
                    if ((selected == 2)) {
                        (primTextColorHighlight = color);
                        (primTextColorHighlightAlpha = alpha);
                    }
                }
            }
            {
                string a;
                string b;
                string c;
                (a = llDumpList2String([primTextColorNormal.x,primTextColorNormal.y,primTextColorNormal.z],","));
                (b = llDumpList2String([primTextColorHighlight.x,primTextColorHighlight.y,primTextColorHighlight.z],","));
                (c = llDumpList2String([primBackgroundColor.x,primBackgroundColor.y,primBackgroundColor.z],","));
                llMessageLinked(LINK_THIS,12123408,((string)19),llDumpList2String([primTexture,a,b,c,primTextColorAlpha,primTextColorHighlightAlpha,primBackgroundAlpha],"|"));
            }
        }
        return;
    }
}
default {

 link_message(integer sender_num,integer num,string str,key id) {
        if (((-1) == llListFindList([12123424,12123425,12123420,0],[num]))) {
            return;
        }
        (tmpList = llParseString2List(str,["|"],[]));
        if ((12123424 == num)) {
            HandleHUDVerticalSize();
            return;
        }
        if ((12123425 == num)) {
            HandleHUDHorozontalSize();
            return;
        }
        if ((12123420 == num)) {
            HandleThemeSetting();
            return;
        }
        if (((0 == num) && (str == "RESET"))) llResetScript();
    }
}
