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
	
	on_rez(integer startpara)
	{
		integer result = TRUE;
		if(startpara != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected startpara");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}