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
	
	run_time_permissions(integer perm)
	{
		integer result = TRUE;
		if(perm != 5)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected perm " + (string)perm);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}