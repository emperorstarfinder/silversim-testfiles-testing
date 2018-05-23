//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(osGetNumberOfNotecardLines("Notecard") == 10);
		_test_Shutdown();
	}
}
