//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer msgcount = 0;
key expected_transactionid;

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Logging in agent");
		_test_Result(FALSE);
		
		agentid = llGetOwner();
		
		vagent = vcLoginAgent((integer)llFrand(100000) + 100000, 
				"39702429-6b4f-4333-bac2-cd7ea688753e", 
				agentid,
				llGenerateKey(),
				llGenerateKey(),
				"Test Viewer",
				"Test Viewer",
				llMD5String(llGenerateKey(), 0),
				llMD5String(llGenerateKey(), 0),
				TELEPORT_FLAGS_VIALOGIN,
				<128, 128, 23>,
				<1, 0, 0>);
		if(!vagent)
		{
			llSay(PUBLIC_CHANNEL, "Login failed");
			_test_Shutdown();
			return;
		}
	}
	
	regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
	{
		llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
		vagent.SendCompleteAgentMovement();
		state test;
	}
}

state test
{
	state_entry()
	{
		llSetTimerEvent(1);
		msgcount = 0;
		expected_transactionid = llGenerateKey();
		vagent.SendDeRezObject("11223344-1122-1122-1122-000000000001", DEREZ_ACTION_TAKE_COPY, NULL_KEY, expected_transactionid, 1, 1);
	}
	
	derezack_received(agentinfo agent, key transactionid, integer success)
	{
		if(expected_transactionid != transactionid)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected transactionid. Got " + transactionid);
			result = FALSE;
		}
		if(!success)
		{
			llSay(PUBLIC_CHANNEL, "DeRez failed");
			result = FALSE;
		}
		++msgcount;
	}
	
	timer()
	{
		if(msgcount == 0)
		{
			llSay(PUBLIC_CHANNEL, "No derezack received");
			result = FALSE;
		}
		state logout;
	}
}


state logout
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Requesting logout");
		llSetTimerEvent(1);
		vagent.Logout();
	}
	
	logoutreply_received(agentinfo agent)
	{
		llSay(PUBLIC_CHANNEL, "Logout confirmed");
		_test_Result(result);
		llSetTimerEvent(1);
	}
	
	timer()
	{
		_test_Shutdown();
	}
}