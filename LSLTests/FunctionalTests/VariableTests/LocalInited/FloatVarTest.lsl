//#!Enable: Testing

default
{
	state_entry()
	{
		float f = 5.0;
		llSay(PUBLIC_CHANNEL, (string)f);
		_test_Result(f == 5.0);
		_test_Shutdown();
	}
}
