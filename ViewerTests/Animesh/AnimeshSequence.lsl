//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer idx;
integer msgcount = 0;

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Setting up animesh");
		llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_SCULPT, llGenerateKey(), 5]);
		_test_EnableAnimesh(llGetKey(), TRUE);
		
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
		state enablecaps;
	}
}

state enablecaps
{
	state_entry()
	{
		hashtable capsresult = vcSeedRequest(vagent.CapsPath, ["ObjectAnimation"]);
		llSetTimerEvent(1);
	}
	
	timer()
	{
		state testanimesh_aftercap;
	}
}

state testanimesh_aftercap
{
	state_entry()
	{
		llSetTimerEvent(1);
		idx = 4;
		msgcount = 0;
		llStartObjectAnimation("9e06424c-0178-82eb-ff21-6c0e4e5a7e6d");
	}
	
	objectanimation_received(agentinfo agent, key sender, objectanimationdatalist objanims)
	{
		++msgcount;
		llSay(PUBLIC_CHANNEL, "objectanimation_received cnt=" + msgcount + " elems=" + objanims.Count);
		if(objanims.Count == 1)
		{
			if(objanims[0].AnimID != "9e06424c-0178-82eb-ff21-6c0e4e5a7e6d")
			{
				llSay(PUBLIC_CHANNEL, "Wrong animation id received");
				result = FALSE;
			}
		}
	}
	
	timer()
	{
		--idx;
		if(idx % 2 == 0)
		{
			llStartObjectAnimation("9e06424c-0178-82eb-ff21-6c0e4e5a7e6d");
		}
		else if(idx > 0)
		{
			llStopObjectAnimation("9e06424c-0178-82eb-ff21-6c0e4e5a7e6d");
		}
		if(idx == 0)
		{
			if(msgcount != 4)
			{
				result = FALSE;
				llSay(PUBLIC_CHANNEL, "ERROR! We should have had 4 ObjectAnimation received. Got " + msgcount);
			}
			state logout;
		}
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