//#!Mode:assl
//#!Enable:testing

default
{
    state_entry()
    {
        _test_Result(FALSE);
	if(!_test_InjectScript("Validator", "../tests/LSLTests/FunctionalTests/Notecard/TwoScripts/Validator.lsl", 0))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
        llMessageLinked(LINK_SET, 0, "", llGetNotecardLine("Notecard", 0));
    }
}
