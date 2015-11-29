//basically, we need a large datastore for our command set
list lmNames;
list lmAction;

integer MSG_DATA_MENU=310;
integer MSG_DATA_TYPE=320;
integer MSG_DATA_POSE=330;
integer MSG_DATA_LM=335;

integer MSG_DO_POSE=350;
integer MSG_DO_LM=351;
integer MSG_DO_SPECIAL=352;

integer MSG_DO_SOUND=356;

integer MSG_SET_RUNNING=340;
integer MSG_STORAGE_RESET=341;
integer MSG_DATA_READY=309;



default
{
    state_entry()
    {
    }

    link_message (integer sn, integer n, string m, key id) {
        if (n==MSG_DATA_LM) {
            //add action    
            lmNames+=m;
            lmAction+=(string)id;
        } else
        if (n==MSG_SET_RUNNING)
            state running;
    }
}

state running {
    state_entry()
    {
        llOwnerSay ("Action manager free memory : "+(string)llGetFreeMemory());    
    }    
    link_message (integer sn, integer n, string m, key id) {
        if (n==MSG_DO_LM) {
            integer i=llListFindList(lmNames, [m]);
            if (i>=0) {
                list l=llParseString2List(llList2String(lmAction, i), [","],[]);
                integer set=(integer)llList2String(l,1);    
                integer num=(integer)llList2String(l,2);    
                //string mess=llStringTrim(llList2String(l,3),STRING_TRIM);
                string mess=llDumpList2String(llList2List(l,3,-1), ",");
                integer nomenu=(integer)llList2String(l,0);    
                //perform requested action
                llMessageLinked (set, num, mess, id);
                
                //if (!nomenu) //this will fail when not found, which it shouldnt.
                //    llMessageLinked (LINK_THIS, 370, "", id);
            }   
        } else
        if (n==MSG_DO_SOUND) {
            //LM list was abused for sound info
            integer i=llListFindList(lmNames, [m]);
            if (i>=0)
                llTriggerSound(llList2String(lmAction, i), 1.);
        }
        else
        if (n==MSG_STORAGE_RESET)
            llResetScript();
    }
    
}