key ourAgent;
string currentAnim;

integer hasPerms;

integer MSG_AGENT_PLAY_ANIM=395; // to notify the slave script
integer MSG_AGENT_STOP_ANIM=396;
integer MSG_ATTACH_AGENT = 398;
integer MSG_DETACH_AGENT = 399;
integer MSG_REGISTER_SITSCRIPT =383;
integer MSG_QUERY_SITSCRIPT = 385;
integer MSG_SYNC_ANIM=361;

integer MSG_ADJUST_POSROT=520;
integer MSG_TEMPORARY_POSROT=521;

integer MSG_MODE_ADJUST=368;

integer MSG_ADJUST_DETAILS=372;


vector o=ZERO_VECTOR;
vector r=ZERO_VECTOR;
integer hastimer;

integer is_adjusting;
integer cursormode;

key adjustID; //key of sitting avi (key to this pose script index)
key adjuster; //key of person adjusting (can be different)

float defaultFacialInterval = 3.5; //MLP does 0.5 - which seems overly short. 2.0 or 2.5 would repeat, somewhere 3+ or 3.5+ is full cycle. sleep animation needs short cycle to be anything, it's overriden since its special already.

//facial anims - MLP compatible index
list facialAnims = [
    "express_open_mouth",          // 1
    "express_surprise_emote",      // 2
    "express_tongue_out",          // 3
    "express_smile",               // 4
    "express_toothsmile",          // 5
    "express_wink_emote",          // 6
    "express_cry_emote",           // 7
    "express_kiss",                // 8
    "express_laugh_emote",         // 9
    "express_disdain",             // 10
    "express_repulsed_emote",      // 11
    "express_anger_emote",         // 12
    "express_bored_emote",         // 13
    "express_sad_emote",           // 14
    "express_embarrassed_emote",   // 15
    "express_frown",               // 16
    "express_shrug_emote",         // 17
    "express_afraid_emote",        // 18
    "express_worry_emote"          // 19
//    "SLEEP",                       // 20
//    "RANDOM"                       // 21
];

list randomFacials = [
    "express_open_mouth",
    "express_open_mouth",
    "express_open_mouth",
    "express_surprise_emote",
    "express_surprise_emote",
    "express_surprise_emote",
    "express_smile",
    "express_cry_emote",
    "express_kiss",
    "express_kiss",
    "express_laugh_emote"
    ];


integer currentFacial;
float facialInterval;
    
string extractFacial (string animation) {
    //extract the facial part from the animation - and run it
    //return the animation name
    //backward compatible, 2 formates
    //animname* - asterix denotes mouth open
    //animname::N - N denotes facial index
    //animname::N::F - F denotes repeat interval.
    currentFacial=0;
    facialInterval=0.0;
    string anim=animation;
    if (llGetSubString(animation, -1, -1)=="*") {
        currentFacial=1;
        anim=llDeleteSubString(animation, -1, -1);        
    } else {
        list l=llParseString2List (animation, ["::"], []);
        if (llGetListLength(l)>1) {
            //found facial data
            anim=llList2String(l,0);
            currentFacial=(integer)llList2String(l,1);
            facialInterval=(float)llList2String(l,2);
        }
    }
    //if we extracted facial parameters, start it right away
    if (currentFacial) {
        runFacial();
        //if interval, set the timer
        if (facialInterval); else
            facialInterval = defaultFacialInterval;
        llSetTimerEvent(facialInterval);
        
    }    
    //return animation part of the string
    return anim;
}

runFacial() {
    if (currentFacial) {
        string a;
        string b;
        if (currentFacial<20)
            a=llList2String(facialAnims, currentFacial-1);
        else
        if (currentFacial==20) {
            a=llList2String(facialAnims, 3);
            b=llList2String(facialAnims, 10);
            facialInterval=0.35;
        }
        else
        if (currentFacial==21) {
            a=llList2String(randomFacials, (integer)llFrand(llGetListLength(randomFacials)));
        }        
        else //22 or higher (...)
            a=llList2String(randomFacials, (integer)llFrand(llGetListLength(randomFacials)));
            
        if (hasPerms) {
            llStartAnimation(a);
            if (b)
                llStartAnimation(b); 
        }        
    }    
}

stopAnim() {
    vector acheck = llGetAgentSize(ourAgent);
    if (hasPerms) if (currentAnim) if (acheck != ZERO_VECTOR)
        llStopAnimation(currentAnim);
    currentFacial=0;
    facialInterval=0.0;   
}

runAnim() {
    if (hasPerms) if (currentAnim)
        llStartAnimation(currentAnim);
}

integer checkPerms() {
    if (llGetPermissionsKey()!=ourAgent) {
        hasPerms = FALSE;
        return FALSE;   
    }
    hasPerms=(PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION) == ((PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION) & llGetPermissions());
    return hasPerms;
}

queryPerms() {
    if (!checkPerms()) {
        //must query them
        llRequestPermissions(ourAgent, PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);   
    } else {
        stopDefAnims();
        if (currentAnim)
            llStartAnimation(currentAnim);
        getControls();   
    }
}

stopDefAnims() {
    //easy way would be:
    //llStopAnimation("sit");   
    //let's go for the hard way
    list a=llGetAnimationList(ourAgent);
    vector acheck = llGetAgentSize(ourAgent);
    integer i;
    for (i=0; i<llGetListLength(a); i++)
    
    if (acheck != ZERO_VECTOR)
        llStopAnimation(llList2Key(a,i));
}

register() {
    llMessageLinked (LINK_THIS, MSG_REGISTER_SITSCRIPT, llGetScriptName(), "");   
}

getControls() {
    llTakeControls (CONTROL_UP|CONTROL_DOWN|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT, TRUE, FALSE);
    //llInstantMessage (ourAgent, "Adjust your position with PGUP, PGDOWN and cursorkeys. Shift rotates.");   
    
    //don't whisp help yet. yes, we take controls, yes! but needs menu to activate adjustment on it, to dodge bugs.
    //actually, we now abuse this very same bug to adjust other avatars
    //in case LL ever fixes this bug, avi can only adjust own position
    //whispHelp(ourAgent);
}

parseControls (integer level, integer edge) {

    integer l = level; //hold down
    
    if ((CONTROL_UP|CONTROL_DOWN)==(l & edge & (CONTROL_UP | CONTROL_DOWN))) {
//        cursormode=!cursormode;
//        whispHelp(ourAgent);
//        whispHelp(adjuster);
        llRegionSayTo (adjuster, 0, "Adjusting stopped");
        adjustID=NULL_KEY;
        adjuster=NULL_KEY;
        return;   
    }
    
    if (is_adjusting) {
        integer cm=cursormode;
        if (l & edge & CONTROL_LEFT) 
            cursormode--;
        if (l & edge & CONTROL_RIGHT)
            cursormode++;
        if (cursormode<1)
            cursormode=3;
        if (cursormode>3)
            cursormode=1;
        if (cm!=cursormode)
//            whispHelp(ourAgent);        
            whispHelp(adjuster);        
    }

    
    if (cursormode==1) {//fine adjust    
        if (l & CONTROL_FWD) o+=<0,2,0>;
        if (l & CONTROL_BACK) o+=<0,-2,0>;
        if (l & CONTROL_ROT_LEFT) o+=<-2,0,0>;
        if (l & CONTROL_ROT_RIGHT) o+=<2,0,0>;
        if (l & CONTROL_UP) o+=<0,0,2>;
        if (l & CONTROL_DOWN) o+=<0,0,-2>;
    }
    else
    if (cursormode==2) {//90 degrees rotation    
        if (l & edge & CONTROL_FWD) r+=<0,90,0>;
        if (l & edge & CONTROL_BACK) r+=<0,-90,0>;
        if (l & edge & CONTROL_ROT_LEFT) r+=<0,0,-90>;
        if (l & edge & CONTROL_ROT_RIGHT) r+=<0,0,90>;
        if (l & edge & CONTROL_UP) r+=<90,0,0>;
        if (l & edge & CONTROL_DOWN) r+=<-90,-0,0>;
    }
    else
    if (cursormode==3) {//fine rotation    
        if (l & CONTROL_FWD) r+=<0,1,0>;
        if (l & CONTROL_BACK) r+=<0,-1,0>; 
        if (l & CONTROL_ROT_LEFT) r+=<0,0,-1>;
        if (l & CONTROL_ROT_RIGHT) r+=<0,0,1>;
        if (l & CONTROL_UP) r+=<1,0,0>;
        if (l & CONTROL_DOWN) r+=<-1,0,0>;
    }
    
    //if (l & edge & CONTROL_LEFT) r += <0,0,90>;
    //if (l & edge & CONTROL_RIGHT) r += <0,-90,0>;    
        
    if (!hastimer) {
        llSetTimerEvent (0.25);
        hastimer=TRUE;
    }
}

whispHelp (key id) {
    if (!is_adjusting) {
        if (!cursormode) {
            llRegionSayTo (id, 0, "Press PAGE-UP and PAGE-DOWN simultanious to fine adjust position");
        } else {
            llRegionSayTo (id, 0, "Use the cursor keys and up/down to adjust position. Changes made are temporary.");
        }        
    } else {
        if (!cursormode)
            llRegionSayTo (id, 0, "Use PAGE-UP and PAGE-DOWN to start adjusting");
        if (1==cursormode)
            llRegionSayTo (id, 0, "Mode: position (fine adjust). Use cursor keys and up/down to adjust position. Shift-left or shift-right to change mode. PAGE-UP and PAGE-DOWN simultanious will stop adjusting. Changes are persistant until system reset.");
        if (2==cursormode)
            llRegionSayTo (id, 0, "Mode: rotation (90 degrees) . Use cursor keys and up/down to adjust rotation. Shift-left or shift-right to change mode. PAGE-UP and PAGE-DOWN simultanious will stop adjusting. Changes are persistant until system reset.");
        if (3==cursormode)
            llRegionSayTo (id, 0, "Mode: rotation (fine adjust). Use cursor keys and up/down to adjust rotation. Shift-left or shift-right to change mode. PAGE-UP and PAGE-DOWN simultanious will stop adjusting. Changes are persistant until system reset.");
    }
}


default
{
    state_entry()
    {
        register();
    }

    link_message(integer sn, integer n, string m, key id) {
        if (n==MSG_ATTACH_AGENT) {
            if (m==llGetScriptName()) {
                if (ourAgent)
                    stopAnim();
                currentAnim="";   
                ourAgent = id;
                adjuster=NULL_KEY;
                adjustID=NULL_KEY;
                queryPerms();
            }
        }
        else
        if (n==MSG_DETACH_AGENT) {
            if (ourAgent==id) {
                llReleaseControls();
                stopAnim();
            }
            ourAgent=NULL_KEY;
            adjuster=NULL_KEY;
            adjustID=NULL_KEY;
            currentAnim="";   
        }
        else
        if (n==MSG_AGENT_PLAY_ANIM) {
            if (ourAgent==id) {
                stopAnim();
                currentAnim=extractFacial(m); //returns anim part. surely enough and accidentaly, MLP used the same approach! LOL!
                runAnim();
            }
        }
        else
        if (n==MSG_AGENT_STOP_ANIM) {
            if (ourAgent==id) {
                stopAnim();
                currentAnim="";    
            }   
        }
        else
        if (n==MSG_SYNC_ANIM) {
            if (ourAgent) {
                stopAnim();
                runAnim();
            }   
        }
        else
        if (n==MSG_QUERY_SITSCRIPT) {
            register();
            //llOwnerSay ("Registering");   
        }
        else
        if (n==MSG_MODE_ADJUST) {
            //this one obsolete, but not deleted yet.
            is_adjusting = (integer)m;
            if (!is_adjusting)
                cursormode=0;
            else
                cursormode=1;
            if (id==ourAgent)
                whispHelp(id);   
        }
        else
        if (n==MSG_ADJUST_DETAILS) {
            is_adjusting = id==llGetOwner(); //true for permanent adjustment (owner)
            cursormode=1;
            adjustID=(key)m;
            adjuster=id;
            if (adjustID==ourAgent)
                whispHelp(adjuster);            
        }

    }
    
    run_time_permissions(integer p) {
        if (checkPerms()) {
            stopDefAnims();
            if (currentAnim)
                llStartAnimation(currentAnim);   
            getControls();
        } 
    }
    
    control (key id, integer level, integer edge) {
        //if (id!=ourAgent)
        if (adjustID != ourAgent)
            return;
        parseControls (level, edge);   
    }
    
    timer () {
        llSetTimerEvent (0.);
        //multiplexing this timer
        //neither use is very time critical - no-one will mind facial reset when fineadjusting
                
        if (hastimer) {
            //agent is fine adjusting position. apply
            hastimer=FALSE;
            if (ZERO_VECTOR!=(o+r)) {
                if (is_adjusting)
                    llMessageLinked (LINK_THIS, MSG_ADJUST_POSROT, (string)(0.005*o)+"&"+(string)r, ourAgent);    
                else
                    llMessageLinked (LINK_THIS, MSG_TEMPORARY_POSROT, (string)(0.005*o)+"&"+(string)r, ourAgent);            
            }
            o=ZERO_VECTOR;
            r=ZERO_VECTOR;
        }
        
        if (currentFacial) {
            //re-run facial animation until expired
            runFacial();
            if (hasPerms)
                llSetTimerEvent (facialInterval);    
        }
        
    }
    
}
