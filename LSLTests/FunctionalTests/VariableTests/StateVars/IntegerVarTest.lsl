//#!Mode:ASSL
//#!Enable:Testing

default
{
	integer i;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)i);
		_test_Result(i == 0);
		_test_Shutdown();
	}
}