//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		key var;
		_test_Result(FALSE);
		llSay(PUBLIC_CHANNEL, "Variable => " + var);
		_test_Result(TRUE);
		_test_Shutdown();
	}
}