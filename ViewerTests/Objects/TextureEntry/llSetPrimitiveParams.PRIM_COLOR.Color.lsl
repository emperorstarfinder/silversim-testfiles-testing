//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

integer localid;

setcolor(vector color, integer face)
{
    llSetPrimitiveParams([PRIM_COLOR, face, color, 1]);
}

default
{
    integer localid_received = FALSE;
    integer msg_regionhandshake_received = FALSE;
	state_entry()
	{
        setcolor(<1,1,1>, ALL_SIDES);
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

displaytecolor(textureentry te)
{
    llSay(PUBLIC_CHANNEL, "TE[0]: " + te[0].TextureColor);
    llSay(PUBLIC_CHANNEL, "TE[1]: " + te[1].TextureColor);
    llSay(PUBLIC_CHANNEL, "TE[2]: " + te[2].TextureColor);
    llSay(PUBLIC_CHANNEL, "TE[3]: " + te[3].TextureColor);
    llSay(PUBLIC_CHANNEL, "TE[4]: " + te[4].TextureColor);
    llSay(PUBLIC_CHANNEL, "TE[5]: " + te[5].TextureColor);
}

state test1
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 1: Setting face 0 to black");
        setcolor(<0,0,0>, 0);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 1: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test2;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 1: No prim update received");
        result = FALSE;
		state test2;
	}
}

state test2
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 2: Setting face 1 to black");
        setcolor(<0,0,0>, 1);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 2: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test3;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 2: No prim update received");
        result = FALSE;
		state test3;
	}
}

state test3
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 3: Setting face 2 to black");
        setcolor(<0,0,0>, 2);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test4;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 3: No prim update received");
        result = FALSE;
		state test4;
	}
}

state test4
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 4: Setting face 3 to black");
        setcolor(<0,0,0>, 3);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 4: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test5;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 4: No prim update received");
        result = FALSE;
		state test5;
	}
}

state test5
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 5: Setting face 4 to black");
        setcolor(<0,0,0>, 4);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 5: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test6;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 5: No prim update received");
        result = FALSE;
		state test6;
	}
}

state test6
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 6: Setting face 5 to black");
        setcolor(<0,0,0>, 5);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 6: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test1b;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 6: No prim update received");
        result = FALSE;
		state test1b;
	}
}


state test1b
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 1b: Setting face 0 to white");
        setcolor(<1,1,1>, 0);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 1b: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test2b;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 1b: No prim update received");
        result = FALSE;
		state test2b;
	}
}

state test2b
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 2b: Setting face 1 to white");
        setcolor(<1,1,1>, 1);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 2b: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test3b;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 2b: No prim update received");
        result = FALSE;
		state test3b;
	}
}

state test3b
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 3b: Setting face 2 to white");
        setcolor(<1,1,1>, 2);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3b: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test4b;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 3b: No prim update received");
        result = FALSE;
		state test4b;
	}
}

state test4b
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 4b: Setting face 3 to white");
        setcolor(<1,1,1>, 3);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 4b: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test5b;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 4b: No prim update received");
        result = FALSE;
		state test5b;
	}
}

state test5b
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 5: Setting face 4 to white");
        setcolor(<1,1,1>, 4);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 5b: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test6b;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 5b: No prim update received");
        result = FALSE;
		state test6b;
	}
}

state test6b
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 6b: Setting face 5 to white");
        setcolor(<1,1,1>, 5);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 6b: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state testc;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test 6b: No prim update received");
        result = FALSE;
		state testc;
	}
}

state testc
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test c: Setting all faces to black");
        setcolor(<0,0,0>, ALL_SIDES);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[1].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[2].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[3].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[4].TextureColor != <0,0,0> ||
                    objdata.TextureEntry[5].TextureColor != <0,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test c: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state testd;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test c: No prim update received");
        result = FALSE;
		state testd;
	}
}


state testd
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test d: Setting all faces to white");
        setcolor(<1,1,1>, ALL_SIDES);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[1].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[2].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[3].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[4].TextureColor != <1,1,1> ||
                    objdata.TextureEntry[5].TextureColor != <1,1,1>)
                {
                    llSay(PUBLIC_CHANNEL, "Test d: failed");
                    displaytecolor(objdata.TextureEntry);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state logout;
            }
        }
    }    
	
	timer()
	{
        llSay(PUBLIC_CHANNEL, "Test d: No prim update received");
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