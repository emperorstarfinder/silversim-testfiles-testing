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
	
	no_npcsensor(key npc)
	{
		integer result = TRUE;
		if(npc != "11223344-1122-1122-2233-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected npc: " + npc);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}