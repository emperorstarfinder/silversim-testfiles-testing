//#!Enable:testing
//#!Enable:InheritEvents

default
{
	state_entry()
	{
		llSetTimerEvent(0.5);
		state one;
	}
}

state one
{
	state_entry()
	{
		state two;
	}
	
	timer()
	{
		_test_Result(TRUE);
		_test_Shutdown();
		state okay;
	}
}

state two
{
	state_entry()
	{
		state one;
	}
	
	timer()
	{
		_test_Result(TRUE);
		_test_Shutdown();
	}
}

state okay
{
	state_entry()
	{
		llSetTimerEvent(0);
	}
}