//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer msgcount = 0;
key itemid;

default
{
	state_entry()
	{
		_test_Result(FALSE);
		llSay(PUBLIC_CHANNEL, "Injecting script");
		if(!_test_InjectScript("TestState", "../tests/ViewerTests/ScriptReset/Sender.lsli", 1, NULL_KEY))
		{
			llSay(PUBLIC_CHANNEL, "Failed to inject script");
			_test_Shutdown();
		}
		itemid = _test_GetInventoryItemID("TestState");
	}
	
	link_message(integer sender, integer num, string data, key id)
	{
		llSay(PUBLIC_CHANNEL, "Script is running");
		state login;
	}
}

state login
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Logging in agent");
		
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
		vagent.SendScriptReset(llGetKey(), itemid);
	}
	
	link_message(integer sender, integer num, string data, key id)
	{
		if(num == 0 && data == "Hello" && id == "World")
		{
			llSay(PUBLIC_CHANNEL, "Script reset detected");
			++msgcount;
		}
	}

	timer()
	{
		if(msgcount == 0)
		{
			llSay(PUBLIC_CHANNEL, "No reset of script detected");
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