//#!Enable: Testing

default
{
	state_entry()
	{
		vector v;
		llSay(PUBLIC_CHANNEL, (string)v);
		_test_Result(v == ZERO_VECTOR);
		_test_Shutdown();
	}
}
