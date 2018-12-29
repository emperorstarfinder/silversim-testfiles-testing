//#!Mode:ASSL
//#!Enable:Testing

integer test = FALSE;
integer success = TRUE;

default
{
	vector v;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)v);
		if(v != ZERO_VECTOR)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected value at run " + test);
			success = FALSE;
		}
		v = llGetPos();
		if(test)
		{
			_test_Result(success);
			_test_Shutdown();
		}
		else
		{
			state other;
		}
	}
}

state other
{
	state_entry()
	{
		test = TRUE;
		state default;
	}
}