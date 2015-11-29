//keeps track of sitted target, position them and animate them.

list animPool; //pool of scripts that are able to pose targets

list poolCache; //try re-use same script for same agent, to avoid reasking permissions

list sitted; //strided, holds: AGENT_KEY, logical offset (`ball number`), [animscript?], current animation?, current position?
integer sittedStride=3;

list sittedAgents;
list sitScripts;

integer MSG_AGENT_UNSIT = 380;
integer MSG_ALL_UNSIT =381;
integer MSG_ENABLE_SITTING=386;
integer MSG_DISABLE_SITTING =382;
integer MSG_REGISTER_SITSCRIPT =383;
integer MSG_QUERY_SITSCRIPT = 385;
integer MSG_STORAGE_RESET =341;
integer MSG_SET_SITTARGET=375;
integer MSG_PLAY_ANIM=390;
integer MSG_STOP_ANIM=391;
integer MSG_AGENT_PLAY_ANIM=395; // to notify the slave script
integer MSG_AGENT_STOP_ANIM=396;
integer MSG_ATTACH_AGENT = 398;
integer MSG_DETACH_AGENT = 399;
integer MSG_RUN_ANIMS=379;

integer MSG_DO_STOP=353;
integer MSG_DO_SWAP=354;
integer MSG_MENU_SWAP=355; 

integer MSG_DO_ADJUST=371;
integer MSG_MENU_ADJUST=370;
integer MSG_ADJUST_DETAILS=372;


integer MSG_MENU_META=333;

integer MSG_MLP_SITTED=-11000;
integer MSG_MLP_UNSITTED=-11001;

integer MSG_MODE_BALLUSERS=366;

integer MSG_DO_DEFAULT_POSE = 358;

integer MSG_RLV_GRAB=308;
integer MSG_RLV_RELEASE=309;
integer MSG_RLV_VICTIM_LIST=307;

integer MSG_DO_MENU_CURRENTMENU = 305;






//keys to controlling:
//animname+index is key to both real animation name and it's position.

list agentAnims;

list agentScripts;
list agentScriptCache;

list agentPoseIdx;

list usedIndexes; //logical pose positions, register in here.

integer MAX_SITTING=1;

string currentAnim;
integer currentAnimSeats;

list menuMeta;

integer mode_ballusers;

key grabberID;

list potentionalVictims;
list victimsWithRelay;

list grabbingVictims; //commanded to, but not yet suited
list grabbedVictims; //victims tagged as victim, sitted

integer CAPTURE_RANGE = 35;
integer RELAY_CHANNEL = -1812221819;
integer relay_handle;

integer timer_reason_versioncheck;
integer rlv_victim_dialog_handle;
integer rlv_victim_dialog_channel;

integer timer_versioncheck=50;
integer timer_closechannel=51;
integer timer_closechannel2=53;
integer timer_defaultpose=52;
integer timer_cleargrabbing=55;


assignScript (key id) {
    integer i=llListFindList (agentScripts, [id]);
    if (i>=0) //agent already got assignment
        return;    
    i=llListFindList (agentScriptCache, [id]);
    string candidate;
    if (i>=0) {
        candidate=llList2String(agentScriptCache, i+1);
        if (-1!=llListFindList(agentScripts, [candidate]))
            candidate="";
    }
    if (candidate);else {
        //try to find a new one
        for (i=0; i<llGetListLength(sitScripts); i++) {
            string ss=llList2String(sitScripts, i);
            if (-1==llListFindList(agentScripts, [ss])) {//found free one
                candidate=ss;   
                jump break;
            }
        }
        @break;        
    }
    if (candidate) {
        agentScripts+=[id, candidate];
        i=llListFindList (agentScriptCache, [candidate]);
        if (-1<i) 
            agentScriptCache=llDeleteSubList(agentScriptCache, i-1, i);    
        agentScriptCache+=[id, candidate];
        //llOwnerSay ((string)id+" attached to "+candidate);
        llMessageLinked(LINK_THIS, MSG_ATTACH_AGENT, candidate, id);
    } else {
        llRegionSayTo (id, 0, "Sorry, but there is no available script to animate your avatar.");
    }
}

integer assignPoseIdx (key id) {
    //start counting at 1.. just because we can.
    integer i=llListFindList (agentPoseIdx, [id]);
    if (-1<i)
        return llList2Integer(agentPoseIdx, i+1); //agent already got a pose assigned
    //see if agent sat on linked prim, and if so, if it gots an idx
    
    //todo:
    //there is llAvatarOnLinkSitTarget now, might want to use that.    
    vector avpos=llList2Vector(llGetObjectDetails(id, [OBJECT_POS]),0)-<0.0,0.0,0.01>;
    integer j;
    float dist=100000;
    list fitidx;
    for (j=2; j<=llGetNumberOfPrims(); j++) {
        key id2=llGetLinkKey(j);
        if (llGetAgentSize(id2));
        else {
            vector lpos=llList2Vector(llGetLinkPrimitiveParams(j, [PRIM_POSITION]),0);            
            float d=llVecDist(lpos, avpos);
            if (d<dist) {
                //see if description has and index
                integer idx=(integer)((string)llGetLinkPrimitiveParams(j, [PRIM_DESC]));
                if (idx) {
                    dist=d;
                    fitidx=[idx]+fitidx;
                }
            }
        }
    }
    //llOwnerSay (llList2CSV(fitidx));
    //based on fit, see if it's still free
    for (i=0; i<llGetListLength(fitidx); i++) {
        integer idx=llList2Integer(fitidx, i);
        if (!~llListFindList(agentPoseIdx, [idx])) {
            agentPoseIdx+=[id, idx];
            return idx;
        }
    }
    //still not found? assign first available.
    for (i=1; i<100; i++) {
        if (-1==llListFindList(agentPoseIdx, [i])) //found empty one
        {
            agentPoseIdx+=[id, i];   
            //llInstantMessage (id, "You are assigned to pose index "+(string)i);
            return i;
        }
    }
    return 0;
}

dropAgent (key id) {
    //clean up stuff agent had
       
}

stopAnims(key id) {
    llMessageLinked (LINK_THIS, MSG_AGENT_STOP_ANIM, "", id);
}

applyAnims() {
    //apply animation (and position?) for all agents involved
    
    //send list of keys with indexes to position. it should know which anim is current.
    llMessageLinked (LINK_THIS, MSG_RUN_ANIMS, llList2CSV(agentPoseIdx), "");
    //llOwnerSay ("anims/poses "+llList2CSV(agentPoseIdx));
       
}

cleanUp(key id) {
    stopAnims(id);
    integer i=llListFindList (agentScripts, [id]);
    if (-1<i)
        agentScripts = llDeleteSubList (agentScripts, i, i+1);
    i=llListFindList (agentPoseIdx, [id]);
    if (-1<i)
        agentPoseIdx = llDeleteSubList (agentPoseIdx, i, i+1);

    i=llListFindList (grabbedVictims, [id]);
    if (-1<i)
        grabbedVictims = llDeleteSubList (grabbedVictims, i, i);
           
}

setSitTarget() {
  //needs pose info.. so we calculate the first available index, and match info with current pose.. it's for position script, i think.
    //linkedmessage (setsittarget, [posename,] index)..    
    //posename might be cached by positioner and/or set to defaults.
    integer idx=1;
    //find first available
    while (-1<llListFindList(agentPoseIdx, [idx]))
        idx++;
    if (idx>MAX_SITTING) {
        llSitTarget (ZERO_VECTOR, ZERO_ROTATION/llGetRot());   
    } else {
        llSitTarget (<0,0,0.01>, ZERO_ROTATION/llGetRot()); //backup option.
        //fixes sitting at greater heights, and allows targeted sitting:
        integer i;
        
        
        for (i=2; i<=llGetNumberOfPrims(); i++) {
            rotation linkrot=llList2Rot(llGetLinkPrimitiveParams(i, [PRIM_ROTATION]),0);
            llLinkSitTarget(i, <0.0,0.0,0.01>, ZERO_ROTATION/linkrot);
        }
        
        llMessageLinked(LINK_THIS, MSG_SET_SITTARGET, (string)idx, "");
    }
    
}

integer maySit(key id) {
    if (!mode_ballusers) //everyone
        return TRUE;
    if (id==llGetOwner()) //always
        return TRUE;
    if (mode_ballusers==1) //group
        return llSameGroup(id);
    return FALSE; //nope
}

broadcastVictims() {
    llMessageLinked (LINK_THIS, MSG_RLV_VICTIM_LIST, llList2CSV(grabbedVictims), "");   
}

requestMenu(key id) {
    llMessageLinked (LINK_THIS, MSG_DO_MENU_CURRENTMENU, "", id);      
}

inventarise() {
    //someone sitted or unsitted. do the bookkeeping
    list agents;
    integer i;
    
    //get sitted avatars
    for (i=0; i<=llGetNumberOfPrims(); i++) {
        key id=llGetLinkKey(i);
        if (llGetAgentSize(id)) {
            //this is an agent..
            agents+=id;
            if (-1!=llListFindList(grabbingVictims, [id])) {
                //grabbingVictims=[]; //should really do this somewhere else
                if (-1==llListFindList(grabbedVictims, [id])) {
                    rlv_lock(id);
                    grabbedVictims+=id;
                    broadcastVictims();
                }
            }   
        }
    }
    
    //now cross reference against existing agents
    //first see, who's all gone
    for (i=0;i<llGetListLength(sittedAgents); i++) {
        key id=llList2Key(sittedAgents, i);
        if (-1==llListFindList(agents, [id])) {
            //agent unsitted, remove him
            msgUnsit(id, llList2Integer(agentPoseIdx, llListFindList(agentPoseIdx, [id])+1));
            if (-1!=llListFindList(grabbedVictims, [id])) {
                //rlv catch, unlock it
                rlv_release(id);   
            }
            cleanUp(id);                           
            broadcastVictims();            
        }
    }
    
    //now, lets see who's all added
    for (i=0;i<llGetListLength(agents); i++) {
        key id=llList2Key(agents, i);
        if (-1==llListFindList(sittedAgents, [id])) {
            //freshy added, assign it a script, if possible, and a logical offset
            if (maySit(id)) {
                assignScript(id);
                msgSit(id, assignPoseIdx(id));
            } else {
                llUnSit(id);
                llWhisper (0, "Sorry "+llKey2Name(id)+" but you cannot use this object.");
            }
            //play anim 
            
        }
    }

//    if (sittedAgents != agents)
//        setSitTarget();    
    sittedAgents = agents;
    setSitTarget();
    applyAnims();
    
    // default pose switching on idle
    if (agents==[])
        scheduleEvent (timer_defaultpose, 120, "");
    else
        cancelEvent (timer_defaultpose);
}

makeSwapMenu(key id, integer channel) {
    //offer nice swap menu
    //list sitted avatars
    string text="";
    integer i;
    integer m=10;
    list buttons=["<BACK"];
    if (MAX_SITTING<m)
        m=MAX_SITTING;
    for (i=1; i<=m; i++) {
        integer j=llListFindList(agentPoseIdx, [i]);
        string agent = "<Nobody>";
        key aid;
        if (-1<j) {
            aid=llList2Key(agentPoseIdx, j-1);
            agent=llKey2Name(aid);
        }
        text+=(string)i + ". " + llList2String(menuMeta, i) + " "+agent+"\n";
                   
        if (aid!=id)
            buttons+=["SWAP::"+(string)i];
    }
    llDialog (id, text, buttons, channel);       
}

makeAdjustMenu(key id, integer channel) {
    //offer nice swap menu
    //list sitted avatars
    string text="Choose a position to adjust.\n\n";
    integer i;
    integer m=10;
    list buttons=["<BACK"];
    if (MAX_SITTING<m)
        m=MAX_SITTING;
    for (i=1; i<=m; i++) {
        integer j=llListFindList(agentPoseIdx, [i]);
        string agent = "";
        key aid;
        if (-1<j) {
            aid=llList2Key(agentPoseIdx, j-1);
            agent=llKey2Name(aid);
        }
                   
        if (agent) {
            text+=(string)i + ". " + llList2String(menuMeta, i) + " "+agent+"\n";            
            buttons+=["ADJUST::"+(string)i];
        }
    }
    llDialog (id, text, buttons, channel);       
}


//consideration: send out sit/unsit events or not.. i think, might as well not. in order not to confuse rlv.
swapAgent (key id, integer newpos) {
    //llSay (0, "Swapping "+llKey2Name(id)+" to position #"+(string)newpos);
    integer o=llListFindList(agentPoseIdx, [id]);
    if (o<0) {
        //llOwnerSay ("swap key not found "+(string)id);
        //agent not found. see if we have a rlv target
        if (llGetListLength(grabbedVictims)) {
            //just default to first best sitted. Stuff gets complex with multiple RLV but who cares that.
            id=llList2Key(grabbedVictims,0);
            o=llListFindList(agentPoseIdx, [id]);
            if (o<0) //OUCH, should nevah happen
                return;            
        }        
        else return;
    }
    integer oldidx=llList2Integer(agentPoseIdx, o+1);
    if (oldidx==newpos) {
        llRegionSayTo (id, 0, "You choosen the same position");
        return;
    }
    agentPoseIdx=llDeleteSubList(agentPoseIdx, o, o+1);
    integer topos=llListFindList(agentPoseIdx, [newpos]);
    if (~topos) {
        agentPoseIdx=llDeleteSubList(agentPoseIdx, topos-1, topos) + [llList2Key(agentPoseIdx, topos-1),oldidx];        
    } else {
        //no swap, means balls alpha might change
        alphaBall(oldidx, 1.0);
        alphaBall(newpos, 0.0);
    }
    agentPoseIdx += [id, newpos];
    applyAnims();
}

adjustAgent (key id, integer pos) {
    integer fpos=llListFindList(agentPoseIdx, [pos]);
    if (~fpos) {
        key adjustID=llList2Key(agentPoseIdx, fpos-1);
        llSay (0, "Adjusting #"+(string)pos+" "+llGetDisplayName(adjustID));        
        //inform pose scripts
        //only pose script holding this avatar seated responds to (any) adjustment commands, all others cancel adjust mode after this message
        llMessageLinked(LINK_THIS, MSG_ADJUST_DETAILS, adjustID, id);        
    }
}


unsitAll() {
    integer i;
    for (i=0; i<=llGetNumberOfPrims(); i++) {
        key id=llGetLinkKey(i);
        if (llGetAgentSize(id))
            llUnSit(id);    
    }   
}

alphaBall (integer index, float alpha) {
    integer i;
    string name="ball "+(string)index;
    for (i=1; i<=llGetNumberOfPrims(); i++) {
        if (~llSubStringIndex(llToLower(llGetLinkName(i)), name)) {
            llSetLinkAlpha (i, alpha, ALL_SIDES);
        }        
        //second way, description only
        if (index == (integer)((string)llGetLinkPrimitiveParams(i, [PRIM_DESC])) )
            llSetLinkAlpha(i, alpha, ALL_SIDES);
    }
}

msgSit(key id, integer poseidx) {
    //we start count at 1, mlp at zero. fix right here
    llMessageLinked(LINK_THIS, MSG_MLP_SITTED, (string)(poseidx-1), id);   
    alphaBall(poseidx, 0.0);    
}

msgUnsit(key id, integer poseidx) {
    //we start count at 1, mlp at zero. fix right here
    llMessageLinked(LINK_THIS, MSG_MLP_UNSITTED, (string)(poseidx-1), id);   
    alphaBall (poseidx, 1.0);
}

log(string t){
    //llOwnerSay(t);
}

RLVGrabMenu(key id) {
    grabberID = id;
    llSensor("", NULL_KEY, AGENT, CAPTURE_RANGE, TWO_PI);    
//    llInstantMessage (id, "Scanning ... menu in 5.. 4.. 3..");
}

RLVReleaseAll() {
    integer i;
    for (i=0; i<llGetListLength(grabbedVictims); i++) {
        key id=llList2Key(grabbedVictims,i);
        rlv_release (id);
        llWhisper (0,"releasing "+llKey2Name(id));
        //unsit?
        llUnSit(id);
    }
    grabbedVictims=[];
}

rlv_checkversion (key id) {
    rlv_relay(id, "!version=" + (string)1);    //version_handle
}

 
rlv_capture(key avatar)
{
    rlv_relay(avatar, "@sit:" + (string)llGetKey() + "=force");
    //llSay (menu_ban_channel, "- "+(string)avatar);    
    llWhisper (0, llKey2Name(grabberID)+" captures "+llKey2Name(avatar));
}

 
rlv_lock(key avatar)
{
    rlv_relay(avatar, "@unsit=n");
}
 
rlv_release(key avatar)
{
    rlv_relay(avatar, "@unsit=y");
    rlv_relay(avatar, "!release");
    //llSay (menu_ban_channel, "- "+(string)avatar);    
}
 
// write a message to the RLV Relay
rlv_relay(key avatar, string message)
{
    if (avatar != NULL_KEY)
    {
        llSay(RELAY_CHANNEL, llEscapeURL(llGetObjectName()) + "," + (string) avatar + "," + message);
        log("RLV: " + llGetObjectName() + "," + (string) avatar + "," + message);
    }
}

//scheduler

list events = [];
integer nextEvent = 0;

scheduleEvent(integer id, integer time, string data) {
    //adjust timestamp
    time+=llGetUnixTime();
    
    //cancel any previous requests, this case we only want one per type, really
    cancelEvent(id);    
    
    events = llListSort(events + [time, id, data], 3, TRUE);
    setTimer(FALSE);
}

cancelEvent(integer id) {
    //reasonable failsafe as long as you don't use id's that could be current timestamp.    
    integer i=llListFindList(events, [id]);
    if ((-1<i) && ((i % 3) == 1)) {
        //it was an id
        events=llDeleteSubList(events, i-1, i+1);
        
        //recurse when found, delete all with said id... ?
        cancelEvent(id);
        
        setTimer(FALSE);
    }
}

integer setTimer(integer executing) {
    if ((events != []) > 0) { // Are there any list items?
        integer id = llList2Integer(events, 1);
 
        integer time = llList2Integer(events, 0);
        nextEvent = id;
 
        float t = (float)(time - llGetUnixTime());
        if (t <= 0.0) {
            if (executing) return TRUE;
            else t = 0.01;
        }
        llSetTimerEvent(t);
    } else {
        llSetTimerEvent(0.0);
        nextEvent = -1;
    }
    return FALSE;
}

handleEvent(integer id, string data) {

    if (id==timer_versioncheck) {
            //time to display our dialog
            if ([]==victimsWithRelay) {
                llRegionSayTo (grabberID, 0, "No eligible victims found (they must wear a relay).");
                requestMenu(grabberID);
            } else {
                list nn;
                integer i;
                for (i=0; (i<llGetListLength(victimsWithRelay)) && (i<23); i+=2) {
                    string s=llKey2Name(llList2Key(victimsWithRelay, i));
                    if (s)
                        nn+=llGetSubString(s,0,23);                     
                }
                
                llListenControl(rlv_victim_dialog_handle, TRUE);          
                scheduleEvent (timer_closechannel, 90, (string)rlv_victim_dialog_handle);
                llDialog (grabberID, "Choose a victim", nn, rlv_victim_dialog_channel);
                //scheduleEvent (timer_versioncheck, 5, "");                 
            }  

            //set timer to new timeout
            
            //llSetTimerEvent(TIMER_TIMEOUT);
            //llListenControl (version_handle, FALSE);            
            //return;   
    }
    else
    if ((id==timer_closechannel) || (id==timer_closechannel2)) {
        llListenControl ((integer)data, FALSE);            
    }
    else
    if (id==timer_defaultpose) {
        llMessageLinked(LINK_THIS, MSG_DO_DEFAULT_POSE, "", "");        
    }
    else
    if (id==timer_cleargrabbing) {
        grabbingVictims=[];   
    }
    
}


default
{
    state_entry()
    {
        llOwnerSay ("sitmanager memory free : "+(string)llGetFreeMemory());
        state active;  
    }
}

state active {   
    state_entry() {
        setSitTarget();
        llMessageLinked (LINK_THIS, MSG_QUERY_SITSCRIPT, "", "");
        
        rlv_victim_dialog_channel = 124904342+llFloor(llFrand(42902543));
        rlv_victim_dialog_handle = llListen(rlv_victim_dialog_channel, "", "", "");
        llListenControl (rlv_victim_dialog_handle, FALSE); 
        relay_handle=llListen(RELAY_CHANNEL, "", "", "");
        llListenControl(relay_handle, FALSE);   
    } 
    link_message(integer sn, integer n, string m, key id) {
        
        if (n==MSG_STORAGE_RESET)
            llResetScript();
        else
        if (n==MSG_ENABLE_SITTING) {
            //note: pose scripts registering themselves will update this.
            MAX_SITTING=llGetListLength(sitScripts);
            setSitTarget();
        }
        else
        if (n==MSG_AGENT_UNSIT) {
            //unsit agent                
            llUnSit(id);
        }
        else
        if (n==MSG_ALL_UNSIT) {
            //just kick everyone
            unsitAll();    
        }
        else
        if (n==MSG_DISABLE_SITTING) {
            //state inactive;
            MAX_SITTING=0;
            setSitTarget();
        }        
        
        else
        if (n==MSG_REGISTER_SITSCRIPT) {
            if (m)
            if (INVENTORY_SCRIPT==llGetInventoryType(m))
            if (-1==llListFindList(sitScripts, [m])) {
                sitScripts+=m;    
                MAX_SITTING=llGetListLength(sitScripts);
            }
        }
        
        else
        if (n==MSG_PLAY_ANIM) {
            currentAnim=m;
            applyAnims();   
        }
        else
        if (n==MSG_MENU_SWAP) {
            makeSwapMenu (id, (integer)m);   
        }
        else
        if (n==MSG_DO_SWAP) {
            swapAgent(id, (integer)m);   
        }
        if (n==MSG_MENU_ADJUST) {
            makeAdjustMenu (id, (integer)m);   
        }
        else
        if (n==MSG_DO_ADJUST) {
            adjustAgent(id, (integer)m);   
        }
        else
        if (n==MSG_MENU_META) {
            menuMeta=llParseString2List(m, ["|", " "], []);   
        }
        else
        if (n==MSG_DO_STOP) {
            llUnSit(id); //let changed event handle the rest   
        }
        else
        if (n==MSG_MODE_BALLUSERS) {
            mode_ballusers=(integer)m;   
        }
        else
        if (n==MSG_RLV_GRAB) {
            RLVGrabMenu(id);       
        }
        else
        if (n==MSG_RLV_RELEASE) {
            RLVReleaseAll();
        }
        
    }
    
    changed (integer c) {
        if (c & CHANGED_LINK) {
            //don't even bother about getting sitted or not or leaving..
            //just fetch all current avatars and match them against our list of known avis
            inventarise();   
        }
        
    }
    
    timer() {
        // Clear timer or it might fire again before we're done
        llSetTimerEvent(0.0);
 
        do {
            // Fire the event
            handleEvent(nextEvent, llList2String(events, 2));
 
            // Get rid of the first item as we've executed it
            integer l = events != [];
            if (l > 0) {
                if (l > 3)
                    events = llList2List((events = []) + events, 3, -1);
                else events = [];
            }
 
            // Prepare the timer for the next event
        } while (setTimer(TRUE));
    }    
    
    /*
    timer() {
        /* default pose.. do somewhere else please
        llSetTimerEvent(0.);
        llMessageLinked(LINK_THIS, MSG_DO_DEFAULT_POSE, "", "");   
        */
        /*
    }
    */
    
    no_sensor()
    {        
        llRegionSayTo (grabberID, 0, "No nearby potentional victims found");
        requestMenu(grabberID);
    }
 
    // some av in sensor range
    sensor(integer total_number)
    {
        //llListenControl (rlv_victim_dialog_handle, TRUE);
        //scheduleEvent (timer_closechannel, 120, (string)rlv_victim_dialog_handle);
        llListenControl (relay_handle, TRUE);
        scheduleEvent (timer_closechannel2, 7, (string)relay_handle);
        
        
        potentionalVictims=[];
        victimsWithRelay=[];
        integer i;
        for(i=0; i < total_number; i++)
        {
            key id = llDetectedKey(i);
            string name = llKey2Name(id);
            if (llStringLength(name) > 24)
            {
                name = llGetSubString(name, 0, 23);
            }
            potentionalVictims+=[id, name];
            rlv_checkversion(id);            
        }
 
        // show dialog if list contains names
        /*
        if (llGetListLength(sensor_names) > 0)
        {
            llListenControl(dialog_handle, TRUE);
            llSetTimerEvent(TIMER_TIMEOUT);
            llDialog(avatar_menu, MSG_CHOOSE_AV, sensor_names, dialog_channel);
        }
        */
        scheduleEvent (timer_versioncheck, 5, (string)grabberID);
        llRegionSayTo (grabberID, 0, "Verifying "+(string)total_number+" potentional victims. Menu in 5.. 4.. 3..");          }    
    
    listen (integer ch, string n, key id, string m) {
        if (ch==RELAY_CHANNEL) {
            if (-1!=llSubStringIndex(m, "version=")) {//bit dirty, we might catch other objects too
                //victims+=llGetOwnerKey(id);
                //victim selected, grab it   
                victimsWithRelay+=[llGetOwnerKey(id),llGetSubString(llKey2Name(llGetOwnerKey(id)),0,23)];                
            }            
        }
        else
        if (ch==rlv_victim_dialog_channel) {
            //victim selected, grab it
            integer i=llListFindList (victimsWithRelay, [m]);
            if (-1<i) {
                key vid=llList2Key(victimsWithRelay, i-1);
                rlv_capture (vid);
                if (-1==llListFindList(grabbingVictims, [vid])) {
                    grabbingVictims+=vid;
                }
                scheduleEvent (timer_cleargrabbing, 120, (string)id);                
            }
            requestMenu(grabberID);   
        }
        
    }
}

/*
state inactive {
    state_entry() {
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
    }   
    link_message(integer sn, integer n, string m, key id) {
        if (n==MSG_RESET)
            llResetScript();
        else
        if (n=MSG_ENABLE_SITTING)
            state active;
    }    
}
*/