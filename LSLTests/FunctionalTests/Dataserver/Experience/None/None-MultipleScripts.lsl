//#!Enable:testing

key q;

integer local_received = 0;
integer remote_received = 0;

default
{
    state_entry()
    {
	    llSetTimerEvent(2);
        _test_Result(FALSE);
	key expId = llList2Key(llGetExperienceDetails(NULL_KEY), 2);
	if(!_test_InjectScript("Validator", "../tests/LSLTests/FunctionalTests/Dataserver/Experience/None/CheckNoReceive.lsli", 0, "11111111-2222-3333-4444-112233445566"))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
        llCreateKeyValue("MyKey", "MyValue");
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
	    ++remote_received;
    }
    
    dataserver(key q, string data)
    {
	    ++local_received;
    }
    
    timer()
    {
	    llSetTimerEvent(0);
	    llSay(PUBLIC_CHANNEL, "Local: " + (string)local_received + " Remote: " + (string)remote_received);
	    _test_Result(local_received == 1 && remote_received == 0);
	    _test_Shutdown();
    }
}
