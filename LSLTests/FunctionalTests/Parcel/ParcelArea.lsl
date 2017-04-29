//#!Enable:Testing
//#!Mode:assl

integer getparcelarea()
{
	list a = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_AREA]);
	return llList2Integer(a, 0);
}

default
{
	state_entry()
	{
		asSetForcedSleep(FALSE, 0);
		integer pass = TRUE;
		
		integer area = getparcelarea();
		llSay(0, (string)area);
		if(area != 65536)
		{
			pass = FALSE;
		}
		
		_test_Result(pass);
		_test_Shutdown();
	}
}
