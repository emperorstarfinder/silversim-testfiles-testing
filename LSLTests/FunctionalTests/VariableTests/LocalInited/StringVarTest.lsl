//#!Enable: Testing

default
{
	state_entry()
	{
		string s = "World";
		llSay(PUBLIC_CHANNEL, s);
		_test_Result(s == "World");
		_test_Shutdown();
	}
}
