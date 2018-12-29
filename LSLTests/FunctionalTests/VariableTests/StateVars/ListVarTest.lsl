//#!Mode:ASSL
//#!Enable:Testing

default
{
	list l;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)l);
		_test_Result(l == []);
		_test_Shutdown();
	}
}