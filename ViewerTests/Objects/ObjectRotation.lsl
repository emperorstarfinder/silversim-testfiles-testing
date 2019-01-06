//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

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
	rotation EXPECTED = <0,1,0,0>;
	state_entry()
	{
		llSleep(1); /* ensure init */
		llSay(PUBLIC_CHANNEL, "Sending ObjectRotation => <0,1,0,0>");
		llSetTimerEvent(1.0);
		vagent.SendObjectRotation([_test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001"), EXPECTED]);
	}
	
	timer()
	{
		rotation seen = llList2Rot(osGetPrimitiveParams("11223344-1122-1122-1122-000000000001", [PRIM_ROTATION]), 0);
		if(seen != EXPECTED)
		{
			llSay(PUBLIC_CHANNEL, "Not changed to new rotation. Got " + seen);
			result = FALSE;
		}
		state test2;
	}
}

state test2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Sending ObjectRotation => ZERO_ROTATION");
		llSetTimerEvent(1.0);
		vagent.SendObjectRotation([_test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001"), ZERO_ROTATION]);
	}
	
	timer()
	{
		rotation seen = llList2Rot(osGetPrimitiveParams("11223344-1122-1122-1122-000000000001", [PRIM_ROTATION]), 0);
		if(seen != ZERO_ROTATION)
		{
			llSay(PUBLIC_CHANNEL, "Not changed to ZERO_ROTATION. Got " + seen);
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