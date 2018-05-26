//#!Mode:ASSL
//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	land_collision_end(vector pos)
	{
		integer result = TRUE;
		if(llFabs(pos.x - 1) > 0.000001 || llFabs(pos.y - 2) > 0.000001 || llFabs(pos.z - 3) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected pos");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}