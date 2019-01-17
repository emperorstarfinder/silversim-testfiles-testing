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
        llOffsetTexture(1, 1, ALL_SIDES);
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

displaytexanim(textureanimationentry tae)
{
    llSay(PUBLIC_CHANNEL, "TEXANIM.Flags: " + tae.Flags);
    llSay(PUBLIC_CHANNEL, "TEXANIM.Face: " + tae.Face);
    llSay(PUBLIC_CHANNEL, "TEXANIM.SizeX: " + tae.SizeX);
    llSay(PUBLIC_CHANNEL, "TEXANIM.SizeY: " + tae.SizeY);
    llSay(PUBLIC_CHANNEL, "TEXANIM.Start: " + tae.Start);
    llSay(PUBLIC_CHANNEL, "TEXANIM.Length: " + tae.Length);
    llSay(PUBLIC_CHANNEL, "TEXANIM.Rate: " + tae.Rate);
}

state test1
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 1: Setting tex anim");
        llSetTextureAnim(ANIM_ON | LOOP, 5, 4, 8, 2, 16, 1);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureAnim.Flags != (ANIM_ON | LOOP) ||
                    objdata.TextureAnim.Face != 5 ||
                    objdata.TextureAnim.SizeX != 4 ||
                    objdata.TextureAnim.SizeY != 8 ||
                    objdata.TextureAnim.Start != 2 ||
                    objdata.TextureAnim.Length != 16 ||
                    objdata.TextureAnim.Rate != 1)
                {
                    llSay(PUBLIC_CHANNEL, "Test 1: failed");
                    displaytexanim(objdata.TextureAnim);
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
        llSay(PUBLIC_CHANNEL, "Test 2: Setting tex anim");
        llSetTextureAnim(ANIM_ON | LOOP | SMOOTH, 5, 4, 8, 2, 16, 1);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureAnim.Flags != (ANIM_ON | LOOP | SMOOTH) ||
                    objdata.TextureAnim.Face != 5 ||
                    objdata.TextureAnim.SizeX != 4 ||
                    objdata.TextureAnim.SizeY != 8 ||
                    objdata.TextureAnim.Start != 2 ||
                    objdata.TextureAnim.Length != 16 ||
                    objdata.TextureAnim.Rate != 1)
                {
                    llSay(PUBLIC_CHANNEL, "Test 2: failed");
                    displaytexanim(objdata.TextureAnim);
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
        llSay(PUBLIC_CHANNEL, "Test 3: Clearing tex anim");
        llSetTextureAnim(0, 5, 4, 8, 2, 16, 1);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureAnim.Flags != 0 ||
                    objdata.TextureAnim.Face != 0 ||
                    objdata.TextureAnim.SizeX != 0 ||
                    objdata.TextureAnim.SizeY != 0 ||
                    objdata.TextureAnim.Start != 0 ||
                    objdata.TextureAnim.Length != 0 ||
                    objdata.TextureAnim.Rate != 0)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3: failed");
                    displaytexanim(objdata.TextureAnim);
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state logout;
            }
        }
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 3: No prim update received");
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