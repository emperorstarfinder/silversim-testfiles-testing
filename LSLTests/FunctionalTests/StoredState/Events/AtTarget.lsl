//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	at_target(integer tnum, vector targetpos, vector ourpos)
	{
		integer result = TRUE;
		if(tnum != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected tnum");
			result = FALSE;
		}
		if(llFabs(targetpos.x - 1) > 0.000001 || llFabs(targetpos.y - 2) > 0.000001 || llFabs(targetpos.z - 3) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected targetpos");
			result = FALSE;
		}
		if(llFabs(ourpos.x - 5) > 0.000001 || llFabs(ourpos.y - 6) > 0.000001 || llFabs(ourpos.z - 7) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected ourpos");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}