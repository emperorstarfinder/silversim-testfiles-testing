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
	
	email(string time, string address, string subj, string message, integer num_left)
	{
		integer result = TRUE;
		if(time != "Time")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected time");
			result = FALSE;
		}
		if(address != "time@example.com")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected address");
			result = FALSE;
		}
		if(subj != "Subject")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected subj");
			result = FALSE;
		}
		if(message != "Message")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected message");
			result = FALSE;
		}
		if(num_left != 5)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected num_left");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}