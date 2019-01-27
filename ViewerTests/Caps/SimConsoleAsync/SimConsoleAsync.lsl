//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer circuitcode;
key sessionid;
key securesessionid;
vieweragent vagent;
key agentid;
integer result = TRUE;
string simConsoleAsync_URL;
string eqg_url;

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
        hashtable capsresult = vcSeedRequest(vagent.CapsPath, ["SimConsoleAsync", "EventQueueGet"]);
        simConsoleAsync_URL = capsresult["SimConsoleAsync"];
        eqg_url = capsresult["EventQueueGet"];
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
        state test_cmd;
    }
}

state test_cmd
{
    integer received = FALSE;
    state_entry()
    {
        llHTTPRequest(simConsoleAsync_URL, [HTTP_METHOD, "POST"], "<llsd><string>enable logins</string></llsd>");
    }
    
    http_response(key req_id, integer status, list metadata, string body)
    {
        if(status != 200)
        {
            llSay(PUBLIC_CHANNEL, "SimConsoleAsync did not accept command. " + status);
            result = FALSE;
        }
        if(body != "<llsd><binary>AA==</binary></llsd>")
        {
            llSay(PUBLIC_CHANNEL, "SimConsoleAsync did not reply with correct response. ");
            llSay(PUBLIC_CHANNEL, body);
            result = FALSE;
        }
        if(!result)
        {
            state logout;
        }
        else
        {
            if(!vagent.RequestEventQueueGet(eqg_url, 5000))
            {
                llSay(PUBLIC_CHANNEL, "EQG failed");
                result = FALSE;
                state logout;
            }
        }
    }
    
    simconsoleresponse_received(agentinfo agent, string response)
    {
        llSay(PUBLIC_CHANNEL, ">" + response + "<");
        if(response != "SimConsole not allowed\n")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected response string");
            result = FALSE;
        }
        received = TRUE;
    }
        
    eventqueueget_finished(agentinfo agent, key requestid, integer statuscode)
    {
        if(!received)
        {
            if(!vagent.RequestEventQueueGet(eqg_url, 5000))
            {
                llSay(PUBLIC_CHANNEL, "EQG failed");
                result = FALSE;
                state logout;
            }
        }
        else
        {
            state logout;
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