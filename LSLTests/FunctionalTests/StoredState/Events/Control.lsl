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
	
	control(key id, integer level, integer edge)
	{
		integer result = TRUE;
		if(id != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected id");
			result = FALSE;
		}
		if(level != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected level");
			result = FALSE;
		}
		if(edge != 2)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected edge");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}