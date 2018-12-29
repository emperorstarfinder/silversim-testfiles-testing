//#!Mode:ASSL
//#!Enable:Testing

integer test = FALSE;
integer success = TRUE;

default
{
	float f = 2;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)f);
		if((f - 2) > 0.00001) /* we have to be a bit fuzzy here */
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