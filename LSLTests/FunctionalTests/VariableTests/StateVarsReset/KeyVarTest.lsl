//#!Mode:ASSL
//#!Enable:Testing

integer test = FALSE;
integer success = TRUE;

default
{
	key k;
	
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, (string)k);
		if(k != "")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected value at run " + test);
			success = FALSE;
		}
		k = llGenerateKey();
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