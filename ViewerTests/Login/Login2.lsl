//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer circuitcode;
key sessionid;
key securesessionid;
vieweragent vagent;
key agentid;
list seenobjects;
integer success = TRUE;
integer seenself = FALSE;
integer seenprim = FALSE;

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        circuitcode = (integer)llFrand(100000) + 100000;
        sessionid = llGenerateKey();
        securesessionid = llGenerateKey();
        
        agentid = vcCreateAccount("Login", "Test");
        
        vagent = vcLoginAgent(circuitcode, 
                "39702429-6b4f-4333-bac2-cd7ea688753e", 
                agentid,
                sessionid,
                securesessionid,
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
        llSetTimerEvent(2);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        state logout;
    }
    
    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        llSay(PUBLIC_CHANNEL, "objectupdate_received(" + objectlist.Count +")");
        foreach(objdata in objectlist)
        {
            key id = objdata.FullID;
            if(id == agentid)
            {
                seenself = TRUE;
                if(objdata.Material != PRIM_MATERIAL_FLESH)
                {
                    llSay(PUBLIC_CHANNEL, "Not flesh for agent: "+ objdata.Material);
                    success = FALSE;
                }
            }
            if(id == llGetKey())
            {
                seenprim = TRUE;
                if(objdata.Material != PRIM_MATERIAL_WOOD)
                {
                    llSay(PUBLIC_CHANNEL, "Not wood for prim: " + objdata.Material);
                    success = FALSE;
                }
            }
            if(llListFindList(seenobjects, [id]) < 0)
            {
                seenobjects += id;
            }
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
        integer received_objects = llGetListLength(seenobjects);
        llSay(PUBLIC_CHANNEL, "Logout confirmed");
        llSay(PUBLIC_CHANNEL, "Seen objects " + received_objects);
        if(received_objects != 2)
        {
            success = FALSE;
        }
        if(!seenprim)
        {
            llSay(PUBLIC_CHANNEL, "Prim not seen");
            success = FALSE;
        }
        if(!seenself)
        {
            llSay(PUBLIC_CHANNEL, "Agent not seen");
            success = FALSE;
        }
        _test_Result(success);
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        _test_Shutdown();
    }
}