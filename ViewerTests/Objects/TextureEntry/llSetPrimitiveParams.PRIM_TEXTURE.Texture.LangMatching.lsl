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
        llSetPrimitiveParams([PRIM_TEXTURE, ALL_SIDES, TEXTURE_MEDIA, <1,1,0>, <0, 0, 0>, 0]);
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

displaytetexture(textureentry te)
{
    llSay(PUBLIC_CHANNEL, "TE[0]: " + te[0].TextureID);
    llSay(PUBLIC_CHANNEL, "TE[1]: " + te[1].TextureID);
    llSay(PUBLIC_CHANNEL, "TE[2]: " + te[2].TextureID);
    llSay(PUBLIC_CHANNEL, "TE[3]: " + te[3].TextureID);
    llSay(PUBLIC_CHANNEL, "TE[4]: " + te[4].TextureID);
    llSay(PUBLIC_CHANNEL, "TE[5]: " + te[5].TextureID);
}

state test1
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 1: Setting face 0 to blank");
        llSetPrimitiveParams([PRIM_LANGUAGE, "fr", PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1,1,0>, <0, 0, 0>, 0]);
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
                    llSay(PUBLIC_CHANNEL, "Test 1: failed");
                    displaytetexture(objdata.TextureEntry);
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
        llSay(PUBLIC_CHANNEL, "Test 2: Setting all faces to plywood");
        llSetPrimitiveParams([PRIM_LANGUAGE, "fr", PRIM_TEXTURE, ALL_SIDES, TEXTURE_PLYWOOD, <1,1,0>, <0, 0, 0>, 0]);
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
                    llSay(PUBLIC_CHANNEL, "Test 2: failed");
                    displaytetexture(objdata.TextureEntry);
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
        llSay(PUBLIC_CHANNEL, "Test 3: Remove language entry");
        llSetPrimitiveParams([PRIM_REMOVE_LANGUAGE, "fr"]);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.TextureEntry[0].TextureID != TEXTURE_MEDIA ||
                    objdata.TextureEntry[1].TextureID != TEXTURE_MEDIA ||
                    objdata.TextureEntry[2].TextureID != TEXTURE_MEDIA ||
                    objdata.TextureEntry[3].TextureID != TEXTURE_MEDIA ||
                    objdata.TextureEntry[4].TextureID != TEXTURE_MEDIA ||
                    objdata.TextureEntry[5].TextureID != TEXTURE_MEDIA)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3: failed");
                    displaytetexture(objdata.TextureEntry);
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