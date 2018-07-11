//start_unprocessed_text
/*/|*
    
    This script handles:
    - The actual gameplay

*|/
#include "switch/classes/packages/sw Game.lsl"*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 5.0.1.52150 - Tonaie
//last_compiled 12/25/2016 07:39:15
//mono














list _TIMERS;





 

 



































                                        
                                        










//#line 5 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
integer BFL;


integer NUM_STRIP_CARDS = 2;


list PLAYERS = [FALSE,FALSE,FALSE,FALSE];
list PRIMS_SEATS = [0,0,0,0];
list HUDQUEUE = [];          


//#line 19 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
list PLAY_ORDER;
integer FIRST_TURN = -1;    
integer TURN = -1;          
integer TURN_POINTER;       

integer CARDS_PLAYED;       
integer CARDS_PLAYED_FX;    



integer COLOR_SCORE_BLUE = 541200;   
integer COLOR_SCORE_RED = 541200;    




list PLAYER_CARDS = [
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
];



integer GAME_SCORE_RED;          
integer GAME_SCORE_BLUE;

onSetEnd(){
    
    
    
    llTriggerSound("60598949-ffad-fb93-71d5-f13b83bab4e5", 1);   
 
    integer blueScore;
    integer redScore;
    
    integer i;
    for(i=0; i<4; ++i){
        
        integer b = (((COLOR_SCORE_BLUE>>(5*(3- i)))&31)-16);
        integer r = (((COLOR_SCORE_RED>>(5*(3- i)))&31)-16);
        
        
        integer v = 1;
        if(i == 3)v = 2;
        
        if(b>r)blueScore+=v;
        else if(r>b)redScore+=v;
        
    }
    
    string text = "This set is a tie";
    if(blueScore>redScore){
        text = "Blue wins this set!";
        ++GAME_SCORE_BLUE;
    }
    else if(redScore>blueScore){
        text = "Red wins this set!"; 
        ++GAME_SCORE_RED;
    }
    
    runMethod((string)LINK_THIS, "sw Board", 4, [GAME_SCORE_BLUE,  GAME_SCORE_RED], JSON_INVALID);
    
    if(GAME_SCORE_BLUE > 2 || GAME_SCORE_RED > 2){
        
        text = "RED Wins!";
        if(GAME_SCORE_BLUE > GAME_SCORE_RED)
            text = "Blue wins!";
        
        
        multiTimer(["GAME_END", "", 2, FALSE]);
        
    }
    else
        multiTimer(["SET_START", "", 2, FALSE]);
        
    {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i);  if((integer)targ != -1) llRegionSayTo(targ, 0, text); }}
        
    //#line 418 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
integer teamWins = redScore>blueScore;
    if(redScore == blueScore)
        teamWins = -1;
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  (string)teamWins])), (string)13);    
    
}

onRoundStart(integer turn){
    
    TURN = turn;
    FIRST_TURN = TURN;
    
    
    CARDS_PLAYED = 0;
    CARDS_PLAYED_FX = 0;
    runMethod((string)LINK_THIS, "sw Board", 1, [CARDS_PLAYED,  CARDS_PLAYED_FX], JSON_INVALID);
    
    
    runMethod((string)LINK_THIS, "sw Board", 3, [-1], JSON_INVALID);
    
    
    PLAY_ORDER = [0,1,2,3];
    if(TURN)
        PLAY_ORDER = llList2List(PLAY_ORDER, TURN, -1)+llList2List(PLAY_ORDER, 0, TURN-1);
    
    {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i);  runMethod((string)targ, "sw HUD", 2, [ -1], JSON_INVALID); }}
    
    //#line 160 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
runMethod((string)LINK_THIS, "sw Board", 2, [TURN,  FALSE], JSON_INVALID);
    
    
    if(llGetListEntryType(PLAYERS, TURN) == TYPE_INTEGER)runMethod((string)LINK_THIS, "sw Bot", 1, [llList2Json(JSON_ARRAY, llList2List(PLAYER_CARDS, TURN*13, TURN*13+13-1)),  ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3),  CARDS_PLAYED,  FIRST_TURN,  TURN], JSON_INVALID); else runMethod((string)llList2String(PLAYERS,  TURN), "sw HUD", 4, [], JSON_INVALID);
    
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  ""])), (string)14);
    
}

onRoundEnd(){
    
    integer cc = ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3);

    
    integer HIGHEST_PLAYER;
    integer HIGHEST_VALUE = -1;     
    integer i;
    
    list fxs = [];
    
    integer switches;
    
    for(i=0; i<4; ++i){
        
        
        integer card = (CARDS_PLAYED>>(8*(3-i)))&255;
        integer nr = ((card&15)-1);
        integer deck = ((card>>4)&3);
        
        if(deck == 3 || deck == cc){
        
            integer fx = (CARDS_PLAYED_FX>>(8*(3-i)))&255;
            if(fx)
                fxs += fx;
            
            integer value = nr+1;
            if(nr == 11){
                value = 0;
                switches++;
            }
                
            if(deck == 3)
                value += 12;
            
            if(value > HIGHEST_VALUE){
                
                HIGHEST_VALUE = value;
                HIGHEST_PLAYER = i;
                
            }
            
        }
    }
    
    integer teamwin = HIGHEST_PLAYER%2;
    
    list scores = [COLOR_SCORE_BLUE, COLOR_SCORE_RED];
    
    integer add = 1;
    if(switches%2)
        add = -add;
    
    integer n = (((llList2Integer(scores,  teamwin)>>(5*(3- cc)))&31)-16)+add;
    
    
    if(teamwin)
        COLOR_SCORE_RED = ((COLOR_SCORE_RED&~(31<<(5*(3- cc))))|(( n+16)<<(5*(3- cc))));
    else
        COLOR_SCORE_BLUE = ((COLOR_SCORE_BLUE&~(31<<(5*(3- cc))))|(( n+16)<<(5*(3- cc))));
    
    runMethod((string)LINK_THIS, "sw Board", 5, [COLOR_SCORE_BLUE,  COLOR_SCORE_RED], JSON_INVALID);
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  llList2Json(JSON_ARRAY, ([COLOR_SCORE_BLUE, COLOR_SCORE_RED]))])), (string)2);
    
    integer won = !(switches%2);
    if(!won)
        won = -1;
    runMethod((string)LINK_THIS, "sw Board", 2, [HIGHEST_PLAYER,  won], JSON_INVALID);
    
    list out = [HIGHEST_PLAYER, llList2Json(JSON_ARRAY, fxs)];
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  llList2Json(JSON_ARRAY, out)])), (string)15);
    
    for(i=0; i<13; ++i){
        
        if(llList2Integer(PLAYER_CARDS, i) != -1){
            
            multiTimer(["ROUND_START", (string)HIGHEST_PLAYER, 2, FALSE]);
            return;
            
        }
        
    }
    
    
    multiTimer(["SET_END", "", 2, FALSE]);
    
    
    
}


timerEvent(string id, string data){
    
    list exp = llParseString2List( id, [":"], []);
    
    
    if(llList2String(exp,  0) == "Q"){
        
        llRezAtRoot("Switch HUD", llGetPos()-<0,0,1>, ZERO_VECTOR, ZERO_ROTATION, 1);
        
    }
    
    
    else if(id == "ROUND_END")
        onRoundEnd();
    
    else if(id == "ROUND_START"){
        onRoundStart((integer)data);
    }
    
    else if(id == "SET_END")
        onSetEnd();
    
    else if(id == "SET_START")
        onSetStart();
    
    else if(id == "GAME_END")
        onGameEnd();
    
}






























    



    



























//#line 135 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_ROOT.lsl"
runMethod(string uuidOrLink, string className, integer method, list data, string callback){
    list op = [method, llList2Json(JSON_ARRAY, data), llGetScriptName()];
    if(callback)op+=[callback];
    if((key)uuidOrLink){llRegionSayTo( uuidOrLink, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey( uuidOrLink), -7,-1))+13268712)), ""+(string)-1+":"+ className+llList2Json(JSON_ARRAY,  op));}
    else{ llMessageLinked((integer) uuidOrLink, -1,  className+llList2Json(JSON_ARRAY,  op),  "");}
}

onSetStart(){
    
    llTriggerSound("ecf779e1-5d87-eca9-20ad-40cad773f317", 1);
    
    
    COLOR_SCORE_BLUE =  541200;
    COLOR_SCORE_RED  = 541200;
    
    runMethod((string)LINK_THIS, "sw Board", 5, [COLOR_SCORE_BLUE,  COLOR_SCORE_RED], JSON_INVALID);
    
    
    if(++TURN_POINTER > 3)
        TURN_POINTER = 0;
    TURN = TURN_POINTER;
    runMethod((string)LINK_THIS, "sw Board", 2, [TURN,  FALSE], JSON_INVALID);                  
    
    
    list prism;
    integer i;
    for(i=0; i<12; ++i)
        prism+= (( 0<<6)|( 3<<4)|(i+1));
    
    
    prism = llListRandomize(prism, 1);
    
    
    list tri = [];
    for(i=0; i<3; ++i){
        
        integer card;
        for(card=0; card<12; ++card){
            
            tri+= (( 0<<6)|( i<<4)|(card+1));
            
        }
        
        
        tri+= (( 0<<6)|( i<<4)|(11+1));
        
    }
    
    
    tri+= (( 0<<6)|( llFloor(llFrand(3))<<4)|(11+1));
    
    
    tri = llListRandomize(tri, 1);

    
    for(i=0; i<llGetListLength(PLAYERS); ++i){
        
        list cards = [];
        

        
        cards = llList2List(prism, 0, 2);       
        prism = llDeleteSubList(prism, 0, 2);

        
        integer n = 13-llGetListLength(cards);        
        
        cards+= llList2List(tri, 0, n-1);
        tri = llDeleteSubList(tri, 0, n-1);
        
        cards = llListSort(cards, 1, FALSE);
        
        PLAYER_CARDS = llListReplaceList(PLAYER_CARDS, cards, i*13, i*13+llGetListLength(cards)-1);
        
    }
    
    
    
    list fxorder;
    for(i=0; i<llGetListLength(PLAYER_CARDS); ++i)
        fxorder+= i;
    fxorder = llListRandomize(fxorder, 1);
    
    
    integer nsc = NUM_STRIP_CARDS;
    while(nsc-- > 0){
        integer n = llList2Integer(fxorder, 0);
        fxorder = llDeleteSubList(fxorder, 0, 0);
        integer c = llList2Integer(PLAYER_CARDS,n)|(1<<6);
        PLAYER_CARDS = llListReplaceList(PLAYER_CARDS, [c], n, n);
    }
    fxorder = [];
    
    
    
    
    for(i=0; i<llGetListLength(PLAYERS); ++i){
        
        if(llGetListEntryType(PLAYERS, i) != TYPE_INTEGER){
            
            runMethod((string)llList2String(PLAYERS,  i), "sw HUD", 1,  llList2List(PLAYER_CARDS, 13*i, 13*i+13-1), JSON_INVALID);
            
        }
    }
    
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  ""])), (string)12);
    
    onRoundStart(TURN);
    
    
}


onGameStart(){
    
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  ""])), (string)10);
    
    BFL = BFL|0x1;
    
    
    GAME_SCORE_BLUE = 0;
    GAME_SCORE_RED = 0;
    TURN_POINTER = -1;
    runMethod((string)LINK_THIS, "sw Board", 4, [GAME_SCORE_BLUE,  GAME_SCORE_RED], JSON_INVALID);
    
    
    
    integer numBots;
    integer i;
    for(i=0; i<llGetListLength(PLAYERS); ++i){
        numBots+=(llGetListEntryType(PLAYERS, i) == TYPE_INTEGER);
    }
    
    {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i);  if((integer)targ != -1) llRegionSayTo(targ, 0, "Starting game with "+(string)numBots+" bots!"); }}
    
    //#line 451 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
onSetStart();
    
}

onGameEnd(){
    
    integer team_wins = GAME_SCORE_RED > GAME_SCORE_BLUE;
    llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  (string)team_wins])), (string)11);
    BFL = BFL&~0x1;
    
    
}


onEvt(string script, integer evt, list data){
    
    if(evt == -2){
        
        string n = llGetLinkName(llList2Integer(data,  0));
        key toucher = llList2String(data,  1);
        
        if(n == "START" && ~BFL&0x1 && ~llListFindList(PLAYERS, [toucher])){
            
            onGameStart();
            
        }
        
    }
    
}











//#line 64 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
onCardPlayed(integer card){
    
    integer isFirst = CARDS_PLAYED == 0;
    
    list cards = llList2List(PLAYER_CARDS, 13*TURN, 13*TURN+13-1);
    integer pos = llListFindList(cards, [card]);
    cards = llListReplaceList(cards, [-1], pos, pos);
    PLAYER_CARDS = llListReplaceList(PLAYER_CARDS, cards, 13*TURN, 13*TURN+13-1);
    
    
    integer fx = ((card>>6)&15);
    
    
    integer cdata = card & 63;
    
    integer cnr = ((cdata&15)-1);
    integer color = ((cdata>>4)&3);
    
    CARDS_PLAYED = CARDS_PLAYED|(cdata<<(8*(3-TURN)));
    
    
    integer suitValid = (color == ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3) || color == 3);
    
    if(fx && suitValid){
        CARDS_PLAYED_FX = CARDS_PLAYED_FX|(fx<<(8*(3-TURN)));
        llTriggerSound("a9f1f07b-82a0-4b8b-6a23-acb9882cd378", .5);
    }
    
    if(isFirst){

        runMethod((string)LINK_THIS, "sw Board", 3, [color], JSON_INVALID);
        
        integer i;
        for(i=0; i<llGetListLength(PLAYERS); ++i){
            
            if(llGetListEntryType(PLAYERS, i) != TYPE_INTEGER)
                runMethod((string)llList2String(PLAYERS,  i), "sw HUD", 2, [ color], JSON_INVALID);
        
        }
        
    }
    
    if(llGetListEntryType(PLAYERS, TURN) != TYPE_INTEGER)
        runMethod((string)llList2String(PLAYERS,  TURN), "sw HUD", 1,  llList2List(PLAYER_CARDS, 13*TURN, 13*TURN+13-1), JSON_INVALID);
    
    
    if(((cdata&15)-1) == 11 && suitValid)
        llTriggerSound("357e4256-53a9-59e9-ed9b-0859b154bd88", 1);
    else
        llTriggerSound("647e68ee-be35-f542-1263-5c51adb037c1", 1);
    
    
    
    ++TURN;
    if(TURN >= llGetListLength(PLAYERS))
        TURN = 0;
    
    
    if(TURN == FIRST_TURN){
        TURN = -1;
    }
    
    runMethod((string)LINK_THIS, "sw Board", 2, [TURN,  FALSE], JSON_INVALID);
    runMethod((string)LINK_THIS, "sw Board", 1, [CARDS_PLAYED,  CARDS_PLAYED_FX], JSON_INVALID);
    
    
    if(TURN == -1)
        return multiTimer(["ROUND_END", "", 1, FALSE]);
    
    
    if(llGetListEntryType(PLAYERS, TURN) == TYPE_INTEGER)runMethod((string)LINK_THIS, "sw Bot", 1, [llList2Json(JSON_ARRAY, llList2List(PLAYER_CARDS, TURN*13, TURN*13+13-1)),  ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3),  CARDS_PLAYED,  FIRST_TURN,  TURN], JSON_INVALID); else runMethod((string)llList2String(PLAYERS,  TURN), "sw HUD", 4, [], JSON_INVALID);
    
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



    

integer hasCardOfColor(integer playerIndex, integer color){
    
    list deck = llList2List(PLAYER_CARDS, 13*playerIndex, 13*playerIndex+13-1);
    while(llGetListLength(deck)){string  card = llList2String(deck,0); deck = llDeleteSubList(deck,0,0);  if((((integer)card>>4)&3) == color && (integer)card != -1) return TRUE; }
    //#line 609 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
return FALSE;
    
}



calculateSeats(){
    
    integer playersExist;
    
    list out;
    
    integer i; integer change; integer playIfBot;
    for(i=0; i<llGetListLength(PRIMS_SEATS); ++i){
        
        integer isInt = (llGetListEntryType(PLAYERS, i) == TYPE_INTEGER);
        key lst = llAvatarOnLinkSitTarget(llList2Integer(PRIMS_SEATS,  i));
        integer isSitting = (lst != NULL_KEY);
        
        playersExist+=isSitting;
        
        if((isInt && isSitting) || (!isSitting && !isInt)){
            
            change = TRUE;
            
            string text = llGetDisplayName(llList2String(PLAYERS,  i))+" will be replaced by a bot.";
            
            list v = [FALSE];
            if(isSitting)
                v = [lst];
                
            PLAYERS = llListReplaceList(PLAYERS, v, i, i);
            
            
            if(isSitting){
                
                HUDQUEUE += lst;
                llRequestPermissions(lst, PERMISSION_TRIGGER_ANIMATION);
                multiTimer(["Q:"+(string)lst, "", 3, FALSE]);                  
                runMethod((string)lst, "sw HUD", 3, [], "PING");
                text = llGetDisplayName(lst)+" has joined the game.";
                
            }
            else{
                
                integer pos = llListFindList(HUDQUEUE, [(key)lst]); if(~pos)HUDQUEUE = llDeleteSubList(HUDQUEUE, pos, pos);;
                multiTimer(["Q:"+(string)lst]);                  
                
                
                if(i == TURN)
                    playIfBot = TRUE;
                
            }
            
            out+= text;
            
        }
        
    }
    
    while(llGetListLength(out)){string  text = llList2String(out,0); out = llDeleteSubList(out,0,0);  {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i);  llRegionSayTo(targ, 0, text);}} }
    
    //#line 526 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
if(change){
        
        llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  llList2Json(JSON_ARRAY, PLAYERS)])), (string)1);
        
        
        if(BFL&0x1){
        
            if(!playersExist){
                llWhisper(0, "Game has ended due to lack of players.");
                return onGameEnd();
            }
        
            if(playIfBot){
                if(llGetListEntryType(PLAYERS, TURN) == TYPE_INTEGER)runMethod((string)LINK_THIS, "sw Bot", 1, [llList2Json(JSON_ARRAY, llList2List(PLAYER_CARDS, TURN*13, TURN*13+13-1)),  ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3),  CARDS_PLAYED,  FIRST_TURN,  TURN], JSON_INVALID); else runMethod((string)llList2String(PLAYERS,  TURN), "sw HUD", 4, [], JSON_INVALID);
            }
            
        }
    }
    
    
    
}

default
{
    state_entry()
    {
        
        
        runMethod((string)LINK_THIS, "sw Board", 1, [CARDS_PLAYED,  CARDS_PLAYED_FX], JSON_INVALID);
        runMethod((string)LINK_THIS, "sw Board", 2, [-1,  FALSE], JSON_INVALID);
        
        {integer nr; for(nr=llGetNumberOfPrims()>1; nr<=llGetNumberOfPrims(); nr++){ string  name=llGetLinkName(nr);  list exp = llParseString2List( name, [":"], []); if(llList2String(exp,  0) == "SEAT"){ integer n = llList2Integer(exp,  1); PRIMS_SEATS = llListReplaceList(PRIMS_SEATS, [nr], n, n); llLinkSitTarget(nr, <.1,0,.4>, llEuler2Rot(<0,0,PI>)); } else llLinkSitTarget(nr, ZERO_VECTOR, ZERO_ROTATION); }}
        
        //#line 637 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
calculateSeats();
        
    }
    
    timer(){multiTimer([]);}
    
    changed(integer change){
        
        if(change&CHANGED_LINK){
            
            calculateSeats();
            
        }
        
    }
    
    run_time_permissions(integer perm){
        
        if(perm&PERMISSION_TRIGGER_ANIMATION)
            llStartAnimation("sit_1");
        
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
        







    
 
    
    
    //#line 672 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
if(nr == -2){
        
        if(METHOD == 3 && SENDER_SCRIPT == "sw HUD" && CB == "PING"){
            
            
            multiTimer(["Q:"+(string)llGetOwnerKey(id)]);
            integer pos = llListFindList(HUDQUEUE, [(key)llGetOwnerKey(id)]); if(~pos)HUDQUEUE = llDeleteSubList(HUDQUEUE, pos, pos);;
            
            
            pos = llListFindList(PLAYERS, [llGetOwnerKey(id)]);
            
            if(BFL&0x1 && ~pos){
                runMethod((string)llList2String(PLAYERS,  pos), "sw HUD", 1,  llList2List(PLAYER_CARDS, 13*pos, 13*pos+13-1), JSON_INVALID);
                runMethod((string)llList2String(PLAYERS,  pos), "sw HUD", 2, [ ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3)], JSON_INVALID);
            }
        }
        
        return;
    }
    
    if(METHOD == 10){
        
        
        if(TURN == -1)
            return;
        
        CB_DATA = [0];
        integer card = llList2Integer(PARAMS,  0);
        
        
        if(
            (id == "" && llGetListEntryType(PLAYERS, TURN) == TYPE_INTEGER) ||
            (llGetOwnerKey(id) == llList2Key(PLAYERS,  TURN))
        ){
            
            
            list deck = llList2List(PLAYER_CARDS, 13*TURN, 13*TURN+13-1);
            if(~llListFindList(deck, [card]) && card != -1){
                
                
                if(
                    !hasCardOfColor(
                        TURN, 
                        ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3)
                    ) ||      
                    ((CARDS_PLAYED>>(8*(3-FIRST_TURN)+4))&3) == ((card>>4)&3) ||     
                    CARDS_PLAYED == 0 ||                        
                    ((card>>4)&3) == 3          
                ){
                    
                    CB_DATA = [1];
                    onCardPlayed(card);
                    
                }
                else 
                    CB_DATA += "Invalid card";
                
            }
            else
                CB_DATA += "Card not held";
            
        }
        else 
            CB_DATA+= "Not your turn";
        
        if(id == "" && !llList2Integer(CB_DATA,  0)){
            llOwnerSay(llGetSubString(llList2String(llParseString2List(llGetTimestamp(), ["T"],[]), 1),0,-5)+" "+"sw Game.lsl"+" @ "+(string)738+": "+(string)("Invalid bot play: "+(string)card+" "+llList2String(CB_DATA, 1)));
        }
    }
    
    
    if(METHOD == 1){
        
        if(~llListFindList(PLAYERS, [llGetOwnerKey(id)])){
            runMethod((string)id, "sw HUD", 3, [], "PING");
        }
        
    }
    
    if(METHOD == 2 && (id == "" || llGetOwnerKey(id) == llGetOwner())){
        
        runMethod((string)id, "sw HUD", 7, [ llList2Key(HUDQUEUE,  0)], JSON_INVALID);
        HUDQUEUE = llDeleteSubList(HUDQUEUE, 0, 0);
        
    }
    
    if(METHOD == 11){
        NUM_STRIP_CARDS = llList2Integer(PARAMS,  0);
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







//#line 767 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Game.lsl"
}
