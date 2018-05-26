//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	link_message(integer sender_num, integer num, string str, key id)
	{
		integer result = TRUE;
		if(sender_num != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected sender_num");
			result = FALSE;
		}
		if(num != 2)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected num");
			result = FALSE;
		}
		if(str != "Message Data")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected str");
			result = FALSE;
		}
		if(id != "Message Key")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected id");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}