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
	
	object_message(key id, string data)
	{
		integer result = TRUE;
		if(id != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected id");
			result = FALSE;
		}
		if(data != "Test Data")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected data");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
	
	dataserver(key id, string data)
	{
		llSay(PUBLIC_CHANNEL, "dataserver should not receive object_message here");
		_test_Result(FALSE);
		_test_Shutdown();
	}
}