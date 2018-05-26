//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "state restore failed");
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	moving_end()
	{
		_test_Result(TRUE);
		_test_Shutdown();
	}
}