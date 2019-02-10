//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;
key otheragentid = llGenerateKey();

default
{
    state_entry()
    {
        _test_AddAvatarName(otheragentid, "List", "Test");
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
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD: Estate Owner");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, llGetOwner()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list bannedlist = _test_GetEstateAllowedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
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
        llSetTimerEvent(0);
        llSay(PUBLIC_CHANNEL, "timer()");
        if(msgcount != 0)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected IM received");
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
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE: Estate Owner");
        if(!llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, llGetOwner()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list bannedlist = _test_GetEstateAllowedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
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
        if(message != "Removed agent \"Script.Test @localhost:9300\" from banned list for estate \"My Estate\"")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got: " + message);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        llSetTimerEvent(0);
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
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD: Other agent");
        if(!llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, otheragentid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list bannedlist = _test_GetEstateBannedAgentsList();
        if(bannedlist.Length != 2)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
            result = FALSE;
        }
        else if(bannedlist[0] != otheragentid)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Agent not added");
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
        if(message != "Added agent \"List.Test @localhost:9300\" to banned list for estate \"My Estate\"")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got: " + message);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        llSetTimerEvent(0);
        llSay(PUBLIC_CHANNEL, "timer()");
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No IM received");
            result = FALSE;
        }
        state test4;
    }
}

state test4
{
    integer msgcount = 0;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE: Other agent");
        if(!llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, otheragentid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list bannedlist = _test_GetEstateBannedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
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
        if(message != "Removed agent \"List.Test @localhost:9300\" from banned list for estate \"My Estate\"")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got: " + message);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        llSetTimerEvent(0);
        llSay(PUBLIC_CHANNEL, "timer()");
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No IM received");
            result = FALSE;
        }
        state test5;
    }
}


state test5
{
    integer msgcount = 0;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD: Wrong agent");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list bannedlist = _test_GetEstateBannedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE: Wrong agent");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        bannedlist = _test_GetEstateBannedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        bannedlist = _test_GetEstateBannedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        bannedlist = _test_GetEstateBannedAgentsList();
        if(bannedlist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Unexpected list length");
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
        llSetTimerEvent(0);
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