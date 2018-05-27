//#!Enable:testing

integer vartoreset = TRUE;
default
{
	state_entry()
	{
		_test_Result(vartoreset);
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
		vartoreset = FALSE;
		_test_scriptresetevent();
	}
}