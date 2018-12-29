//#!Mode:ASSL
//#!Enable:Testing

default
{
	float f;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)f);
		_test_Result(f == 0.0);
		_test_Shutdown();
	}
}