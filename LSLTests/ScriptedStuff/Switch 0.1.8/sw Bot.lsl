//start_unprocessed_text
/*/|*
    
    This script handles:
    - The bots

*|/
#include "switch/classes/packages/sw Bot.lsl"*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Release 4.7.9.50527- Tonaie
//last_compiled 11/30/2016 15:29:26
//mono














list _TIMERS;





 

 



































                                        
                                        










//#line 4 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Bot.lsl"
integer COLOR_SCORE_BLUE = 541200;
integer COLOR_SCORE_RED = 541200;

integer DIFFICULTY = 1;






























    



    



























//#line 135 "D:/contentLib\\SL LIBRARIES\\xobj_core\\_ROOT.lsl"
runMethod(string uuidOrLink, string className, integer method, list data, string callback){
    list op = [method, llList2Json(JSON_ARRAY, data), llGetScriptName()];
    if(callback)op+=[callback];
    if((key)uuidOrLink){llRegionSayTo( uuidOrLink, (-llAbs((integer)("0x7"+llGetSubString((string)llGetOwnerKey( uuidOrLink), -7,-1))+13268712)), ""+(string)-1+":"+ className+llList2Json(JSON_ARRAY,  op));}
    else{ llMessageLinked((integer) uuidOrLink, -1,  className+llList2Json(JSON_ARRAY,  op),  "");}
}

timerEvent(string id, string data){
    
    if(id == "PLAY")
        runMethod((string)LINK_THIS, "sw Game", 10, [ (integer)data], "PLAY");
    
}

integer scoreDifference(integer color, integer isRed){
    
    list scores = [(((COLOR_SCORE_BLUE>>(5*(3- color)))&31)-16), (((COLOR_SCORE_RED>>(5*(3- color)))&31)-16)];
    return llList2Integer(scores,  isRed)-llList2Integer(scores,  !isRed);
    
}

list reverse(list input){
    list output;
    integer i;
    for(i=0; i<llGetListLength(input); ++i){
        output = llList2List(input, i, i)+output;
    }
    return output;
}

onEvt(string script, integer evt, list data){
    
    if(script == "sw Game"){
        
        if(evt == 10){
            
            COLOR_SCORE_BLUE = 541200;
            COLOR_SCORE_RED = 541200;
            
        }
        
        else if(evt == 2){
            
            COLOR_SCORE_BLUE = llList2Integer(data,  0);
            COLOR_SCORE_RED = llList2Integer(data,  1);
            
            
            
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



integer getHighestNonSwitchCard(list cards){
    
    integer highest;
    
    integer i;
    for(i=0; i<llGetListLength(cards); ++i){
        
        integer c = llList2Integer(cards,  i);
        integer v = ((c&15)-1);
        
        if(v == 11)
            return highest;
        
        highest = c;
        
    }
    
    return highest;
    
}



list getDeckByColor(list deck, integer color){
    
    if(color == -1)
        return deck;
    
    list out;
    
    while(llGetListLength(deck)){string  card = llList2String(deck,0); deck = llDeleteSubList(deck,0,0);  if((((integer)card>>4)&3) == color && (integer)card != -1){ out+= (integer)card; } }
    
    //#line 93 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Bot.lsl"
return out;
    
}


integer getCardScore(integer card){
    
    integer cValue = ((card&15)-1);
    if(cValue == 11)
        cValue-= 12;
    if(((card>>4)&3) == 3)
        cValue+= 12;
    return cValue+1;
    
}




default
{
    state_entry()
    {
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
        







    
 
    
    
    //#line 138 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Bot.lsl"
if(nr == -2){
        return;
    }
    
    
    if(!(id == ""))
        return;
    
    if(METHOD == 1){
        
        integer i;
        
        
        list cards = reverse(llJson2List(llList2String(PARAMS, 0)));    
        integer roundcolor = llList2Integer(PARAMS,  1);        
        integer cards_played = llList2Integer(PARAMS,  2);      
        integer first_player = llList2Integer(PARAMS,  3);      
        integer player_index = llList2Integer(PARAMS,  4);      
        
        if(cards_played == 0)
            roundcolor = -1;
        
        integer team = player_index%2;
        
        
        list cp_data;               
        list viable;                
                                    
        list in_suit;               
        list prismatics;            
        integer isSwitched;         
        integer highestCard = -1;   
        integer highestTeam = -1;   
        integer play = -1;               
        integer has_card_color;     
        list score_offsets;         
        integer leadingOnBoard;     
                
        
        
        for(i=0; i<4; ++i){
            
            integer dif = scoreDifference(i, team);
            
            integer n = dif>0;
            
            if(dif<0)
                n = -n;
            
            if(i == 3)
                n*= 2;
                
            leadingOnBoard += n;
            score_offsets += dif;
            
        }
        
        
        integer n = first_player;
        
        for(i=0; i<4; ++i){
            
            integer cdata = (cards_played>>(8*(3-n)))&255; 
            
            integer cValue = getCardScore(cdata);
            
            if(((cdata&15)-1) == 11)
                isSwitched = !isSwitched;

            if(cdata > 0)
                cp_data += cdata;       
            else
                i = 100;                
            
            if(cValue > getCardScore(highestCard) || highestCard == -1){
                

                highestCard = cdata;
                highestTeam = n%2;
                
            }
            
            if(++n>3)
                n = 0;
                
            
        }
        
        
        has_card_color = llGetListLength(getDeckByColor(cards, roundcolor));
        
        
        for(i=0; i<llGetListLength(cards); ++i){
            
            integer card = llList2Integer(cards,  i);
            integer cc = ((card>>4)&3);
            
            if(card != -1 && cc == roundcolor)
                in_suit += card;
            if(card != -1 && cc == 3)
                prismatics += card;
            
            if(
                card != -1 &&           
                (
                    !cards_played ||            
                    cc == 3 ||         
                    !has_card_color ||          
                    cc == roundcolor
                )
            ){
                
                viable += card;
                
            }
            
        }
        
        if(DIFFICULTY > 0 && (DIFFICULTY == 2 || llFrand(1) < 0.8)){
            
            if(roundcolor == -1 && (DIFFICULTY >= 2 || llFrand(1)<.5)){
                
                integer highest = getHighestNonSwitchCard(prismatics);      
                
                if(
                    
                    llAbs(llList2Integer(score_offsets,  3)) < 1 && 
                    
                    (((highest&15)-1) > 6 || llGetListLength(prismatics) == 1)
                ){
                    
                    play = highest;
                    ;
                    
                }
                
                else{
                    
                    
                    list scoreSort;
                    for(i=0; i<llGetListLength(score_offsets); ++i)
                        scoreSort += [llList2Integer(score_offsets,  i), i];
                    
                    
                    scoreSort = llListSort(scoreSort, 2, TRUE);
                    
                    
                    if(leadingOnBoard > 0){
                        
                        list ss = llListSort(scoreSort, 2, FALSE);
                        for(i=0; i<llGetListLength(ss) && play == 0; i+=2){
                            
                            list select = getDeckByColor(cards, llList2Integer(ss,  i+1));
                            if(llAbs(llList2Integer(ss,  i)) > 1 && select != []){
                                
                                
                                integer highest = getHighestNonSwitchCard(select);
                                
                                if(highest < 4)
                                    highest = llList2Integer(select,  -1);
                                
                                play = highest;
                                ;
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    if(play == -1){
                        
                        
                        integer closest = -1;
                        list lowest;
                        for(i=0; i<llGetListLength(scoreSort); i+=2){
                            
                            integer d = llList2Integer(scoreSort,  i+1);            
                            list select = getDeckByColor(cards, d);
                            
                            integer val = llAbs(llList2Integer(scoreSort,  i));     
                            
                            if((closest == -1 || val <= closest) && select != [] && d != 3 && llList2Integer(scoreSort,  i)<1){
                                
                                if(val < closest){
                                    lowest = [];
                                    closest = val;
                                }
                                
                                lowest+= d;
                                
                            }
                            
                        }
                        
                        if(lowest){
                            
                            
                            integer el = (integer)llList2String(lowest, ((integer)(llFrand(llGetListLength(lowest)))));
                            
                            list select = getDeckByColor(cards, el);
                            
                            
                            integer highest = getHighestNonSwitchCard(select);
                            
                            if(highest < 4)
                                highest = llList2Integer(select,  -1);
                                
                            play = highest;
                            ;
                            
                        }
                        
                        
                    }
                    
                    
                    if(play == -1){
                        
                        integer highest;
                        for(i=0; i<llGetListLength(cards) && play == -1; ++i){
                            
                            integer c = llList2Integer(cards,  i);
                            integer v = ((i&15)-1);
                            if(v != 11 && v > highest){
                                
                                highest = v;
                                play = c;
                                ;
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
            }
            
            
            else{
                
                    
                integer offset = llAbs(llList2Integer(score_offsets,  roundcolor));
                list inSuit = getDeckByColor(cards, roundcolor);
                
                
                
                if(isSwitched && highestTeam == team){
                        
                    
                    integer c = llList2Integer(inSuit,  -1);
                    if(((c&15)-1) == 11){
                        
                        play = c;
                        ;
                        
                    }
                    
                    c = llList2Integer(prismatics,  -1);
                    if(play == -1 && ((c&15)-1) == 11 && llGetListLength(cp_data) >= 3){
                        
                        play = c;
                        ;
                        
                    }
                        
                }
                    
                
                if(play == -1 && !isSwitched && highestTeam != team){
                    
                    
                    integer c = llList2Integer(inSuit,  -1);
                    if(((c&15)-1) == 11){
                        
                        play = c;
                        ;
                        
                    }
                    
                    c = llList2Integer(prismatics,  -1);
                    if(play == -1 && ((c&15)-1) == 11 && ((highestCard>>4)&3) == 3){
                        
                        play = c;
                        ;
                        
                    }
                        
                }
                
                if(inSuit){
                    
                    
                    if(play == -1 && (
                        isSwitched || 
                        (!isSwitched && highestTeam == team && llFrand(1)<.75)
                    )){
                        
                        for(i=0; i<llGetListLength(viable) && play == -1; ++i){
                            integer c = llList2Integer(viable,  0);
                            if(((c&15)-1) != 11){
                                play = c;
                            }
                        }
                        
                        ;
                        
                    }
                    
                    
                    for(i=0; i<llGetListLength(inSuit) && play == -1; ++i){
                        
                        if(getCardScore(llList2Integer(inSuit,  i)) > getCardScore(highestCard)){
                            
                            play = llList2Integer(inSuit,  i);
                            ;
                            
                        }
                        
                    }
                    
                }
                
                
                if(!isSwitched){
                    for(i=0; i<llGetListLength(prismatics) && play == -1; ++i){
                            
                        if(getCardScore(llList2Integer(prismatics,  i)) > getCardScore(highestCard) && ((llList2Integer(prismatics,  i)&15)-1) != 11){
                            
                            play = llList2Integer(prismatics,  i);
                            ;
                            
                        }
                            
                    }
                }
                        
                
                if(play == -1){
                    
                    integer l = -1;
                    integer lp;
                    for(i=0; i<llGetListLength(viable); ++i){
                        
                        integer c = llList2Integer(viable,  i);
                        integer score = getCardScore(c);
                        if((score<l || l == -1) && ((c&15)-1) != 11){
                            
                            l = score;
                            lp = c;
                            
                        }
                        
                    }
                    
                    if(lp != 0){
                        play = lp;
                        ;
                    }
                    
                    
                }
                    
                            
            }
        }
        
        
        if(play <= 0){
            
            play = (integer)llList2String(viable, ((integer)(llFrand(llGetListLength(viable)))));
            ;
            

        }
        
        if(play == 0){
            llOwnerSay(llGetSubString(llList2String(llParseString2List(llGetTimestamp(), ["T"],[]), 1),0,-5)+" "+"sw Bot.lsl"+" @ "+(string)529+": "+(string)("Bot play failed. Held cards were: "+llList2Json(JSON_ARRAY, cards)));
            llOwnerSay(llGetSubString(llList2String(llParseString2List(llGetTimestamp(), ["T"],[]), 1),0,-5)+" "+"sw Bot.lsl"+" @ "+(string)530+": "+(string)("Viable: "+llList2Json(JSON_ARRAY, viable)));
        }
        
        multiTimer(["PLAY", play, .5, FALSE]);
        

        
        
        
    }
    
    else if(METHOD == 2){
        DIFFICULTY = llList2Integer(PARAMS,  0);
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







//#line 548 "D:/contentLib\\SL LIBRARIES\\switch\\classes\\packages\\sw Bot.lsl"
}
