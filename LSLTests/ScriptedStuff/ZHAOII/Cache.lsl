///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: Cache.lsl 3 2007-01-28 23:10:44Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

list overrideCSV = ["","","","","","","","","","","",""];

default
{
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            // We might have a changed notecard, go ahead and clear the cache just to be safe.
            overrideCSV = ["","","","","","","","","","","",""];
        }
    }

    link_message(integer sender, integer index, string message, key id)
    {
        if(message == "Get Override")
        {
            llMessageLinked(LINK_ROOT, -1, "Recive Override", (key)llList2String(overrideCSV, index));
        }
        else if(message == "Store Override")
        {
            overrideCSV = llListReplaceList(overrideCSV, [(string)id], index, index);
            llOwnerSay("Cached notecard for future use. ("+(string)llCeil(100 * llGetFreeMemory() / (float)(16*1024))+"% of cache available)");
        }
    }
}
