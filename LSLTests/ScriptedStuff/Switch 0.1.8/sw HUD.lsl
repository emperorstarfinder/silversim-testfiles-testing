//start_unprocessed_text
/*/|*
    
    This script handles:
    - IO
    - All the hud things
    
*|/
#include "switch/classes/packages/sw HUD.lsl"*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 4.7.9.50527- Tonaie
//last_compiled 11/27/2016 07:41:34
//mono














list _TIMERS;





 

 



































                                        
                                        










//#line 5 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw HUD.lsl"
list PRIM_CARDS = [0,0,0,0,0,0,0,0,0,0,0,0,0];


list CARDS = [];
integer ROUND_COLOR = -1;



integer BFL;


integer DIALOG_CHAN;


timerEvent(string id, string data){
    
    
    if(id == "SC"){
        
        if(~llGetAgentInfo(llGetOwner())&AGENT_SITTING && BFL&0x1){
            
            BFL = BFL&~0x1;
            runMethod((string)LINK_THIS, "sw HUD", 1,  [], JSON_INVALID);
            
        }
    }
    
}






























    



    



























//#line 135 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_ROOT.lsl"
runMethod(string uuidOrLink, string className, integer method, list data, string callback){
    list op = [method, llList2Json(JSON_ARRAY, data), llGetScriptName()];
    if(callback)op+=[callback];
    if((key)uuidOrLink){llRegionSayTo( uuidOrLink, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey( uuidOrLink), -7,-1))+13268712)), ""+(string)-1+":"+ className+llList2Json(JSON_ARRAY,  op));}
    else{ llMessageLinked((integer) uuidOrLink, -1,  className+llList2Json(JSON_ARRAY,  op),  "");}
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
loadDialog(){
    
    list buttons = [
        "❔Help",
        "👙 JasX HUD"
    ];
            
    llDialog(llGetOwner(), "Welcome to Switch!\n- First time playing? Hit HELP.\n- RLV Stripping? Get a JasX HUD!", buttons, DIALOG_CHAN);
    
}


integer hasCardFromDeck(integer deck){ 
    
    integer i;
    for(i=0; i<llGetListLength(CARDS); ++i){
        
        if(((llList2Integer(CARDS,  i)>>4)&3) == deck){
            
            return TRUE;
        }
        
    }
    
    return FALSE;
}



drawCards(){
    
    list out;
    integer i;
    for(i=0; i<13; ++i){
            
        out+= [PRIM_LINK_TARGET, llList2Integer(PRIM_CARDS,  i)];
            
        integer card = llList2Integer(CARDS,  i);
            
        
        if(i>=llGetListLength(CARDS))
            out+= [PRIM_COLOR, ALL_SIDES, ZERO_VECTOR, 0];
                
        
        else{
                
            integer nr = ((card&15)-1);
            integer deck = ((card>>4)&3);
            integer fx = ((card>>6)&15)-1;            
            
            
                
            integer offset = nr+(deck*12);

            integer y = llFloor(offset/8);
            integer x = offset-(y*8);
            
            
            out+= [PRIM_COLOR, ALL_SIDES, ZERO_VECTOR, 0];
            out+= [PRIM_COLOR, 0, <1,1,1>, 1];
            
            out+= [
                PRIM_TEXTURE, 0, "09994fba-f2e6-3122-2301-60dd8872ac85", 
                <1, 1, 0>, 
                <(float)x/8, -(float)y/6, 0>,
                0
            ];
            
            
            list border = [ZERO_VECTOR, .5];
            if(deck == 3 || ROUND_COLOR == deck || ROUND_COLOR == -1 || !hasCardFromDeck(ROUND_COLOR)){
                
                border = [<1,1,1>,1];
                
            }
            

            
            out+= [PRIM_COLOR, 1]+border;
                
            if(~fx){
                
                float xscale = (float)8/8;
                float yscale = (float)6/1;
                out+= [
                    PRIM_TEXTURE, 2, "3b08b220-43b0-509a-4d63-0865a0c965d3",
                    <xscale, yscale, 0>,
                    <(float)fx/8,.5,0>,                                       
                    0,
                        
                    PRIM_COLOR, 2, <1,1,1>, 1
                ];
                    
            }
                
        }
            
    }
        
    llSetLinkPrimitiveParamsFast(0,  out);
    
}

default 
{

    on_rez(integer blap){
        
        if(blap)
            llSetLinkPrimitiveParams(LINK_THIS, [PRIM_TEMP_ON_REZ, TRUE]);
        
        llResetScript();
        
    }

    
    state_entry()
    {

        
        llMessageLinked(LINK_SET, -4, llGetScriptName(), "");
        
        
        llListen((-llAbs((integer)("0x7"+llGetSubString((string)llGetOwner(), -7,-1))+13268712)), "", "", "");;

        DIALOG_CHAN = llFloor(llFrand(0xFFFFFF));
        llListen(DIALOG_CHAN, "", llGetOwner(), "");

        list out = [];
        
        //#line 167 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw HUD.lsl"
{integer nr; for(nr=llGetNumberOfPrims()>1; nr<=llGetNumberOfPrims(); nr++){ string  name=llGetLinkName(nr);  list ex = llParseString2List( name, [":"], []); string label = llList2String(ex,  0); if(label == "CARD") PRIM_CARDS = llListReplaceList(PRIM_CARDS, [nr], llList2Integer(ex, 1), llList2Integer(ex, 1)); }}
        
        integer i;
        for(i=0; i<llGetListLength(PRIM_CARDS); ++i){
            
            integer nr = llList2Integer(PRIM_CARDS,  i);
            out+= [PRIM_LINK_TARGET, nr, PRIM_SIZE, <0.11, 0.15, 0.02000>];
            out+= [PRIM_POSITION, -<i*.05, .07+0.07*i, 0>];

        }
        
        llSetLinkPrimitiveParamsFast(0, out);
        
        runMethod((string)LINK_THIS, "sw HUD", 1,  [], JSON_INVALID);
        
        
        
        if(llGetAttached()){
            
            multiTimer(["SC", "", 1, TRUE]);
            
            runMethod((string)llList2Key(llGetObjectDetails(llGetOwner(), [OBJECT_ROOT]),0), "sw Game", 1, [], JSON_INVALID);
            runMethod(llGetOwner(), "sw HUD", 6, [], JSON_INVALID);
            loadDialog();
            
        }
        
        else{
            
            
            runMethod((string)llList2Key(llGetObjectDetails(llGetKey(), [OBJECT_REZZER_KEY]), 0), "sw Game", 2, [], JSON_INVALID);
            
        }
        
        
        
    }
    
    
    timer(){multiTimer([]);}
    
    
    attach(key id){
        
        if(id)
            llResetScript();
        
    }
    
    
    touch_start(integer total){
        if(llDetectedKey(0) != llGetOwner())return;
        
        list splice = llParseString2List( llGetLinkName(llDetectedLinkNumber(0)), [":"], []);
        
        if(llList2String(splice,  0) == "CARD"){
            
            
            runMethod((string)llList2Key(llGetObjectDetails(llGetOwner(), [OBJECT_ROOT]),0), "sw Game", 10, [ llList2Integer(CARDS,  llList2Integer(splice, 1))], "PLAY");
            

        }
        
        else if(llDetectedLinkNumber(0) == 1){
            
            loadDialog();
            
        }
        
        
    }
    
    run_time_permissions(integer perm){
        
        if(~perm&PERMISSION_ATTACH)
            return;
            
        integer pre = llGetAttached();
        if(pre)
            llDetachFromAvatar();
        else
            llAttachToAvatarTemp(0);
            
                
    }
    
    
    
    





//#line 21 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LISTEN.lsl"
listen(integer chan, string name, key id, string message){
    
    
    if(llGetOwnerKey(id) != llGetOwner() && id != llList2Key(llGetObjectDetails(llGetOwner(), [OBJECT_ROOT]),0)){        return;     }     if(chan == DIALOG_CHAN){         if(message == "👙 JasX HUD")             llGiveInventory(llGetOwner(), "JasX HUD 0.3.3");         else if(message == "❔Help")             llGiveInventory(llGetOwner(), "How To Play");     }
    
    
    
    
    
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
        







    
 
    
    
    //#line 287 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw HUD.lsl"
if(nr == -2){
        
        
        if(id == llList2Key(llGetObjectDetails(llGetOwner(), [OBJECT_ROOT]),0) && CB == "PLAY"){
            
            
            if(!llList2Integer(PARAMS,  0)){
                
                llPlaySound("d70302dc-912b-4540-1e90-ab517026aa6d", .5);
                llOwnerSay(llList2String(PARAMS,  1));
                
            }
            
        }
        
        
        return;
    }
    
    if(METHOD == 1){
        
        
        CARDS = [];
        while(llGetListLength(PARAMS)){string  card = llList2String(PARAMS,0); PARAMS = llDeleteSubList(PARAMS,0,0);  if(~(integer)card) CARDS+= (integer)card; }
        
        
        //#line 318 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw HUD.lsl"
drawCards();
        BFL = BFL|0x1;
        
    }
    
    
    if(METHOD == 2){
        
        ROUND_COLOR = llList2Integer(PARAMS,  0);
        drawCards();
        
    }
    
    
    if(METHOD == 3 && id == llList2Key(llGetObjectDetails(llGetOwner(), [OBJECT_ROOT]),0)){
        
        CB_DATA = [TRUE];
        
    }
    
    if(METHOD == 4){
        
        llPlaySound("bff8378a-cccd-b9c3-57a9-0f9a256b71ca", .5);
        
    }
    
    if(METHOD == 5){
        
        
        integer layer = llList2Integer(PARAMS,  0);
        list layers = ["dressed", "underwear", "bits"];
        
        llRegionSayTo(llGetOwner(), 1, "jasx.setclothes "+llList2String(layers,  layer));        
        
    }
    
    if(METHOD == 7 && (id == "" || llGetOwnerKey(id) == llGetOwner())){
        
        key player = llList2String(PARAMS, 0);
        if(~llGetAgentInfo(player)&AGENT_SITTING)
            llDie();
        
        else
            llRequestPermissions(player, PERMISSION_ATTACH);
        
    }
    
    
    if(METHOD == 6 && (id == "" || llGetOwnerKey(id) == llGetOwner())){
        
        llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
        
    }
    
    

    





        
        //#line 228 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_LM.lsl"
if(((string)CB!="" && (string)CB!=JSON_INVALID) && !(nr == -2)){
            list CB_OP = [ METHOD,  llList2Json(JSON_ARRAY, CB_DATA), llGetScriptName(),  CB]; if(llStringLength(id)!=36){llMessageLinked((integer) LINK_SET, -2,  SENDER_SCRIPT+llList2Json(JSON_ARRAY,  CB_OP),  "");}else{ llRegionSayTo(id, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey(id), -7,-1))+13268712)), ""+(string)-2+":"+ SENDER_SCRIPT+llList2Json(JSON_ARRAY,  CB_OP));}
        }
    }else if(nr == -4 && s != llGetScriptName()){
        llResetScript();
    }
    
}







//#line 377 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw HUD.lsl"
}
