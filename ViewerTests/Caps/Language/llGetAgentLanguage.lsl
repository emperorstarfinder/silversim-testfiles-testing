//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer circuitcode;
key sessionid;
key securesessionid;
vieweragent vagent;
key agentid;
integer result = TRUE;
string updateAgentLanguage_URL;

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
        hashtable capsresult = vcSeedRequest(vagent.CapsPath, ["UpdateAgentLanguage"]);
        updateAgentLanguage_URL = capsresult["UpdateAgentLanguage"];
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
        state test_en;
    }
}

state test_en
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Selecting 'en'");
        /* send our chosen language */
        capsUpdateAgentLanguage(updateAgentLanguage_URL, "en", TRUE);
        if(llGetAgentLanguage(agentid) != "en")
        {
            llSay(PUBLIC_CHANNEL, "Agent language not changed to 'en'");
            result = FALSE;
        }
        
        state test_fr;
    }
}

state test_fr
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Selecting 'fr'");
        /* send our chosen language */
        capsUpdateAgentLanguage(updateAgentLanguage_URL, "fr", TRUE);
        if(llGetAgentLanguage(agentid) != "fr")
        {
            llSay(PUBLIC_CHANNEL, "Agent language not changed to 'fr'");
            result = FALSE;
        }
        
        state test_de;
    }
}

state test_de
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Selecting 'de'");
        /* send our chosen language */
        capsUpdateAgentLanguage(updateAgentLanguage_URL, "de", TRUE);
        if(llGetAgentLanguage(agentid) != "de")
        {
            llSay(PUBLIC_CHANNEL, "Agent language not changed to 'de'");
            result = FALSE;
        }
        
        state test_nl;
    }
}


state test_nl
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Selecting 'nl'");
        /* send our chosen language */
        capsUpdateAgentLanguage(updateAgentLanguage_URL, "nl", TRUE);
        if(llGetAgentLanguage(agentid) != "nl")
        {
            llSay(PUBLIC_CHANNEL, "Agent language not changed to 'nl'");
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