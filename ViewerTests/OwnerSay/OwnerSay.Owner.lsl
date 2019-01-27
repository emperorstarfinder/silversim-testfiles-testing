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
        llSetTimerEvent(1);
        msgcount = 0;
        llOwnerSay("Hello");
    }
    
    chatfromsimulator_received(agentinfo agent, string fromname, key sourceid, key ownerid, integer sourcetype, integer chattype, integer audiblelevel, vector position, string message)
    {
        if(chattype == 1)
        {
            /* block public channel */
            return;
        }
        if(fromname != llGetObjectName())
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "FromName wrong in received OwnerSay: Got " + fromname);
        }
        if(sourceid != llGetKey())
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "SourceID wrong in received OwnerSay. Got " + sourceid);
        }
        if(ownerid != llGetOwner())
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "OwnerID wrong in received OwnerSay. Got " + ownerid);
        }
        if(sourcetype != CHAT_SOURCE_TYPE_OBJECT)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "SourceType wrong in received OwnerSay. Got " + sourcetype);
        }
        if(chattype != CHAT_TYPE_OWNER)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "ChatType wrong in received OwnerSay. Got " + chattype);
        }
        if(audiblelevel != 1)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "AudibleLevel wrong in received OwnerSay. Got " + audiblelevel);
        }
        if(message != "Hello")
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Message wrong in received OwnerSay. Got: " + message);
        }
        ++msgcount;
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No OwnerSay received");
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