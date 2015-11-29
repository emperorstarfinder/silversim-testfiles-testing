string version = "TMCP v0.56";

//Render menu

list menuNames;
list menuEntries; //menus that appear in 'auto' menu
list menuDetails;

//some hardcoded stuff that this script adds, not any menu. prefill.
list itemNames=["<<<",">>>","<BACK"];
list itemTypes=[7,7,7];

list menuHistory;
string currentMenu;
string currentPose="default";
string defaultPose="default";


integer channel=999; 
integer listenhandle;

integer mode_chat=1;
integer mode_adjust=0;
integer mode_menu=3; //user
integer mode_ball=0; //all

integer hibernate;

list rlvVictims;


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
integer MSG_DATA_LM=335;

integer MSG_DO_POSE=350;
integer MSG_DO_LM=351;
integer MSG_DO_SPECIAL=352;

integer MSG_DO_STOP=353;
integer MSG_DO_SWAP=354;
integer MSG_MENU_SWAP=355;
integer MSG_DO_SOUND=356;

integer MSG_DO_ADJUST=371;
integer MSG_MENU_ADJUST=370;


//integer MSG_SET_RUNNING=390;
//integer MSG_STORAGE_RESET=391;

integer MSG_SET_RUNNING=340;
integer MSG_STORAGE_RESET=341;


integer MSG_DATA_READY=309;

integer MSG_DATA_START_READ=301;

integer MSG_MENU_META=333;

integer MSG_DUMP_POSITIONS=389;
integer MSG_MODE_ADJUST=368;
integer MSG_MODE_CHAT=367;
integer MSG_MODE_BALLUSERS=366;
integer MSG_MODE_OFF=365;

integer MSG_UPDATE_POS=363;
integer MSG_ALL_UNSIT =381;

integer MSG_SET_DEFAULT_POSE = 359;
integer MSG_DO_DEFAULT_POSE = 358;

integer MSG_RLV_GRAB=308;
integer MSG_RLV_RELEASE=309;
integer MSG_RLV_VICTIM_LIST=307;

integer MSG_DO_MENU_CURRENTMENU = 305;

//incoming
integer MSG_DO_MENU_COMMAND = -12002;

verbose(string text) {
    //llOwnerSay (text);
    if (mode_chat)
        llSay (0, text);
}

string onOff(integer value) {
    if (value) return "On"; else return "Off";   
}

string aclMode(integer value) {
    if (0==value)
        return "ALL";
    else
    if (1==value)
        return "GROUP";
    else
    if (2==value)
        return "OWNER";
    else
    if (3==value)
        return "USER";
    else
        return "UNKNOWN";
}

reset(integer resetSelf) {
    integer i;
    for (i=0; i<llGetInventoryNumber(INVENTORY_SCRIPT); i++) {
        string s=llGetInventoryName(INVENTORY_SCRIPT, i);
        if (-1<llSubStringIndex(s, "~TMCP ")) {
            if (s!=llGetScriptName()) {
                llResetOtherScript(s);    
            }   
        }
    }
    if (resetSelf)
        llResetScript();        
}

setRunning(integer running) {
    integer i;
    for (i=0; i<llGetInventoryNumber(INVENTORY_SCRIPT); i++) {
        string s=llGetInventoryName(INVENTORY_SCRIPT, i);
        if (-1<llSubStringIndex(s, "~TMCP ")) {
            if (s!=llGetScriptName()) {
                llSetScriptState (s, running);
            }   
        }
    }
}


integer hasDialogAccess(key id) {
    
    //OWNER ALWAYS
    if (id==llGetOwner())
        return TRUE;
        
    if (-1<llListFindList(rlvVictims, [(string)id]))
        return FALSE;
        
    //ALL
    if ((!mode_menu)/* || (id==llGetOwner())*/)
        return TRUE; //little speed optimalization to avoid call to samegroup
        
    //USER
    if (mode_menu==3) {
        //user must be sitted to access, or no-one sitted at all
        integer someSit=FALSE;
        integer i;
        for (i=0; i<=llGetNumberOfPrims(); i++) {
            if (llGetLinkKey(i)==id)
                return TRUE;
            if (llGetAgentSize(llGetLinkKey(i)))
                someSit=TRUE;   
        }
        return (!someSit);
    }
    
    //GROUP
    return (mode_menu==1) && llSameGroup(id);
}

integer hasMenuAccess (key id, string menu) {
    //supposed to be trimmed already?
    if (id==llGetOwner())
        return TRUE;
    string access=
        llStringTrim(
            llList2String(
                llParseString2List(
                    llList2String(menuDetails, 1+llListFindList(menuDetails, [menu]) )
                , ["|"], [])
            , 0)
        , STRING_TRIM);
    if (access=="OWNER") {
        return id==llGetOwner();
    }
    if (access=="GROUP") {
        return (id==llGetOwner()) || llSameGroup(id);        
    }
    if (access=="USER") {
        integer i;
        for (i=0; i<=llGetNumberOfPrims(); i++)
            if (llGetLinkKey(i)==id)
                return TRUE;
        return FALSE;   
    }
    //defaults to all.. learn to edit notecards if you made an error.
    //future options might be a name or some. dunnow.
    return TRUE;
}

makeMenu(string name, key id) {
    
    if (id); else return; //might be invoked by remote scripts. can't pop menu's to none-avi's.
    
    //present user a fine menu   
    integer idx=0;
    
    integer offset;
    
    if ((name==">>>") || (name=="<<<")) {
        //offset making
        //rename to the last found menu
        /*
        if (name==">>>")
            offset+=10;
        if (name=="<<<")
            offset-=10;                   
        */
        menuHistory+=name; //next step will fix this
        //llOwnerSay ("history: "+(string)menuHistory);
    }
    
    integer ho=llGetListLength(menuHistory)-1;
    while ((ho>1) && (-1<llListFindList(["<<<", ">>>"], [llList2String(menuHistory, ho)])) ) {
        //adjust offset
        string s=llList2String(menuHistory, ho);
        if (s=="<<<")
            offset-=10;
        if (s==">>>")
            offset+=10;
        name=llList2String(menuHistory, ho-1);
        ho--;            
    }
    
        
    if (name) {
        idx=llListFindList(menuNames, [name]);
        if (idx<0) {            
            //llOwnerSay ("No menu entry for "+name);
            return;
        }
        
    } else {
        //make it main menu
        name=llList2String(menuNames, 0); //assume at least 1 menu item please.. else its bugged anyways.
        menuHistory=[];
    }

    currentMenu=name;
        
    integer i=llListFindList (menuHistory, [name]);
    if (i>=0) {
        //truncate rest from history, maybe we went back.
        menuHistory = llList2List(menuHistory, 0, i);   
    } else 
        menuHistory += name;

        
    list present=llCSV2List(llList2String(menuEntries, idx));

    if (llAbs(offset)>=(llGetListLength(present))) offset=0;
                                
    integer o=offset;
    while (o>0) {
        menuHistory += ">>>";
        o-=10;   
        if (o<0)
            o=0;
    }
    while (o<0) {
        menuHistory += "<<<";
        o+=10;   
    }
    
    string h=">>";
    for (i=0; i<llGetListLength(menuHistory); i++)
        h+="> "+llList2String(menuHistory,i)+" ";
    
    
    if (currentPose)
        h+="\n\nCurrent pose: "+currentPose;
    //todo somewhere. some better wrap around.
    
    
    if ((offset) || (llGetListLength(present)>12))
        present = llList2List(present, offset, offset+8) + ["<<<", ">>>", "BACK"];        
    
    if (llGetListLength(rlvVictims)) {
        h+="\nCaptured (RLV): ";
        for (i=0; i<llGetListLength(rlvVictims); i++)
            h+=llKey2Name((key)llList2String(rlvVictims, i))+"\n";
    }    
    
    //got our filled up menu here? prolly need to sort it, for now just present it
    //llOwnerSay (name+":"+llList2CSV(present));
    
    //invert our list
    list p;
    for (i=0; i<12; i+=3)
        p = p+llList2List (present, -i-3, -i-1);
    
    llDialog (id, "\n"+h+"\n\n"+version, p, channel);
}

processCommand (key id, string message) {
        integer typeidx=llListFindList (itemNames, [message]);
        string param;
        integer newMenu=TRUE;
        
        if (typeidx<0) {
            list l=llParseString2List(message, ["::"], []);
            message=llList2String(l,0);
            param=llList2String(l,1);
            typeidx=llListFindList (itemNames, [message]);
            //llOwnerSay ("Message "+message+" got param "+param);            
        }
        
        if (typeidx<0) {
            //llOwnerSay ("Error - no menu entry for "+message);
            return;    
        }
        
           
        integer type=llList2Integer(itemTypes, typeidx);
        //llOwnerSay ("Type for "+message+" is "+(string)type);
        if (type==TYPE_MENU) {
            if (hasMenuAccess(id, message)) {
                makeMenu(message, id);           
                newMenu=FALSE;                
            } else {
                llRegionSayTo (id, 0, "Access to menu "+message+" is denied.");
                //makeMenu(currentMenu, id);                   
                //return;
            }
        }
        else
        if (type==TYPE_POSE) {
            llMessageLinked (LINK_THIS, MSG_DO_POSE, message, "");
            currentPose=message;
            llMessageLinked (LINK_THIS, MSG_MENU_META,llList2String(menuDetails, 1+llListFindList(menuDetails, [currentMenu])), "");            
        }
        else
        if (type==TYPE_LM_NOMENU) {
            llMessageLinked (LINK_THIS, MSG_DO_LM, message, id);
            newMenu=FALSE;
        }
        else
        if (type==TYPE_LM_MENU) {
            llMessageLinked (LINK_THIS, MSG_DO_LM, message, id);
        }
        else
        if (type==TYPE_SOUND) {
            llMessageLinked (LINK_THIS, MSG_DO_SOUND, message, id);               
        }
        else
        //some built in messages
        if (type==TYPE_SPECIAL) {
        
            if  (message=="SWAP") {
                
                if ((integer)param) {            
                    llMessageLinked (LINK_THIS, MSG_DO_SWAP, param, id);
                }
                else {
                    llMessageLinked (LINK_THIS, MSG_MENU_SWAP, (string)channel, id);             
                    newMenu=FALSE;
                }
            }
            else
    
            if  (message=="STOP") {
                llMessageLinked (LINK_THIS, MSG_DO_STOP, "", id);
                newMenu=FALSE;
            }
            else
                
            if  (message=="BACK") {
                //check menu history
                string newM="";
                integer i=llGetListLength (menuHistory)-1;            
                while ((i>0) && (-1<llListFindList(["<<<", ">>>"], [llList2String(menuHistory, i)]))) i--;
                if (i>0) {
                    menuHistory=llList2List(menuHistory, 0, i);
                    newM=llList2String(menuHistory,i-1);                        
                }
                makeMenu(newM, id);
                newMenu=FALSE;
            }
            else
            if ((message=="<<<") || (message==">>>")) {
                //previous and next. let menumaker solve this.
                makeMenu(message, id);
                newMenu=FALSE;
            }
            else
            if (message=="<BACK") {
                //makeMenu(currentMenu, id);
            }
            else
            //anything we don't know off for some reason. include it anyways.
            if (message=="DUMP") {
                llMessageLinked (LINK_THIS, MSG_DUMP_POSITIONS, "", "");                   
            }
            else
            if (message=="CHAT") {
                mode_chat=!mode_chat;
                llMessageLinked (LINK_THIS, MSG_MODE_CHAT, (string)mode_chat, id);
                llRegionSayTo (id, 0, "Chat "+onOff(mode_chat));   
            }
            else
            if (message=="ADJUSTMODE") {
                mode_adjust=!mode_adjust;
                llMessageLinked (LINK_THIS, MSG_MODE_ADJUST, (string)mode_adjust, id);                
                llRegionSayTo (id, 0, "Adjusting : "+onOff(mode_adjust));   
            }
            else
            if  (message=="ADJUST") {
                
                if ((integer)param) {            
                    llMessageLinked (LINK_THIS, MSG_DO_ADJUST, param, id);
                }
                else {
                    llMessageLinked (LINK_THIS, MSG_MENU_ADJUST, (string)channel, id);             
                    newMenu=FALSE;
                }
            }            
            else
            if (message=="MENUUSERS") {
                mode_menu++;
                if (mode_menu>3)
                    mode_menu=0;
                llRegionSayTo (id, 0, "Menu access set to "+aclMode(mode_menu));                   
            }
            else
            if (message=="BALLUSERS") {
                mode_ball++;
                if (mode_ball>2)
                    mode_ball=0;
                llRegionSayTo (id, 0, "Usage access set to "+aclMode(mode_ball));                   
                llMessageLinked (LINK_THIS, MSG_MODE_BALLUSERS, (string)mode_ball, id);                                
            }
            else
            if (-1<llListFindList (["RESET", "RESTART", "RELOAD"], [message])) {
                llSay (0, "Reset sequence started... Touch me again in a few seconds to reload the configuration.");
                reset(TRUE);   
                newMenu=FALSE;
            }
            else
            if (message=="Z") {
                if ("+"==llGetSubString(param,0,0))
                    param=llGetSubString(param,1,-1);                
                llSetObjectDesc((string)((integer)llGetObjectDesc()+(integer)param)+llGetSubString(llGetObjectDesc(), llStringLength((string)((integer)llGetObjectDesc())), -1));
                llMessageLinked (LINK_THIS, MSG_UPDATE_POS, (string)mode_ball, id);                
            }
            else
            if (message=="OFF") {
                state Off;
                newMenu=FALSE;
            }
            else
            if (message=="SAVE") {
                defaultPose=currentPose;
                llMessageLinked (LINK_THIS, MSG_SET_DEFAULT_POSE, currentPose, "");
   
            }
            else
            if (message=="GRAB") {
                llMessageLinked (LINK_THIS, MSG_RLV_GRAB, "", id);
                newMenu=FALSE;                               
            }
            else
            if (message=="RELEASE") {
                llMessageLinked (LINK_THIS, MSG_RLV_RELEASE, "", id);                            
            }
            else {
                //forward to whoever handles it
                llMessageLinked (LINK_THIS, MSG_DO_SPECIAL, message, id);            
            }
        }  
                  
        if (newMenu)
            makeMenu(currentMenu, id);            
}


default
{
    state_entry()
    {
        state WaitTouch;
    }
}

state WaitTouch
{
    state_entry()
    {
        reset(FALSE);
        llSay (0,"TMCP resetted - Touch me to load the configuration");
    }    
    touch_start (integer n) {
        llSay (0,"TMCP startup - reading data");
        state reading_data;   
    }
}

    
state reading_data
{    
    state_entry() {
        llMessageLinked (LINK_THIS, MSG_DATA_START_READ, "", "");   
    }
    link_message (integer sn, integer n, string m, key id) {
        if (n==MSG_DATA_MENU) {
            //add action    
            menuNames+=m;
            menuEntries+=(string)id;
        } else
        if (n==MSG_DATA_MENU_DETAILS) {
            //add action    
            menuDetails+= [m, (string)id];
        } else
        
        if (n==MSG_DATA_TYPE) {
            //set type
            itemNames+=m;
            itemTypes+=(integer)((string)id);   
        }
        if (n==MSG_SET_RUNNING)
            state running;
    }
}

state running {
    state_entry()
    {
        llOwnerSay ("Menu ready. "+(string)llGetFreeMemory());
        channel=-(integer)llFrand(1309123)-492345;
        listenhandle=llListen (channel, "", "", "");
    }
    
    touch_start(integer total_number)
    {
        key id=llDetectedKey(0);
        if (!hasDialogAccess(id)) {
            if (mode_chat)
                llWhisper (0, "Sorry "+llKey2Name(id)+", but menu usage is limited to "+aclMode(mode_menu));
            return;   
        }        
        makeMenu("",id);
    } 
    
    listen (integer ch, string name, key id, string message) {
        
        if (!hasDialogAccess(id)) {
            if (mode_chat)
                llWhisper (0, "Sorry "+llKey2Name(id)+", but menu usage is limited to "+aclMode(mode_menu));
            return;   
        }
        
        if (hibernate) {
            setRunning(TRUE);
            hibernate=FALSE;   
        }
        
        //llSetTimerEvent (3600.);
        
        processCommand (id, message);
        
    }
    
    link_message (integer sn, integer n, string m, key id) {
        if (n==MSG_DO_MENU_COMMAND) {
            processCommand (id, m);    
        }   
        else
        if (n==MSG_DO_DEFAULT_POSE) {
            currentPose = defaultPose;   
        }
        else
        if (n==MSG_RLV_VICTIM_LIST) {
            if (m)
                rlvVictims=llCSV2List(m);   
            else
                rlvVictims=[];
        }
        else
        if (n==MSG_DO_MENU_CURRENTMENU) {
            makeMenu(currentMenu, id);   
        }
    }
    
    timer() {
        //inactivity detected, sleep all other scripts.        
        llSetTimerEvent(0.);
        hibernate=TRUE;
        setRunning(FALSE);   
    }
}

state Off {
    state_entry() {
        llMessageLinked (LINK_THIS, MSG_ALL_UNSIT, "", "");    
        llWhisper (0,"Switching off in 10... 9...");
        llSleep (5.0);
        setRunning(FALSE);        
        llSleep (5.0);
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);        
    }   
    
    touch_start(integer n) {
        key id=llDetectedKey(0);
        if (id==llGetOwner())
            state running;
        if ((mode_menu==1) && llSameGroup(id))
            state running;
        llRegionSayTo (id, 0, "Sorry, but this object is switched OFF. Ask the owner to turn it on.");
    }
    
    state_exit() {
        setRunning(TRUE);
        hibernate=FALSE; 
        llWhisper (0, "Switching on");
          
    }
    
}