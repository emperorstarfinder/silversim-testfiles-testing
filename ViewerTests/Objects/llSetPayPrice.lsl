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

state test1
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 1");
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != PAY_HIDE || 
            buttons.Length != 4 ||
            buttons[0] != PAY_HIDE ||
            buttons[1] != PAY_HIDE || 
            buttons[2] != PAY_HIDE || 
            buttons[3] != PAY_HIDE)
        {
            llSay(PUBLIC_CHANNEL, "Test 1: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test2;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 1: No paypricereply received");
        result = FALSE;
        state logout;
    }
}

state test2
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 2");
        llSetPayPrice(10, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != 10 || 
            buttons.Length != 4 ||
            buttons[0] != PAY_HIDE ||
            buttons[1] != PAY_HIDE || 
            buttons[2] != PAY_HIDE || 
            buttons[3] != PAY_HIDE)
        {
            llSay(PUBLIC_CHANNEL, "Test 2: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test3;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 2: No paypricereply received");
        result = FALSE;
        state logout;
    }
}

state test3
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 3");
        llSetPayPrice(PAY_HIDE, [10, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != PAY_HIDE || 
            buttons.Length != 4 ||
            buttons[0] != 10 ||
            buttons[1] != PAY_HIDE || 
            buttons[2] != PAY_HIDE || 
            buttons[3] != PAY_HIDE)
        {
            llSay(PUBLIC_CHANNEL, "Test 3: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test4;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 3: No paypricereply received");
        result = FALSE;
        state logout;
    }
}

state test4
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 4");
        llSetPayPrice(PAY_HIDE, [PAY_HIDE, 10, PAY_HIDE, PAY_HIDE]);
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != PAY_HIDE || 
            buttons.Length != 4 ||
            buttons[0] != PAY_HIDE ||
            buttons[1] != 10 || 
            buttons[2] != PAY_HIDE || 
            buttons[3] != PAY_HIDE)
        {
            llSay(PUBLIC_CHANNEL, "Test 4: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test5;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 4: No paypricereply received");
        result = FALSE;
        state logout;
    }
}

state test5
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 5");
        llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, 10, PAY_HIDE]);
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != PAY_HIDE || 
            buttons.Length != 4 ||
            buttons[0] != PAY_HIDE ||
            buttons[1] != PAY_HIDE || 
            buttons[2] != 10 || 
            buttons[3] != PAY_HIDE)
        {
            llSay(PUBLIC_CHANNEL, "Test 5: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test6;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 5: No paypricereply received");
        result = FALSE;
        state logout;
    }
}

state test6
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 6");
        llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, 10]);
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != PAY_HIDE || 
            buttons.Length != 4 ||
            buttons[0] != PAY_HIDE ||
            buttons[1] != PAY_HIDE || 
            buttons[2] != PAY_HIDE || 
            buttons[3] != 10)
        {
            llSay(PUBLIC_CHANNEL, "Test 6: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state test7;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 6: No paypricereply received");
        result = FALSE;
        state logout;
    }
}

state test7
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 7");
        llSetPayPrice(10, [PAY_DEFAULT, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        vagent.SendRequestPayPrice(llGetKey());
        llSetTimerEvent(1.0);
    }

    paypricereply_received(agentinfo agent, key objectid, integer payprice, list buttons)
    {
        received = TRUE;
        if(objectid != llGetKey() ||
            payprice != 10 || 
            buttons.Length != 4 ||
            buttons[0] != PAY_DEFAULT ||
            buttons[1] != PAY_HIDE || 
            buttons[2] != PAY_HIDE || 
            buttons[3] != PAY_HIDE)
        {
            llSay(PUBLIC_CHANNEL, "Test 7: failed");
            llSay(PUBLIC_CHANNEL, "Default payprice: " + payprice);
            llSay(PUBLIC_CHANNEL, "Buttons: " + llDumpList2String(buttons, ","));
            result = FALSE;
        }
        llSetTimerEvent(0);
        state logout;
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 7: No paypricereply received");
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