//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
	if(!_test_InjectScript("Validator", "../tests/LSLTests/FunctionalTests/Dataserver/Region/Validator.lsli", 0))
	{
		llSay(PUBLIC_CHANNEL, "Failed to inject script");
		_test_Shutdown();
	}
        llMessageLinked(LINK_SET, 0, (string)llGetRegionCorner(), llRequestSimulatorData("Testing Region", DATA_SIM_POS));
    }
}
