//#!Enable: Testing

default
{
	state_entry()
	{
		key k;
		llSay(PUBLIC_CHANNEL, (string)k);
		_test_Result(k == "");
		_test_Shutdown();
	}
}
