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
	
	money(key id, integer amount)
	{
		integer result = TRUE;
		if(id != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected id");
			result = FALSE;
		}
		if(amount != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected amount");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}