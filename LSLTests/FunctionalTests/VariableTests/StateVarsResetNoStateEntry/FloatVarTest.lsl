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
	float f = 1.0;
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, (string)f);
		llSetTimerEvent(0);
		if(f != 1.0)
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