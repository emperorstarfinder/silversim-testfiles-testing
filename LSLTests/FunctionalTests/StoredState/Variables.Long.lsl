//#!Enable:LongInteger
//#!Enable:testing

long Long;

default
{
	state_entry()
	{
	}
	
	timer()
	{
		llSetTimerEvent(0);
		integer result = TRUE;
		if((string)Long != "4000000000")
		{
			llSay(PUBLIC_CHANNEL, "Restore of Long failed: " + (string)Long);
			result = FALSE;
		}
		
		_test_Result(result);
		_test_Shutdown();
	}
}