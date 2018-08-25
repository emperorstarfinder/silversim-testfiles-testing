//#!Enable:testing

key r1 = NULL_KEY;
key r2 = NULL_KEY;

default
{
	state_entry()
	{
		llSetTimerEvent(0.8);
	}
	
	link_message(integer sender, integer num, string str, key id)
	{
		llOwnerSay("link_message received " + (string)id);
		r1 = id;
		_test_Result(r1 == r2);
	}
	
	dataserver(key id, string data)
	{
		llOwnerSay("dataserver received " + (string)id);
		r2 = id;
		_test_Result(r1 == r2);
	}
	
	timer()
	{
		_test_Shutdown();
	}
}