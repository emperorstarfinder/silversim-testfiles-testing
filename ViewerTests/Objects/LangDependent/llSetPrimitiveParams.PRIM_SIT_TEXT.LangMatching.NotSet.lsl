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
        llSetPrimitiveParams([PRIM_LANGUAGE, "fr", PRIM_NAME, "DefLangName"]);
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
    integer received2 = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 1: Setting lang{default} sittext to Hello");
        llSetPrimitiveParams([PRIM_SIT_TEXT, "Hello"]);
        vagent.SendObjectSelect([localid]);
		llSetTimerEvent(2.0);
	}

    objectproperties_received(agentinfo agent, objectpropertieslist objlist)
	{
        foreach(data in objlist)
        {
            if(data.ObjectID == llGetKey())
            {
                received = TRUE;
                if(data.SitText != "Hello")
                {
                    llSay(PUBLIC_CHANNEL, "Test 1: failed");
                    llSay(PUBLIC_CHANNEL, "SitText: " + data.SitText);
                    result = FALSE;
                }
                if(received && received2)
                {
                    vagent.SendObjectDeselect([localid]);
                }
            }
        }
    }    
	
	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                if((objdata.UpdateFlags & 2) == 0)
                {
                    if(received2)
                    {
                        llSetTimerEvent(0);
                        llSay(PUBLIC_CHANNEL, "Test 1 completed");
                        state test2;
                    }
                }
                else
                {
                    received2 = TRUE;
                    if(received && received2)
                    {
                        vagent.SendObjectDeselect([localid]);
                    }
                }
            }
        }
    }    
    
	timer()
	{
        llSay(PUBLIC_CHANNEL, "timer()");
        if(!received2)
        {
            llSay(PUBLIC_CHANNEL, "Test 1: No prim update received");
        }
        if(!received)
        {
            llSay(PUBLIC_CHANNEL, "Test 1: No prim properties received");
        }
        result = FALSE;
		state test2;
	}
}

state test2
{
    integer received = FALSE;
    integer received2 = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 2: Setting lang{default} sittext to World");
        llSetPrimitiveParams([PRIM_SIT_TEXT, "World"]);
        vagent.SendObjectSelect([localid]);
		llSetTimerEvent(2.0);
	}
    
    objectproperties_received(agentinfo agent, objectpropertieslist objlist)
	{
        foreach(data in objlist)
        {
            if(data.ObjectID == llGetKey())
            {
                received = TRUE;
                if(data.SitText != "World")
                {
                    llSay(PUBLIC_CHANNEL, "Test 2: failed");
                    llSay(PUBLIC_CHANNEL, "SitText: " + data.SitText);
                    result = FALSE;
                }
                if(received && received2)
                {
                    vagent.SendObjectDeselect([localid]);
                }
            }
        }
    }    
	
	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                if((objdata.UpdateFlags & 2) == 0)
                {
                    if(received2)
                    {
                        llSetTimerEvent(0);
                        llSay(PUBLIC_CHANNEL, "Test 2 completed");
                        state test3;
                    }
                }
                else
                {
                    received2 = TRUE;
                    if(received && received2)
                    {
                        vagent.SendObjectDeselect([localid]);
                    }
                }
            }
        }
    }    
    
	timer()
	{
        llSay(PUBLIC_CHANNEL, "timer()");
        if(!received2)
        {
            llSay(PUBLIC_CHANNEL, "Test 2: No prim update received");
        }
        if(!received)
        {
            llSay(PUBLIC_CHANNEL, "Test 2: No prim properties received");
        }
        result = FALSE;
		state test3;
	}
}


state test3
{
    integer received = FALSE;
    integer received2 = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 3: Remove language entry");
        llSetPrimitiveParams([PRIM_REMOVE_LANGUAGE, "fr"]);
        vagent.SendObjectSelect([localid]);
		llSetTimerEvent(2.0);
	}

    objectproperties_received(agentinfo agent, objectpropertieslist objlist)
	{
        foreach(data in objlist)
        {
            if(data.ObjectID == llGetKey())
            {
                received = TRUE;
                if(data.SitText != "World")
                {
                    llSay(PUBLIC_CHANNEL, "Test 3: failed");
                    llSay(PUBLIC_CHANNEL, "SitText: " + data.SitText);
                    result = FALSE;
                }
                if(received && received2)
                {
                    vagent.SendObjectDeselect([localid]);
                }
            }
        }
    }    

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                if((objdata.UpdateFlags & 2) == 0)
                {
                    if(received2)
                    {
                        llSetTimerEvent(0);
                        llSay(PUBLIC_CHANNEL, "Test 3 completed");
                        state logout;
                    }
                }
                else
                {
                    received2 = TRUE;
                    if(received && received2)
                    {
                        vagent.SendObjectDeselect([localid]);
                    }
                }
            }
        }
    }    
    
	timer()
	{
        llSay(PUBLIC_CHANNEL, "timer()");
        if(!received2)
        {
            llSay(PUBLIC_CHANNEL, "Test 3: No prim update received");
        }
        if(!received)
        {
            llSay(PUBLIC_CHANNEL, "Test 3: No prim properties received");
        }
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