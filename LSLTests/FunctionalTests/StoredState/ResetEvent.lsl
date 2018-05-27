//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(TRUE);
		_test_Shutdown();
	}
	
	on_rez(integer start_param)
	{
		llSay(PUBLIC_CHANNEL, "Executed wrong on_rez(integer)");
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
}

state check
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Executed wrong state_entry()");
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	on_rez(integer start_param)
	{
		_test_scriptresetevent();
	}
}