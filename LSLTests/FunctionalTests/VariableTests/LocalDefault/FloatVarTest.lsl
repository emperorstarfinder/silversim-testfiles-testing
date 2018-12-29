//#!Enable: Testing

default
{
	state_entry()
	{
		float f;
		llSay(PUBLIC_CHANNEL, (string)f);
		_test_Result(f == 0);
		_test_Shutdown();
	}
}
