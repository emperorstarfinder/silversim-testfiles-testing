//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	http_response(key requestid, integer status, list metadata, string data)
	{
		integer result = TRUE;
		if(requestid != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected requestid");
			result = FALSE;
		}
		if(status != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected num");
			result = FALSE;
		}
		if(llGetListLength(metadata) != 1 || llList2Integer(metadata, 0) != 55)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected metadata");
			result = FALSE;
		}
		if(data != "Message Data")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected data");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}