//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
key groupid = llGenerateKey();

default
{
    state_entry()
    {
        _test_AddGroupName(groupid, "List Test");
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
    integer msgcount = 0;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_ADD: Valid Group");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_ADD, groupid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list grouplist = _test_GetEstateAllowedGroupsList();
        if(grouplist.Length != 3)
        {
            llSay(PUBLIC_CHANNEL, "Fail: List length not correct");
            result = FALSE;
        }
        if(grouplist[0] != groupid)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Group not added");
            result = FALSE;
        }
    
        llSetTimerEvent(1.0);
    }
    
    improvedinstantmessage_received(
        agentinfo agent,
        integer fromGroup,
        key toAgentID,
        integer parentEstateID,
        key regionID,
        vector position,
        integer isOffline,
        integer dialog,
        key id,
        long timestamp,
        string fromAgentName,
        string message,
        bytearray binaryBucket)
    {
        if(message != "Added group \"List.Test @localhost:9300\" to allowed list for estate \"My Estate\"")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got: " + message);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "timer()");
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No IM received");
            result = FALSE;
        }
        state test2;
    }
}

state test2
{
    integer msgcount = 0;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE: Valid Group");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_REMOVE, groupid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list grouplist = _test_GetEstateAllowedGroupsList();
        if(grouplist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: List length not correct");
            result = FALSE;
        }
    
        llSetTimerEvent(1.0);
    }
    
    improvedinstantmessage_received(
        agentinfo agent,
        integer fromGroup,
        key toAgentID,
        integer parentEstateID,
        key regionID,
        vector position,
        integer isOffline,
        integer dialog,
        key id,
        long timestamp,
        string fromAgentName,
        string message,
        bytearray binaryBucket)
    {
        if(message != "Removed group \"List.Test @localhost:9300\" from allowed list for estate \"My Estate\"")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got: " + message);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "timer()");
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No IM received");
            result = FALSE;
        }
        state test3;
    }
}


state test3
{
    integer msgcount = 0;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_ADD: Wrong group");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_ADD, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE: Wrong group");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_REMOVE, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_ADD: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_ADD, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_REMOVE, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }

        llSetTimerEvent(1.0);
    }
    
    improvedinstantmessage_received(
        agentinfo agent,
        integer fromGroup,
        key toAgentID,
        integer parentEstateID,
        key regionID,
        vector position,
        integer isOffline,
        integer dialog,
        key id,
        long timestamp,
        string fromAgentName,
        string message,
        bytearray binaryBucket)
    {
        ++msgcount;
    }
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "timer()");
        if(msgcount != 0)
        {
            llSay(PUBLIC_CHANNEL, "IMs received when there should be none.");
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