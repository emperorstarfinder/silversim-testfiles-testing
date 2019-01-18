//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

integer localid;

settexture(string texture, integer face)
{
    llSetPrimitiveParams([PRIM_TEXTURE, face, texture, <1,1,0>, <0, 0, 0>, 0]);
}

default
{
    integer localid_received = FALSE;
    integer msg_regionhandshake_received = FALSE;
	state_entry()
	{
        settexture(TEXTURE_PLYWOOD, ALL_SIDES);
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

state test1
{
    integer received = FALSE;
	state_entry()
	{
        llSay(PUBLIC_CHANNEL, "Test 1: Setting face 0 to blank");
        settexture(TEXTURE_BLANK, 0);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test 1: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 2: Setting face 1 to blank");
        settexture(TEXTURE_BLANK, 1);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test 2: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 3: Setting face 2 to blank");
        settexture(TEXTURE_BLANK, 2);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 4: Setting face 3 to blank");
        settexture(TEXTURE_BLANK, 3);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test 4: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 5: Setting face 4 to blank");
        settexture(TEXTURE_BLANK, 4);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test 5: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 6: Setting face 5 to blank");
        settexture(TEXTURE_BLANK, 5);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test 6: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 1b: Setting face 0 to plywood");
        settexture(TEXTURE_PLYWOOD, 0);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test 1b: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 2b: Setting face 1 to plywood");
        settexture(TEXTURE_PLYWOOD, 1);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test 2b: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 3b: Setting face 2 to plywood");
        settexture(TEXTURE_PLYWOOD, 2);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3b: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 4b: Setting face 3 to blank");
        settexture(TEXTURE_PLYWOOD, 3);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test 4b: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 5: Setting face 4 to blank");
        settexture(TEXTURE_PLYWOOD, 4);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test 5b: failed");
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
        llSay(PUBLIC_CHANNEL, "Test 6b: Setting face 5 to blank");
        settexture(TEXTURE_PLYWOOD, 5);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test 6b: failed");
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
        llSay(PUBLIC_CHANNEL, "Test c: Setting all faces to blank");
        settexture(TEXTURE_BLANK, ALL_SIDES);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_BLANK ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_BLANK)
                {
                    llSay(PUBLIC_CHANNEL, "Test c: failed");
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
        llSay(PUBLIC_CHANNEL, "Test d: Setting all faces to plywood");
        settexture(TEXTURE_PLYWOOD, ALL_SIDES);
		llSetTimerEvent(1.0);
	}

	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_PLYWOOD ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_PLYWOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Test d: failed");
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