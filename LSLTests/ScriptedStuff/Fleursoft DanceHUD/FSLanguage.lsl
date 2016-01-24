// LSL script generated: FSLanguage.lslp Sun Jan 24 18:17:31 Mitteleuropäische Zeit 2016

list Keys = [];
list Messages = [];
list lookUsUp = [];
integer line = 0;
key readLineId = NULL_KEY;
integer loadingMsgs = FALSE;
OwnerSay(string errorCode,list params){
    integer paramCount;
    list msgParts;
    integer msgLength;
    string item;
    list numberCheck = ["1","2","3","4","5","6","7","8","9"];
    integer i;
    integer j;
    integer k;
    string messageOut;
    key sendTo = "";
    (paramCount = llGetListLength(params));
    (msgParts = llParseString2List(errorCode,["|"],[]));
    if ((llGetListLength(msgParts) > 1)) (sendTo = llList2Key(msgParts,1));
    (i = llListFindList(Keys,[llList2String(msgParts,0)]));
    if ((i != (-1))) {
        (messageOut = llList2String(Messages,i));
        (msgParts = llParseStringKeepNulls(messageOut,["&"],[]));
        (msgLength = llGetListLength(msgParts));
        (messageOut = llList2String(msgParts,0));
        for ((i = 1); (i < msgLength); (++i)) {
            (item = llList2String(msgParts,i));
            (k = llStringLength(item));
            if ((k > 0)) {
                (j = llListFindList(numberCheck,[llGetSubString(item,0,0)]));
                if ((j != (-1))) {
                    if ((j < paramCount)) {
                        if ((k > 1)) (messageOut = ((((messageOut = "") + messageOut) + llList2String(params,j)) + llGetSubString(item,1,(-1))));
                        else  (messageOut = (((messageOut = "") + messageOut) + llList2String(params,j)));
                    }
                    else  {
                        (messageOut = ((((((messageOut = "") + messageOut) + "(missing parameter number ") + ((string)j)) + ") &") + item));
                    }
                }
                else  {
                    (messageOut = ((((messageOut = "") + messageOut) + "&") + item));
                }
            }
        }
        if ((sendTo == "")) {
            llOwnerSay(messageOut);
        }
        else  {
            llInstantMessage(sendTo,messageOut);
        }
    }
    else  llOwnerSay(("Error - unknown error message code:" + errorCode));
}
default {

 state_entry() {
        if ((llGetInventoryType("~FSErrors") == INVENTORY_NOTECARD)) {
            (loadingMsgs = TRUE);
            (readLineId = llGetNotecardLine("~FSErrors",line));
        }
        else  llOwnerSay((("Error message configuration notecard '" + "~FSErrors") + "' is missing - many error messages will not make any sense."));
    }

 link_message(integer sender_num,integer num,string str,key id) {
        if (((num == 0) && (str == "RESET"))) {
            llResetScript();
        }
        if ((num == 12123405)) {
            if (loadingMsgs) (lookUsUp = (((lookUsUp = []) + lookUsUp) + [llDumpList2String([str,((string)id)],"|")]));
            else  OwnerSay(str,llParseString2List(((string)id),["|"],[]));
        }
    }

 dataserver(key request_id,string data) {
        if ((request_id == readLineId)) {
            if ((data != EOF)) {
                list p = llParseStringKeepNulls(data,[" "],[]);
                if ((llGetListLength(p) > 0)) {
                    (Keys = (((Keys = []) + Keys) + [llList2String(p,0)]));
                    (p = ((p = []) + llDeleteSubList(p,0,0)));
                    (Messages = (((Messages = []) + Messages) + [llDumpList2String(p," ")]));
                    (++line);
                    (readLineId = llGetNotecardLine("~FSErrors",line));
                }
            }
            else  {
                (loadingMsgs = FALSE);
                if ((lookUsUp != [])) {
                    integer i;
                    list p;
                    string str;
                    for ((i = 0); (i < llGetListLength(lookUsUp)); (++i)) {
                        (p = llParseString2List(llList2String(lookUsUp,i),["|"],[]));
                        (str = llList2String(p,0));
                        (p = ((p = []) + llDeleteSubList(p,0,0)));
                        OwnerSay(str,p);
                    }
                }
            }
        }
    }
}
