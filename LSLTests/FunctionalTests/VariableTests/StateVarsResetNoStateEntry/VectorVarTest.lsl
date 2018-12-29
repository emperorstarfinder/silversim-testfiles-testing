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
	vector v = <1,1,1>;
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, (string)v);
		llSetTimerEvent(0);
		if(v != <1,1,1>)
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