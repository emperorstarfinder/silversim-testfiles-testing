///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: Button Handler MenuHide.lsl 1 2007-01-28 05:38:29Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

string onTexture = "menu";
string offTexture = "hide";

key notecardKey;
list layout = [];
integer lineNum = 0;

integer myState;

default
{
	state_entry()
	{
		llSetTexture(onTexture, 4);

		notecardKey = llGetNotecardLine("layout", lineNum);

		myState = TRUE;
		llMessageLinked(LINK_SET, 0, "Menu", NULL_KEY);
	}

	dataserver(key query_id, string line)
	{
		if(query_id == notecardKey && line != EOF)
		{
			list cache = llParseStringKeepNulls(line, [";"], []);
			layout = (layout = []) + layout + llList2String(cache, 0);
			lineNum++;
			notecardKey = llGetNotecardLine("layout", lineNum);
		}
	}

	touch_start(integer total_number)
	{
		if (llDetectedKey(0) != llGetOwner()){return;}
		if(myState)
		{
			myState = FALSE;
			llMessageLinked(LINK_SET, 0, "Hide", NULL_KEY);
		}
		else
		{
			myState = TRUE;
			llMessageLinked(LINK_SET, 0, "Menu", NULL_KEY);
		}
	}

	link_message(integer sender, integer attachPoint, string message, key id)
	{
		if (message == "Menu")
		{
			llSetTexture(offTexture, 4);
		}
		else if (message == "Hide")
		{
			llSetTexture(onTexture, 4);
		}
		else if(attachPoint >= 31 && attachPoint <= 38)
		{
			attachPoint -= 31;
			llSetPos((vector)llList2String(layout, attachPoint));
		}
	}
}
