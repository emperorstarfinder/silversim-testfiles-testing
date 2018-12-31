//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		list var = ["1","2"];
		_test_Result(FALSE);
		llSay(PUBLIC_CHANNEL, var + var);
		_test_Result(TRUE);
		_test_Shutdown();
	}
}