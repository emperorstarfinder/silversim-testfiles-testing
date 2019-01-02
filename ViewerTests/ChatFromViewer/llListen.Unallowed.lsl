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
		vagent.SendCompleteAgentMovement();
		state testsound;
	}
}

state testsound
{
	state_entry()
	{
		llListen(PUBLIC_CHANNEL, "", NULL_KEY, "");
		llSetTimerEvent(1);
		msgcount = 0;
		vagent.SendChatFromViewer("Hello1", CHAT_TYPE_DEBUG_CHANNEL, PUBLIC_CHANNEL);
		vagent.SendChatFromViewer("Hello2", CHAT_TYPE_REGION, PUBLIC_CHANNEL);
		vagent.SendChatFromViewer("Hello3", CHAT_TYPE_OWNER, PUBLIC_CHANNEL);
		vagent.SendChatFromViewer("Hello4", CHAT_TYPE_BROADCAST, PUBLIC_CHANNEL);
	}
	
	listen(integer channel, string name, key id, string msg)
	{
		++msgcount;
	}
	
	chatfromsimulator_received(agentinfo agent, string fromname, key sourceid, key ownerid, integer sourcetype, integer chattype, integer audiblelevel, vector position, string message)
	{
		++msgcount;
	}
	
	timer()
	{
		if(msgcount != 0)
		{
			llSay(PUBLIC_CHANNEL, "Unallowed viewer chat received");
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