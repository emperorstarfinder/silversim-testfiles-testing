//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

integer localid;

default
{
    integer localid_received = FALSE;
    integer msg_regionhandshake_received = FALSE;
	state_entry()
	{
        llSetPrimitiveParams([PRIM_NAME, "LangDefName"]);
		llSay(PUBLIC_CHANNEL, "Logging in agent");
		_test_Result(FALSE);
        localid = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000000");
		
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
		hashtable capsresult = vcSeedRequest(vagent.CapsPath, ["UpdateAgentLanguage"]);
        /* send our chosen language */
        capsUpdateAgentLanguage(capsresult["UpdateAgentLanguage"], "fr", TRUE);
	}
	
	regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
	{
		llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
		vagent.SendCompleteAgentMovement();
        msg_regionhandshake_received = TRUE;
        if(msg_regionhandshake_received && localid_received)
        {
            state test1;
        }
	}
    
	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                localid_received = TRUE;
            }
        }
        if(msg_regionhandshake_received && localid_received)
        {
            state test1;
        }
    }    
}

state test1
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 1: Setting lang{fr} name to Hello");
        llSetPrimitiveParams([PRIM_LANGUAGE, "fr", PRIM_NAME, "Hello"]);
        vagent.SendRequestObjectPropertiesFamily(0, llGetKey());
		llSetTimerEvent(1.0);
	}

    objectpropertiesfamily_received(agentinfo agent, integer requestFlags, key objectid, objectpropertiesfamilydata data)
	{
        received = TRUE;
        if(objectid != llGetKey() ||
            data.Name != "Hello")
        {
            llSay(PUBLIC_CHANNEL, "Test 1: failed");
            llSay(PUBLIC_CHANNEL, "Name: " + data.Name);
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test2;
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 1: No prim properties family received");
        result = FALSE;
		state test2;
	}
}

state test2
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 2: Setting lang{fr} name to World");
        llSetPrimitiveParams([PRIM_LANGUAGE, "fr", PRIM_NAME, "World"]);
        vagent.SendRequestObjectPropertiesFamily(0, llGetKey());
		llSetTimerEvent(1.0);
	}

    objectpropertiesfamily_received(agentinfo agent, integer requestFlags, key objectid, objectpropertiesfamilydata data)
	{
        received = TRUE;
        if(objectid != llGetKey() ||
            data.Name != "World")
        {
            llSay(PUBLIC_CHANNEL, "Test 2: failed");
            llSay(PUBLIC_CHANNEL, "Name: " + data.Name);
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test3;
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 2: No prim properties family received");
        result = FALSE;
		state test3;
	}
}


state test3
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 3: Remove language entry");
        llSetPrimitiveParams([PRIM_REMOVE_LANGUAGE, "fr"]);
        vagent.SendRequestObjectPropertiesFamily(0, llGetKey());
		llSetTimerEvent(1.0);
	}

    objectpropertiesfamily_received(agentinfo agent, integer requestFlags, key objectid, objectpropertiesfamilydata data)
	{
        received = TRUE;
        if(objectid != llGetKey() ||
            data.Name != "LangDefName")
        {
            llSay(PUBLIC_CHANNEL, "Test 1: failed");
            llSay(PUBLIC_CHANNEL, "Name: " + data.Name);
            result = FALSE;
        }
        llSetTimerEvent(0);
        state logout;
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 3: No prim properties family received");
        result = FALSE;
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