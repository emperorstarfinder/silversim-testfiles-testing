//#!Enable: Testing

default
{
	state_entry()
	{
		integer i = 10;
		llSay(PUBLIC_CHANNEL, (string)i);
		_test_Result(i == 10);
		_test_Shutdown();
	}
}
