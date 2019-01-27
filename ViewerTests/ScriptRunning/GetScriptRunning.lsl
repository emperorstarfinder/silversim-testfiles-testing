//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
integer msgcount = 0;
key script_itemid;
string eqg_url;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        llSay(PUBLIC_CHANNEL, "Injecting script");
        if(!_test_InjectScript("TestState", "../tests/ViewerTests/ScriptRunning/Responder.lsli", 1, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Failed to inject script");
            _test_Shutdown();
        }
        script_itemid = _test_GetInventoryItemID("TestState");
    }
    
    link_message(integer sender, integer num, string data, key id)
    {
        llSay(PUBLIC_CHANNEL, "Script is running");
        state login;
    }
}

state login
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        
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
        hashtable capsresult = vcSeedRequest(vagent.CapsPath, ["EventQueueGet"]);
        eqg_url = capsresult["EventQueueGet"];
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        vagent.SendCompleteAgentMovement();
        state testactive;
    }
}

state testactive
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "**** Verifying script running ****");
        llSetTimerEvent(1);
        llMessageLinked(LINK_SET, 0, "Hello", "World");
    }
    
    link_message(integer sender, integer num, string data, key id)
    {
        if(num == 1 && data == "Hello" && id == "World")
        {
            llSetTimerEvent(0);
            state setinactive;
        }
    }
    
    timer()
    {
        llSetTimerEvent(0);
        result = FALSE;
        llSay(PUBLIC_CHANNEL, "Running test failed");
        state logout;
    }
}

state setinactive
{
    state_entry()
    {
        llSleep(2);
        llSetScriptState("TestState", FALSE);
        llSay(PUBLIC_CHANNEL, "**** Get script inactive ****");
        llSetTimerEvent(1);
        vagent.SendGetScriptRunning(llGetKey(), script_itemid);
        if(!vagent.RequestEventQueueGet(eqg_url, 5000))
        {
            llSay(PUBLIC_CHANNEL, "EQG failed");
        }
    }

    scriptrunningreply_received(agentinfo agent, key objectid, key itemid, integer isrunning)
    {
        if(isrunning)
        {
            llSay(PUBLIC_CHANNEL, "Changing running state to not running failed");
            result = FALSE;
            state logout;
        }
        else
        {
            llSetTimerEvent(0);
            state testnotrunning;
        }
    }

    eventqueueget_finished(agentinfo agent, key requestid, integer statuscode)
    {
        if(!vagent.RequestEventQueueGet(eqg_url, 5000))
        {
            llSay(PUBLIC_CHANNEL, "EQG failed");
        }
    }

    timer()
    {
        llSetTimerEvent(0);
        result = FALSE;
        llSay(PUBLIC_CHANNEL, "Changing running state to not running timeout");
        state logout;
    }
}

state testnotrunning
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "**** Verifying script not running ****");
        llSetTimerEvent(1);
        llMessageLinked(LINK_SET, 0, "Hello", "World");
    }
    
    link_message(integer sender, integer num, string data, key id)
    {
        if(num == 1)
        {
            result = FALSE;
            llSetTimerEvent(0);
            llSay(PUBLIC_CHANNEL, "Script running state was not changed");
            state logout;
        }
    }
    
    timer()
    {
        llSetTimerEvent(0);
        state setactive;
    }
}


state setactive
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "**** Set script active ****");
        llSetScriptState("TestState", TRUE);
        llSetTimerEvent(1);
        vagent.SendGetScriptRunning(llGetKey(), script_itemid);
        if(!vagent.RequestEventQueueGet(eqg_url, 5000))
        {
            llSay(PUBLIC_CHANNEL, "EQG failed");
        }
    }
    
    scriptrunningreply_received(agentinfo agent, key objectid, key itemid, integer isrunning)
    {
        if(!isrunning)
        {
            llSay(PUBLIC_CHANNEL, "Changing running state to running failed");
            result = FALSE;
            state logout;
        }
        else
        {
            llSetTimerEvent(0);
            state testrunning;
        }
    }
    
    eventqueueget_finished(agentinfo agent, key requestid, integer statuscode)
    {
        if(!vagent.RequestEventQueueGet(eqg_url, 5000))
        {
            llSay(PUBLIC_CHANNEL, "EQG failed");
        }
    }
    
    timer()
    {
        llSetTimerEvent(0);
        result = FALSE;
        llSay(PUBLIC_CHANNEL, "Changing running state to running timeout");
        state logout;
    }
}

state testrunning
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "**** Verifying script running ****");
        llSetTimerEvent(1);
        llMessageLinked(LINK_SET, 0, "Hello", "World");
    }
    
    link_message(integer sender, integer num, string data, key id)
    {
        if(num == 1 && data == "Hello" && id == "World")
        {
            llSetTimerEvent(0);
            state logout;
        }
    }
    
    timer()
    {
        llSetTimerEvent(0);
        result = FALSE;
        llSay(PUBLIC_CHANNEL, "Running test failed");
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