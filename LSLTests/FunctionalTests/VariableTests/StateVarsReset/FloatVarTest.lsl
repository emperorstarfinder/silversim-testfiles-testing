//#!Mode:ASSL
//#!Enable:Testing

integer test = FALSE;
integer success = TRUE;

default
{
	float f;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)f);
		if(f != 0)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected value at run " + test);
			success = FALSE;
		}
		f = 5;
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