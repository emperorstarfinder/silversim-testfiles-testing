// LSL script generated: FSUI-Lookup.lslp Sun Jan 24 18:17:34 Mitteleuropäische Zeit 2016

list menuStartItem = [];
list primMenuClicks = [];
list primMenuText = [];
list primScrollLinks = [];
integer primModeLink = 0;
integer primMenusLink = 0;
integer primMenuNameLink = 0;
integer primMoreButtons = 0;
list menuLinkIdLookup = [];
list otherAdminMenuLinkIds = [];
LookupPrimsInfo(){
    integer numberPrims = llGetNumberOfPrims();
    string linkName;
    list names;
    integer i = 0;
    integer j;
    (primMenuClicks = []);
    (primMenuText = []);
    (primScrollLinks = []);
    (primModeLink = 0);
    (primMenusLink = 0);
    (primMenuNameLink = 0);
    for ((i = 1); (i < numberPrims); (++i)) {
        (linkName = llGetLinkName((i + 1)));
        (names = llParseString2List(linkName,[",",":"],[]));
        if (((-1) != llListFindList(names,["MenuItem"]))) {
            (primMenuClicks = (((primMenuClicks = []) + primMenuClicks) + [(-1)]));
            (primMenuText = (((primMenuText = []) + primMenuText) + [(-1)]));
        }
    }
    for ((i = 1); (i < numberPrims); (++i)) {
        (linkName = llGetLinkName((i + 1)));
        (names = llParseString2List(linkName,[",",":"],[]));
        (j = llListFindList(names,["MenuItem"]));
        if (((-1) != j)) {
            (j = llList2Integer(names,(j + 1)));
            (primMenuClicks = llListReplaceList(primMenuClicks,[(i + 1)],(j - 1),(j - 1)));
        }
        (j = llListFindList(names,["MenuText"]));
        if (((-1) != j)) {
            (j = llList2Integer(names,(j + 1)));
            (primMenuText = llListReplaceList(primMenuText,[(i + 1)],(j - 1),(j - 1)));
        }
        if (((-1) != llListFindList(names,["Scroll"]))) (primScrollLinks = (((primScrollLinks = []) + primScrollLinks) + [(i + 1)]));
        if (((-1) != llListFindList(names,["HScroll"]))) (primScrollLinks = (((primScrollLinks = []) + primScrollLinks) + [(i + 1)]));
        if (((-1) != llListFindList(names,["MenuName"]))) (primMenuNameLink = (i + 1));
        if (((-1) != llListFindList(names,["Mode"]))) (primModeLink = (i + 1));
        if (((-1) != llListFindList(names,["Numbers"]))) (primMenusLink = (i + 1));
        if (((-1) != llListFindList(names,["Half"]))) (primMoreButtons = (i + 1));
    }
    (menuLinkIdLookup = [(-1)]);
    (menuStartItem = []);
    (otherAdminMenuLinkIds = []);
    for ((i = 0); (i < 10); (i++)) {
        (menuLinkIdLookup = (((menuLinkIdLookup = []) + menuLinkIdLookup) + [((305410560 + i) + 1)]));
        (menuStartItem = (((menuStartItem = []) + menuStartItem) + [0]));
        (otherAdminMenuLinkIds = (((otherAdminMenuLinkIds = []) + otherAdminMenuLinkIds) + [(((121234200 + 200) + i) + 1)]));
    }
    (menuStartItem = (((menuStartItem = []) + menuStartItem) + [0]));
    (menuLinkIdLookup = (((menuLinkIdLookup = []) + menuLinkIdLookup) + [12123411]));
    (menuLinkIdLookup = (((menuLinkIdLookup = []) + menuLinkIdLookup) + [12123412]));
    (otherAdminMenuLinkIds += [12123413,12123414,12123415,12123416,12123417,12123418,12123420,12123424,12123425,12123427]);
    llOwnerSay("/* START: The following constants were calculated by FSUI-Lookup and placed here as constants */");
    llOwnerSay("/* If the constants change - we need to regenerate this set of lists */");
    llOwnerSay((("#define PRIMMENUCLICKS [" + llDumpList2String(primMenuClicks,",")) + "]"));
    llOwnerSay(("#define PRIMMENUCLICKSITEM5 " + llList2String(primMenuClicks,5)));
    llOwnerSay((("#define PRIMMENUTEXT [" + llDumpList2String(primMenuText,",")) + "]"));
    llOwnerSay((("#define PRIMSCROLLLINKS [" + llDumpList2String(primScrollLinks,",")) + "]"));
    llOwnerSay(("#define PRIMMENUNAMELINK " + ((string)primMenuNameLink)));
    llOwnerSay(("#define PRIMMODELINK " + ((string)primModeLink)));
    llOwnerSay(("#define PRIMMENUSLINK " + ((string)primMenusLink)));
    llOwnerSay(("#define PRIMMOREBUTTONS " + ((string)primMoreButtons)));
    llOwnerSay((("#define MENULINKIDLOOKUP [" + llDumpList2String(menuLinkIdLookup,",")) + "]"));
    llOwnerSay((("#define OTHERADMINMENULINKIDS [" + llDumpList2String(otherAdminMenuLinkIds,",")) + "]"));
    llOwnerSay("#define NUMBEROFLINES Define_DefaultNumberLines");
    llOwnerSay((("list menuStartItem = [" + llDumpList2String(menuStartItem,",")) + "]"));
    llOwnerSay("/* END: The following constants were calculated by FSUI-Lookup and placed here as constants */");
}
default {

 state_entry() {
        LookupPrimsInfo();
    }
}
