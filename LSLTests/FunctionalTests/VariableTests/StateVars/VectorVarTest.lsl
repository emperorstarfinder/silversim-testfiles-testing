//#!Mode:ASSL
//#!Enable:Testing

default
{
	vector v;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)v);
		_test_Result(v == ZERO_VECTOR);
		_test_Shutdown();
	}
}