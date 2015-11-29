//start_unprocessed_text
/*

integer seatupdate = 35353;
list seatAndAv;
integer dismount = -221;

list SeatedAvs(){ /|/returns the list of uuid's of seated AVs
    list avs=[];
    integer counter = llGetNumberOfPrims();
    while (llGetAgentSize(llGetLinkKey(counter)) != ZERO_VECTOR){
        avs += [llGetLinkKey(counter)];
        counter--;
    }    
    return avs;
}

default
{
    state_entry()
    {
    }

    link_message(integer sender_num, integer num, string str, key id){
        if (num == dismount){
            list tempList = llParseStringKeepNulls(str, ["~"], []);
            integer sitters = llGetListLength(tempList);
            integer n;
            llSleep(1.5);
            for (n=0; n<sitters; ++n){
                if (llListFindList(SeatedAvs(), [(key)llList2String(seatAndAv, (n * 2) + 1)]) != -1){
                    /|/slave will be doing all unsits from now on... link message out to the slave
                    llMessageLinked(LINK_SET, -222, llList2String(seatAndAv, (n * 2) + 1), NULL_KEY);
                }
            }
        }else if (num == seatupdate){
            integer seatcount;
            list seatsavailable = llParseStringKeepNulls(str, ["^"], []);
            integer stop = llGetListLength(seatsavailable)/8;
            seatAndAv = [];
            for (seatcount = 1; seatcount <= stop; ++seatcount){
                integer index = llSubStringIndex(llList2String(seatsavailable, (seatcount-1)*8+7), "seat");
                integer seatNum = (integer)llGetSubString(llList2String(seatsavailable, (seatcount-1)*8+7), index+4,-1);
                seatAndAv += [seatNum, llList2String(seatsavailable, (seatcount-1)*8+4)];
            }
        }
    }
}

*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 4.6.9.42974 - Howard Baxton
//mono


integer seatupdate = 35353;
list seatAndAv;
integer dismount = -221;
list SeatedAvs(){ 
    list avs=[];
    integer counter = llGetNumberOfPrims();
    while (llGetAgentSize(llGetLinkKey(counter)) != ZERO_VECTOR){
        avs += [llGetLinkKey(counter)];
        counter--;
    }    
    return avs;
}


default
{
    state_entry()
    {
    }

    link_message(integer sender_num, integer num, string str, key id){
        if (num == dismount){
            list tempList = llParseStringKeepNulls(str, ["~"], []);
            integer sitters = llGetListLength(tempList);
            integer n;
            llSleep(1.5);
            for (n=0; n<sitters; ++n){
                if (llListFindList(SeatedAvs(), [(key)llList2String(seatAndAv, (n * 2) + 1)]) != -1){
                    
                    llMessageLinked(LINK_SET, -222, llList2String(seatAndAv, (n * 2) + 1), NULL_KEY);
                }
            }
        }else if (num == seatupdate){
            integer seatcount;
            list seatsavailable = llParseStringKeepNulls(str, ["^"], []);
            integer stop = llGetListLength(seatsavailable)/8;
            seatAndAv = [];
            for (seatcount = 1; seatcount <= stop; ++seatcount){
                integer index = llSubStringIndex(llList2String(seatsavailable, (seatcount-1)*8+7), "seat");
                integer seatNum = (integer)llGetSubString(llList2String(seatsavailable, (seatcount-1)*8+7), index+4,-1);
                seatAndAv += [seatNum, llList2String(seatsavailable, (seatcount-1)*8+4)];
            }
        }
    }
}


