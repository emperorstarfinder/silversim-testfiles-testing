//start_unprocessed_text
/*/|*
The nPose scripts are licensed under the GPLv2 (http:/|/www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in Second Life and/or other virtual world platforms derived from Second Life (such as OpenSim).  If the platform should allow more fine-grained permissions, then "full perms" will mean the most permissive possible set of permissions allowed by the platform.
*|/

/|/default options settings.  Change these to suit personal preferences
list Permissions = ["PUBLIC"]; /|/default permit option [Pubic, Locked, Group]
string curmenuonsit = "off"; /|/default menuonsit option
string cur2default = "off";  /|/default action to revert back to default pose when last sitter has stood
string Facials = "on";
string menuReqSit = "off";  /|/required to be seated to get a menu
string RLVenabled = "on";   /|/default RLV enabled state  on or no
/|/

list victims;
list options = [];
string path;
list slots; /|/this slots list is not complete. it only contains seated AV key and seat numbers
string defaultPose;/|/holds the name of the default notecard.
integer curseatednumber = 0;
list slotbuttons = [];/|/list of seat# or seated AV name for change seats menu.
list dialogids;     /|/3-strided list of dialog ids, the avs they belong to, and the menu path.
key toucherid;
list avs;
list menus;
list menuPerm = [];
float currentOffsetDelta = 0.2;

#define setprefix "SET"
#define btnprefix "BTN"
#define defaultprefix "DEFAULT"
#define cardprefixes [setprefix, defaultprefix, btnprefix]
#define DIALOG -900
#define DIALOG_RESPONSE -901
#define DIALOG_TIMEOUT -902
#define DOPOSE 200
#define ADJUST 201
#define SWAP 202
#define DUMP 204
#define STOPADJUST 205
#define SYNC 206
#define DOBUTTON 207
#define ADJUSTOFFSET 208
#define SETOFFSET 209
#define SWAPTO 210
#define DOMENU -800
#define DOMENU_ACCESSCTRL -801
#define memusage 34334
#define optionsNum -240
#define FWDBTN "forward"
#define BKWDBTN "backward"
#define LEFTBTN "left"
#define RIGHTBTN "right"
#define UPBTN "up"
#define DOWNBTN "down"
#define ZEROBTN "reset"
list offsetbuttons = [FWDBTN, LEFTBTN, UPBTN, BKWDBTN, RIGHTBTN, DOWNBTN, "0.2", "0.1", "0.05", "0.01", ZEROBTN];

/|/dialog button responses
#define SLOTBTN "ChangeSeat"
#define SYNCBTN "sync"
#define OFFSETBTN "offset"
#define BACKBTN "^"
#define ROOTMENU "Main"
#define ADMINBTN "admin"
#define ManageRLV "ManageRLV"
#define ADJUSTBTN "Adjust"
#define STOPADJUSTBTN "StopAdjust"
#define POSDUMPBTN "PosDump"
#define UNSITBTN "Unsit"
#define OPTIONS "Options"
#define MENUONSIT "Menuonsit"
#define TODEFUALT "ToDefault"
#define PERMITBTN "Permit"
list adminbuttons = [ADJUSTBTN, STOPADJUSTBTN, POSDUMPBTN, UNSITBTN, OPTIONS];

key Dialog(key rcpt, string prompt, list choices, list utilitybuttons, integer page){
    key id = "";
    /|/find out if we seated
    integer stopc = llGetListLength(choices);
    integer nc;
    if (!~llListFindList(SeatedAvs(), [toucherid])){
        /|/menu user is not seated.  give menu to owner always but non-owner only if menuReqSit is "off".
        /|/{group} permissions do apply
        if (toucherid == llGetOwner() | (toucherid != llGetOwner() && menuReqSit == "off")){
            if (toucherid != llGetOwner()){
                for (; nc < stopc; ++nc){
                    /|/ find the index of each button in menuPerm list. perms will be (~ delimited string) at indexc + 1
                    integer indexc = llListFindList(menuPerm, [llList2String(choices, nc)]);
                    /|/apply {group} restrictions if needed
                    if (((indexc != -1)
                     && (!llSubStringIndex(llList2String(menuPerm, indexc + 1), "group") && !llSameGroup(toucherid)))
                      || (!llSubStringIndex(llList2String(menuPerm, indexc + 1), "owner"))){
                        choices = llDeleteSubList(choices, nc, nc);
                        --nc;
                        --stopc;
                    }
                }
            }
            id = llGenerateKey();
            llMessageLinked(LINK_SET, DIALOG, (string)rcpt + "|" + prompt + "|" + (string)page
             + "|" + llDumpList2String(choices, "`") + "|" + llDumpList2String(utilitybuttons, "`"), id);
        }
    }else{
        /|/menu user is seated.  go do your stuff
        /|/first find our seat# in the slots list
        integer slotIndex = llListFindList(slots, [toucherid]);
        integer z = llSubStringIndex(llList2String(slots, slotIndex + 1), "§");
        string seat# = llGetSubString(llList2String(slots, slotIndex + 1), z+5,-1);
        for (nc = 0; nc < stopc; ++nc){
            /|/ find the index of each button in menuPerm list. perms will be (~ delimited string) at indexc + 1
            integer indexc = llListFindList(menuPerm, [llList2String(choices, nc)]);
            if (indexc != -1){
                /|/create our list of perms allowed for this button
                list permsList = llParseString2List(llList2String(menuPerm, indexc + 1), ["~"],[]);
/|/                llOwnerSay("this card menuPerm:\n" + llList2String(choices, nc) + "," + llList2CSV(permsList));
                if (llGetListLength(permsList) > 1){
                    /|/get the list of seat numbers allowed to get this button
                    list seatPerms = llList2List(permsList, 1, -1);
                    /|/remove if not in the allowed seats
                    /|/complicated but we look for a "!" in permissions, if found we only looking for !seat#'s (excluding only them)
                    /|/if we don't find "!" in permissions, we only exclude seat#'s not found (including only them)
                    /|/user cannot mix !seat#'s with seat#'s or unexpected results will be produced.
                    if (((~llSubStringIndex(llDumpList2String(seatPerms, ""), "!")) && (~llListFindList(seatPerms,["!" + seat#])))
                     | ((!~llSubStringIndex(llDumpList2String(seatPerms, ""), "!")) && (!~llListFindList(seatPerms,[seat#])))){
                        choices = llDeleteSubList(choices, nc, nc);
                        --nc;
                        --stopc;
                    }
                }else{
                    /|/no seat number restrictions so do {owner} and {group} perms
                    if ((llList2String(permsList, 0) == "owner" && toucherid != llGetOwner())
                     | (llList2String(permsList, 0) == "group" && !llSameGroup(toucherid))){
                        choices = llDeleteSubList(choices, nc, nc);
                        --nc;
                        --stopc;
                    }
                }
            }
        }
        id = llGenerateKey();
        llMessageLinked(LINK_SET, DIALOG, (string)rcpt + "|" + prompt + "|" + (string)page +
         "|" + llDumpList2String(choices, "`") + "|" + llDumpList2String(utilitybuttons, "`"), id);
    }
    return id;
}

list SeatedAvs(){ /|/returns the list of uuid's of seated AVs
    avs=[];
    integer counter = llGetNumberOfPrims();
    while (llGetAgentSize(llGetLinkKey(counter)) != <0, 0, 0>){
        avs += llGetLinkKey(counter);
        --counter;
    }
    return avs;
}

AdjustOffsetDirection(key id, vector direction) {
    vector delta = direction * currentOffsetDelta;
    llMessageLinked(LINK_SET, ADJUSTOFFSET, (string)delta, id);
}    

AdminMenu(key toucher, string path, string prompt, list buttons){
    key id = Dialog(toucher, prompt+"\n"+path+"\n", buttons, [BACKBTN], 0);
    integer index = llListFindList(dialogids, [toucher]);
    list addme = [id, toucher, path];
    if (~index){ /|/ found - replace
        dialogids = llListReplaceList(dialogids, addme, index+-1, index+1);        
    }else{ /|/ not found - add
        dialogids += addme;
    }
}

DoMenu(key toucher, string path, string menuPrompt, integer page){/|/builds the final menu for authorized
    integer index = llListFindList(menus, [path]);
    if (~index){
        list buttons = llListSort(llParseStringKeepNulls(llList2String(menus, index+1), ["|"], []), 1, 1);
        list tmp = [];
        if (path != ROOTMENU){
            tmp += [BACKBTN];
        }
        key id = Dialog(toucher, menuPrompt + "\n"+path+"\n", buttons, tmp, page);
        tmp = [id, toucher, path];
        index = llListFindList(dialogids, (list)toucher);
        if (~index){ /|/ found - replace
            dialogids = llListReplaceList(dialogids, tmp, index+-1, index+1);        
        }else{ /|/ not found - add
            dialogids += tmp;
        }        
    }
}

DoMenu_AccessCtrl(key toucher, string path, string menuPrompt, integer page){/|/checks and enforces who has access to the menu.
    integer authorized;/|/ = FALSE; /|/ it's FALSE by default
    if (toucher == llGetOwner() && !~llListFindList(victims, [(string)llGetOwner()])){/|/owner always gets authorized, except if they are a victim
        authorized = TRUE;
    }else if ((llList2String(Permissions, 0) == "GROUP" && llSameGroup(toucher))
     | (llList2String(Permissions, 0) == "PUBLIC")){
        if (!~llListFindList(victims, [(string)toucher])){ /|/if not found in victims list.. (if found, do not authorize)
            authorized = TRUE;
        }
    }
    if (authorized){
        DoMenu(toucher, path, menuPrompt, page);
    }
}

BuildMenus(){/|/builds the user defined menu buttons
    menus = [];
    menuPerm = [];
    integer stop = llGetInventoryNumber(INVENTORY_NOTECARD);
    integer defaultSet;/|/ = FALSE; /|/ false by default
    integer n;
    for (; n<stop; ++n){/|/step through the notecards backwards so that default notecard is first in the contents
        string name = llGetInventoryName(INVENTORY_NOTECARD, n);
        integer permsIndex1 = llSubStringIndex(name,"{");
        integer permsIndex2 = llSubStringIndex(name,"}");
        string menuPerms = "";
        if (~permsIndex1){ /|/ found
            menuPerms = llToLower(llGetSubString(name, permsIndex1+1, permsIndex2+-1));
            name = llDeleteSubString(name, permsIndex1, permsIndex2);
            /|/put "public" in front of perms if not "owner" or not "group"
            if (!~llSubStringIndex(menuPerms, "owner") && !~llSubStringIndex(menuPerms, "group")){
                if (llSubStringIndex(menuPerms, "~") != 0){
                    menuPerms = "public~" + menuPerms;
                }else{
                    menuPerms = "public" + menuPerms;
                }
            }
        }else{
            /|/for legacy use default to "public" if no "{" are used
            menuPerms = "public";
        }
        list pathParts = llParseStringKeepNulls(name, [":"], []);
        menuPerm += [llList2String(pathParts, -1), menuPerms];
        string prefix = llList2String(pathParts, 0);
        if (!defaultSet && ((prefix == setprefix) | (prefix == defaultprefix))){
            defaultPose = llGetInventoryName(INVENTORY_NOTECARD,n);
            defaultSet = TRUE;
        }
        if (~llListFindList(cardprefixes, [prefix])){ /|/ found
            pathParts = llDeleteSubList(pathParts, 0, 0);            
            while(llGetListLength(pathParts)){
                string last = llList2String(pathParts, -1);
                string parentpath = llDumpList2String([ROOTMENU] + llDeleteSubList(pathParts, -1, -1), ":");
                integer index = llListFindList(menus, [parentpath]);
                if (~index && !(index & 1)){
                    list children = llParseStringKeepNulls(llList2String(menus, index + 1), ["|"], []);
                    if (!~llListFindList(children, [last])){
                        children += [last];
                        menus = llListReplaceList((menus = []) + menus, [llDumpList2String(children, "|")], index + 1, index + 1);
                    }
                }else{
                    menus += [parentpath, last];
                }
                pathParts = llDeleteSubList(pathParts, -1, -1);
            }
        }
    }
}

default{
    state_entry(){
        BuildMenus();
    }

    touch_start(integer total_number){
        toucherid = llDetectedKey(0);
        DoMenu_AccessCtrl(toucherid,ROOTMENU, "",0);
    }
    
    link_message(integer sender, integer num, string str, key id){
        integer index;
        integer n;
        integer stop;
        if (num == DIALOG_RESPONSE){ /|/response from menu
            index = llListFindList(dialogids, [id]); /|/find the id in dialogids
            if (~index){ /|/we found the toucher in dialogids
                list params = llParseString2List(str, ["|"], []);  /|/parse the message
                integer page = (integer)llList2String(params, 0);  /|/get the page number
                string selection = llList2String(params, 1);  /|/get the button that was pressed from str
                path = llList2String(dialogids, index + 2); /|/get the path from dialogids
                toucherid = llList2Key(dialogids, index + 1);
                if (selection == BACKBTN){
                    /|/handle the back button. admin menu gets handled differently cause buttons are custom
                    list pathparts = llParseString2List(path, [":"], []);
                    pathparts = llDeleteSubList(pathparts, -1, -1);
                    if (llList2String(pathparts, -1) == ADMINBTN){
                       AdminMenu(toucherid, llDumpList2String(pathparts, ":"), "", adminbuttons);
                    }else if (llGetListLength(pathparts) <= 1){
                        DoMenu(toucherid, ROOTMENU, "", 0);
                    }else{
                        DoMenu(toucherid, llDumpList2String(pathparts, ":"), "", 0);
                    }
                }else if (selection == ADMINBTN){
                    path += ":" + selection;
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == SLOTBTN){
                    /|/someone wants to change sit positionss.
                    /|/taking a place where someone already has that slot should do the swap regardless of how many 
                    /|/places are open
                    path = path + ":" + selection;
                    AdminMenu(toucherid, path,  "Where will you sit?", slotbuttons);
                }else if (selection == OFFSETBTN){
                    /|/give offset menu
                    path = path + ":" + selection;
                    AdminMenu(toucherid, path,   "Adjust by " + (string)currentOffsetDelta
                     + "m, or choose another distance.", offsetbuttons);
                }else if (selection == ADJUSTBTN){
                    llMessageLinked(LINK_SET, ADJUST, "", "");
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == STOPADJUSTBTN){
                    llMessageLinked(LINK_SET, STOPADJUST, "", "");
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == POSDUMPBTN){
                    llMessageLinked(LINK_SET, DUMP, "", "");
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == UNSITBTN){
                    
                    avs = SeatedAvs();
                    list buttons;
                    stop = llGetListLength(avs);
                    for (; n < stop; ++n){
                        buttons += [llGetSubString(llKey2Name((key)llList2String(avs, n)), 0, 20)];
                    }
                    if (buttons != []){
                        path += ":" + selection;
                        AdminMenu(toucherid, path, "Pick an avatar to unsit", buttons);
                    }else{
                        AdminMenu(toucherid, path, "", adminbuttons);
                    }
                }else if (selection == OPTIONS){
                    path += ":" + selection;
                    string optionsPrompt =  "Permit currently set to " + llList2String(Permissions, 0)
                     + "\nMenuOnSit currently set to "+ curmenuonsit + "\nsit2GetMenu currently set to " + menuReqSit 
                     + "\n2default currently set to "+ cur2default + "\nFacialEnable currently set to "+ Facials
                    + "\nUseRLVBaseRestrict currently set to "+ RLVenabled;
                    AdminMenu(toucherid, path, optionsPrompt, options);
                }else if (~llListFindList(menus, [path + ":" + selection])){
                    path = path + ":" + selection;
                    DoMenu(toucherid, path, "", 0);
                }else if (llList2String(llParseString2List(path, [":"], []), -1) == SLOTBTN){/|/change seats
                    if (llGetSubString(selection, 0,3)=="seat"){ /|/clicker selected an open seat where menu is 'seat'+#
                        n = (integer)llGetSubString(selection, 4,-1);
                        if (n >= 0) {
                            llMessageLinked(LINK_SET, SWAPTO, (string)n, toucherid);
                        }
                    }else{ /|/clicker selected a name so get seat# from list
                        n = llListFindList(slotbuttons, [selection])+1;
                        if (n >= 0) {
                            llMessageLinked(LINK_SET, SWAPTO, (string)n, toucherid);
                        }
                    }
                    list pathparts = llParseString2List(path, [":"], []);
                    pathparts = llDeleteSubList(pathparts, -1, -1);
                    path = llDumpList2String(pathparts, ":");
                    DoMenu(toucherid, path,  "", 0);
                }else if (llList2String(llParseString2List(path, [":"], []), -1) == UNSITBTN){
                    stop = llGetListLength(avs);
                    for (; n < stop; n++){
                        key av = llList2Key(avs, n);
                        if (llGetSubString(llKey2Name(av), 0, 20) == selection){
                            if (~llListFindList(SeatedAvs(), [av])){ /|/just make sure the av is seated before doing this unsit
                                /|/letting the slave script do the unsit function so link message out the command to unsit
                                llMessageLinked(LINK_SET, -222, (string)av, NULL_KEY);
                                integer avIndex = llListFindList(avs, [av]);
                                avs = llDeleteSubList(avs, index, index);
                                n = stop;
                            }
                        }
                    }
                    list buttons = [];
                    stop = llGetListLength(avs);
                    for (n = 0; n < stop; n++){
                        buttons += [llGetSubString(llKey2Name((key)llList2String(avs, n)), 0, 20)];
                    }
                    if (buttons != []){
                        AdminMenu(toucherid, path, "Pick an avatar to unsit", buttons);
                    }else{
                        list pathParts = llParseString2List(path, [":"], []);
                        pathParts = llDeleteSubList(pathParts, -1, -1);
                        AdminMenu(toucherid, llDumpList2String(pathParts, ":"), "", adminbuttons);
                    }
                }else if (llList2String(llParseString2List(path, [":"], []), -1) == OFFSETBTN){
                         if (selection ==   FWDBTN) AdjustOffsetDirection(toucherid,  (vector)<1, 0, 0>);
                    else if (selection ==  BKWDBTN) AdjustOffsetDirection(toucherid,  (vector)<-1, 0, 0>);
                    else if (selection ==  LEFTBTN) AdjustOffsetDirection(toucherid,  (vector)<0, 1, 0>);
                    else if (selection == RIGHTBTN) AdjustOffsetDirection(toucherid,  (vector)<0, -1, 0>);
                    else if (selection ==    UPBTN) AdjustOffsetDirection(toucherid,  (vector)<0, 0, 1>);
                    else if (selection ==  DOWNBTN) AdjustOffsetDirection(toucherid,  (vector)<0, 0, -1>);
                    else if (selection ==  ZEROBTN) llMessageLinked(LINK_SET, SETOFFSET, (string)ZERO_VECTOR, toucherid);
                    else currentOffsetDelta = (float)selection;
                    AdminMenu(toucherid, path,  "Adjust by " + (string)currentOffsetDelta
                     + "m, or choose another distance.", offsetbuttons);
                }else if (selection == SYNCBTN){
                    llMessageLinked(LINK_SET, SYNC, "", "");
                    DoMenu(toucherid, path, "", page);                    
                }else{
                    list pathlist = llDeleteSubList(llParseStringKeepNulls(path, [":"], []), 0, 0);
                    integer permission = llListFindList(menuPerm, [selection]);
                    string defaultname = llDumpList2String([defaultprefix] + pathlist + [selection], ":");                
                    string setname = llDumpList2String([setprefix] + pathlist + [selection], ":");
                    string btnname = llDumpList2String([btnprefix] + pathlist + [selection], ":");
                    /|/correct the notecard name so the core can find this notecard
                    if (~permission){
                        string thisPerm;
                        if (llSubStringIndex(llList2String(menuPerm, permission+1), "public") == 0){
                             thisPerm = llGetSubString(llList2String(menuPerm, permission+1), 7, -1);
                        }else{
                            thisPerm = llList2String(menuPerm, permission+1);
                        }
                        if (thisPerm != "public"){
                            defaultname += "{"+thisPerm+"}";
                            setname += "{"+thisPerm+"}";
                            btnname += "{"+thisPerm+"}";
                        }
                    }
                    if (llGetInventoryType(defaultname) == INVENTORY_NOTECARD){
                        llMessageLinked(LINK_SET, DOPOSE, defaultname, toucherid);                    
                    }else if (llGetInventoryType(setname) == INVENTORY_NOTECARD){
                        llMessageLinked(LINK_SET, DOPOSE, setname, toucherid);
                    }else if (llGetInventoryType(btnname) == INVENTORY_NOTECARD){
                        llMessageLinked(LINK_SET, DOBUTTON, btnname, toucherid);
                    }
                    if (llGetSubString(selection,-1,-1) == "-"){/|/don't remenu
                        llMessageLinked(LINK_SET, -802, path, toucherid);
                    }else{
                        DoMenu(toucherid, path, "", page);
                    }
                }
            }
        }else if (num == DIALOG_TIMEOUT){/|/menu not clicked and dialog timed out
            index = llListFindList(dialogids, [id]);
            if (~index){
                dialogids = llDeleteSubList(dialogids, index, index + 2);
            }
            if (cur2default == "on" && llGetListLength(SeatedAvs()) < 1){
                llMessageLinked(LINK_SET, DOPOSE, defaultPose, NULL_KEY);
            }
        }else if (num==optionsNum){
            list optionsToSet = llParseStringKeepNulls(str, ["~"], []);
            stop = llGetListLength(optionsToSet);
            for (; n<stop; ++n){
                list optionsItems = llParseString2List(llList2String(optionsToSet, n), ["="], []);
                string optionItem = llList2String(optionsItems, 0);
                string optionSetting = llList2String(optionsItems, 1);
                if (optionItem == "menuonsit") {curmenuonsit = optionSetting;}
                else if (optionItem == "permit") {Permissions = [llToUpper(optionSetting)];}
                else if (optionItem == "2default") {cur2default = optionSetting;}
                else if (optionItem == "sit2getmenu") {menuReqSit = optionSetting;}
                else if (optionItem == "facialExp"){
                    Facials = optionSetting;
                    llMessageLinked(LINK_SET, -241, Facials, NULL_KEY);
                }else if (optionItem == "rlvbaser"){
                    RLVenabled = optionSetting;
                    llMessageLinked(LINK_SET, -1812221819, "RLV=" + RLVenabled, NULL_KEY);
                }
            }
        }else if (num == -888){
            if (str == ADMINBTN){
                path += ":" + str;
                AdminMenu(toucherid, path, "", adminbuttons);
            }else if (str == SLOTBTN){
                /|/someone wants to change sit positionss.
                /|/taking a place where someone already has that slot should do the swap regardless of how many 
                /|/places are open
                path = path + ":" + str;
                AdminMenu(toucherid, path,  "Where will you sit?", slotbuttons);
            }else if (str == OFFSETBTN){
                /|/give offset menu
                path = path + ":" + str;
                AdminMenu(toucherid, path,   "Adjust by " + (string)currentOffsetDelta
                 + "m, or choose another distance.", offsetbuttons);
            }else if (str == SYNCBTN){
                llMessageLinked(LINK_SET, SYNC, "", "");
                DoMenu(toucherid, path, "", 0);
            }
        }else if (num == DOMENU){
            toucherid = id;
            DoMenu(toucherid, str, "", 0);
        }else if (num == DOMENU_ACCESSCTRL){/|/external call to check permissions
            toucherid = id;
            DoMenu_AccessCtrl(toucherid, ROOTMENU, "", 0);
        }else if(num == -238){
/|/            victims = llCSV2List(str);
        }else if (num==35353){
            list slotsList = llParseStringKeepNulls(str, ["^"], []);
            slots = [];
            for (n=0; n<(llGetListLength(slotsList)/8); ++n){
                slots += [(key)llList2String(slotsList, n*8+4), llList2String(slotsList, n*8+7)];
            }
        }else if (num==35354){
            slotbuttons = llParseString2List(str, [","], []);
            string strideSeat;
            for (n = 0; n < llGetListLength(slotbuttons); ++n){ /|/ n is the slot number
                index = llSubStringIndex(llList2String(slotbuttons, n), "§");
                if (!index){
                    strideSeat = llGetSubString(llList2String(slotbuttons, n), 1,-1);
                }else{
                    strideSeat = llGetSubString(llList2String(slotbuttons, n), 0, index+-1);
                }
                slotbuttons = llListReplaceList(slotbuttons, [strideSeat], n, n);
            }
        }else if (num == memusage){/|/dump memory stats to local
            llSay(0,"Memory Used by " + llGetScriptName() + ": " + (string)llGetUsedMemory() + " of " + (string)llGetMemoryLimit()
                 + ",Leaving " + (string)llGetFreeMemory() + " memory free.");
        }
    }

    changed(integer change){
        if (change & CHANGED_INVENTORY){
            BuildMenus();           
        }
        if (change & CHANGED_OWNER){
            llResetScript();
        }
        /|/ check on the options and act accordingly on av count change
        avs = SeatedAvs();
        if ((change & CHANGED_LINK) && (llGetListLength(avs)>0)){ /|/we have a sitter
            if (curmenuonsit == "on"){
                integer lastSeatedAV = llGetListLength(avs);  /|/get current number of AVs seated
                if (lastSeatedAV > curseatednumber){  /|/we are in changed event so find out if 
                /|/it is a new sitter that brought us here
                    key id = llList2Key(avs,lastSeatedAV+-curseatednumber+-1);  /|/if so, get key of last sitter 
                    curseatednumber = lastSeatedAV;  /|/update our number of sitters
                    DoMenu_AccessCtrl(id, ROOTMENU, "", 0);  /|/if not a victim, give menu
                }
            }
        } 
        if ((change & CHANGED_LINK) && (cur2default == "on") && (!llGetListLength(avs))){ /|/av count is 0 (we lost all sitters)
            llMessageLinked(LINK_SET, DOPOSE, defaultPose, NULL_KEY);
            curseatednumber=0;
        }
        curseatednumber=llGetListLength(avs);
    }
    on_rez(integer params){
        llResetScript();
    }
}
*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 4.6.9.42974 - Howard Baxton
//mono


list victims;
key toucherid;
list slots;
list slotbuttons = [];
string path;
list options = [];
list offsetbuttons = ["forward", "left", "up", "backward", "right", "down", "0.2", "0.1", "0.05", "0.01", "reset"];
list menus;
string menuReqSit = "off";
list menuPerm = [];
list dialogids;
string defaultPose;
integer curseatednumber = 0;
float currentOffsetDelta = 0.2;
string curmenuonsit = "off";
string cur2default = "off";
list avs;
list adminbuttons = ["Adjust", "StopAdjust", "PosDump", "Unsit", "Options"];
string RLVenabled = "on";
list Permissions = ["PUBLIC"];
string Facials = "on";
list SeatedAvs(){ 
    avs=[];
    integer counter = llGetNumberOfPrims();
    while (llGetAgentSize(llGetLinkKey(counter)) != <0, 0, 0>){
        avs += llGetLinkKey(counter);
        --counter;
    }
    return avs;
}


DoMenu_AccessCtrl(key toucher, string path, string menuPrompt, integer page){
    integer authorized;
    if (toucher == llGetOwner() && !~llListFindList(victims, [(string)llGetOwner()])){
        authorized = TRUE;
    }else if ((llList2String(Permissions, 0) == "GROUP" && llSameGroup(toucher))
     | (llList2String(Permissions, 0) == "PUBLIC")){
        if (!~llListFindList(victims, [(string)toucher])){ 
            authorized = TRUE;
        }
    }
    if (authorized){
        DoMenu(toucher, path, menuPrompt, page);
    }
}


DoMenu(key toucher, string path, string menuPrompt, integer page){
    integer index = llListFindList(menus, [path]);
    if (~index){
        list buttons = llListSort(llParseStringKeepNulls(llList2String(menus, index+1), ["|"], []), 1, 1);
        list tmp = [];
        if (path != "Main"){
            tmp += ["^"];
        }
        key id = Dialog(toucher, menuPrompt + "\n"+path+"\n", buttons, tmp, page);
        tmp = [id, toucher, path];
        index = llListFindList(dialogids, (list)toucher);
        if (~index){ 
            dialogids = llListReplaceList(dialogids, tmp, index+-1, index+1);        
        }else{ 
            dialogids += tmp;
        }        
    }
}
key Dialog(key rcpt, string prompt, list choices, list utilitybuttons, integer page){
    key id = "";
    
    integer stopc = llGetListLength(choices);
    integer nc;
    if (!~llListFindList(SeatedAvs(), [toucherid])){
        
        
        if (toucherid == llGetOwner() | (toucherid != llGetOwner() && menuReqSit == "off")){
            if (toucherid != llGetOwner()){
                for (; nc < stopc; ++nc){
                    
                    integer indexc = llListFindList(menuPerm, [llList2String(choices, nc)]);
                    
                    if (((indexc != -1)
                     && (!llSubStringIndex(llList2String(menuPerm, indexc + 1), "group") && !llSameGroup(toucherid)))
                      || (!llSubStringIndex(llList2String(menuPerm, indexc + 1), "owner"))){
                        choices = llDeleteSubList(choices, nc, nc);
                        --nc;
                        --stopc;
                    }
                }
            }
            id = llGenerateKey();
            llMessageLinked(LINK_SET, -900, (string)rcpt + "|" + prompt + "|" + (string)page
             + "|" + llDumpList2String(choices, "`") + "|" + llDumpList2String(utilitybuttons, "`"), id);
        }
    }else{
        
        
        integer slotIndex = llListFindList(slots, [toucherid]);
        integer z = llSubStringIndex(llList2String(slots, slotIndex + 1), "§");
        string seat  = llGetSubString(llList2String(slots, slotIndex + 1), z+5,-1);
        for (nc = 0; nc < stopc; ++nc){
            
            integer indexc = llListFindList(menuPerm, [llList2String(choices, nc)]);
            if (indexc != -1){
                
                list permsList = llParseString2List(llList2String(menuPerm, indexc + 1), ["~"],[]);

                if (llGetListLength(permsList) > 1){
                    
                    list seatPerms = llList2List(permsList, 1, -1);
                    
                    
                    
                    
                    if (((~llSubStringIndex(llDumpList2String(seatPerms, ""), "!")) && (~llListFindList(seatPerms,["!" + seat ])))
                     | ((!~llSubStringIndex(llDumpList2String(seatPerms, ""), "!")) && (!~llListFindList(seatPerms,[seat ])))){
                        choices = llDeleteSubList(choices, nc, nc);
                        --nc;
                        --stopc;
                    }
                }else{
                    
                    if ((llList2String(permsList, 0) == "owner" && toucherid != llGetOwner())
                     | (llList2String(permsList, 0) == "group" && !llSameGroup(toucherid))){
                        choices = llDeleteSubList(choices, nc, nc);
                        --nc;
                        --stopc;
                    }
                }
            }
        }
        id = llGenerateKey();
        llMessageLinked(LINK_SET, -900, (string)rcpt + "|" + prompt + "|" + (string)page +
         "|" + llDumpList2String(choices, "`") + "|" + llDumpList2String(utilitybuttons, "`"), id);
    }
    return id;
}


BuildMenus(){
    menus = [];
    menuPerm = [];
    integer stop = llGetInventoryNumber(INVENTORY_NOTECARD);
    integer defaultSet;
    integer n;
    for (; n<stop; ++n){
        string name = llGetInventoryName(INVENTORY_NOTECARD, n);
        integer permsIndex1 = llSubStringIndex(name,"{");
        integer permsIndex2 = llSubStringIndex(name,"}");
        string menuPerms = "";
        if (~permsIndex1){ 
            menuPerms = llToLower(llGetSubString(name, permsIndex1+1, permsIndex2+-1));
            name = llDeleteSubString(name, permsIndex1, permsIndex2);
            
            if (!~llSubStringIndex(menuPerms, "owner") && !~llSubStringIndex(menuPerms, "group")){
                if (llSubStringIndex(menuPerms, "~") != 0){
                    menuPerms = "public~" + menuPerms;
                }else{
                    menuPerms = "public" + menuPerms;
                }
            }
        }else{
            
            menuPerms = "public";
        }
        list pathParts = llParseStringKeepNulls(name, [":"], []);
        menuPerm += [llList2String(pathParts, -1), menuPerms];
        string prefix = llList2String(pathParts, 0);
        if (!defaultSet && ((prefix == "SET") | (prefix == "DEFAULT"))){
            defaultPose = llGetInventoryName(INVENTORY_NOTECARD,n);
            defaultSet = TRUE;
        }
        if (~llListFindList(["SET", "DEFAULT", "BTN"], [prefix])){ 
            pathParts = llDeleteSubList(pathParts, 0, 0);            
            while(llGetListLength(pathParts)){
                string last = llList2String(pathParts, -1);
                string parentpath = llDumpList2String(["Main"] + llDeleteSubList(pathParts, -1, -1), ":");
                integer index = llListFindList(menus, [parentpath]);
                if (~index && !(index & 1)){
                    list children = llParseStringKeepNulls(llList2String(menus, index + 1), ["|"], []);
                    if (!~llListFindList(children, [last])){
                        children += [last];
                        menus = llListReplaceList((menus = []) + menus, [llDumpList2String(children, "|")], index + 1, index + 1);
                    }
                }else{
                    menus += [parentpath, last];
                }
                pathParts = llDeleteSubList(pathParts, -1, -1);
            }
        }
    }
}
    

AdminMenu(key toucher, string path, string prompt, list buttons){
    key id = Dialog(toucher, prompt+"\n"+path+"\n", buttons, ["^"], 0);
    integer index = llListFindList(dialogids, [toucher]);
    list addme = [id, toucher, path];
    if (~index){ 
        dialogids = llListReplaceList(dialogids, addme, index+-1, index+1);        
    }else{ 
        dialogids += addme;
    }
}






AdjustOffsetDirection(key id, vector direction) {
    vector delta = direction * currentOffsetDelta;
    llMessageLinked(LINK_SET, 208, (string)delta, id);
}


default{
    state_entry(){
        BuildMenus();
    }

    touch_start(integer total_number){
        toucherid = llDetectedKey(0);
        DoMenu_AccessCtrl(toucherid,"Main", "",0);
    }
    
    link_message(integer sender, integer num, string str, key id){
        integer index;
        integer n;
        integer stop;
        if (num == -901){ 
            index = llListFindList(dialogids, [id]); 
            if (~index){ 
                list params = llParseString2List(str, ["|"], []);  
                integer page = (integer)llList2String(params, 0);  
                string selection = llList2String(params, 1);  
                path = llList2String(dialogids, index + 2); 
                toucherid = llList2Key(dialogids, index + 1);
                if (selection == "^"){
                    
                    list pathparts = llParseString2List(path, [":"], []);
                    pathparts = llDeleteSubList(pathparts, -1, -1);
                    if (llList2String(pathparts, -1) == "admin"){
                       AdminMenu(toucherid, llDumpList2String(pathparts, ":"), "", adminbuttons);
                    }else if (llGetListLength(pathparts) <= 1){
                        DoMenu(toucherid, "Main", "", 0);
                    }else{
                        DoMenu(toucherid, llDumpList2String(pathparts, ":"), "", 0);
                    }
                }else if (selection == "admin"){
                    path += ":" + selection;
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == "ChangeSeat"){
                    
                    
                    
                    path = path + ":" + selection;
                    AdminMenu(toucherid, path,  "Where will you sit?", slotbuttons);
                }else if (selection == "offset"){
                    
                    path = path + ":" + selection;
                    AdminMenu(toucherid, path,   "Adjust by " + (string)currentOffsetDelta
                     + "m, or choose another distance.", offsetbuttons);
                }else if (selection == "Adjust"){
                    llMessageLinked(LINK_SET, 201, "", "");
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == "StopAdjust"){
                    llMessageLinked(LINK_SET, 205, "", "");
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == "PosDump"){
                    llMessageLinked(LINK_SET, 204, "", "");
                    AdminMenu(toucherid, path, "", adminbuttons);
                }else if (selection == "Unsit"){
                    
                    avs = SeatedAvs();
                    list buttons;
                    stop = llGetListLength(avs);
                    for (; n < stop; ++n){
                        buttons += [llGetSubString(llKey2Name((key)llList2String(avs, n)), 0, 20)];
                    }
                    if (buttons != []){
                        path += ":" + selection;
                        AdminMenu(toucherid, path, "Pick an avatar to unsit", buttons);
                    }else{
                        AdminMenu(toucherid, path, "", adminbuttons);
                    }
                }else if (selection == "Options"){
                    path += ":" + selection;
                    string optionsPrompt =  "Permit currently set to " + llList2String(Permissions, 0)
                     + "\nMenuOnSit currently set to "+ curmenuonsit + "\nsit2GetMenu currently set to " + menuReqSit 
                     + "\n2default currently set to "+ cur2default + "\nFacialEnable currently set to "+ Facials
                    + "\nUseRLVBaseRestrict currently set to "+ RLVenabled;
                    AdminMenu(toucherid, path, optionsPrompt, options);
                }else if (~llListFindList(menus, [path + ":" + selection])){
                    path = path + ":" + selection;
                    DoMenu(toucherid, path, "", 0);
                }else if (llList2String(llParseString2List(path, [":"], []), -1) == "ChangeSeat"){
                    if (llGetSubString(selection, 0,3)=="seat"){ 
                        n = (integer)llGetSubString(selection, 4,-1);
                        if (n >= 0) {
                            llMessageLinked(LINK_SET, 210, (string)n, toucherid);
                        }
                    }else{ 
                        n = llListFindList(slotbuttons, [selection])+1;
                        if (n >= 0) {
                            llMessageLinked(LINK_SET, 210, (string)n, toucherid);
                        }
                    }
                    list pathparts = llParseString2List(path, [":"], []);
                    pathparts = llDeleteSubList(pathparts, -1, -1);
                    path = llDumpList2String(pathparts, ":");
                    DoMenu(toucherid, path,  "", 0);
                }else if (llList2String(llParseString2List(path, [":"], []), -1) == "Unsit"){
                    stop = llGetListLength(avs);
                    for (; n < stop; n++){
                        key av = llList2Key(avs, n);
                        if (llGetSubString(llKey2Name(av), 0, 20) == selection){
                            if (~llListFindList(SeatedAvs(), [av])){ 
                                
                                llMessageLinked(LINK_SET, -222, (string)av, NULL_KEY);
                                integer avIndex = llListFindList(avs, [av]);
                                avs = llDeleteSubList(avs, index, index);
                                n = stop;
                            }
                        }
                    }
                    list buttons = [];
                    stop = llGetListLength(avs);
                    for (n = 0; n < stop; n++){
                        buttons += [llGetSubString(llKey2Name((key)llList2String(avs, n)), 0, 20)];
                    }
                    if (buttons != []){
                        AdminMenu(toucherid, path, "Pick an avatar to unsit", buttons);
                    }else{
                        list pathParts = llParseString2List(path, [":"], []);
                        pathParts = llDeleteSubList(pathParts, -1, -1);
                        AdminMenu(toucherid, llDumpList2String(pathParts, ":"), "", adminbuttons);
                    }
                }else if (llList2String(llParseString2List(path, [":"], []), -1) == "offset"){
                         if (selection ==   "forward") AdjustOffsetDirection(toucherid,  (vector)<1, 0, 0>);
                    else if (selection ==  "backward") AdjustOffsetDirection(toucherid,  (vector)<-1, 0, 0>);
                    else if (selection ==  "left") AdjustOffsetDirection(toucherid,  (vector)<0, 1, 0>);
                    else if (selection == "right") AdjustOffsetDirection(toucherid,  (vector)<0, -1, 0>);
                    else if (selection ==    "up") AdjustOffsetDirection(toucherid,  (vector)<0, 0, 1>);
                    else if (selection ==  "down") AdjustOffsetDirection(toucherid,  (vector)<0, 0, -1>);
                    else if (selection ==  "reset") llMessageLinked(LINK_SET, 209, (string)ZERO_VECTOR, toucherid);
                    else currentOffsetDelta = (float)selection;
                    AdminMenu(toucherid, path,  "Adjust by " + (string)currentOffsetDelta
                     + "m, or choose another distance.", offsetbuttons);
                }else if (selection == "sync"){
                    llMessageLinked(LINK_SET, 206, "", "");
                    DoMenu(toucherid, path, "", page);                    
                }else{
                    list pathlist = llDeleteSubList(llParseStringKeepNulls(path, [":"], []), 0, 0);
                    integer permission = llListFindList(menuPerm, [selection]);
                    string defaultname = llDumpList2String(["DEFAULT"] + pathlist + [selection], ":");                
                    string setname = llDumpList2String(["SET"] + pathlist + [selection], ":");
                    string btnname = llDumpList2String(["BTN"] + pathlist + [selection], ":");
                    
                    if (~permission){
                        string thisPerm;
                        if (llSubStringIndex(llList2String(menuPerm, permission+1), "public") == 0){
                             thisPerm = llGetSubString(llList2String(menuPerm, permission+1), 7, -1);
                        }else{
                            thisPerm = llList2String(menuPerm, permission+1);
                        }
                        if (thisPerm != "public"){
                            defaultname += "{"+thisPerm+"}";
                            setname += "{"+thisPerm+"}";
                            btnname += "{"+thisPerm+"}";
                        }
                    }
                    if (llGetInventoryType(defaultname) == INVENTORY_NOTECARD){
                        llMessageLinked(LINK_SET, 200, defaultname, toucherid);                    
                    }else if (llGetInventoryType(setname) == INVENTORY_NOTECARD){
                        llMessageLinked(LINK_SET, 200, setname, toucherid);
                    }else if (llGetInventoryType(btnname) == INVENTORY_NOTECARD){
                        llMessageLinked(LINK_SET, 207, btnname, toucherid);
                    }
                    if (llGetSubString(selection,-1,-1) == "-"){
                        llMessageLinked(LINK_SET, -802, path, toucherid);
                    }else{
                        DoMenu(toucherid, path, "", page);
                    }
                }
            }
        }else if (num == -902){
            index = llListFindList(dialogids, [id]);
            if (~index){
                dialogids = llDeleteSubList(dialogids, index, index + 2);
            }
            if (cur2default == "on" && llGetListLength(SeatedAvs()) < 1){
                llMessageLinked(LINK_SET, 200, defaultPose, NULL_KEY);
            }
        }else if (num==-240){
            list optionsToSet = llParseStringKeepNulls(str, ["~"], []);
            stop = llGetListLength(optionsToSet);
            for (; n<stop; ++n){
                list optionsItems = llParseString2List(llList2String(optionsToSet, n), ["="], []);
                string optionItem = llList2String(optionsItems, 0);
                string optionSetting = llList2String(optionsItems, 1);
                if (optionItem == "menuonsit") {curmenuonsit = optionSetting;}
                else if (optionItem == "permit") {Permissions = [llToUpper(optionSetting)];}
                else if (optionItem == "2default") {cur2default = optionSetting;}
                else if (optionItem == "sit2getmenu") {menuReqSit = optionSetting;}
                else if (optionItem == "facialExp"){
                    Facials = optionSetting;
                    llMessageLinked(LINK_SET, -241, Facials, NULL_KEY);
                }else if (optionItem == "rlvbaser"){
                    RLVenabled = optionSetting;
                    llMessageLinked(LINK_SET, -1812221819, "RLV=" + RLVenabled, NULL_KEY);
                }
            }
        }else if (num == -888){
            if (str == "admin"){
                path += ":" + str;
                AdminMenu(toucherid, path, "", adminbuttons);
            }else if (str == "ChangeSeat"){
                
                
                
                path = path + ":" + str;
                AdminMenu(toucherid, path,  "Where will you sit?", slotbuttons);
            }else if (str == "offset"){
                
                path = path + ":" + str;
                AdminMenu(toucherid, path,   "Adjust by " + (string)currentOffsetDelta
                 + "m, or choose another distance.", offsetbuttons);
            }else if (str == "sync"){
                llMessageLinked(LINK_SET, 206, "", "");
                DoMenu(toucherid, path, "", 0);
            }
        }else if (num == -800){
            toucherid = id;
            DoMenu(toucherid, str, "", 0);
        }else if (num == -801){
            toucherid = id;
            DoMenu_AccessCtrl(toucherid, "Main", "", 0);
        }else if(num == -238){

        }else if (num==35353){
            list slotsList = llParseStringKeepNulls(str, ["^"], []);
            slots = [];
            for (n=0; n<(llGetListLength(slotsList)/8); ++n){
                slots += [(key)llList2String(slotsList, n*8+4), llList2String(slotsList, n*8+7)];
            }
        }else if (num==35354){
            slotbuttons = llParseString2List(str, [","], []);
            string strideSeat;
            for (n = 0; n < llGetListLength(slotbuttons); ++n){ 
                index = llSubStringIndex(llList2String(slotbuttons, n), "§");
                if (!index){
                    strideSeat = llGetSubString(llList2String(slotbuttons, n), 1,-1);
                }else{
                    strideSeat = llGetSubString(llList2String(slotbuttons, n), 0, index+-1);
                }
                slotbuttons = llListReplaceList(slotbuttons, [strideSeat], n, n);
            }
        }else if (num == 34334){
            llSay(0,"Memory Used by " + llGetScriptName() + ": " + (string)llGetUsedMemory() + " of " + (string)llGetMemoryLimit()
                 + ",Leaving " + (string)llGetFreeMemory() + " memory free.");
        }
    }

    changed(integer change){
        if (change & CHANGED_INVENTORY){
            BuildMenus();           
        }
        if (change & CHANGED_OWNER){
            llResetScript();
        }
        
        avs = SeatedAvs();
        if ((change & CHANGED_LINK) && (llGetListLength(avs)>0)){ 
            if (curmenuonsit == "on"){
                integer lastSeatedAV = llGetListLength(avs);  
                if (lastSeatedAV > curseatednumber){  
                
                    key id = llList2Key(avs,lastSeatedAV+-curseatednumber+-1);  
                    curseatednumber = lastSeatedAV;  
                    DoMenu_AccessCtrl(id, "Main", "", 0);  
                }
            }
        } 
        if ((change & CHANGED_LINK) && (cur2default == "on") && (!llGetListLength(avs))){ 
            llMessageLinked(LINK_SET, 200, defaultPose, NULL_KEY);
            curseatednumber=0;
        }
        curseatednumber=llGetListLength(avs);
    }
    on_rez(integer params){
        llResetScript();
    }
}

