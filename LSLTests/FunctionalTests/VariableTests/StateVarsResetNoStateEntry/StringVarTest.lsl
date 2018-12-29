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
	string s = "Value";
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, s);
		llSetTimerEvent(0);
		if(s != "Value")
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