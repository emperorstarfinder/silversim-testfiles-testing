//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		vector var;
		_test_Result(FALSE);
		llSay(PUBLIC_CHANNEL, "Variable => " + var);
		_test_Result(TRUE);
		_test_Shutdown();
	}
}