//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer msgcount = 0;

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Logging in agent");
		_test_Result(FALSE);
		
		agentid = vcCreateAccount("Login", "Test");
		
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
		state testsound;
	}
}

state testsound
{
	state_entry()
	{
		llSetTimerEvent(1);
		msgcount = 0;
		vagent.SendSoundTrigger("5bc11cd6-2f40-071e-a8da-0903394204f9", agentid, agentid, NULL_KEY, 256000, 256000, <128, 128, 23>, 1.0);
	}
	
	soundtrigger_received(agentinfo agent, key soundid, key ownerid, key objectid, key parentid, integer gridX, integer gridY, vector position, float gain)
	{
		++msgcount;
	}
	
	timer()
	{
		if(msgcount != 0)
		{
			llSay(PUBLIC_CHANNEL, "No sound request should happen for missing asset");
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