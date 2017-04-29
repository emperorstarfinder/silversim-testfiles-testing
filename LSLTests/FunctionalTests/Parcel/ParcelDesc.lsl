//#!Enable:Testing
//#!Mode:assl

string getparceldesc()
{
	list a = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_DESC]);
	return llList2String(a, 0);
}

default
{
	state_entry()
	{
		_test_setserverparam("OSSL.ThreatLevel", "severe");
		asSetForcedSleep(FALSE, 0);
		integer pass = TRUE;
		
		if(getparceldesc() != "")
		{
			pass = FALSE;
		}
		osSetParcelDetails(llGetPos(), [PARCEL_DETAILS_DESC, "Desc One"]);
		if(getparceldesc() != "Desc One")
		{
			llSay(PUBLIC_CHANNEL, "Failed to set first description");
			pass = FALSE;
		}
		osSetParcelDetails(llGetPos(), [PARCEL_DETAILS_DESC, "One Desc"]);
		if(getparceldesc() != "One Desc")
		{
			llSay(PUBLIC_CHANNEL, "Failed to set second description");
			pass = FALSE;
		}
		osSetParcelDetails(llGetPos(), [PARCEL_DETAILS_DESC, ""]);
		if(getparceldesc() != "")
		{
			llSay(PUBLIC_CHANNEL, "Failed to set parcel description back to original");
			pass = FALSE;
		}
		_test_Result(pass);
		_test_Shutdown();
	}
}
