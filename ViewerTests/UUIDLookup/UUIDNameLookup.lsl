//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer msgcount = 0;

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
        llSetTimerEvent(1);
        vagent.SendUUIDNameRequest([agentid]);
        msgcount = 0;
    }
    
    uuidnamereply_received(agentinfo agent, list data)
    {
        if(data.Length != 2)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected list length. Got " + data.Length);
            result = FALSE;
        }
        if(llList2Key(data, 0) != agentid)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected agentid. Got " + llList2Key(data, 0));
            result = FALSE;
        }
        if(llList2String(data, 1) != "Script Test")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected agentname. Got " + llList2String(data, 1));
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No uuid name reply received");
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