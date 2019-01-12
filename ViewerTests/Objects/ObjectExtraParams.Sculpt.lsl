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
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_SCULPT, TEXTURE_PLYWOOD, PRIM_SCULPT_TYPE_SPHERE]);
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
		llSay(PUBLIC_CHANNEL, "Sending ObjectExtraParams => Sculpt");
		llSetTimerEvent(1.0);
        vcextraparamsdatalist paramslist;
        vcextraparamsdata params;
        vcextraparams extraparams;
        extraparams.HasSculpt = TRUE;
        extraparams.SculptMap = TEXTURE_BLANK;
        extraparams.SculptType = PRIM_SCULPT_TYPE_PLANE;
        params.LocalID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        params.Flags = VC_EXTRA_PARAMS_DATA_SET_SCULPT_EP;
        params.ExtraParams = extraparams;
        paramslist.Add(params);
		vagent.SendObjectExtraParams(paramslist);
	}
	
	timer()
	{
        list p = osGetPrimitiveParams("11223344-1122-1122-1122-000000000001", [PRIM_TYPE]);
		if(llList2Integer(p, 0) != PRIM_TYPE_SCULPT ||
            llList2Key(p, 1) != TEXTURE_BLANK ||
            llList2Integer(p, 2) != PRIM_SCULPT_TYPE_PLANE)
		{
			llSay(PUBLIC_CHANNEL, "Not changed to targeted sculpt");
            llSay(PUBLIC_CHANNEL, "Got prim type " + llList2Integer(p, 0));
            llSay(PUBLIC_CHANNEL, "Got texture " + llList2Key(p, 1));
            llSay(PUBLIC_CHANNEL, "Got sculpt type " + llList2Integer(p, 2));
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