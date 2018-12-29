//#!Enable: Testing

default
{
	state_entry()
	{
		integer i;
		llSay(PUBLIC_CHANNEL, (string)i);
		_test_Result(i == 0);
		_test_Shutdown();
	}
}
