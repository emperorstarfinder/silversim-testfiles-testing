// LSL script generated: FSUI.lslp Sun Jan 24 18:17:35 Mitteleuropäische Zeit 2016

list menuStartItem = [0,0,0,0,0,0,0,0,0,0,0];
integer activeMenuIndex = -1;
integer menuNumberOfEntries = 0;
integer startingMenuItem = 0;
integer menuLength = 0;
integer menuLinkId = 0;
list menuItems = [];
list menuParams = [];
list menuSequences = [];
string menuName = "";
integer constrainedMenu = 0;
integer highlightMe = -2;
integer highlightLinkid = -2;
integer tempHighlight = -2;
string highlightName = "";
integer prevUserMenuLinkId = -1;
integer UIflags = 0;
integer verticalSize = 0;
integer primMeUp = TRUE;
integer mode = 0;
integer deferredMode = FALSE;
integer clickStartedOnWhichLink = -1;
integer autoInvite = FALSE;
vector primColorWhite = <1.0,1.0,1.0>;
vector primBackgroundColor = <0.0,0.0,0.0>;
vector primTextColorNormal = <1.0,1.0,1.0>;
vector primTextColorHighlight = <0.0,1.0,0.0>;
float primBackgroundAlpha = 1.0;
float primTextColorAlpha = 1.0;
float primTextColorHighlightAlpha = 1.0;
float primBackAlphaLevel = 0.0;
integer primPrevMenuIndex = -1;
string primTexture = "~FS Theme Basic";
list primMoreButtonsOffsets = ["0.5,0.025,0.25,0.485","0.5,0.025,0.25,0.460"];
integer i = 0;
list p = [];
list p2 = [];
OwnerSay(string msg,list params){
    llMessageLinked(LINK_THIS,12123405,msg,((key)llDumpList2String(params,"|")));
}
SetPrimText(integer index,string data){
    integer z = llList2Integer([32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3],index);
    llSetLinkPrimitiveParamsFast(z,[PRIM_TEXT,data,primTextColorNormal,primTextColorAlpha]);
}
SetPrimMenuItem(integer index){
    integer z = llList2Integer([32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3],index);
    string z2 = llList2String(menuItems,index);
    llSetLinkPrimitiveParamsFast(z,[PRIM_TEXT,z2,primTextColorNormal,primTextColorAlpha]);
}
SetPrimMenuItemHL(integer index){
    integer z = llList2Integer([32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3],index);
    string z2 = llList2String(menuItems,index);
    llSetLinkPrimitiveParamsFast(z,[PRIM_TEXT,z2,primTextColorHighlight,primTextColorHighlightAlpha]);
}
string GetPrimMenuOffsets(integer i5){
    return llList2String(["0.5,0.050,0.75,0.47","0.5,0.050,0.75,0.407","0.5,0.050,0.75,0.345","0.5,0.050,0.75,0.282","0.5,0.050,0.75,0.220","0.5,0.050,0.75,0.157","0.5,0.050,0.75,0.095","0.5,0.050,0.75,0.0325","0.5,0.050,0.75,-0.03","0.5,0.050,0.75,-0.093","0.5,0.050,0.75,-0.155","0.5,0.050,0.75,-0.218","0.5,0.050,0.75,-0.28"],i5);
}
string GetPrimModeOffsets(integer i5){
    return llList2String(["0.5,0.025,0.75,-0.328","0.5,0.025,0.75,-0.359","0.5,0.025,0.75,-0.391"],i5);
}
SetInitialMessage(){
    llSetLinkPrimitiveParamsFast(33,[PRIM_TEXT,"",primTextColorNormal,primTextColorAlpha]);
    SetPrimText(0,"Hi! Welcome to the");
    SetPrimText(1,"Fleursoft DanceHUD!");
    SetPrimText(2,"");
    SetPrimText(3,"Quick directions:");
    SetPrimText(4,"Off - means off or stop");
    SetPrimText(5,"Dance - Dancing mode");
    SetPrimText(6,"AO - ZHAO II AO mode");
    SetPrimText(7,"");
    SetPrimText(8,"Menus 1-10 are your menus");
    SetPrimText(9,"where you can load notecards");
    SetPrimText(10,"of dance sequences.");
    SetPrimText(11,"");
    SetPrimText(12,"I is the inventory menu");
    SetPrimText(13,"shows you the animations in");
    SetPrimText(14,"the inventory of the DanceHUD");
    SetPrimText(15,"");
    SetPrimText(16,"A is the administrative");
    SetPrimText(17,"menu - for things like");
    SetPrimText(18,"adding dancers and lots more.");
    SetPrimText(19,"");
    SetPrimText(20,"The bottom buttons are:");
    SetPrimText(21,"|◀◀ top of current menu");
    SetPrimText(22,"◀◀ scroll up current menu");
    SetPrimText(23,"| middle of current menu");
    SetPrimText(24,"▶▶ scroll down current menu");
    SetPrimText(25,"▶▶| bottom of current menu");
    SetPrimText(26,"◼ stop dancing and start");
    SetPrimText(27,"a wait sequence");
    SetPrimText(28,"");
    SetPrimText(29,"Click the top for a helpful website");
}
DisplayMenu(){
    if (primMeUp) {
        if ((activeMenuIndex != primPrevMenuIndex)) {
            (p = llParseString2List(GetPrimMenuOffsets(activeMenuIndex),[","],[]));
            llSetLinkPrimitiveParamsFast(36,[PRIM_TEXTURE,4,primTexture,<llList2Float(p,0),llList2Float(p,1),0.0>,<llList2Float(p,2),llList2Float(p,3),0.0>,0]);
            (primPrevMenuIndex = activeMenuIndex);
        }
        llSetLinkPrimitiveParamsFast(33,[PRIM_TEXT,menuName,primTextColorNormal,primTextColorAlpha]);
        for ((i = 0); (i < menuLength); (++i)) SetPrimMenuItem(i);
        if ((highlightLinkid == menuLinkId)) {
            if (((-2) == highlightMe)) {
                (i = llListFindList(menuSequences,[highlightName]));
                if ((i != (-1))) (highlightMe = (i + startingMenuItem));
            }
            if (((-2) != highlightMe)) SetPrimMenuItemHL((highlightMe - startingMenuItem));
        }
        if ((tempHighlight != (-2))) SetPrimMenuItemHL((tempHighlight - startingMenuItem));
        for ((i = menuLength); (i < 30); (++i)) SetPrimText(i,"");
        return;
    }
    if (((menuLinkId & 2147483392) == 305410560)) llOwnerSay(((("Menu:" + ((string)(menuLinkId - 305410560))) + "  ") + menuName));
    else  llOwnerSay(("Menu:" + menuName));
    for ((i = 0); (i < menuLength); (++i)) llOwnerSay(llList2String(menuItems,i));
    llOwnerSay("What would you like to do?");
    
}
ScrollMenu(integer scrollDirection){
    if ((2 == scrollDirection)) {
        if ((startingMenuItem >= 30)) (startingMenuItem -= 30);
        else  {
            if ((startingMenuItem == 0)) (startingMenuItem = (menuNumberOfEntries - 30));
            else  (startingMenuItem = 0);
        }
    }
    if ((1 == scrollDirection)) {
        if (((startingMenuItem + 30) < menuNumberOfEntries)) (startingMenuItem += 30);
        else  (startingMenuItem = 0);
    }
    if ((3 == scrollDirection)) {
        (startingMenuItem = 0);
    }
    if ((4 == scrollDirection)) {
        if ((menuNumberOfEntries > 30)) (startingMenuItem = (menuNumberOfEntries - 30));
        else  (startingMenuItem = 0);
    }
    if ((5 == scrollDirection)) {
        if ((menuNumberOfEntries > 30)) (startingMenuItem = ((menuNumberOfEntries - 30) / 2));
        else  (startingMenuItem = 0);
    }
    (i = (-1));
    if (((menuLinkId & 2147483392) == 305410560)) (i = (activeMenuIndex - 1));
    else  {
        if ((12123411 == menuLinkId)) (i = 10);
    }
    if ((i != (-1))) (menuStartItem = ((menuStartItem = []) + llListReplaceList(menuStartItem,[startingMenuItem],i,i)));
    llMessageLinked(LINK_THIS,menuLinkId,llDumpList2String([103,startingMenuItem,12123408,30],"|"),((key)""));
}
GoToMenu(integer menulink){
    (i = (-1));
    if (((menulink & 2147483392) == 305410560)) (i = (menulink - 305410560));
    if ((12123411 == menulink)) (i = 10);
    if ((i != (-1))) (i = llList2Integer(menuStartItem,i));
    else  (i = 0);
    llMessageLinked(LINK_THIS,menulink,llDumpList2String([103,i,12123408,30],"|"),((key)""));
}
StopAllDancing(integer stopAllFlag){
    llMessageLinked(LINK_THIS,12123402,((string)1),((key)((string)stopAllFlag)));
    if (((-2) != highlightMe)) {
        if (primMeUp) SetPrimMenuItem((highlightMe - startingMenuItem));
    }
    (highlightMe = (-2));
    (highlightLinkid = (-2));
    (highlightName = "");
}
DoSetMode(integer setMode,integer getWaitSequenceToo,integer superStop){
    integer gotoThisMenu = (-1);
    if (((setMode == mode) && (!superStop))) {
        
        if ((mode == 2)) GoToMenu(12123410);
        return;
    }
    if (((2 == mode) || superStop)) {
        llMessageLinked(LINK_THIS,12123409,"ZHAO_AOOFF",((key)""));
        (i = 12123411);
        if (((-1) != prevUserMenuLinkId)) (i = prevUserMenuLinkId);
        (gotoThisMenu = i);
    }
    if (((1 == mode) || superStop)) StopAllDancing(TRUE);
    if ((2 == setMode)) {
        llMessageLinked(LINK_THIS,12123409,"ZHAO_AOON",((key)""));
        (gotoThisMenu = 12123410);
    }
    if ((1 == setMode)) {
        key owner = llGetOwner();
        if (getWaitSequenceToo) llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)12123402)));
        llMessageLinked(LINK_THIS,12123428,((string)1),((key)llDumpList2String([llKey2Name(owner),owner],"|")));
    }
    (mode = setMode);
    if (primMeUp) {
        (p = llParseString2List(GetPrimModeOffsets(mode),[","],[]));
        llSetLinkPrimitiveParamsFast(38,[PRIM_TEXTURE,4,primTexture,<llList2Float(p,0),llList2Float(p,1),0.0>,<llList2Float(p,2),llList2Float(p,3),0.0>,0]);
        
    }
    if ((gotoThisMenu != (-1))) GoToMenu(gotoThisMenu);
}
DrawTexture(integer link,string coords,integer face){
    (p = llParseString2List(coords,[","],[]));
    llSetLinkPrimitiveParamsFast(link,[PRIM_COLOR,face,primColorWhite,1.0,PRIM_COLOR,2,primBackgroundColor,primBackAlphaLevel,PRIM_TEXTURE,face,primTexture,<llList2Float(p,0),llList2Float(p,1),0.0>,<llList2Float(p,2),llList2Float(p,3),0.0>,0]);
}
RepaintPrims(){
    integer numberPrims = llGetNumberOfPrims();
    string s;
    DrawTexture(LINK_ROOT,"0.5,0.025,0.75,-0.454",4);
    llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_COLOR,0,primColorWhite,1.0,PRIM_TEXTURE,0,primTexture,<0.5,2.5e-2,0.0>,<0.75,(-0.454),0.0>,(-PI_BY_TWO)]);
    for ((i = 1); (i < numberPrims); (++i)) {
        (s = llGetLinkName((i + 1)));
        (p = llParseString2List(s,[",",":"],[]));
        if (((-1) != llListFindList(p,["Scroll"]))) DrawTexture((i + 1),"0.5,0.025,0.75,-0.422",4);
        else  {
            if (((-1) != llListFindList(p,["Numbers"]))) DrawTexture((i + 1),GetPrimMenuOffsets(0),4);
            else  {
                if (((-1) != llListFindList(p,["Mode"]))) DrawTexture((i + 1),GetPrimModeOffsets(0),4);
                else  {
                    if (((-1) != llListFindList(p,["Half"]))) {
                        DrawTexture((i + 1),llList2String(primMoreButtonsOffsets,autoInvite),4);
                    }
                    else  llSetLinkPrimitiveParamsFast((i + 1),[PRIM_FULLBRIGHT,ALL_SIDES,FALSE,PRIM_COLOR,ALL_SIDES,primBackgroundColor,0.0,PRIM_COLOR,4,primBackgroundColor,primBackgroundAlpha,PRIM_COLOR,2,primBackgroundColor,primBackAlphaLevel]);
                }
            }
        }
    }
}
SearchForVerticalPrimSize(){
    vector primSize;
    integer searchForMe;
    (primSize = llList2Vector(llGetLinkPrimitiveParams(29,[PRIM_SIZE]),0));
    (searchForMe = llRound((primSize.z * 10000.0)));
    (verticalSize = llListFindList([144,158,172,186,200,214,228,242],[searchForMe]));
    if ((verticalSize == (-1))) (verticalSize = 0);
}
SendSelectMessage(integer p1,integer p2){
    if (deferredMode) llMessageLinked(LINK_THIS,p1,llDumpList2String([51,p2],"|"),((key)((string)1)));
    else  llMessageLinked(LINK_THIS,p1,llDumpList2String([51,p2],"|"),((key)((string)0)));
}
default {

 state_entry() {
        SearchForVerticalPrimSize();
        DoSetMode(0,FALSE,FALSE);
        (prevUserMenuLinkId = (305410560 + 1));
    }

 touch_start(integer count) {
        integer link = llDetectedLinkNumber(0);
        llResetTime();
        (clickStartedOnWhichLink = (-1));
        if ((38 == link)) (clickStartedOnWhichLink = link);
        if (((-1) != llListFindList([2,3,4],[link]))) (clickStartedOnWhichLink = link);
    }

 touch_end(integer count) {
        integer link = llDetectedLinkNumber(0);
        vector clicked = llDetectedTouchST(0);
        integer danceMenu;
        integer duration = llFloor(llGetAndResetTime());
        integer menuItemClicked = FALSE;
        (i = llListFindList([34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5],[link]));
        if (((-1) != i)) {
            if ((llFloor((clicked.y * 100)) > llList2Integer([68,56,55,46,40,36,24,24],verticalSize))) {
                (i--);
                if ((i == (-1))) (i = 0);
            }
            (menuItemClicked = TRUE);
        }
        if ((link == 4)) {
            if ((llFloor((clicked.y * 100)) > llList2Integer([68,56,55,46,40,36,24,24],verticalSize))) {
                (i = 0);
                (menuItemClicked = TRUE);
            }
        }
        if (menuItemClicked) {
            if ((i >= menuLength)) return;
            (danceMenu = (((menuLinkId & 2147483392) == 305410560) || (12123411 == menuLinkId)));
            if (((mode != 1) && danceMenu)) DoSetMode(1,FALSE,FALSE);
            if ((((llFloor((clicked.x * 10)) == 9) && (mode == 1)) && (i == (highlightMe - startingMenuItem)))) {
                llMessageLinked(LINK_THIS,12123402,((string)4),((key)""));
                return;
            }
            (p = llParseString2List(llList2String(menuParams,i),["|"],[]));
            SendSelectMessage(llList2Integer(p,0),llList2Integer(p,1));
            return;
        }
        if (((-1) != llListFindList([2,3,4],[link]))) {
            (link = llList2Integer([3,2,5,1,4,6],llFloor((clicked.x * 6))));
            if ((6 != link)) ScrollMenu(link);
            else  {
                if ((mode != 1)) DoSetMode(1,FALSE,FALSE);
                if (((clickStartedOnWhichLink != (-1)) && (duration >= 1))) StopAllDancing(FALSE);
                else  llMessageLinked(LINK_THIS,12123407,((string)1),((key)((string)12123402)));
            }
            return;
        }
        if ((36 == link)) {
            (i = llFloor((clicked.x * 12)));
            GoToMenu(llList2Integer([(-1),305410561,305410562,305410563,305410564,305410565,305410566,305410567,305410568,305410569,305410570,12123411,12123412],(i + 1)));
            return;
        }
        if ((38 == link)) {
            integer superStop = FALSE;
            (danceMenu = llFloor((clicked.x * 3)));
            if ((((danceMenu == 0) && (clickStartedOnWhichLink == link)) && (duration >= 1))) {
                OwnerSay("CMSG009",[]);
                (superStop = TRUE);
            }
            DoSetMode(llList2Integer([0,1,2],danceMenu),TRUE,superStop);
            if ((((danceMenu == 1) && (clickStartedOnWhichLink == link)) && (duration >= 1))) {
                (deferredMode = (deferredMode ^ TRUE));
                OwnerSay("CMSG008",[llList2String(["Off","On"],deferredMode)]);
            }
            return;
        }
        if ((37 == link)) {
            (danceMenu = llFloor((clicked.x * 12)));
            if ((danceMenu == 11)) {
                if (autoInvite) {
                    OwnerSay("CMSG017",[]);
                    (autoInvite = FALSE);
                }
                else  {
                    OwnerSay("CMSG016",[50.0]);
                    (autoInvite = TRUE);
                }
                (p = llParseString2List(llList2String(primMoreButtonsOffsets,autoInvite),[","],[]));
                llSetLinkPrimitiveParamsFast(37,[PRIM_TEXTURE,4,primTexture,<llList2Float(p,0),llList2Float(p,1),0.0>,<llList2Float(p,2),llList2Float(p,3),0.0>,0]);
                llMessageLinked(LINK_THIS,12123428,((string)7),((key)((string)autoInvite)));
            }
            return;
        }
        if ((LINK_ROOT == link)) {
            if (primMeUp) {
                if ((llFloor((clicked.x * 10)) < 9)) llLoadURL(llDetectedKey(0),((("Fleursoft" + " ") + "DanceHUD OpenSource") + " documentation"),"http://fleursoft.com/");
                else  {
                    if (primMeUp) {
                        vector eul = <0,(-90),0>;
                        (eul *= DEG_TO_RAD);
                        rotation quat = llEuler2Rot(eul);
                        llSetPrimitiveParams([PRIM_ROTATION,quat]);
                        llSetLinkPrimitiveParamsFast(33,[PRIM_TEXT,"",primTextColorNormal,primTextColorAlpha]);
                        for ((i = 0); (i < 30); (++i)) SetPrimText(i,"");
                        (primMeUp = FALSE);
                    }
                }
            }
            else  {
                vector eul = <0,0,0>;
                (eul *= DEG_TO_RAD);
                rotation quat = llEuler2Rot(eul);
                llSetPrimitiveParams([PRIM_ROTATION,quat]);
                (primMeUp = TRUE);
                DisplayMenu();
            }
            return;
        }
        return;
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if (((-1) == llListFindList([12123408,0],[num]))) {
            return;
        }
        if ((12123408 == num)) {
            integer cmd = ((integer)str);
            (p = llParseString2List(str,["|"],[]));
            if (("ITEMS" == llList2String(p,0))) {
                string s;
                (menuName = llList2String(p,1));
                (menuNumberOfEntries = llList2Integer(p,2));
                (startingMenuItem = llList2Integer(p,3));
                (constrainedMenu = llList2Integer(p,4));
                (menuLinkId = llList2Integer(p,5));
                (tempHighlight = (-2));
                if ((llGetListLength(p) > 6)) (tempHighlight = llList2Integer(p,6));
                if (((menuLinkId & 2147483392) == 305410560)) {
                    (prevUserMenuLinkId = menuLinkId);
                    llMessageLinked(LINK_THIS,12123412,llDumpList2String([115,menuLinkId],"|"),"");
                    llMessageLinked(LINK_THIS,12123407,((string)3),((key)((string)menuLinkId)));
                }
                (p = llParseString2List(((string)id),["|||"],[]));
                (menuLength = llGetListLength(p));
                (menuItems = []);
                (menuParams = []);
                (menuSequences = []);
                for ((i = 0); (i < menuLength); (i++)) {
                    (p2 = llParseString2List(llList2String(p,i),["|"],[]));
                    (s = llList2String(p2,0));
                    (menuItems = (((menuItems = []) + menuItems) + [s]));
                    (menuParams = (((menuParams = []) + menuParams) + [llDumpList2String(((p2 = []) + llDeleteSubList(p2,0,0)),"|")]));
                    if ((llList2Integer(p2,1) != 12123426)) {
                        integer j;
                        (j = llSubStringIndex(s," "));
                        if (((llGetSubString(s,0,0) == "#") && (j != (-1)))) {
                            (menuSequences = (((menuSequences = []) + menuSequences) + [llGetSubString(s,(j + 1),(-1))]));
                        }
                        else  (menuSequences = (((menuSequences = []) + menuSequences) + ["|"]));
                    }
                    else  (menuSequences = (((menuSequences = []) + menuSequences) + ["|"]));
                }
                (p = []);
                (p2 = []);
                (activeMenuIndex = llListFindList([(-1),305410561,305410562,305410563,305410564,305410565,305410566,305410567,305410568,305410569,305410570,12123411,12123412],[menuLinkId]));
                if (((-1) == activeMenuIndex)) {
                    if ((1 == mode)) (activeMenuIndex = 12);
                    else  (activeMenuIndex = 0);
                }
                if ((((-1) == activeMenuIndex) && ((-1) != llListFindList([121234401,121234402,121234403,121234404,121234405,121234406,121234407,121234408,121234409,121234410,12123413,12123414,12123415,12123416,12123417,12123418,12123420,12123421,12123424,12123425,12123427],[menuLinkId])))) (activeMenuIndex = 12);
                (highlightMe = (-2));
                DisplayMenu();
                return;
            }
            if ((9 == cmd)) {
                integer itemNumber = 0;
                integer maxRange = menuNumberOfEntries;
                (i = ((integer)((string)id)));
                if ((constrainedMenu == 0)) {
                    (itemNumber = (i - 1));
                    (maxRange = menuLength);
                }
                if (((i >= 1) && (i <= maxRange))) {
                    (p = llParseString2List(llList2String(menuParams,itemNumber),["|"],[]));
                    SendSelectMessage(llList2Integer(p,0),llList2Integer([llList2Integer(p,1),(i - 1)],constrainedMenu));
                }
                else  OwnerSay("CMSG003",[((string)id)]);
                return;
            }
            if ((10 == cmd)) {
                (i = llListFindList(menuItems,[((string)id)]));
                if (((-1) != i)) {
                    (p = llParseString2List(llList2String(menuParams,i),["|"],[]));
                    SendSelectMessage(llList2Integer(p,0),llList2Integer(p,1));
                }
                else  {
                    if ((constrainedMenu == 0)) OwnerSay("CMSG003",[((string)id)]);
                    else  {
                        (p = llParseString2List(llList2String(menuParams,0),["|"],[]));
                        if ((INVENTORY_ANIMATION == llGetInventoryType(((string)id)))) {
                            llMessageLinked(LINK_THIS,12123411,llDumpList2String([52,((string)id)],"|"),((key)((string)0)));
                            return;
                        }
                        llMessageLinked(LINK_THIS,305410560,llDumpList2String([52,((string)id)],"|"),((key)((string)0)));
                    }
                }
                return;
            }
            if ((3 == cmd)) {
                (p = llParseString2List(((string)id),["|"],[]));
                (i = llList2Integer(p,1));
                (highlightName = llList2String(p,0));
                if (((-2) != highlightMe)) {
                    if (primMeUp) SetPrimMenuItem((highlightMe - startingMenuItem));
                }
                (highlightMe = (-2));
                (highlightLinkid = i);
                if ((menuLinkId == i)) {
                    (i = llListFindList(menuSequences,[highlightName]));
                    if (((-1) != i)) {
                        if (primMeUp) SetPrimMenuItemHL(i);
                        (highlightMe = (i + startingMenuItem));
                    }
                }
            }
            if ((2 == cmd)) {
                GoToMenu(((integer)((string)id)));
                return;
            }
            if ((1 == cmd)) {
                llMessageLinked(LINK_THIS,prevUserMenuLinkId,llDumpList2String([103,llList2Integer(menuStartItem,(prevUserMenuLinkId - 305410560)),12123408,30],"|"),((key)""));
                return;
            }
            if ((4 == cmd)) {
                (cmd = ((integer)((string)id)));
                if (cmd) (UIflags = (((268435455 ^ 1) & UIflags) ^ 1));
                else  (UIflags = ((268435455 ^ 1) & UIflags));
                llMessageLinked(LINK_THIS,12123402,((string)3),((key)llDumpList2String([prevUserMenuLinkId,cmd],"|")));
                
                return;
            }
            if ((15 == cmd)) {
                (cmd = ((integer)((string)id)));
                if (cmd) (UIflags = (((268435455 ^ 2) & UIflags) ^ 2));
                else  (UIflags = ((268435455 ^ 2) & UIflags));
                return;
            }
            if ((16 == cmd)) {
                (i = 0);
                if ((UIflags & 2)) (i = 1);
                if ((12123411 == menuLinkId)) llMessageLinked(LINK_THIS,menuLinkId,((string)113),llDumpList2String([i,highlightMe],"|"));
                else  llMessageLinked(LINK_THIS,prevUserMenuLinkId,((string)113),llDumpList2String([i,highlightMe],"|"));
                return;
            }
            if ((8 == cmd)) {
                (p = llParseString2List(id,["|"],[]));
                DoSetMode(llList2Integer(p,0),TRUE,llList2Integer(p,1));
                return;
            }
            if ((5 == cmd)) {
                llMessageLinked(LINK_THIS,12123401,llDumpList2String(["LOAD",((string)id),prevUserMenuLinkId],"|"),((key)""));
                return;
            }
            if ((14 == cmd)) {
                llMessageLinked(LINK_THIS,12123401,llDumpList2String(["REMEMBER",prevUserMenuLinkId],"|"),((key)id));
                return;
            }
            if ((17 == cmd)) {
                llMessageLinked(LINK_THIS,prevUserMenuLinkId,((string)105),"");
                return;
            }
            if ((7 == cmd)) {
                ScrollMenu(((integer)((string)id)));
                return;
            }
            if ((11 == cmd)) {
                (deferredMode = (deferredMode ^ TRUE));
                OwnerSay("CMSG008",[llList2String(["Off","On"],deferredMode)]);
                return;
            }
            if ((12 == cmd)) {
                llOwnerSay(((("Currently displaying menu:" + menuName) + " and the menu is ") + llList2String(["minimized","showing"],primMeUp)));
                llOwnerSay(("Mode is set to:" + llList2String(["Off","Dance","AO"],mode)));
                llOwnerSay(("Deferred freestyle dancing is:" + llList2String(["Off","On"],deferredMode)));
                llOwnerSay(("Current theme is:" + primTexture));
                llMessageLinked(LINK_THIS,12123428,((string)5),((key)""));
                return;
            }
            if ((18 == cmd)) {
                (prevUserMenuLinkId = ((integer)((string)id)));
                return;
            }
            if ((19 == cmd)) {
                (p = llParseString2List(((string)id),["|"],[]));
                (primTexture = llList2String(p,0));
                (p2 = llParseString2List(llList2String(p,1),[","],[]));
                (primTextColorNormal.x = llList2Float(p2,0));
                (primTextColorNormal.y = llList2Float(p2,1));
                (primTextColorNormal.z = llList2Float(p2,2));
                (p2 = llParseString2List(llList2String(p,2),[","],[]));
                (primTextColorHighlight.x = llList2Float(p2,0));
                (primTextColorHighlight.y = llList2Float(p2,1));
                (primTextColorHighlight.z = llList2Float(p2,2));
                (p2 = llParseString2List(llList2String(p,3),[","],[]));
                (primBackgroundColor.x = llList2Float(p2,0));
                (primBackgroundColor.y = llList2Float(p2,1));
                (primBackgroundColor.z = llList2Float(p2,2));
                (p2 = []);
                (primTextColorAlpha = llList2Float(p,4));
                (primTextColorHighlightAlpha = llList2Float(p,5));
                (primBackgroundAlpha = llList2Float(p,6));
                RepaintPrims();
                (primPrevMenuIndex = (-1));
                if (primMeUp) {
                    (p = llParseString2List(GetPrimModeOffsets(mode),[","],[]));
                    llSetLinkPrimitiveParamsFast(38,[PRIM_TEXTURE,4,primTexture,<llList2Float(p,0),llList2Float(p,1),0.0>,<llList2Float(p,2),llList2Float(p,3),0.0>,0]);
                }
                llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123412)));
                return;
            }
            if (("LOADED" == str)) {
                if (((menuLinkId & 2147483392) == 305410560)) llMessageLinked(LINK_THIS,menuLinkId,llDumpList2String([103,llList2Integer(menuStartItem,(menuLinkId - 305410560)),12123408,30],"|"),((key)""));
                return;
            }
            if (("FREESTYLEADDED" == str)) {
                (p = llParseString2List(id,["|"],[]));
                OwnerSay("DCMSG022",[llList2String(p,0),(llList2Integer(p,1) - 305410560)]);
                llMessageLinked(LINK_THIS,llList2Integer(p,1),llDumpList2String([1,llList2String(p,0)],"|"),"");
                return;
            }
            return;
        }
        if (((0 == num) && ("RESET" == str))) {
            if ((!primMeUp)) {
                vector eul = <0,0,0>;
                (eul *= DEG_TO_RAD);
                rotation quat = llEuler2Rot(eul);
                llSetPrimitiveParams([PRIM_ROTATION,quat]);
                (primMeUp = TRUE);
            }
            (primTextColorNormal = <1.0,1.0,1.0>);
            (primTextColorHighlight = <0.0,1.0,0.0>);
            (primBackgroundColor = <0.0,0.0,0.0>);
            (primBackgroundAlpha = 1.0);
            (primTextColorAlpha = 1.0);
            (primTextColorHighlightAlpha = 1.0);
            llSetLinkPrimitiveParamsFast(33,[PRIM_TEXT,"",primTextColorNormal,primTextColorAlpha]);
            for ((i = 0); (i < 30); (++i)) SetPrimText(i,"");
            (primTexture = "~FS Theme Basic");
            RepaintPrims();
            SetInitialMessage();
            llResetScript();
        }
    }

 attach(key attached) {
        if ((attached != NULL_KEY)) {
            if (deferredMode) {
                (deferredMode = FALSE);
                OwnerSay("CMSG008",["Off"]);
            }
            if ((primBackAlphaLevel == 1.0)) {
                (primBackAlphaLevel = 0.0);
                RepaintPrims();
            }
        }
    }

 on_rez(integer startParam) {
        if ((0 == llGetAttached())) {
            (primBackAlphaLevel = 1.0);
            RepaintPrims();
        }
    }

 changed(integer flags) {
        if ((flags & CHANGED_SCALE)) SearchForVerticalPrimSize();
    }
}
