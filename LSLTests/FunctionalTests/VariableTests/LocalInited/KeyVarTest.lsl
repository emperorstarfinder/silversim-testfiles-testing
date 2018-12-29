//#!Enable: Testing

default
{
	state_entry()
	{
		key k = NULL_KEY;
		llSay(PUBLIC_CHANNEL, (string)k);
		_test_Result(k == NULL_KEY);
		_test_Shutdown();
	}
}
