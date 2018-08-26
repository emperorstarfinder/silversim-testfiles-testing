//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
	key expId = llList2Key(llGetExperienceDetails(NULL_KEY), 2);
	if(!_test_InjectScript("Validator", "../tests/LSLTests/FunctionalTests/Dataserver/Experience/ValidatorExperience.lsli", 0, expId))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
	if(!_test_InjectScript("Validator Fail", "../tests/LSLTests/FunctionalTests/Dataserver/Experience/ValidatorExperienceFail.lsli", 0, NULL_KEY))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
	if(!_test_InjectScript("Validator Fail 1", "../tests/LSLTests/FunctionalTests/Dataserver/Experience/ValidatorExperienceFail.lsli", 0, "11111111-2222-3333-4444-112233445566"))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
        llMessageLinked(LINK_SET, 0, "1,0,-1", llDataSizeKeyValue());
    }
    
    dataserver(key q, string data)
    {
	    llSay(PUBLIC_CHANNEL, "Test script received: " + (string)q + ":" + data);
    }
}
