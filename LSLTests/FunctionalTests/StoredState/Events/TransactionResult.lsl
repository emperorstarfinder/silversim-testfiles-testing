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
	
	transaction_result(key id, integer success, string replydata)
	{
		integer result = TRUE;
		if(id != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected id");
			result = FALSE;
		}
		if(!success)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected success");
			result = FALSE;
		}
		if(replydata != "Test Data")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected replydata");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}