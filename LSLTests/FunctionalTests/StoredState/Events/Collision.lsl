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
	
	collision(integer num)
	{
		integer result = TRUE;
		if(num != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected num: " + (string)num);
			result = FALSE;
		}
		if(llDetectedKey(0) != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedKey: " + llDetectedKey(0));
			result = FALSE;
		}
		vector v = llDetectedGrab(0);
		if(llFabs(v.x-1) > 0.000001 || llFabs(v.y-2) > 0.000001 || llFabs(v.z-3)>0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedGrab: " + (string)v);
			result = FALSE;
		}
		if(llDetectedLinkNumber(0) != 4)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedLinkNumber: " + (string)llDetectedLinkNumber(0));
			result = FALSE;
		}
		if(llDetectedName(0) != "Name 1")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedName: " + llDetectedName(0));
			result = FALSE;
		}
		if(llDetectedOwner(0) != "11223344-1122-0000-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedOwner: " + llDetectedOwner(0));
			result = FALSE;
		}
		v = llDetectedPos(0);
		if(llFabs(v.x-5) > 0.000001 || llFabs(v.y-6) > 0.000001 || llFabs(v.z-7)>0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedPos:: " + (string)v);
			result = FALSE;
		}
		rotation r = llDetectedRot(0);
		if(llFabs(r.x-8) > 0.000001 || llFabs(r.y-9) > 0.000001 || llFabs(r.z-10)>0.000001 || llFabs(r.s-11)>0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedRot: " + (string)r);
			result = FALSE;
		}
		if(llDetectedType(0) != 12)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedType: " + (string)llDetectedType(0));
			result = FALSE;
		}
		v = llDetectedVel(0);
		if(llFabs(v.x-13) > 0.000001 || llFabs(v.y-14) > 0.000001 || llFabs(v.z-15)>0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected llDetectedVel: " + (string)v);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}