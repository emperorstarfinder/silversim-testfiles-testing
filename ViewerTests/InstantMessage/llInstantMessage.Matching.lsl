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
        llInstantMessage(agentid, "Hello");
    }
    
    improvedinstantmessage_received(
        agentinfo agent, 
        integer fromGroup, 
        key toAgentID, 
        integer parentEstateID, 
        key regionID, 
        vector position, 
        integer isoffline, 
        integer dialog, 
        key id, 
        long timestamp, 
        string fromagentname, 
        string message, 
        bytearray binarybucket)
    {
        if(fromGroup)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected fromGroup. Got "+ fromGroup);
            result = FALSE;
        }
        if(toAgentID != agentid)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected toAgentID. Got "+ toAgentID);
            result = FALSE;
        }
        if(parentEstateID != 0)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected parentEstateID. Got "+ parentEstateID);
            result = FALSE;
        }
        if(regionID != "39702429-6b4f-4333-bac2-cd7ea688753e")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected regionID. Got "+ regionID);
            result = FALSE;
        }
        if(isoffline)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected isoffline. Got "+ isoffline);
            result = FALSE;
        }
        if(dialog != DIALOG_MESSAGE_FROM_OBJECT)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected dialog. Got "+ dialog);
            result = FALSE;
        }
        if(fromagentname != "Test Object")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected fromagentname. Got "+ fromagentname);
            result = FALSE;
        }
        if(message != "Hello")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected message. Got "+ message);
            result = FALSE;
        }
        if(binarybucket.Length == 0)
        {
            llSay(PUBLIC_CHANNEL, "Unexpected binarybucket. Should not be empty");
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No InstantMessage received");
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