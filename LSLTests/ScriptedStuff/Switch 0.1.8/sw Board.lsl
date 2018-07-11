//start_unprocessed_text
/*/|*
    
    This script handles:
    - The board visuals
    - Default chairs
    - Default sits

*|/
#include "switch/classes/packages/sw Board.lsl"*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 5.0.1.52150 - Tonaie
//last_compiled 12/25/2016 07:57:55
//mono














list _TIMERS;





 

 



































                                        
                                        










//#line 4 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
list PRIM_SEATS = [0,0,0,0];            


integer PRIM_CENTER;                    
list PC_ORDER = [6,5,3,4];              

list PRIM_CARDS = [0,0,0,0];            

//#line 15 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
list PRIM_BULBS = [0,0,0,0,0,0,0,0];    


list PRIM_SCORE = [0,0];                






//#line 27 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
integer ROUND_COLOR = -1;

timerEvent(string id, string data){
    
    if(id == "particles"){
        llLinkParticleSystem(PRIM_CENTER, []);
    }
    
}


scoreParticles(integer team, integer deck, integer switched){
    
    list data = [];
    if(~team){
        
        vector color = <.5,1,.5>;
        if(switched)
            color = <1,.5,.5>;
        
        data = [  
            PSYS_PART_FLAGS,
                PSYS_PART_EMISSIVE_MASK|
                PSYS_PART_INTERP_COLOR_MASK|
                PSYS_PART_INTERP_SCALE_MASK|
                PSYS_PART_RIBBON_MASK|
                
                
                
                PSYS_PART_TARGET_POS_MASK|
                PSYS_PART_FOLLOW_VELOCITY_MASK
                
            ,
            PSYS_PART_MAX_AGE, .5,
            
            PSYS_PART_START_COLOR, color,
            PSYS_PART_END_COLOR, color,
            
            PSYS_PART_START_SCALE,<.2,.2,0>,
            PSYS_PART_END_SCALE,<.2,.2,0>, 
                            
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            
            PSYS_SRC_BURST_RATE, 0.01,
            
            PSYS_SRC_ACCEL, <0,0,12>,
            
            PSYS_SRC_BURST_PART_COUNT, 1,
            
            PSYS_SRC_BURST_RADIUS, 0.1,
            
            PSYS_SRC_BURST_SPEED_MIN, 0.0,
            PSYS_SRC_BURST_SPEED_MAX, 0.1,
            
            PSYS_SRC_TARGET_KEY, llGetLinkKey(llList2Integer(PRIM_BULBS,  deck+team*4)),
            
            PSYS_SRC_ANGLE_BEGIN,   0.0, 
            PSYS_SRC_ANGLE_END,     0.0,
            
            PSYS_SRC_OMEGA, <0,0,0>,
            
            PSYS_SRC_MAX_AGE, 2,
                            
            PSYS_SRC_TEXTURE, "b6ac962c-ed64-de7d-ade0-b4333403d21b",
            
            PSYS_PART_START_ALPHA, 1,
            PSYS_PART_END_ALPHA, 1,
            
            PSYS_PART_START_GLOW, 0.1,
            PSYS_PART_END_GLOW, 0.1
            
        ];
        
    }
    
    llLinkParticleSystem(PRIM_CENTER, data);

}






























    



    



























//#line 135 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_ROOT.lsl"
runMethod(string uuidOrLink, string className, integer method, list data, string callback){
    list op = [method, llList2Json(JSON_ARRAY, data), llGetScriptName()];
    if(callback)op+=[callback];
    if((key)uuidOrLink){llRegionSayTo( uuidOrLink, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey( uuidOrLink), -7,-1))+13268712)), ""+(string)-1+":"+ className+llList2Json(JSON_ARRAY,  op));}
    else{ llMessageLinked((integer) uuidOrLink, -1,  className+llList2Json(JSON_ARRAY,  op),  "");}
}        


onEvt(string script, integer evt, list data){
    
    if(script == "sw Game"){
        
        if(evt == 10){
        
            llLinkParticleSystem(PRIM_CENTER, []);
        
        }
        
        if(evt == 11){
            
            vector color = <.5,.75,1>;
            if(llList2Integer(data,  0))
                color = <1,.5,.5>;
                
            llTriggerSound("1f6a2ff2-0fd4-dc36-f5a7-bf86b572e527", 1);
                
            llLinkParticleSystem(PRIM_CENTER, [  
                PSYS_PART_FLAGS,
                    PSYS_PART_EMISSIVE_MASK|
                    PSYS_PART_INTERP_COLOR_MASK|
                    PSYS_PART_INTERP_SCALE_MASK|
                    PSYS_PART_BOUNCE_MASK|
                    
                    
                    
                    PSYS_PART_FOLLOW_VELOCITY_MASK
                    
                ,
                PSYS_PART_MAX_AGE, .2,
                
                PSYS_PART_START_COLOR, color,
                PSYS_PART_END_COLOR, color,
                
                PSYS_PART_START_SCALE,<.0,.0,0>,
                PSYS_PART_END_SCALE,<.5,.5,0>, 
                                
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                
                PSYS_SRC_BURST_RATE, 0.01,
                
                PSYS_SRC_ACCEL, <0,0,0.1>,
                
                PSYS_SRC_BURST_PART_COUNT, 2,
                
                PSYS_SRC_BURST_RADIUS, .5,
                
                PSYS_SRC_BURST_SPEED_MIN, 0.0,
                PSYS_SRC_BURST_SPEED_MAX, 0.01,
                
                
                
                PSYS_SRC_ANGLE_BEGIN,   0.0, 
                PSYS_SRC_ANGLE_END,     0.0,
                
                PSYS_SRC_OMEGA, <0,0,0>,
                
                PSYS_SRC_MAX_AGE, 0,
                                
                PSYS_SRC_TEXTURE, "4fe2bc25-c239-1956-6391-12324609d4a2",
                
                PSYS_PART_START_ALPHA, 1,
                PSYS_PART_END_ALPHA, 1,
                
                PSYS_PART_START_GLOW, 0.5,
                PSYS_PART_END_GLOW, 0.1
                
            ]);
            
            multiTimer(["particles", "", 3, FALSE]);
            
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
        {integer nr; for(nr=llGetNumberOfPrims()>1; nr<=llGetNumberOfPrims(); nr++){ string  name=llGetLinkName(nr);  list spl = llParseString2List( name, [":"], []); string label = llList2String(spl,  0); if(label == "centerPiece") PRIM_CENTER = nr; else if(label == "CARD") PRIM_CARDS = llListReplaceList(PRIM_CARDS,  [nr],  llList2Integer(spl, 1),  llList2Integer(spl, 1)); else if(label == "SEAT") PRIM_SEATS = llListReplaceList(PRIM_SEATS,  [nr],  llList2Integer(spl, 1),  llList2Integer(spl, 1)); else if(label == "SCORE") PRIM_SCORE = llListReplaceList(PRIM_SCORE,  [nr],  llList2Integer(spl,  1),  llList2Integer(spl,  1)); else if(label == "BULB") PRIM_BULBS = llListReplaceList(PRIM_BULBS,  [nr],  llList2Integer(spl, 2)+(4*llList2Integer(spl, 1)),  llList2Integer(spl, 2)+(4*llList2Integer(spl, 1))); }}
        
        //#line 213 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
llLinkParticleSystem(PRIM_CENTER, []);
        
        
        
        
        runMethod((string)LINK_THIS, "sw Board", 5, [541200,  541200], JSON_INVALID);
        
        
        runMethod((string)LINK_THIS, "sw Board", 1, [     (((0<<4)| 0) << 24) |     (((0<<4)| 0) << 16) |     (((0<<4)| 0) << 8) |     ((0<<4)| 0),         ((0)<<24) |     ((0)<<16) |     ((0)<<8) |     (0 ) ], JSON_INVALID);
        
        
        //#line 229 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
runMethod((string)LINK_THIS, "sw Board", 2, [-1,  FALSE], JSON_INVALID);
        
        
        runMethod((string)LINK_THIS, "sw Board", 3, [-1], JSON_INVALID);
        
        
        runMethod((string)LINK_THIS, "sw Board", 4, [0, 0], JSON_INVALID);
        
        scoreParticles(-1, 0, 0);
        
    }
    
    timer(){multiTimer([]);}

    






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
        







    
 
    
    
    //#line 255 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
if(nr == -2){
        return;
    }
    
    
    if(!(id == ""))
        return;
       
    

    if(METHOD == 1){
        
        
        integer active = llList2Integer(PARAMS,  0);
        integer effects = llList2Integer(PARAMS,  1);
        
        list out = [];
        
        integer i;
        for(i=0; i<4; i++){
            
            
            integer cData = (active>>((3-i)*8))&255;
            
            integer cardPlayed = (cData&15)-1;
            integer deckPlayed = (cData&48)>>4;
            integer cardSpecial = ((effects>>((3-i)*8))&255)-1;
            
            
            out+= [PRIM_LINK_TARGET, llList2Integer(PRIM_CARDS,  i)];
            
            
            if(~cardPlayed){
                
                integer offset = cardPlayed+(deckPlayed*12);
                integer y = llFloor(offset/8);
                integer x = offset-(y*8);
                out+= [PRIM_COLOR, ALL_SIDES, ZERO_VECTOR, 0, PRIM_FULLBRIGHT, ALL_SIDES, FALSE];
                
                
                out+= [
                    PRIM_COLOR, 0, <1,1,1>*.5, 1,
                    PRIM_COLOR, 1, <1,1,1>*.5, 1
                ];
                
                
                if(ROUND_COLOR == deckPlayed || deckPlayed == 3)
                    out+= [
                        PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                        PRIM_COLOR, 0, <1,1,1>, 1,
                        PRIM_COLOR, 1, <1,1,1>, 1
                    ];
                
                out+= [
                    PRIM_TEXTURE, 0, "09994fba-f2e6-3122-2301-60dd8872ac85", 
                    <1, 1, 0>, 
                    <(float)x/8, -(float)y/(6), 0>,
                    0
                ];
                
                
                if(~cardSpecial){
                    
                    float xscale = (float)8/8;
                    float yscale = (float)6/1;
                    out+= [
                        PRIM_TEXTURE, 2, "3b08b220-43b0-509a-4d63-0865a0c965d3",
                        <xscale, yscale, 0>,
                        <(float)cardSpecial/8,.5,0>,                                       
                        0,
                        
                        PRIM_COLOR, 2, <1,1,1>, 1
                    ];
                    
                }
                
            }
            else
                out+= [PRIM_COLOR, ALL_SIDES, <1,1,1>, 0];
            
        }
        
        llSetLinkPrimitiveParamsFast(0, out);
        
    }
    
    
    

    else if(METHOD == 2){
        
        integer player = llList2Integer(PARAMS,  0);
        integer won = llList2Integer(PARAMS,  1);
        
        list out = []; integer i;
        for(i=0; i<4; ++i){
            
            integer face = llList2Integer(PC_ORDER,  i);
            
            list l = [PRIM_COLOR, face, <.1,.1,.1>, 1, PRIM_FULLBRIGHT, face, FALSE, PRIM_GLOW, face, 0];
            if(player == i){
                
                vector color = <1,1,1>; float glow = 0.1;
                if(won == 1){
                
                    color = <0,1,0>;
                    glow = 0.3;
                    
                }
                else if(won == -1){
                
                    color = <1,0,0>;
                    glow = 0.3;
                    
                }
                
                if(won != 0){
                    scoreParticles(player%2, ROUND_COLOR, won != 1);
                }
                    
                l = [PRIM_COLOR, face, color, 1, PRIM_FULLBRIGHT, face, TRUE, PRIM_GLOW, face, glow];
                
            }
            
            out+= l;
            
        }
        
        llSetLinkPrimitiveParamsFast(PRIM_CENTER,  out);
        
    }
    
    
    
    else if(METHOD == 3){
        
        ROUND_COLOR = llList2Integer(PARAMS,  0);
        
        list out = [PRIM_COLOR, 0, <.1,.1,.1>, 1, PRIM_FULLBRIGHT, 0, FALSE, PRIM_GLOW, 0, 0];
        if(~ROUND_COLOR)
            out = [PRIM_COLOR, 0, llList2Vector([<1,.5,.5>,<.5,1,.5>,<.5,.6,1>,<1,1,1>],  ROUND_COLOR), 1, PRIM_FULLBRIGHT, 0, TRUE, PRIM_GLOW, 0, 0.05];
        
        llSetLinkPrimitiveParamsFast(PRIM_CENTER,  out);
        
    }
    
    
    else if(METHOD == 4){
        
        
        
        integer i; integer lamp;
        list out;
        for(i=0; i<llGetListLength(PARAMS); ++i){
            
            out+= [PRIM_LINK_TARGET, llList2Integer(PRIM_SCORE, i)];
            vector color = llList2Vector([<.5,.8,1>,<1,.5,.5>],  i);
            
            integer sc = llList2Integer(PARAMS,  i);
            for(lamp = 0; lamp<3; ++lamp){
                
                integer face = llList2Integer([5,0,4],  lamp);
                if(i)
                    face = llList2Integer([5,0,4],  2-lamp);
                
                
                list l = [PRIM_COLOR, face, <0.1,0.1,0.1>, 1, PRIM_FULLBRIGHT, face, FALSE, PRIM_GLOW, face, 0];
                if(sc > lamp)
                    l = [PRIM_COLOR, face, color, 1, PRIM_FULLBRIGHT, face, TRUE, PRIM_GLOW, face, 0.1];
                
                out+= l;
                
            }
            
        }
        
        llSetLinkPrimitiveParamsFast(0,  out);
        
    }
    
    
    else if(METHOD == 5){
        
        integer blueScore = llList2Integer(PARAMS,  0);
        integer redScore = llList2Integer(PARAMS,  1);
       
        list out = [];
       
        integer i;
        for(i=0; i<4; ++i){
            
            
            list prims = [llList2Integer(PRIM_BULBS,  i), llList2Integer(PRIM_BULBS,  i+4)];
            
            list scores = [
                (((blueScore>>(5*(3- i)))&31)-16),
                (((redScore>>(5*(3- i)))&31)-16)
            ];
                        
            
            integer winningTeam = llList2Integer(scores,  1) > llList2Integer(scores,  0);
            if(llList2Integer(scores,  1) == llList2Integer(scores,  0))
                winningTeam = -1;
            
            integer team;
            for(team=0; team<2; ++team){
                
                
                out+= [PRIM_LINK_TARGET, llList2Integer(prims,  team)];
                            
                
                integer score = llList2Integer(scores,  team);
                
                
                list bulb = [PRIM_COLOR, 1, llList2Vector([<1,.5,.5>,<.5,1,.5>,<.5,.6,1>,<1,1,1>],  i)*.2, 1, PRIM_FULLBRIGHT, 1, FALSE, PRIM_GLOW, 1, 0];
                if(team == winningTeam)
                    bulb = [PRIM_COLOR, 1, llList2Vector([<1,.5,.5>,<.5,1,.5>,<.5,.6,1>,<1,1,1>],  i), 1, PRIM_FULLBRIGHT, 1, TRUE, PRIM_GLOW, 1, .1];
                out+= bulb;
                
                
                integer y = llFloor(llFabs(score)/8);
                integer x = llAbs(score)-y*8;
                out+= [
                    PRIM_TEXTURE, 5, "c1ccd9c4-a596-4e44-3e80-3926b0fac6af",  
                    <1./8, 1./3, 0>, 
                    <-1./8/2-1./8*8/2+1./8*x, 1./3-1./3*y, 0>, 
                    PI_BY_TWO
                ];
                
                
                if(score > 0)
                    out+= [PRIM_COLOR, 5, <.5,1,.5>, 1];
                else if(score<0)
                    out+= [PRIM_COLOR, 5, <0.5,.5,1>, 1];
                else
                    out+= [PRIM_COLOR, 5, <1,1,1>, 1];
                
                
                
                vector polarityPos = <1./8/2+1./8, 0,0>;
                vector polarityColor = <.5,1,.5>;
                if(score<0){
                    polarityPos.x += 1./8; 
                    polarityColor = <.5,.5,1>;
                }
                out+= [
                    PRIM_TEXTURE, 0, "c1ccd9c4-a596-4e44-3e80-3926b0fac6af", 
                    <1./8, 1./3,0>, 
                    polarityPos, 
                    PI_BY_TWO,
                    PRIM_COLOR, 0, polarityColor, 1
                ];
                
                
            }
            
                
        }
        
        llSetLinkPrimitiveParamsFast(0,  out);
        
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







//#line 529 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Board.lsl"
}
