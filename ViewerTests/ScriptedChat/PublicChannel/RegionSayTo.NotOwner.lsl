//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer msgcount = 0;
list errortexts;

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        
        agentid = vcCreateAccount("Login", "Test");
        
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
        llRegionSayTo(agentid, PUBLIC_CHANNEL, "Hello");
    }
    
    chatfromsimulator_received(agentinfo agent, string fromname, key sourceid, key ownerid, integer sourcetype, integer chattype, integer audiblelevel, vector position, string message)
    {
        if(fromname != llGetObjectName())
        {
            result = FALSE;
            errortexts += ["FromName wrong in received Say: Got " + fromname];
        }
        if(sourceid != llGetKey())
        {
            result = FALSE;
            errortexts += ["SourceID wrong in received Say. Got " + sourceid];
        }
        if(ownerid != llGetOwner())
        {
            result = FALSE;
            errortexts += ["OwnerID wrong in received Say. Got " + ownerid];
        }
        if(sourcetype != CHAT_SOURCE_TYPE_OBJECT)
        {
            result = FALSE;
            errortexts += ["SourceType wrong in received Say. Got " + sourcetype];
        }
        if(chattype != CHAT_TYPE_REGION)
        {
            result = FALSE;
            errortexts += ["ChatType wrong in received Say. Got " + chattype];
        }
        if(audiblelevel != 1)
        {
            result = FALSE;
            errortexts += ["AudibleLevel wrong in received Say. Got " + audiblelevel];
        }
        if(message != "Hello")
        {
            result = FALSE;
            errortexts += ["Message wrong in received Say. Got: " + message];
        }
        ++msgcount;
    }
    
    timer()
    {
        state logout;
    }
}


state logout
{
    state_entry()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No Say received");
            result = FALSE;
        }
        
        if(llGetListLength(errortexts) != 0)
        {
            result = FALSE;
            foreach(errortext in errortexts)
            {
                llSay(PUBLIC_CHANNEL, errortext);
            }
        }
    
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