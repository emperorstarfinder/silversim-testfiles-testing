//#!Enable:testing

key q;

default
{
	state_entry()
	{
		_test_Result(FALSE);
		q = llGetNumberOfNotecardLines("Notecard");
	}
	
	dataserver(key r, string data)
	{
		llSay(PUBLIC_CHANNEL, data);
		_test_Result(r == q && data == "10");
		_test_Shutdown();
	}
}
