//#!Enable:Testing

default
{
	state_entry()
	{
		llSleep(1); /* get log buffer written */
		list objectparam = llGetObjectDetails("11223344-1122-1122-1122-000000000000", [OBJECT_POS, OBJECT_PHYSICS, OBJECT_PHANTOM]);
		list targetparam = llGetObjectDetails("11223344-1122-1122-1122-000000000001", [OBJECT_POS, OBJECT_PHYSICS, OBJECT_PHANTOM]);
		vector objectpos = llList2Vector(objectparam, 0);
		vector targetpos = llList2Vector(targetparam, 0);
		integer success = TRUE;
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
		
		/* format rules [<id>, <link>*, <position>, <normal>*] */
		list result = llCastRay(objectpos - (targetpos - objectpos), targetpos, [RC_DATA_FLAGS, RC_GET_NORMAL|RC_GET_ROOT_KEY|RC_GET_LINK_NUM, RC_MAX_HITS, 10]);
		
		if(llList2Integer(result, -1)!=2)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hits: " + (string)llList2Integer(result, -1));
			llSay(PUBLIC_CHANNEL, "Dump: " + llDumpList2String(result, ";"));
			success = FALSE;
		}
		else if(llGetListLength(result) != 9)
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
			llSay(PUBLIC_CHANNEL, "Unexpected object link hit: " + (string)llList2Integer(result, 1));
			success = FALSE;
		}
		else if(llList2Key(result, 4) != "11223344-1122-1122-1122-000000000001")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object hit: " + (string)llList2Key(result, 0));
			success = FALSE;
		}
		else if(llList2Integer(result, 5) != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object link hit: " + (string)llList2Integer(result, 1));
			success = FALSE;
		}
		llSay(PUBLIC_CHANNEL, "Hitpoint A: " + (string)llList2Vector(result, 2));
		llSay(PUBLIC_CHANNEL, "HitNormal A: " + (string)llList2Vector(result, 3));
		llSay(PUBLIC_CHANNEL, "Hitpoint B: " + (string)llList2Vector(result, 6));
		llSay(PUBLIC_CHANNEL, "HitNormal B: " + (string)llList2Vector(result, 7));
		
		_test_Result(success);
		_test_Shutdown();
	}
}