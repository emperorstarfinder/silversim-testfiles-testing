//#!Enable:Testing
//#!Mode:assl

string getparcelname()
{
	list a = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME]);
	return llList2String(a, 0);
}

default
{
	state_entry()
	{
		_test_setserverparam("OSSL.ThreatLevel", "severe");
		asSetForcedSleep(FALSE, 0);
		integer pass = TRUE;
		
		if(getparcelname() != "Your Parcel")
		{
			pass = TRUE;
		}
		osSetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME, "My Parcel"]);
		if(getparcelname() != "My Parcel")
		{
			llSay(PUBLIC_CHANNEL, "Failed to set first name");
			pass = FALSE;
		}
		osSetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME, "Parcel Mine"]);
		if(getparcelname() != "Parcel Mine")
		{
			llSay(PUBLIC_CHANNEL, "Failed to set second name");
			pass = FALSE;
		}
		osSetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME, "Your Parcel"]);
		if(getparcelname() != "Your Parcel")
		{
			llSay(PUBLIC_CHANNEL, "Failed to set parcel name back to original");
			pass = FALSE;
		}
		_test_Result(pass);
		_test_Shutdown();
	}
}
