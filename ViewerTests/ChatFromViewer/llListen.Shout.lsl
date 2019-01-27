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
        state testsound;
    }
}

state testsound
{
    state_entry()
    {
        llListen(1, "", NULL_KEY, "");
        llSetTimerEvent(1);
        msgcount = 0;
        vagent.SendChatFromViewer("Hello", CHAT_TYPE_SHOUT, 1);
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if(channel != 1)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected channel. Got " + channel);
            result = FALSE;
        }
        if(name != "Script Test")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected name. Got " + name);
            result = FALSE;
        }
        if(id != agentid)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected source. Got " + id);
            result = FALSE;
        }
        if(msg != "Hello")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got " + msg);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No viewer chat received");
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