//#!Enable:Testing
//#!Enable:BulletPhysicsTest
//#!Enable:PermGranter

integer rootpartlocalid;
integer success = TRUE;

default
{
	state_entry()
	{
		llSleep(1); /* physics is slightly deferred so give it time */
		_test_GrantScriptPerm(PERMISSION_CHANGE_LINKS);
		llCreateLink("11223344-1122-1122-1122-000000000001", TRUE);
		list paramOwn = btGetPrimParams("11223344-1122-1122-1122-000000000000", BULLET_PARAM_ROOTPARTLOCALID);
		rootpartlocalid = llList2Integer(paramOwn, 0);
		if(_test_LocalId2ObjectKey(rootpartlocalid) != "11223344-1122-1122-1122-000000000000")
		{
			llSay(PUBLIC_CHANNEL, "Root part local id is not valid");
			success = FALSE;
		}
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSleep(1); /* physics is slightly deferred so give it time */
			llSay(PUBLIC_CHANNEL, "Prim linked");
			list paramOwn = btGetPrimParams("11223344-1122-1122-1122-000000000000", BULLET_PARAM_ROOTPARTLOCALID);
			list paramOther = btGetPrimParams("11223344-1122-1122-1122-000000000001", BULLET_PARAM_ROOTPARTLOCALID);
			
			integer rootpartOwn = llList2Integer(paramOwn, 0);
			integer rootpartOther = llList2Integer(paramOther, 0);
			llSay(PUBLIC_CHANNEL, "Root linkset: " + (string)rootpartOwn);
			llSay(PUBLIC_CHANNEL, "Child linkset: " + (string)rootpartOther);
			if(_test_LocalId2ObjectKey(rootpartOwn) != "11223344-1122-1122-1122-000000000000")
			{
				llSay(PUBLIC_CHANNEL, "Root part local id is not valid");
				success = FALSE;
			}
			if(rootpartOwn != rootpartlocalid)
			{
				llSay(PUBLIC_CHANNEL, "Root part does not match " + (string)rootpartlocalid + " != " + (string)rootpartOwn);
				success = FALSE;
			}
			if(rootpartOther != rootpartlocalid)
			{
				llSay(PUBLIC_CHANNEL, "Root part in child does not match " + (string)rootpartlocalid + " != " + (string)rootpartOther);
				success = FALSE;
			}
			
			state unlink;
		}
	}
}

state unlink
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Breaking link");
		llBreakLink(2);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSleep(1); /* physics is slightly deferred so give it time */
			llSay(PUBLIC_CHANNEL, "Prim unlinked");
			list paramOwn = btGetPrimParams("11223344-1122-1122-1122-000000000000", BULLET_PARAM_ROOTPARTLOCALID);
			list paramOther = btGetPrimParams("11223344-1122-1122-1122-000000000001", BULLET_PARAM_ROOTPARTLOCALID);
			
			integer rootpartOwn = llList2Integer(paramOwn, 0);
			integer rootpartOther = llList2Integer(paramOther, 0);
			llSay(PUBLIC_CHANNEL, "Root linkset: " + (string)rootpartOwn);
			llSay(PUBLIC_CHANNEL, "Child linkset: " + (string)rootpartOther);
			if(_test_LocalId2ObjectKey(rootpartOwn) != "11223344-1122-1122-1122-000000000000")
			{
				llSay(PUBLIC_CHANNEL, "Root part local id is not valid");
				success = FALSE;
			}
			if(_test_LocalId2ObjectKey(rootpartOther) != "11223344-1122-1122-1122-000000000001")
			{
				llSay(PUBLIC_CHANNEL, "Other root part local id is not valid");
				success = FALSE;
			}
			if(rootpartOwn != rootpartlocalid)
			{
				llSay(PUBLIC_CHANNEL, "Root part does not match " + (string)rootpartlocalid + " != " + (string)rootpartOwn);
				success = FALSE;
			}
			if(rootpartOther == rootpartlocalid)
			{
				llSay(PUBLIC_CHANNEL, "Root part in child does not match " + (string)rootpartlocalid + " == " + (string)rootpartOther);
				success = FALSE;
			}
			
			_test_Result(success);
			_test_Shutdown();
		}
	}
}