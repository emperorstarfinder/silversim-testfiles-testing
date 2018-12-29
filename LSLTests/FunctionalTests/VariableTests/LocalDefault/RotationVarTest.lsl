//#!Enable: Testing

default
{
	state_entry()
	{
		rotation r;
		llSay(PUBLIC_CHANNEL, (string)r);
		_test_Result(r == ZERO_ROTATION);
		_test_Shutdown();
	}
}
