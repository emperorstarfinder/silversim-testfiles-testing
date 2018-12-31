//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		key var = NULL_KEY;
		_test_Result(FALSE);
		llSay(PUBLIC_CHANNEL, var + var);
		_test_Result(TRUE);
		_test_Shutdown();
	}
}