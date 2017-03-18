//start_unprocessed_text
/*/|*
The nPose scripts are licensed under the GPLv2 (http:/|/www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in Second Life and/or other virtual world platforms derived from Second Life (such as OpenSim).  If the platform should allow more fine-grained permissions, then "full perms" will mean the most permissive possible set of permissions allowed by the platform.
*|/
/|/an adaptation of Schmobag Hogfather's SchmoDialog script

integer DIALOG = -900;
integer DIALOG_RESPONSE = -901;
integer DIALOG_TIMEOUT = -902;

integer pagesize = 12;
integer memusage = 34334;
string MORE = "More";
/|/string BACKBTN = "^";
/|/string SWAPBTN = "swap";
/|/string SYNCBTN = "sync";
string BLANK = " ";
integer timeout = 60;
integer repeat = 5;/|/how often the timer will go off, in seconds
integer channel;
integer listener = -1;

list menus;/|/8-strided list in form [recipient, dialogid, starttime, prompt, list buttons, page buttons, currentpage, path]
/|/where "list buttons" means the big list of choices presented to the user
/|/and "page buttons" means utility buttons that will appear on every page, such as one saying "go up one level"
/|/and "currentpage" is an integer meaning which page of the menu the user is currently viewing

integer stridelength = 8;

list avs;/|/fill this on start and update on changed_link.  leave dialogs open until avs stand

string Utf8Trim(string s, integer iLen)
/|/ This trims a string to iLen bytes interpreted as utf8 (not utf16).
/|/ The string returned will be utf16, but when interpreted as utf8,
/|/ it will be iLen bytes (not characters) or shorter.  Also, because
/|/ of the use of base64, it's best if iLen is a multiple of 3.  If
/|/ it's not, it will be rounded down to a multiple of 3 if trimming
/|/ is needed.  If trimming isn't needed, it will be unchanged regardless
/|/ of original length.
{
    string s2 = llStringToBase64(s);
    iLen = (iLen / 3) * 4; /|/ This winds up being a multiple of 4, rounded down.
    if (llStringLength(s2) > iLen) return llBase64ToString(llGetSubString(s2, 0, --iLen));
    return s;
}

list SeatedAvs()
{/|/like AvCount() but returns a list of seated avs, starting with lowest link number and moving up from there
    list avs;
    integer linkcount = llGetNumberOfPrims();
    integer n;
    for (n = linkcount; n >= 0; n--)
    {
        key id = llGetLinkKey(n);
        if (llGetAgentSize(id) != ZERO_VECTOR)
        {
            /|/it's a real av. add to list
            avs = [id] + avs;/|/adding it this way prevents having to reverse the av list later
        }
        else
        {
            /|/we've gotten down to a regular prim.  Break loop and return list
            return avs;
        }
    }
    /|/there must not have been anyone seated.  Shouldn't ever get here but LSL doesn't know that and wants a return value
    return [];
}

integer RandomUniqueChannel()
{
    integer out = llRound(llFrand(10000000)) + 100000;
    if (out == channel)
    {
        out = RandomUniqueChannel();
    }
    return out;
}

Dialog(key recipient, string prompt, list menuitems, list utilitybuttons, integer page, key id, string path)
{
    prompt = Utf8Trim(prompt, 483);
    string thisprompt = prompt + "(Timeout in 60 seconds.)\n";
    list buttons;
    list currentitems;
    integer numitems = llGetListLength(menuitems + utilitybuttons);
    integer start;
    integer mypagesize;
    if (llList2CSV(utilitybuttons) != ""){
        mypagesize = pagesize - llGetListLength(utilitybuttons);
    }else{
        mypagesize = pagesize;
    }
        
    /|/slice the menuitems by page
    if (numitems > pagesize)
    {
        mypagesize--;/|/we'll use one slot for the MORE button, so shrink the page accordingly
        start = page * mypagesize;
        integer end = start + mypagesize - 1;
        /|/multi page menu
        currentitems = llList2List(menuitems, start, end);
    }
    else
    {
        start = 0;
        currentitems = menuitems;
    }
    
    integer stop = llGetListLength(currentitems);
    integer n;
    for (n = 0; n < stop; n++)
    {
        string name = llList2String(menuitems, start + n);
        buttons += [name];
    }
    buttons = SanitizeButtons(buttons);
    utilitybuttons = SanitizeButtons(utilitybuttons);
    
    integer menusIndex = llListFindList(menus, [recipient]);
    if(menusIndex >= 0) {
        menus = RemoveMenuStride(menus, menusIndex);
    }
    if(!~listener) {
        listener = llListen(channel, "", NULL_KEY, "");
        llSetTimerEvent(repeat);
    }
    if (numitems > pagesize)
    {
        llDialog(recipient, thisprompt, PrettyButtons(buttons, utilitybuttons + [MORE]), channel);      
    }
    else
    {
        llDialog(recipient, thisprompt, PrettyButtons(buttons, utilitybuttons), channel);
    }    
    integer ts = -1;
    if (llListFindList(avs, [recipient]) == -1)
    {
        ts = llGetUnixTime();
    }
    
    menus += [recipient, id, ts, prompt, llDumpList2String(menuitems, "|"), llDumpList2String(utilitybuttons, "|"), page, path];
}

list SanitizeButtons(list in)
{
    integer length = llGetListLength(in);
    integer n;
    for (n = length - 1; n >= 0; n--)
    {
        integer type = llGetListEntryType(in, n);
        if (llList2String(in, n) == "") /|/remove empty strings
        {
            in = llDeleteSubList(in, n, n);
        }        
        else if (type != TYPE_STRING)        /|/cast anything else to string
        {
            in = llListReplaceList(in, [llList2String(in, n)], n, n);
        }
    }
    return in;
}

list PrettyButtons(list options, list utilitybuttons)
{/|/returns a list formatted to that "options" will start in the top left of a dialog, and "utilitybuttons" will start in the bottom right
    list spacers;
    list combined = options + utilitybuttons;
    while (llGetListLength(combined) % 3 != 0 && llGetListLength(combined) < 12)    
    {
        spacers += [BLANK];
        combined = options + spacers + utilitybuttons;
    }    
    
    list out = llList2List(combined, 9, 11);
    out += llList2List(combined, 6, 8);
    out += llList2List(combined, 3, 5);    
    out += llList2List(combined, 0, 2);    
    return out;    
}


list RemoveMenuStride(list menu, integer index)
{
    /|/tell this function the menu you wish to remove, identified by list index
    /|/it will remove the menu's entry from the list, and return the new list
    /|/should be called in the listen event, and on menu timeout    
    return llDeleteSubList(menu, index, index + stridelength - 1);
}

CleanList()
{
    debug("cleaning list");
    /|/loop through menus, check their start times against current time, remove any that are more than <timeout> seconds old
    /|/start at end of list and loop down so that indexes don't get messed up as we remove items
    integer length = llGetListLength(menus);
    integer n;
    for (n = length - stridelength; n >= 0; n -= stridelength)
    {
        integer starttime = llList2Integer(menus, n + 2);
        debug("starttime: " + (string)starttime);
        if (starttime == -1)
        {          
            /|/menu was for seated av.  close if they're not seated anymore
            key av = (key)llList2String(menus, n);
            if (llListFindList(avs, [av]) == -1)
            {
                debug("mainmenu stood");
                menus = RemoveMenuStride(menus, n);
            }
        }
        else
        {/|/was a plain old non-seated menu, most likely for owner.  Do timeouts normally
            integer age = llGetUnixTime() - starttime;
            if (age > timeout)
            {
                debug("mainmenu timeout");                
                key id = llList2Key(menus, n + 1);
                llMessageLinked(LINK_SET, DIALOG_TIMEOUT, "", id);
                menus = RemoveMenuStride(menus, n);
            }            
        }
    }
}

debug(string str)
{
    /|/llOwnerSay(llGetScriptName() + ": " + str);
}

default
{    
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        channel = RandomUniqueChannel();
        avs = SeatedAvs();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            avs = SeatedAvs();
            /|/loop through dialogs and close any for avs that aren't seated.  except for obj owner
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == memusage) {
            llSay(0,"Memory Used by " + llGetScriptName() + ": " + (string)llGetUsedMemory() + " of " + (string)llGetMemoryLimit() + ", Leaving " + (string)llGetFreeMemory() + " memory free.");
        } else if (num == DIALOG)
        {/|/give a dialog with the options on the button labels
            /|/str will be pipe-delimited list with rcpt|prompt|page|backtick-delimited-list-buttons|backtick-delimited-utility-buttons
            debug(str);
            list params = llParseStringKeepNulls(str, ["|"], []);
            key rcpt = (key)llList2String(params, 0);
            string prompt = llList2String(params, 1);
            integer page = (integer)llList2String(params, 2);
            string path = llList2String(params, 5);
            list lbuttons = llParseStringKeepNulls(llList2String(params, 3), ["`"], []);
            list ubuttons = llParseStringKeepNulls(llList2String(params, 4), ["`"], []);            
            Dialog(rcpt, prompt, lbuttons, ubuttons, page, id, path);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        integer menuindex = llListFindList(menus, [id]);
        if (~menuindex)
        {
            key menuid = llList2Key(menus, menuindex + 1);
            string prompt = llList2String(menus, menuindex + 3);            
            list items = llParseStringKeepNulls(llList2String(menus, menuindex + 4), ["|"], []);
            list ubuttons = llParseStringKeepNulls(llList2String(menus, menuindex + 5), ["|"], []);
            integer page = llList2Integer(menus, menuindex + 6);
            string path = llList2String(menus, menuindex + 7);
            menus = RemoveMenuStride(menus, menuindex);              
            if (message == MORE)
            {
                debug((string)page);
                /|/increase the page num and give new menu
                page++;
                integer thispagesize = pagesize - llGetListLength(ubuttons) - 1;
                if (page * thispagesize > llGetListLength(items))
                {
                    page = 0;
                }
                Dialog(id, prompt, items, ubuttons, page, menuid, path);
            }
            else if (message == BLANK)
            {
                /|/give the same menu back
                Dialog(id, prompt, items, ubuttons, page, menuid, path);
            }            
            else
            {
                llMessageLinked(LINK_SET, DIALOG_RESPONSE, (string)page + "|" + message + "|" + (string)id + "|" + path, menuid);
            }       
        }
    }
    
    timer()
    {
        CleanList();    
        
        /|/if list is empty after that, then stop timer
        
        if (!llGetListLength(menus))
        {
            llListenRemove(listener);
            listener = -1;
            llSetTimerEvent(0.0);
        }
    }
}
*/
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Firestorm-Releasex64 4.7.3.47323 - Howard Baxton
//mono







integer DIALOG = -900;
integer DIALOG_RESPONSE = -901;
integer DIALOG_TIMEOUT = -902;

integer pagesize = 12;
integer memusage = 34334;
string MORE = "More";



string BLANK = " ";
integer timeout = 60;
integer repeat = 5;
integer channel;
integer listener = -1;

list menus;




integer stridelength = 8;

list avs;

debug(string str)
{
    
}

string Utf8Trim(string s, integer iLen)







{
    string s2 = llStringToBase64(s);
    iLen = (iLen / 3) * 4; 
    if (llStringLength(s2) > iLen) return llBase64ToString(llGetSubString(s2, 0, --iLen));
    return s;
}

list SeatedAvs()
{
    list avs;
    integer linkcount = llGetNumberOfPrims();
    integer n;
    for (n = linkcount; n >= 0; n--)
    {
        key id = llGetLinkKey(n);
        if (llGetAgentSize(id) != ZERO_VECTOR)
        {
            
            avs = [id] + avs;
        }
        else
        {
            
            return avs;
        }
    }
    
    return [];
}

list SanitizeButtons(list in)
{
    integer length = llGetListLength(in);
    integer n;
    for (n = length - 1; n >= 0; n--)
    {
        integer type = llGetListEntryType(in, n);
        if (llList2String(in, n) == "") 
        {
            in = llDeleteSubList(in, n, n);
        }        
        else if (type != TYPE_STRING)        
        {
            in = llListReplaceList(in, [llList2String(in, n)], n, n);
        }
    }
    return in;
}


list RemoveMenuStride(list menu, integer index)
{
    
    
    
    return llDeleteSubList(menu, index, index + stridelength - 1);
}

integer RandomUniqueChannel()
{
    integer out = llRound(llFrand(10000000)) + 100000;
    if (out == channel)
    {
        out = RandomUniqueChannel();
    }
    return out;
}

list PrettyButtons(list options, list utilitybuttons)
{
    list spacers;
    list combined = options + utilitybuttons;
    while (llGetListLength(combined) % 3 != 0 && llGetListLength(combined) < 12)    
    {
        spacers += [BLANK];
        combined = options + spacers + utilitybuttons;
    }    
    
    list out = llList2List(combined, 9, 11);
    out += llList2List(combined, 6, 8);
    out += llList2List(combined, 3, 5);    
    out += llList2List(combined, 0, 2);    
    return out;    
}

Dialog(key recipient, string prompt, list menuitems, list utilitybuttons, integer page, key id, string path)
{
    prompt = Utf8Trim(prompt, 483);
    string thisprompt = prompt + "(Timeout in 60 seconds.)\n";
    list buttons;
    list currentitems;
    integer numitems = llGetListLength(menuitems + utilitybuttons);
    integer start;
    integer mypagesize;
    if (llList2CSV(utilitybuttons) != ""){
        mypagesize = pagesize - llGetListLength(utilitybuttons);
    }else{
        mypagesize = pagesize;
    }
        
    
    if (numitems > pagesize)
    {
        mypagesize--;
        start = page * mypagesize;
        integer end = start + mypagesize - 1;
        
        currentitems = llList2List(menuitems, start, end);
    }
    else
    {
        start = 0;
        currentitems = menuitems;
    }
    
    integer stop = llGetListLength(currentitems);
    integer n;
    for (n = 0; n < stop; n++)
    {
        string name = llList2String(menuitems, start + n);
        buttons += [name];
    }
    buttons = SanitizeButtons(buttons);
    utilitybuttons = SanitizeButtons(utilitybuttons);
    
    integer menusIndex = llListFindList(menus, [recipient]);
    if(menusIndex >= 0) {
        menus = RemoveMenuStride(menus, menusIndex);
    }
    if(!~listener) {
        listener = llListen(channel, "", NULL_KEY, "");
        llSetTimerEvent(repeat);
    }
    if (numitems > pagesize)
    {
        llDialog(recipient, thisprompt, PrettyButtons(buttons, utilitybuttons + [MORE]), channel);      
    }
    else
    {
        llDialog(recipient, thisprompt, PrettyButtons(buttons, utilitybuttons), channel);
    }    
    integer ts = -1;
    if (llListFindList(avs, [recipient]) == -1)
    {
        ts = llGetUnixTime();
    }
    
    menus += [recipient, id, ts, prompt, llDumpList2String(menuitems, "|"), llDumpList2String(utilitybuttons, "|"), page, path];
}

CleanList()
{
    debug("cleaning list");
    
    
    integer length = llGetListLength(menus);
    integer n;
    for (n = length - stridelength; n >= 0; n -= stridelength)
    {
        integer starttime = llList2Integer(menus, n + 2);
        debug("starttime: " + (string)starttime);
        if (starttime == -1)
        {          
            
            key av = (key)llList2String(menus, n);
            if (llListFindList(avs, [av]) == -1)
            {
                debug("mainmenu stood");
                menus = RemoveMenuStride(menus, n);
            }
        }
        else
        {
            integer age = llGetUnixTime() - starttime;
            if (age > timeout)
            {
                debug("mainmenu timeout");                
                key id = llList2Key(menus, n + 1);
                llMessageLinked(LINK_SET, DIALOG_TIMEOUT, "", id);
                menus = RemoveMenuStride(menus, n);
            }            
        }
    }
}

default
{    
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        channel = RandomUniqueChannel();
        avs = SeatedAvs();
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            avs = SeatedAvs();
            
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == memusage) {
            llSay(0,"Memory Used by " + llGetScriptName() + ": " + (string)llGetUsedMemory() + " of " + (string)llGetMemoryLimit() + ", Leaving " + (string)llGetFreeMemory() + " memory free.");
        } else if (num == DIALOG)
        {
            
            debug(str);
            list params = llParseStringKeepNulls(str, ["|"], []);
            key rcpt = (key)llList2String(params, 0);
            string prompt = llList2String(params, 1);
            integer page = (integer)llList2String(params, 2);
            string path = llList2String(params, 5);
            list lbuttons = llParseStringKeepNulls(llList2String(params, 3), ["`"], []);
            list ubuttons = llParseStringKeepNulls(llList2String(params, 4), ["`"], []);            
            Dialog(rcpt, prompt, lbuttons, ubuttons, page, id, path);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        integer menuindex = llListFindList(menus, [id]);
        if (~menuindex)
        {
            key menuid = llList2Key(menus, menuindex + 1);
            string prompt = llList2String(menus, menuindex + 3);            
            list items = llParseStringKeepNulls(llList2String(menus, menuindex + 4), ["|"], []);
            list ubuttons = llParseStringKeepNulls(llList2String(menus, menuindex + 5), ["|"], []);
            integer page = llList2Integer(menus, menuindex + 6);
            string path = llList2String(menus, menuindex + 7);
            menus = RemoveMenuStride(menus, menuindex);              
            if (message == MORE)
            {
                debug((string)page);
                
                page++;
                integer thispagesize = pagesize - llGetListLength(ubuttons) - 1;
                if (page * thispagesize > llGetListLength(items))
                {
                    page = 0;
                }
                Dialog(id, prompt, items, ubuttons, page, menuid, path);
            }
            else if (message == BLANK)
            {
                
                Dialog(id, prompt, items, ubuttons, page, menuid, path);
            }            
            else
            {
                llMessageLinked(LINK_SET, DIALOG_RESPONSE, (string)page + "|" + message + "|" + (string)id + "|" + path, menuid);
            }       
        }
    }
    
    timer()
    {
        CleanList();    
        
        
        
        if (!llGetListLength(menus))
        {
            llListenRemove(listener);
            listener = -1;
            llSetTimerEvent(0.0);
        }
    }
}

