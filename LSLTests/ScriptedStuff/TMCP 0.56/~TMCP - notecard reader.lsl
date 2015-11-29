//read MLP notecards
//see how much memory headroom we got after for other stuff

integer notecardidx;
key notecardkey;
integer notecardtype;
integer notecardline;
string notecardname;
list positions;
list tempMenu;
list menuNames;
list menuEntries; //menus that appear in 'auto' menu
list toMenu; //menus with pointers
list linkedMsg;

integer hasReset=FALSE; //indicates if there is a reset option in *some* menu. If absent, we add it for safety.


integer TYPE_MENU=1;
integer TYPE_POSE=2;
integer TYPE_LM_NOMENU=3;
integer TYPE_LM_MENU=4;
integer TYPE_IGNORE=5;
integer TYPE_SPECIAL=6;
integer TYPE_UNKNOWN=7;
integer TYPE_SOUND=8;

integer MSG_DATA_MENU=310;
integer MSG_DATA_MENU_DETAILS=311;
integer MSG_DATA_TYPE=320;
integer MSG_DATA_POSE=330;
integer MSG_DATA_POSITION=331;
integer MSG_DATA_PROP=332;
integer MSG_DATA_LM=335;

integer MSG_DO_POSE=350;
integer MSG_DO_LM=351;
integer MSG_DO_SPECIAL=352;

integer MSG_DO_STOP=353;
integer MSG_DO_SWAP=354;

integer MSG_SET_RUNNING=340;
integer MSG_STORAGE_RESET=341;
integer MSG_DATA_READY=309;

integer MSG_DATA_START_READ=301;

verbose(string text) {
    llOwnerSay (text);
}

startNotecard() {
    integer i;
    notecardline=0;    
    for (;notecardidx<llGetInventoryNumber(INVENTORY_NOTECARD); notecardidx++) {                
        //loop until we found appropiate card
        notecardname=llGetInventoryName(INVENTORY_NOTECARD, notecardidx);
        if (llGetSubString(notecardname,0,9)==".MENUITEMS") {
            //neato. go fetch it
            notecardtype=1;
            notecardkey=llGetNotecardLine(notecardname, 0);
            verbose ("Reading menu from "+notecardname);
            return;            
        }
        if (llGetSubString(notecardname,0,9)==".POSITIONS") {
            //neato. go fetch it
            notecardtype=2;
            notecardkey=llGetNotecardLine(notecardname, 0);
            verbose ("Reading positions from "+notecardname);
            return;            
        }     
        if (llGetSubString(notecardname,0,5)==".PROPS") {
            //neato. go fetch it
            notecardtype=3;
            notecardkey=llGetNotecardLine(notecardname, 0);
            verbose ("Reading properties from "+notecardname);
            return;            
        }     
        verbose ("Skipping "+notecardname);
        
    }
    //still here? then we'r done
    //verbose ("Done reading all notecards");
    postFixMenu();
    sendMenuItems();
    llSleep (2.0);
    llMessageLinked (LINK_THIS, MSG_SET_RUNNING, "", ""); //set to running
    verbose ("Ready.");
    //llOwnerSay ("Notecard reader free memory: "+(string)llGetFreeMemory());
}

addPose (string name, list data) {
    //add pose info.. link to position info exactly when again?   
    //positions+=[name, data];
    llMessageLinked (LINK_THIS, MSG_DATA_POSE, name, llDumpList2String(data, "|"));       
}

addMenuDetails (string name, list data) {
    //add menu details.. access, color of balls.
    llMessageLinked (LINK_THIS, MSG_DATA_MENU_DETAILS, name, llDumpList2String(data, "|"));       
}


addLM (string name, string data) {
    llMessageLinked (LINK_THIS, MSG_DATA_LM, name, data);   
}

setType (string name, integer type) {
    llMessageLinked (LINK_THIS, MSG_DATA_TYPE, name, (string)type);       
}

parseMenu() {
    //parse our temporary menu to a real menu;   
    //this is where the real stuff happens.
    integer i;
    string menuName=""; //MLP 1 compatability: don't add stuff to menu as long as menu name is empty. add poses though.
    list options;
    for (i=0; i<llGetListLength(tempMenu); i++) {
        string data=llList2String(tempMenu, i);
        integer posspace=llSubStringIndex(data, " ");
        string cmd=data;
        string param="";
        string option="";
        if (posspace>0) {
            cmd=llGetSubString(data,0,posspace-1);
            param=llGetSubString(data, posspace+1, -1);   
        }
        list paramsTmp=llParseString2List(param, ["|"], []);
        integer j;
        list params;
        for (j=0; j<llGetListLength(paramsTmp); j++)
            params+=llStringTrim(llList2String(paramsTmp, j), STRING_TRIM);
        //params are now nice seperated on |, still allowed to contain spaces in the middle but trimmed from the outside.
        string p1=llList2String(params, 0);
        string p2=llList2String(params, 1);
        string p3=llList2String(params, 2);
        //got our set of command and optional parameters now. let's test them.
        if (cmd=="MENU") {
            addMenuDetails (p1, llDeleteSubList(params,0,0));
            //menuEntries+=p1;
            menuName=p1; //additional params hint the number of available seats            
            setType (p1, TYPE_MENU);  
        } else
        if (cmd=="POSE") {
            addPose (p1, llDeleteSubList(params,0,0));   
            option = p1;
            setType (p1, TYPE_POSE);
        } else
        if (cmd=="SOUND") {
            addLM (p1, p2);   
            option = p1;
            setType (p1, TYPE_SOUND);
        } else
        if (-1 != llListFindList (["BACK", "STOP","SWAP","RESET","RESTART", "MENUUSERS", "BALLUSERS","ADJUST", "DUMP", "CHAT", "RELOAD", "OFF"], [cmd])) {
            //recognized simple options
            option = cmd;   
            setType (cmd, TYPE_SPECIAL);
            if (-1!= llListFindList (["RESET","RESTART", "RELOAD"], [cmd]))
                hasReset=TRUE;
        } else
        if (-1 != llListFindList (["SAVE", "CHECK"], [cmd])) {
            //recognized simple options
            option = cmd;   
            setType (cmd, TYPE_IGNORE);
        } else
        if (cmd=="TOMENU") {
            if (p1!="-")
                toMenu+=p1;
            option=p1;   
        } else
        if (cmd=="LINKMSG") {
            //linkedMsg+=[p1,p2];
            addLM (p1, p2);
            option=p1;
            if ((integer)p2)
                setType (p1, TYPE_LM_NOMENU);
            else
                setType (p1, TYPE_LM_MENU);
        } else
        if (-1<llListFindList(["Z+", "Z-"], [llGetSubString(cmd, 0, 1)])) {
            //Z command, we'll rewrite it
            option = "Z::"+llGetSubString(cmd, 1, -1);
            setType ("Z", TYPE_SPECIAL);
        }
        else
        if (-1<llListFindList (["GRAB", "Grab.Fem"], [cmd])) {
            option = "GRAB";
            setType ("GRAB", TYPE_SPECIAL);               
        }
        else
        if (-1<llListFindList (["Grab.Male","RELEASE"], [cmd])) {
            option = "RELEASE";
            setType ("RELEASE", TYPE_SPECIAL);                           
        }
        //todo.. fill in a bunch of MLP commands here, implemented or not
        else
        { //we checked all commands. Anything defined here is considered undefined and we list it just as is.
            option = cmd;
            //don't set type. it may be defined elsewhere.
            //setType (cmd, TYPE_UNKNOWN);            
        }
        if (menuName) if (option)
            options+=option;
    }
    tempMenu=[];
    if (options!=[]) {
        llOwnerSay ("Menu "+menuName +" ["+(string)llGetListLength(options)+"]");
        //menuAll+=options+"!--!";
        //menuAll+=[menuName,llList2CSV(options)];
        menuNames+=menuName;
        menuEntries+=llList2CSV(options);
    }
}

addMenuItem(string data) {
    integer posslash=llSubStringIndex(data, "//");
    if (posslash>=0) {
        data=llDeleteSubString(data, posslash, -1);
    }
    data=llStringTrim(data,STRING_TRIM);
    //llOwnerSay ("menu data: "+data);
    
    if (data=="") //comment or some but not empty line, silently ignore
        return;
    
    if (llGetSubString (data,0,3+1)=="MENU ") {
        //what a surprise, new menu. finish old one.
        parseMenu();
    }
    
    //what's left, add it to our temp menu. We'l parse it later.
    tempMenu+=data;
}

postFixMenu() {
    //on failed configurations - add some default stuff
    if (!llGetListLength(menuNames)) {
        
        llOwnerSay ("Warning - no reset function found in menu cards. Adding menu 'Reset'.");
        //add a default menu with a reset button.
        
        addMenuItem ("MENU Reset...|OWNER");
        addMenuItem ("RESET");
        parseMenu();
    }
    
    
    //dont add mainmenu
    list entries=llDeleteSubList(menuNames,0,0);
    
    integer i;
    
    //llOwnerSay ("PF entries: "+(string)entries);
    //llOwnerSay ("PF tomenu: "+(string)toMenu);    
    
    
    for (i=0; i<llGetListLength(toMenu); i++) {        
        integer j=llListFindList (entries, [llList2String(toMenu, i)]);
        if (j>-1) {
            entries=llDeleteSubList(entries, j, j);
        }        
    }
    //llOwnerSay ("PF entries after: "+(string)entries);
    
    list MainMenu=llCSV2List(llList2String(menuEntries, 0));
    for (i=0; i<llGetListLength(entries); i++) {
        integer j=llListFindList(MainMenu, ["-"]);
        if (j>-1) {
            MainMenu=llListReplaceList(MainMenu, [llList2String(entries, i)], j, j);            
        }   
    }
    
    i=llListFindList(MainMenu, ["-"]);
    while (-1<i) {
        MainMenu=llDeleteSubList(MainMenu, i, i);
        i=llListFindList(MainMenu, ["-"]);               
    }
    
    if (MainMenu)
        menuEntries = llListReplaceList(menuEntries, [llList2CSV(MainMenu)], 0, 0);
}

sendMenuItems() {
    //llOwnerSay ("Applying menu information");
    
    integer i;
    for (i=0; i<llGetListLength(menuNames); i++) {
        llMessageLinked (LINK_THIS, MSG_DATA_MENU, llList2String(menuNames, i), llList2String(menuEntries, i));            
        llSleep (0.25);
    }    
    
    llMessageLinked (LINK_THIS, MSG_DATA_READY, "Done", "TTP");    
}

addPosition(string data) {
    //some memory optimalization possible here in last half.
    integer curlyopen = llSubStringIndex(data, "{");
    integer curlyclose = llSubStringIndex(data, "}");
    if ((curlyopen<0) || (curlyclose<curlyopen))
        return;
    string pose=llGetSubString(data, curlyopen+1, curlyclose-1);
    data=llGetSubString(data, curlyclose+1, -1);
    list posrotsraw=llParseString2List(data, [">"], []);
    //llOwnerSay ("raw pos data "+data+" convert to "+(string)posrotsraw);
    
    list posrots;
    integer i;
    for (i=0; i<llGetListLength(posrotsraw); i++) {
        if (-1<llSubStringIndex (llList2String(posrotsraw,i), "<")) {
            list v=llParseString2List(llList2String(posrotsraw,i), ["<", ",", " "], []);         
            posrots += <(float)llList2String(v,0), (float)llList2String(v,1),(float)llList2String(v,2)>;
        }
    }
    //llOwnerSay ("position data for "+pose+" : "+(string)posrots);
    //positions+=[pose, llList2CSV(posrots)];
    list posrotshort;
    for (i=0; i<llGetListLength(posrots);i++)
        posrotshort+=shortVec(llList2Vector(posrots,i));
        
    llMessageLinked (LINK_THIS,MSG_DATA_POSITION, pose, llDumpList2String(posrotshort,"&"));
}

string shortString (float n) {
    string s=(string)n;
    while (llStringLength(s)>1) {
        integer hasdot=-1!=llSubStringIndex(s, ".");
        string d=llGetSubString(s,-1,-1);
        if ((hasdot && (d=="0")) || (d=="."))
            s=llDeleteSubString(s,-1,-1);
        else
            jump ok;   
    }
    @ok;
    return s;
}

string shortVec (vector v) {
    return "<"+shortString(v.x)+","+shortString(v.y)+","+shortString(v.z)+">";
}


vector str2vec (string vec) {
    list v=llParseString2List(vec, ["<", ",", " "], []);         
    return <(float)llList2String(v,0), (float)llList2String(v,1),(float)llList2String(v,2)>;    
}

addProp(string data) {
    //format:
    // | anim-name | property | position / rotation
    // no clue why MLP has such preference for odd formats. anyhows. flexible parsing
    list l=llParseString2List(data,["|","/"],[]);
    string pose=llStringTrim(llList2String(l,0), STRING_TRIM); 
    string prop=llStringTrim(llList2String(l,1), STRING_TRIM);
    string spos=llStringTrim(llList2String(l,2), STRING_TRIM);
    string srot=llStringTrim(llList2String(l,3), STRING_TRIM);
    vector pos=str2vec(spos);
    vector rot=str2vec(srot);
    list propdata=[prop,spos,srot];
    llMessageLinked (LINK_THIS,MSG_DATA_PROP, pose, llDumpList2String(propdata,"&"));        
}


default 
{
    state_entry() {
        
        //enable if you want to debug this script without waiting for signal:        
        
        //state ReadMenu;           
        
    }
    
    link_message (integer sn, integer n, string m, key id) {
        if (n==301)
            state ReadMenu;
    }
    
}

state ReadMenu
{
    state_entry()
    {
        llMessageLinked (LINK_THIS, MSG_STORAGE_RESET, "", ""); //reset data storage scripts
        llSleep (2.0);
        //fetch first notecard, go on from there
        startNotecard ();
    }
    
    dataserver(key id, string data) {
        //llOwnerSay ("card "+notecardname+" line "+(string)notecardline+" data "+data);
        
        if (id!=notecardkey)
            return; //not for us
            
        if (data==EOF) {
            if (notecardtype==1)
                parseMenu(); //clean up any menu leftovers
            //read next notecard
            notecardidx++;
            startNotecard();
        } else   
        {
            if (notecardtype==1)
                addMenuItem(data);
            else
            if (notecardtype==2)
                addPosition(data);
            else
            if (notecardtype==3)
                addProp(data);
            notecardkey=llGetNotecardLine(notecardname, ++notecardline);

        }
    }
}
