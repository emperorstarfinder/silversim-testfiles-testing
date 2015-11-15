///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: Button Handler SitOnOff.lsl 4 2007-02-03 18:13:52Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

string onTexture = "siton";
string offTexture = "sitoff";

key notecardKey;
list layout = [];
integer lineNum = 0;

vector offsetShown;
vector offsetHidden;

integer myState;

default
{
	state_entry()
	{
		notecardKey = llGetNotecardLine("layout", lineNum);

		myState = TRUE;
		llSetTexture(onTexture, 4);
		llMessageLinked(LINK_ROOT, 0, "Sit On", NULL_KEY);
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
			llSetTexture(offTexture, 4);
			llMessageLinked(LINK_ROOT, 0, "Sit Off", NULL_KEY);
		}
		else
		{
			myState = TRUE;
			llSetTexture(onTexture, 4);
			llMessageLinked(LINK_ROOT, 0, "Sit On", NULL_KEY);
		}
	}

	link_message(integer sender, integer attachPoint, string message, key id)
	{
		if (message == "Menu")
		{
			llSetPos(offsetShown);
		}
		else if (message == "Hide")
		{
			llSetPos(offsetHidden);
		}
		else if(message == "Sit Off")
		{
			myState = FALSE;
			llSetTexture(offTexture, 4);
			llMessageLinked(LINK_ROOT, 0, "Sit Off", NULL_KEY);
		}
		else if(message == "Sit On")
		{
			myState = TRUE;
			llSetTexture(onTexture, 4);
			llMessageLinked(LINK_ROOT, 0, "Sit On", NULL_KEY);
		}

		else if(attachPoint >= 31 && attachPoint <= 38)
		{
			attachPoint -= 31;
			list offsets = llCSV2List(llList2String(layout, attachPoint));
			offsetShown = (vector)llList2String(offsets, 0);
			offsetHidden = (vector)llList2String(offsets, 1);
		}
	}
}
