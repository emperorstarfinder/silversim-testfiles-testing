///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: Button Handler.lsl 4 2007-02-03 18:13:52Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

string myName;
string myTexture;

key notecardKey;
list layout = [];
integer lineNum = 0;

vector offsetShown;
vector offsetHidden;

default
{
	state_entry()
	{
		myName = llGetLinkName(llGetLinkNumber());

		notecardKey = llGetNotecardLine("layout", lineNum);

		// Get and set the button texture
		myTexture = llGetInventoryName(INVENTORY_TEXTURE, 0);
		llSetTexture(myTexture, 4);
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
		llMessageLinked(LINK_ROOT, 0, myName, NULL_KEY);
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
		else if(attachPoint >= 31 && attachPoint <= 38)
		{
			attachPoint -= 31;
			list offsets = llCSV2List(llList2String(layout, attachPoint));
			offsetShown = (vector)llList2String(offsets, 0);
			offsetHidden = (vector)llList2String(offsets, 1);
		}
	}
}
