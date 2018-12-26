//#!Enable:Testing

default
{
	state_entry()
	{
		llSleep(1); /* get log buffer written */
		list objectparam = llGetObjectDetails("11223344-1122-1122-1122-000000000000", [OBJECT_POS, OBJECT_PHYSICS, OBJECT_PHANTOM]);
		vector objectpos = llList2Vector(objectparam, 0);
		integer success = TRUE;
		/* format rules [<id>, <link>*, <position>, <normal>*] */
		list result = llCastRay(objectpos, objectpos - <0,0,100>, []);
		
		if(llList2Integer(result, -1)!=1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hits: " + (string)llList2Integer(result, -1));
			llSay(PUBLIC_CHANNEL, "Dump: " + llDumpList2String(result, ";"));
			success = FALSE;
		}
		else if(llGetListLength(result) != 3)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of ray hit data: " + (string)llGetListLength(result));
			success = FALSE;
		}
		else if(llList2Key(result, 0) != NULL_KEY)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected object hit: " + (string)llList2Key(result, 0));
			success = FALSE;
		}
		llSay(PUBLIC_CHANNEL, "Hitpoint: " + (string)llList2Vector(result, 1));
		
		_test_Result(success);
		_test_Shutdown();
	}
}