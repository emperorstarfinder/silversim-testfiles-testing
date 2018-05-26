//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "state restore failed");
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	changed(integer change)
	{
		integer result = TRUE;
		if(change != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected change");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}