//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
	if(!_test_InjectScript("Validator", "../tests/LSLTests/FunctionalTests/Dataserver/Agent/Validator.lsli", 0))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
        llMessageLinked(LINK_SET, 0, "Script.Test.@localhost:8002", llRequestUsername(llGetOwner()));
    }
}
