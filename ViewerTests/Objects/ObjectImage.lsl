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
	state_entry()
	{
		llSleep(1); /* ensure init */
		llSay(PUBLIC_CHANNEL, "Sending ObjectImage => TEXTURE_BLANK");
		llSetTimerEvent(1.0);
        objectimagedatalist objimglist;
        objectimagedata objimg;
        objimg.LocalID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        textureentryface texentry = objimg.TextureEntry.Default;
        texentry.TextureID = TEXTURE_BLANK;
        objimglist.Add(objimg);
		vagent.SendObjectImage(objimglist);
	}
	
	timer()
	{
		if(llList2Key(osGetPrimitiveParams("11223344-1122-1122-1122-000000000001", [PRIM_TEXTURE, 0]), 0) != TEXTURE_BLANK)
		{
			llSay(PUBLIC_CHANNEL, "Not changed to TEXTURE_BLANK. Got " + llGetTexture(0));
			result = FALSE;
		}
		state test2;
	}
}

state test2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Sending ObjectImage => TEXTURE_PLYWOOD");
		llSetTimerEvent(1.0);
        objectimagedatalist objimglist;
        objectimagedata objimg;
        objimg.LocalID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        textureentryface texentry = objimg.TextureEntry.Default;
        texentry.TextureID = TEXTURE_PLYWOOD;
        objimglist.Add(objimg);
		vagent.SendObjectImage(objimglist);
	}
	
	timer()
	{
		if(llList2Key(osGetPrimitiveParams("11223344-1122-1122-1122-000000000001", [PRIM_TEXTURE, 0]), 0) != TEXTURE_PLYWOOD)
		{
			llSay(PUBLIC_CHANNEL, "Not changed to TEXTURE_PLYWOOD. Got " + llGetTexture(0));
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
		llSetTimerEvent(0);
		_test_Shutdown();
	}
}