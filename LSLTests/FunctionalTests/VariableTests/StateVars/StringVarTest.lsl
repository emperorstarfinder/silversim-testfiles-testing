//#!Mode:ASSL
//#!Enable:Testing

default
{
	string s;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)s);
		_test_Result(s == "");
		_test_Shutdown();
	}
}