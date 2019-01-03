//#!Enable: testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		state message;
	}
}

state message
{
	state_entry()
	{
		llMessageLinked(LINK_SET, 0, "", NULL_KEY);
	}
	
	link_message(integer sender_num, integer num, string str, key id)
	{
		_test_Result(TRUE);
		_test_Shutdown();
	}
}