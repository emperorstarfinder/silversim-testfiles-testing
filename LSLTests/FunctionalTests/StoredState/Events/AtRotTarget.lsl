//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	at_rot_target(integer tnum, rotation targetrot, rotation ourrot)
	{
		integer result = TRUE;
		if(tnum != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected tnum");
			result = FALSE;
		}
		if(llFabs(targetrot.x - 1) > 0.000001 || llFabs(targetrot.y - 2) > 0.000001 || llFabs(targetrot.z - 3) > 0.000001 || llFabs(targetrot.s - 4) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected targetrot");
			result = FALSE;
		}
		if(llFabs(ourrot.x - 5) > 0.000001 || llFabs(ourrot.y - 6) > 0.000001 || llFabs(ourrot.z - 7) > 0.000001 || llFabs(ourrot.s - 8) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected ourrot");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}