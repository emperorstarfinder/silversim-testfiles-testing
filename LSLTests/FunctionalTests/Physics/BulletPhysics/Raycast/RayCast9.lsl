//#!Enable:Testing
//#!Enable:PermGranter

integer success = TRUE;
vector objectpos;
vector targetpos;

default
{
	state_entry()
	{
		llSleep(1); /* physics is slightly deferred so give it time */
		list objectparam = llGetObjectDetails("11223344-1122-1122-1122-000000000000", [OBJECT_POS, OBJECT_PHYSICS, OBJECT_PHANTOM]);
		list targetparam = llGetObjectDetails("11223344-1122-1122-1122-000000000001", [OBJECT_POS, OBJECT_PHYSICS, OBJECT_PHANTOM]);
		objectpos = llList2Vector(objectparam, 0);
		targetpos = llList2Vector(targetparam, 0);
		if(llList2Integer(objectparam, 1) || llList2Integer(objectparam, 2))
		{
			llSay(PUBLIC_CHANNEL, "Object parameter physics/phantom do not match");
			success = FALSE;
		}
		if(llList2Integer(targetparam, 1) || llList2Integer(targetparam, 2))
		{
			llSay(PUBLIC_CHANNEL, "Object parameter physics/phantom do not match");
			success = FALSE;
		}
		
		_test_GrantScriptPerm(PERMISSION_CHANGE_LINKS);
		llCreateLink("11223344-1122-1122-1122-000000000001", TRUE);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			state raycast1;
		}
	}
}

state raycast1
{
	state_entry()
	{
		llSleep(1); /* get log buffer written */
		llSay(PUBLIC_CHANNEL, "***** Raycast1 *****");
		
		/* format rules [<id>, <link>*, <position>, <normal>*] */
		list result = llCastRay(objectpos - (targetpos - objectpos), targetpos + (targetpos - objectpos), [RC_DATA_FLAGS, RC_GET_LINK_NUM]);
		
		if(llList2Integer(result, -1)!=1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hits: " + (string)llList2Integer(result, -1));
			llSay(PUBLIC_CHANNEL, "Dump: " + llDumpList2String(result, ";"));
			success = FALSE;
		}
		else if(llGetListLength(result) != 4)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hit data: " + (string)llGetListLength(result));
			success = FALSE;
		}
		else if(llList2Key(result, 0) != "11223344-1122-1122-1122-000000000000")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object hit: " + (string)llList2Key(result, 0));
			success = FALSE;
		}
		else if(llList2Integer(result, 1) != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object hit link: " + (string)llList2Integer(result, 1));
		}
		llSay(PUBLIC_CHANNEL, "Hitpoint: " + (string)llList2Vector(result, 2));
		
		state raycast2;
	}
}


state raycast2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "***** Raycast2 *****");
		
		/* format rules [<id>, <link>*, <position>, <normal>*] */
		list result = llCastRay(targetpos + (targetpos - objectpos), objectpos - (targetpos - objectpos), [RC_DATA_FLAGS, RC_GET_LINK_NUM]);
		
		if(llList2Integer(result, -1)!=1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hits: " + (string)llList2Integer(result, -1));
			llSay(PUBLIC_CHANNEL, "Dump: " + llDumpList2String(result, ";"));
			success = FALSE;
		}
		else if(llGetListLength(result) != 4)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hit data: " + (string)llGetListLength(result));
			success = FALSE;
		}
		else if(llList2Key(result, 0) != "11223344-1122-1122-1122-000000000001")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object hit: " + (string)llList2Key(result, 0));
			success = FALSE;
		}
		else if(llList2Integer(result, 1) != 2)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object hit link: " + (string)llList2Integer(result, 1));
		}
		llSay(PUBLIC_CHANNEL, "Hitpoint: " + (string)llList2Vector(result, 2));
		
		_test_Result(success);
		_test_Shutdown();
	}
}