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
	list l = [1,2];
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, (string)l);
		llSetTimerEvent(0);
		if(l != [1,2])
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