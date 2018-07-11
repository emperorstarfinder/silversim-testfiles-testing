//start_unprocessed_text
/*/|*
    
    This script handles:
    - Stripping
    - Vibrated chairs

*|/
#include "switch/classes/packages/sw RLV.lsl"*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 5.0.1.52150 - Tonaie
//last_compiled 02/15/2017 16:15:21
//mono













list _TIMERS;





 

 



































                                        
                                        











//#line 4 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
list PLAYERS;

integer PLAYER_CLOTHES;     
                            



//#line 17 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
list PRIMS_SEATS = [0,0,0,0];
list PRIMS_VIB = [  
    0,0,
    0,0,
    0,0,
    0,0
];
list VIBRATORS_ON = [0,0,0,0];


list PERM_QUEUE;

integer BFL;


toggleChairs(list chairs){
    
    if(BFL&0x4)
        return;
    
    list out = [];
    
    integer triggerSound;
    
    integer i;
    for(i=0; i<llGetListLength(chairs); ++i){
        
        integer vib = llList2Integer(chairs,  i);
        
        if(vib != -1){
            
            integer pre = llList2Integer(VIBRATORS_ON,  i);
            VIBRATORS_ON = llListReplaceList(VIBRATORS_ON, [vib], i, i);
                        
            
            if(vib){
                
                
                multiTimer(["VS:"+(string)i, "", 10, FALSE]);
                
                
                out+= [
                    
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_SEATS,  i),
                    PRIM_COLOR, ALL_SIDES, <1,1,1>, 0,
                    
                    
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_VIB,  i*2),
                    PRIM_COLOR, ALL_SIDES, <1,1,1>, 1,
                    
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_VIB,  i*2+1),
                    PRIM_COLOR, ALL_SIDES, <1,1,1>, 1
                    
                ];
                
            }
            else if(llList2Integer(chairs,  i) == 0){
                
                multiTimer(["VS:"+(string)i]);
                
                
                out+= [
                    
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_SEATS,  i),
                    PRIM_COLOR, ALL_SIDES, <1,1,1>, 1,
                    
                    
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_VIB,  i*2),
                    PRIM_COLOR, ALL_SIDES, <1,1,1>, 0,
                    
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_VIB,  i*2+1),
                    PRIM_COLOR, ALL_SIDES, <1,1,1>, 0
                    
                ];
                
                
                
            }

            
            key targ = llAvatarOnLinkSitTarget(llList2Integer(PRIMS_SEATS,  i));
            if(pre != vib){
                
                permQueue(i, FALSE);
                
                
                llLinkParticleSystem(llList2Integer(PRIMS_VIB,  i*2+1), []);
                llLinkParticleSystem(llList2Integer(PRIMS_VIB,  i*2+1), [  
                    PSYS_PART_FLAGS,
                        PSYS_PART_EMISSIVE_MASK|
                        PSYS_PART_INTERP_COLOR_MASK|
                        PSYS_PART_INTERP_SCALE_MASK|
                        
                        
                        
                        
                        PSYS_PART_FOLLOW_VELOCITY_MASK
                        
                    ,
                    PSYS_PART_MAX_AGE, .25,
                    
                    PSYS_PART_START_COLOR, <.5,.8,1>,
                    PSYS_PART_END_COLOR, <1,1,1>,
                    
                    PSYS_PART_START_SCALE,<.0,.0,0>,
                    PSYS_PART_END_SCALE,<1.5,1.5,0>, 
                                    
                    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                    
                    PSYS_SRC_BURST_RATE, 0.05,
                    
                    PSYS_SRC_ACCEL, <0,0,0>,
                    
                    PSYS_SRC_BURST_PART_COUNT, 1,
                    
                    PSYS_SRC_BURST_RADIUS, 0.1,
                    
                    PSYS_SRC_BURST_SPEED_MIN, 0.0,
                    PSYS_SRC_BURST_SPEED_MAX, 0.5,
                    
                    
                    
                    PSYS_SRC_ANGLE_BEGIN,   0.0, 
                    PSYS_SRC_ANGLE_END,     0.0,
                    
                    PSYS_SRC_OMEGA, <0,0,0>,
                    
                    PSYS_SRC_MAX_AGE, 0.5,
                                    
                    PSYS_SRC_TEXTURE, "c7c58cc4-878a-71ae-29e9-dc2f32241162",
                    
                    PSYS_PART_START_ALPHA, 1,
                    PSYS_PART_END_ALPHA, 0,
                    
                    PSYS_PART_START_GLOW, .1,
                    PSYS_PART_END_GLOW, 0.0
                    
                ]);
                
                if(vib)
                    llTriggerSound("d366735c-b98c-7de1-7ee0-58184d613287", 1);
                
            }
            
        }
    }
    
    if(out)
        llSetLinkPrimitiveParamsFast(0,  out);
    
    
    
    for(i=0; i<llGetListLength(VIBRATORS_ON); ++i){
        
        if(llList2Integer(VIBRATORS_ON,  i)){
            
            llLoopSound("33b4f7c0-66f1-5860-0e80-2edbb53d8f06", 1);
            return multiTimer(["V", "", 0.1, TRUE]);
            
        }
        
    }
    
    llStopSound();
    
    multiTimer(["V"]);
    
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  llList2Json(JSON_ARRAY, VIBRATORS_ON)])), (string)1);
    
}

timerEvent(string id, string data){
    
    
    if(id == "V"){
        
        float z = 0.619873;
        vector scale = <0.399834, 0.198138, 0.209000>;
        BFL = BFL^0x1;
        
        if(BFL&0x1){
            z += .005;
            scale*= 1.03;
        }
        
        list out;
                
        integer i;
        for(i=0; i<llGetListLength(VIBRATORS_ON); ++i){
            
            if(llList2Integer(VIBRATORS_ON,  i)){
                
                
                vector xy = llList2Vector(llGetLinkPrimitiveParams(llList2Integer(PRIMS_VIB,  i*2+1), [PRIM_POS_LOCAL]),  0);
                xy.z = z;
                
                out+= [
                    PRIM_LINK_TARGET, llList2Integer(PRIMS_VIB,  i*2+1),
                    PRIM_SIZE, scale,
                    PRIM_POSITION, xy
                ];
                
                
            }
            
        }
        
        llSetLinkPrimitiveParamsFast(0,  out);
        
    }
    
    
    else if(llGetSubString(id, 0, 2) == "VS:"){
        
        integer player = (integer)llGetSubString(id, 3, 3);
        
        list chairs = [-1,-1,-1,-1];
        chairs = llListReplaceList(chairs, [0], player, player);
        toggleChairs(chairs);
                
    }
    
    else if(id == "Q"){
        
        permQueue(-1, TRUE);
        
    }
    
}






























    



    



























//#line 135 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_ROOT.lsl"
runMethod(string uuidOrLink, string className, integer method, list data, string callback){
    list op = [method, llList2Json(JSON_ARRAY, data), llGetScriptName()];
    if(callback)op+=[callback];
    if((key)uuidOrLink){llRegionSayTo( uuidOrLink, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey( uuidOrLink), -7,-1))+13268712)), ""+(string)-1+":"+ className+llList2Json(JSON_ARRAY,  op));}
    else{ llMessageLinked((integer) uuidOrLink, -1,  className+llList2Json(JSON_ARRAY,  op),  "");}
}


permQueue(integer user, integer force){
    
    if(force){
        BFL = BFL&~0x2;
    }
    
    if(llListFindList(PERM_QUEUE, [user]) == -1 && user != -1)
        PERM_QUEUE+= user;
    
    if(BFL&0x2 || !llGetListLength(PERM_QUEUE))
        return;
    
    
    //#line 230 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
while(llGetListLength(PERM_QUEUE)){string  index = llList2String(PERM_QUEUE,0); PERM_QUEUE = llDeleteSubList(PERM_QUEUE,0,0);  integer idx = (integer)index; key sitter = llAvatarOnLinkSitTarget(llList2Integer(PRIMS_SEATS,  idx)); if(sitter){ BFL = BFL|0x2; llRequestPermissions(sitter, PERMISSION_TRIGGER_ANIMATION); return multiTimer(["Q", "", 2, FALSE]); } }
    
}



//#line 39 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
onEvt(string script, integer evt, list data){
    
    if(script == "sw Game"){
        
        if(evt == 1){
            PLAYERS = data;
            
            integer i;
            for(i=0; i<llGetListLength(PLAYERS); ++i){
                if(llGetListEntryType(PLAYERS, i) != TYPE_INTEGER && BFL&0x8){         runMethod((string)llList2String(PLAYERS,  i), "sw HUD", 5, [ ((PLAYER_CLOTHES>>(8*(3-i)))&3)], JSON_INVALID);     };
            }
        }
        
        if(evt == 10){
            
            BFL = BFL|0x8;
            
            
            PLAYER_CLOTHES = 0;
            integer i;
            for(i=0; i<4; ++i)
                if(llGetListEntryType(PLAYERS, i) != TYPE_INTEGER && BFL&0x8){         runMethod((string)llList2String(PLAYERS,  i), "sw HUD", 5, [ ((PLAYER_CLOTHES>>(8*(3-i)))&3)], JSON_INVALID);     };
                
            
            toggleChairs([0,0,0,0]);
            llLinkParticleSystem(LINK_SET, []);
            
        }
        
        if(evt == 13){
            
            
            if(llList2Integer(data,  0) == -1)        
                return;
                
            
            list chairs = [-1,1,-1,1];
            if(llList2Integer(data,  0)){
                chairs = [1, -1, 1, -1];
            }
            toggleChairs(chairs);
            
        }
        
        else if(evt == 11){
            BFL = BFL&~0x8;
        }
        
        else if(evt == 15){
            
            integer player = llList2Integer(data,  0);
            list fxs = llJson2List(llList2String(data,  1));
            
            
            integer stripped;
            integer vibrate;
            
            integer lvl = ((PLAYER_CLOTHES>>(8*(3-player)))&3);
            
            while(llGetListLength(fxs)){string  fx = llList2String(fxs,0); fxs = llDeleteSubList(fxs,0,0);  if((integer)fx == 1){ if(lvl < 2){ ++lvl; PLAYER_CLOTHES = ((PLAYER_CLOTHES&~(3<<(8*(3-player))))) | ( lvl<<(8*(3-player))); stripped = TRUE; } 
 //#line 110 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
else{ vibrate = TRUE; } } }
            
            if(stripped){
                
                key uuid = llAvatarOnLinkSitTarget(llList2Integer(PRIMS_SEATS,  player));
                string txt = "The bot ";
                if(uuid)
                    txt = llGetDisplayName(uuid)+" ";
                
                list states = ["", "is now in their underwear.", "is now nude."];
                txt+= llList2String(states,  lvl);
                
                //#line 131 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
{integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i);  llRegionSayTo(targ, 0, txt); }}
                
                llTriggerSound("a76b6a1f-60b1-9dc5-579a-92271bc8c71e", 1);
                if(llGetListEntryType(PLAYERS, player) != TYPE_INTEGER && BFL&0x8){         runMethod((string)llList2String(PLAYERS,  player), "sw HUD", 5, [ ((PLAYER_CLOTHES>>(8*(3-player)))&3)], JSON_INVALID);     };
                
                llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  (string)PLAYER_CLOTHES])), (string)2);
                
            }else if(vibrate){
                
                list chairs = ([-1,-1,-1,-1]);
                chairs = llListReplaceList(chairs, [1], player, player);
                toggleChairs(chairs);
                
            }                 
            
        }
        
    }
    
    
}
multiTimer(list data){
    integer i;
    if(data != []){
        integer pos = llListFindList(llList2ListStrided(llDeleteSubList(_TIMERS,0,0), 0, -1, 5), llList2List(data,0,0));
        if(~pos)_TIMERS = llDeleteSubList(_TIMERS, pos*5, pos*5+4);
        if(llGetListLength(data)==4)_TIMERS+=[llGetTime()+llList2Float(data,2)]+data;
    }
    for(i=0; i<llGetListLength(_TIMERS); i+=5){
        if(llList2Float(_TIMERS,i)<=llGetTime()){
            string t = llList2String(_TIMERS, i+1);
            string d = llList2String(_TIMERS,i+2);
            if(!llList2Integer(_TIMERS,i+4))_TIMERS= llDeleteSubList(_TIMERS, i, i+4);
            else _TIMERS= llListReplaceList(_TIMERS, [llGetTime()+llList2Float(_TIMERS,i+3)], i, i);
            timerEvent(t, d);
            i-=5;
        }
    }
    if(_TIMERS== []){llSetTimerEvent(0); return;}
    _TIMERS= llListSort(_TIMERS, 5, TRUE);
    float t = llList2Float(_TIMERS,0)-llGetTime();
    if(t<.01)t=.01;
    llSetTimerEvent(t);
}



default
{
    state_entry()
    {
        PLAYERS = [(string)llGetOwner()];
        
        //#line 413 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
{integer nr; for(nr=llGetNumberOfPrims()>1; nr<=llGetNumberOfPrims(); nr++){ string  name=llGetLinkName(nr);  list split = llParseString2List( name, [":"], []); if(llList2String(split,  0) == "SEAT") PRIMS_SEATS = llListReplaceList(PRIMS_SEATS, [nr], llList2Integer(split,  1), llList2Integer(split,  1)); else if(llList2String(split,  0) == "VIB"){ integer n = 2*llList2Integer(split,  1)+llList2Integer(split,  2); PRIMS_VIB = llListReplaceList(PRIMS_VIB, [nr], n, n); list data = llGetLinkPrimitiveParams(nr, [PRIM_POS_LOCAL, PRIM_SIZE]); } }}
        
        toggleChairs([0,0,0,0]);
        
        
    }
    
    run_time_permissions(integer perm){
        
        if(perm&PERMISSION_TRIGGER_ANIMATION){
            
            key id = llGetPermissionsKey();
            integer i;
            for(i=0; i<llGetListLength(PRIMS_SEATS); ++i){
                
                key sitter = llAvatarOnLinkSitTarget(llList2Integer(PRIMS_SEATS,  i));
                if(id == sitter){
                    
                    integer vib = llList2Integer(VIBRATORS_ON,  i);
                    if(vib)
                        llStartAnimation("vibs_ab_v");
                    else 
                        llStopAnimation("vibs_ab_v");
                    
                    return permQueue(-1, TRUE);
                }
                
            }
            
        }
        
    }

    timer(){
        multiTimer([]);
    }

    






//#line 35 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LM.lsl"
link_message(integer link, integer nr, string s, key id){
    
    
    

    
    if(nr >= 0){return;}
    
    

    
    
    else if(nr==-1 || nr == -2){
        list CB_DATA;
        string CB = JSON_NULL;
        
        string _mname = llGetScriptName();
        integer _mnl = llStringLength(_mname);
        
        if(llGetSubString(s,0,_mnl) != _mname+"["){
            return;
        }
        
        
        
        list _s_DATA = llJson2List(llGetSubString(s, _mnl, -1));
        integer METHOD = llList2Integer(_s_DATA, 0);
        list PARAMS = llJson2List(llList2String(_s_DATA, 1));
        string SENDER_SCRIPT = llList2String(_s_DATA, 2);
        CB = llList2String(_s_DATA, 3);
        _s_DATA = [];
        







    
 
    
    
    //#line 477 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
if(nr == -2){
        return;
    }
    
    
    if(!(id == ""))
        return;
    
    if(METHOD == 1){
        
        if(llList2Integer(PARAMS,  0))
            BFL = BFL&~0x4;
        else
            BFL = BFL|0x4;
        
    }
    
    





        
        //#line 228 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LM.lsl"
if(((string)CB!="" && (string)CB!=JSON_INVALID) && !(nr == -2)){
            list CB_OP = [ METHOD,  llList2Json(JSON_ARRAY, CB_DATA), llGetScriptName(),  CB]; if(llStringLength(id)!=36){llMessageLinked((integer) LINK_SET, -2,  SENDER_SCRIPT+llList2Json(JSON_ARRAY,  CB_OP),  "");}else{ llRegionSayTo(id, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey(id), -7,-1))+13268712)), ""+(string)-2+":"+ SENDER_SCRIPT+llList2Json(JSON_ARRAY,  CB_OP));}
        }
    }else if(nr == -4 && s != llGetScriptName()){
        llResetScript();
    }
    else if(nr == -3){
        list dta = llJson2List(s);
        onEvt(llList2String(dta,0), (integer)((string)id), llJson2List(llList2String(dta,1)));
    }
    
}







//#line 497 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw RLV.lsl"
}
