//#!Mode:ASSL
//#!Enable:Testing

integer test = FALSE;
integer success = TRUE;

default
{
	rotation r;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)r);
		if(r != ZERO_ROTATION)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected value at run " + test);
			success = FALSE;
		}
		r = <1,1,1,1>;
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