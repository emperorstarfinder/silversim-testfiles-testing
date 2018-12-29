//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		llSetTimerEvent(0.2);
		_test_Result(FALSE);
		state other;
	}
}

state other
{
	key k = NULL_KEY;
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, (string)k);
		llSetTimerEvent(0);
		if(k != NULL_KEY)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected value");
		}
		else
		{
			_test_Result(TRUE);
		}
		_test_Shutdown();	
	}
}