//#!Mode:ASSL
//#!Enable:Testing

default
{
	rotation r;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)r);
		_test_Result(r == ZERO_ROTATION);
		_test_Shutdown();
	}
}