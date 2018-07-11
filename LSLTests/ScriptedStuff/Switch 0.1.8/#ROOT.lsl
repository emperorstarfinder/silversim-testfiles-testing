//start_unprocessed_text
/*/|*
    
    Root script which also handles
    - Dialog
    
*|/
#include "switch/classes/packages/ROOT.lsl"*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 5.0.1.52150 - Tonaie
//last_compiled 12/25/2016 07:47:39
//mono








 

 



































                                        
                                        













//#line 20 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\ROOT.lsl"
list PLAYERS;
list PRIMS_SEATS = [0,0,0,0];

integer USE_VIBRATOR = TRUE;
integer NR_STRIP_CARDS = 2;
integer BOT_DIFFICULTY = 1;


integer DIALOG_CHAN;
integer MENU;

//#line 46 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\ROOT.lsl"
list BOT_DIFFICULTIES = ["Dumb", "Average", "Expert"];






























    



    



























//#line 135 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_ROOT.lsl"
runMethod(string uuidOrLink, string className, integer method, list data, string callback){
    list op = [method, llList2Json(JSON_ARRAY, data), llGetScriptName()];
    if(callback)op+=[callback];
    if((key)uuidOrLink){llRegionSayTo( uuidOrLink, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey( uuidOrLink), -7,-1))+13268712)), ""+(string)-1+":"+ className+llList2Json(JSON_ARRAY,  op));}
    else{ llMessageLinked((integer) uuidOrLink, -1,  className+llList2Json(JSON_ARRAY,  op),  "");}
}

rebuildPlayers(){
    PLAYERS = [];
    integer i;
    for(i=0; i<llGetListLength(PRIMS_SEATS); ++i){
        
        key t = llAvatarOnLinkSitTarget(llList2Integer(PRIMS_SEATS,  i));
        if(t)
            PLAYERS+=t;
        
    }
}

dialog(integer menu, key id){
    MENU = menu;
    
    string text = "Welcome to Switch!\nSettings:\n\n👙 "+(string)NR_STRIP_CARDS+"x Strip cards\n💓 Vibrator is ";
    if(USE_VIBRATOR)
        text+= "ON";
    else
        text+= "OFF";
    text+= "\n💻 Bot Skill: "+llList2String(BOT_DIFFICULTIES,  BOT_DIFFICULTY);
    
    list buttons = [
        "💓 Vibrator",
        "👙 Strip Cards",
        "💻 Bot Skill"
    ];
    
    if(menu == 1){
        
        text = "How many strip cards should be generated at the start of each set? 0 Turns off strip cards.\n\nCurrent strip cards: "+(string)NR_STRIP_CARDS;
        buttons = ["◀ Back", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
        
    }
    
    else if(menu == 2){
        
        text = "Bot difficulty:\n\nCurrently: "+llList2String(BOT_DIFFICULTIES,  BOT_DIFFICULTY);
        buttons = ["◀ Back"]+BOT_DIFFICULTIES;
        
    }
    
    llDialog(id, text, buttons, DIALOG_CHAN);
    
}

default 
{
    
    on_rez(integer bap){
        
        llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  ""])), (string)-1);
            
    }
    
    
    state_entry()
    {

        
        llMessageLinked(LINK_SET, -4, llGetScriptName(), "");
        
        
        llListen((-llAbs((integer)("0x7"+llGetSubString((string)llGetOwner(), -7,-1))+13268712)), "", "", "");;
        
        DIALOG_CHAN = llCeil(llFrand(0xFFFFFFF));
        llListen(DIALOG_CHAN, "", "", "");
        
        {integer nr; for(nr=llGetNumberOfPrims()>1; nr<=llGetNumberOfPrims(); nr++){ string  name=llGetLinkName(nr);  list exp = llParseString2List( name, [":"], []); if(llList2String(exp,  0) == "SEAT"){ integer n = llList2Integer(exp,  1); PRIMS_SEATS = llListReplaceList(PRIMS_SEATS, [nr], n, n); } }}
        
        //#line 116 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\ROOT.lsl"
rebuildPlayers();
 
    }
    
    
    
    
    changed(integer change){
        
        if(change&CHANGED_OWNER){
            llResetScript();
        }
        
        if(change&CHANGED_LINK){
            rebuildPlayers();
        }
        
    }
    
    touch_start(integer total){
        
        key id = llDetectedKey(0);
        
        if(id != llGetOwner() && llListFindList(PLAYERS, [id] )== -1)            return;
        
        if(llGetLinkName(llDetectedLinkNumber(0)) == "SETTINGS"){
            dialog(0, llDetectedKey(0));
        }
        
        list data = [llDetectedLinkNumber(0), id];
        llMessageLinked(LINK_SET, -3, llList2Json(JSON_ARRAY, ([llGetScriptName(),  llList2Json(JSON_ARRAY, data)])), (string)-2);
        
    }
    
    
        





//#line 21 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LISTEN.lsl"
listen(integer chan, string name, key id, string message){
    
    
    if(llGetOwnerKey(id) != llGetOwner() && ~llListFindList(PLAYERS, [(string)llGetOwnerKey(id)] )== -1)        return;     if(chan == DIALOG_CHAN){         if(MENU == 1){             if(message == "◀ Back")                 return dialog(0, id);             NR_STRIP_CARDS = (integer)message;             runMethod((string)LINK_ROOT, "sw Game", 11, [NR_STRIP_CARDS], JSON_INVALID);             {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i); llRegionSayTo(targ, 0, "The next set will have "+(string)NR_STRIP_CARDS+" strip cards.");}}             dialog(1, id);         }        else if(MENU == 2){             if(message == "◀ Back")                 return dialog(0, id);             BOT_DIFFICULTY = llListFindList(BOT_DIFFICULTIES, [message]);             if(BOT_DIFFICULTY<0)BOT_DIFFICULTY = 0;            runMethod((string)LINK_THIS, "sw Bot", 2, [BOT_DIFFICULTY], JSON_INVALID);             {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i); llRegionSayTo(targ, 0, "Bot difficulty is now "+(string)llList2String(BOT_DIFFICULTIES,  BOT_DIFFICULTY));}}             dialog(2, id);         }         else if(MENU == 0){             if(message == "💓 Vibrator"){                 USE_VIBRATOR = !USE_VIBRATOR;                 runMethod((string)LINK_THIS, "sw RLV", 1, [USE_VIBRATOR], JSON_INVALID);                 string text = "Vibration feature is now ";                 if(USE_VIBRATOR)text+= "ON";                 else text+= "OFF";                 {integer _i; for(_i=0; _i<llGetListLength(PLAYERS); ++_i){string targ = llList2String(PLAYERS,  _i); llRegionSayTo(targ, 0, text);}}                 dialog(0, id);             }             else if(message == "👙 Strip Cards")                 dialog(1, id);             else if(message == "💻 Bot Skill")                 dialog(2, id);         }         return;     }
    
    
    
    
    
    ;
    
    
    
    llMessageLinked(LINK_SET, (integer)llGetSubString(message, 0,llSubStringIndex(message, ":")-1), llGetSubString(message, llSubStringIndex(message, ":")+1, -1), id);
    
}
    
    






//#line 35 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LM.lsl"
link_message(integer link, integer nr, string s, key id){
    
    
    

    
    if(nr >= 0){return;}
    
    

    else if(nr == -5){
    
    string sender = llJsonGetValue(s, [ 0]);
    list _to_create = llJson2List(llJsonGetValue(s, [1]));
    list _index_tables;        
    list _index_db;            
    integer _i; integer nr;
    for(nr = 1; nr<=llGetNumberOfPrims(); nr++){
        string name = llGetLinkName(nr);
        if(llGetSubString(name, 0, 1) == "DB"){
            _index_db += [(integer)llGetSubString(name, 2, -1), nr];
            integer _occupied; 
            for(_i = 0; _i <llGetLinkNumberOfSides(nr); _i++){
                string _data = llList2String(llGetLinkMedia(nr, _i, [PRIM_MEDIA_HOME_URL]),0); 
                string name = llGetSubString(_data, 0, llSubStringIndex(_data, "|")-1);
                
                if(name != "" && llListFindList(_index_tables, [name]) == -1){ 
                    _index_tables += name;
                    _occupied = _occupied | (integer)llPow(2, _i);
                }
            }
            _index_db += _occupied;
        }
    }
    
    _index_db = llListSort(_index_db, 3, TRUE);
    for(_i = 0; _i<llGetListLength(_to_create); _i++){
        string _tbl = llGetSubString(llList2String(_to_create, _i),0,29);
        if(llListFindList(_index_tables,[_tbl]) == -1){
            
            integer _x;
            
            for(_x = 0; _x<llGetListLength(_index_db); _x+=3){
                integer _occupied = llList2Integer(_index_db, _x+2);
                integer _prim = llList2Integer(_index_db, _x+1);
                integer _y;
                for(_y = 0; _y<llGetLinkNumberOfSides(_prim); _y++){
                    integer _n = (integer)llPow(2, _y);
                    if(~_occupied & _n){
                        llSetLinkMedia(_prim, _y, [PRIM_MEDIA_HOME_URL, _tbl+"|[]"]);
                        _index_db = llListReplaceList(_index_db, [_occupied|_n], _x+2, _x+2);
                        
                        jump _db4_add_continue;
                    }
                }
            }
            llOwnerSay("FATAL ERROR: Not enough DB sides for DB3.");
            return;
            @_db4_add_continue;
        }
    }
    
    list CB_OP = [ -3,  llList2Json(JSON_ARRAY, _to_create), llGetScriptName(),  ""]; if(llStringLength(id)!=36){llMessageLinked((integer) LINK_SET, -2,  sender+llList2Json(JSON_ARRAY,  CB_OP),  "");}else{ llRegionSayTo(id, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey(id), -7,-1))+13268712)), ""+(string)-2+":"+ sender+llList2Json(JSON_ARRAY,  CB_OP));};
    }
    
    
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
        







    
 
    
    
    //#line 205 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\ROOT.lsl"
if(nr == -2){
        return;
    }

    
    

    





        
        //#line 228 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LM.lsl"
if(((string)CB!="" && (string)CB!=JSON_INVALID) && !(nr == -2)){
            list CB_OP = [ METHOD,  llList2Json(JSON_ARRAY, CB_DATA), llGetScriptName(),  CB]; if(llStringLength(id)!=36){llMessageLinked((integer) LINK_SET, -2,  SENDER_SCRIPT+llList2Json(JSON_ARRAY,  CB_OP),  "");}else{ llRegionSayTo(id, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey(id), -7,-1))+13268712)), ""+(string)-2+":"+ SENDER_SCRIPT+llList2Json(JSON_ARRAY,  CB_OP));}
        }
    }else if(nr == -4 && s != llGetScriptName()){
        llResetScript();
    }
    
}







//#line 215 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\ROOT.lsl"
}
