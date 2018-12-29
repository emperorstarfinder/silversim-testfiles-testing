//#!Enable: Testing

default
{
	state_entry()
	{
		string s;
		llSay(PUBLIC_CHANNEL, s);
		_test_Result(s == "");
		_test_Shutdown();
	}
}
