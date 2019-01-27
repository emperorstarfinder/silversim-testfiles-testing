//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer controlcircuitcode;
integer circuitcode;
vieweragent vagent;
vieweragent vcontrolagent;

integer msgcount;
integer result = TRUE;

const key REGION_ID = "39702429-6b4f-4333-bac2-cd7ea688753e";

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        controlcircuitcode = (integer)llFrand(100000) + 200000;
        circuitcode = (integer)llFrand(100000) + 100000;
        
        key agentid = vcCreateAccount("Login", "Test");
        key controlagentid = vcCreateAccount("Login", "Control");
        
        vcontrolagent = vcLoginAgent(controlcircuitcode, 
                REGION_ID, 
                controlagentid,
                llGenerateKey(),
                llGenerateKey(),
                "Test Viewer",
                "Test Viewer",
                llMD5String(llGenerateKey(), 0),
                llMD5String(llGenerateKey(), 0),
                TELEPORT_FLAGS_VIALOGIN,
                <128, 128, 23>,
                <1, 0, 0>);
                
        if(!vcontrolagent)
        {
            llSay(PUBLIC_CHANNEL, "Login failed");
            _test_Shutdown();
            return;
        }
        
        vagent = vcLoginAgent(circuitcode, 
                REGION_ID, 
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
            vcontrolagent.Logout();
            llSay(PUBLIC_CHANNEL, "Login failed");
            _test_Shutdown();
            return;
        }
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        if(agent.AgentID == vagent.AgentID)
        {
            vagent.SendCompleteAgentMovement();
        }
        else if(agent.AgentID == vcontrolagent.AgentID)
        {
            vcontrolagent.SendCompleteAgentMovement();
        }
        llSetTimerEvent(2);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        state logouttest;
    }
}

state imtest
{
    key test_session = "11223344-1122-1122-1122-112233445566";
    
    state_entry()
    {
        llSetTimerEvent(1);
        msgcount = 0;
        vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_MESSAGE_FROM_AGENT, test_session, 10, "Login Test", "Message", ByteArray(0));
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "ImprovedInstanceMessage not received");
            result = FALSE;
        }
        llSetTimerEvent(0);
        state imtest2;
    }
    
    improvedinstantmessage_received(
        agentinfo agent, 
        integer fromGroup, 
        key toagentid, 
        integer parentestateid, 
        key regionid, 
        vector position, 
        integer isoffline, 
        integer dialog, 
        key id, 
        long timestamp, 
        string fromagentname, 
        string message, 
        bytearray binarybucket)
    {
        ++msgcount;
        if(fromGroup)
        {
            llSay(PUBLIC_CHANNEL, "fromGroup wrong. Got " + fromGroup);
            result = FALSE;
        }
        if(toagentid != vcontrolagent.AgentID)
        {
            llSay(PUBLIC_CHANNEL, "toagentid wrong. Got " + toagentid);
            result = FALSE;
        }
        if(agent.AgentID != vcontrolagent.AgentID)
        {
            llSay(PUBLIC_CHANNEL, "Receiver wrong. Got " + agent.AgentID);
            result = FALSE;
        }
        if(parentestateid != 1)
        {
            llSay(PUBLIC_CHANNEL, "parentestateid wrong. Got " + parentestateid);
            result = FALSE;
        }
        if(regionid != REGION_ID)
        {
            llSay(PUBLIC_CHANNEL, "regionid wrong. Got " + regionid);
            result = FALSE;
        }
        if(isoffline)
        {
            llSay(PUBLIC_CHANNEL, "isoffline wrong. Got " + isoffline);
            result = FALSE;
        }
        if(dialog != DIALOG_MESSAGE_FROM_AGENT)
        {
            llSay(PUBLIC_CHANNEL, "dialog wrong. Got " + dialog);
            result = FALSE;
        }
        if(id != test_session)
        {
            llSay(PUBLIC_CHANNEL, "id wrong. Got " + id);
            result = FALSE;
        }
        if(timestamp != 10)
        {
            llSay(PUBLIC_CHANNEL, "timestamp wrong. Got " + timestamp);
            result = FALSE;
        }
        if(fromagentname != "Login Test")
        {
            llSay(PUBLIC_CHANNEL, "fromagentname wrong. Got " + fromagentname);
            result = FALSE;
        }
        if(message != "Message")
        {
            llSay(PUBLIC_CHANNEL, "message wrong. Got " + message);
            result = FALSE;
        }
        if(binarybucket.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "binarybucket wrong. Got " + binarybucket.Length);
            result = FALSE;
        }
    }
}


state imtest2
{
    key test_session = "11223344-1122-1122-1122-112233445567";
    
    state_entry()
    {
        llSetTimerEvent(1);
        msgcount = 0;
        vcontrolagent.SendInstantMessage(FALSE, vagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_MESSAGE_FROM_AGENT, test_session, 15, "Login Control", "Message", ByteArray(0));
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "ImprovedInstanceMessage not received");
            result = FALSE;
        }
        llSetTimerEvent(0);
        state logouttest;
    }
    
    improvedinstantmessage_received(
        agentinfo agent, 
        integer fromGroup, 
        key toagentid, 
        integer parentestateid, 
        key regionid, 
        vector position, 
        integer isoffline, 
        integer dialog, 
        key id, 
        long timestamp, 
        string fromagentname, 
        string message, 
        bytearray binarybucket)
    {
        ++msgcount;
        if(fromGroup)
        {
            llSay(PUBLIC_CHANNEL, "fromGroup wrong. Got " + fromGroup);
            result = FALSE;
        }
        if(toagentid != vcontrolagent.AgentID)
        {
            llSay(PUBLIC_CHANNEL, "toagentid wrong. Got " + toagentid);
            result = FALSE;
        }
        if(agent.AgentID != vcontrolagent.AgentID)
        {
            llSay(PUBLIC_CHANNEL, "Receiver wrong. Got " + agent.AgentID);
            result = FALSE;
        }
        if(parentestateid != 1)
        {
            llSay(PUBLIC_CHANNEL, "parentestateid wrong. Got " + parentestateid);
            result = FALSE;
        }
        if(regionid != REGION_ID)
        {
            llSay(PUBLIC_CHANNEL, "regionid wrong. Got " + regionid);
            result = FALSE;
        }
        if(isoffline)
        {
            llSay(PUBLIC_CHANNEL, "isoffline wrong. Got " + isoffline);
            result = FALSE;
        }
        if(dialog != DIALOG_MESSAGE_FROM_AGENT)
        {
            llSay(PUBLIC_CHANNEL, "dialog wrong. Got " + dialog);
            result = FALSE;
        }
        if(id != test_session)
        {
            llSay(PUBLIC_CHANNEL, "id wrong. Got " + id);
            result = FALSE;
        }
        if(timestamp != 10)
        {
            llSay(PUBLIC_CHANNEL, "timestamp wrong. Got " + timestamp);
            result = FALSE;
        }
        if(fromagentname != "Login Control")
        {
            llSay(PUBLIC_CHANNEL, "fromagentname wrong. Got " + fromagentname);
            result = FALSE;
        }
        if(message != "Message")
        {
            llSay(PUBLIC_CHANNEL, "message wrong. Got " + message);
            result = FALSE;
        }
        if(binarybucket.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "binarybucket wrong. Got " + binarybucket.Length);
            result = FALSE;
        }
    }
}

state logouttest
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Requesting logout for Login Test");
        llSetTimerEvent(5);
        vagent.Logout();
    }
    
    logoutreply_received(agentinfo agent)
    {

        llSetTimerEvent(1);
    }
    
    timer()
    {
        state logoutcontrol;
    }
}

state logoutcontrol
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Requesting logout for Login Control");
        llSetTimerEvent(1);
        vcontrolagent.Logout();
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
