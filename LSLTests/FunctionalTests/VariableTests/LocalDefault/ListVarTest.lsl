//#!Enable: Testing

default
{
	state_entry()
	{
		list l;
		llSay(PUBLIC_CHANNEL, (string)l);
		_test_Result(l == []);
		_test_Shutdown();
	}
}
