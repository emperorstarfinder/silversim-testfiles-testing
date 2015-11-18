integer debug;
string str;
key id;

default
{
	state_entry()
	{
		if (debug) llOwnerSay("DEBUG: =database-keys.lsl: link_message(): str("+str+") id("+(string)id+")");
	}
}
