//#!Enable: Testing

default
{
	state_entry()
	{
		list l = [1,2];
		llSay(PUBLIC_CHANNEL, (string)l);
		_test_Result(l == [1,2]);
		_test_Shutdown();
	}
}
