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
	
	remote_data(integer event_type, key channel, key message_id, string sender, integer idata, string sdata)
	{
		integer result = TRUE;
		if(event_type != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected event_type");
			result = FALSE;
		}
		if(channel != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected channel");
			result = FALSE;
		}
		if(message_id != "11223344-2211-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected message_id");
			result = FALSE;
		}
		if(sender != "Test Sender")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected sender");
			result = FALSE;
		}
		if(idata != 5)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected idata");
			result = FALSE;
		}
		if(sdata != "Test Data")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected sdata");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}