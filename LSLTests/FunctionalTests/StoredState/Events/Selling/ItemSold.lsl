//#!Mode:ASSL
//#!Enable:testing
//#!Enable:selling

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "state restore failed");
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	item_sold(string agentname, key agentid, string objectname, key objectid)
	{
		integer result = TRUE;
		/*
		if(agentname != "Script Test")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected agentname: " + agentname);
			result = FALSE;
		}
		*/
		if(agentid != "6c7abd0c-2b72-403f-a95c-a98c659680ca")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected agentid");
			result = FALSE;
		}
		if(objectname != "Object Name")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected objectname");
			result = FALSE;
		}
		if(objectid != "11223344-1122-1122-1122-112233445566")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected objectid");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}