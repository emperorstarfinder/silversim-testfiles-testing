//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	listen(integer channel, string name, key id, string data)
	{
		integer result = TRUE;
		if(channel != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected channel");
			result = FALSE;
		}
		if(name != "Test Name")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected name");
			result = FALSE;
		}
		if(id != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected id");
			result = FALSE;
		}
		if(data != "Message Text")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected data");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}