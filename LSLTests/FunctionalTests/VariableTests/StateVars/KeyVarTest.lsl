//#!Mode:ASSL
//#!Enable:Testing

default
{
	key k;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)k);
		_test_Result(k == "");
		_test_Shutdown();
	}
}