//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, "Timer");
		_test_Result(TRUE);
		_test_Shutdown();
	}
}