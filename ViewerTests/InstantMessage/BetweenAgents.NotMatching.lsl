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
        vagent.SendInstantMessage(FALSE, llGenerateKey(), 1, REGION_ID, llGetPos(), FALSE, DIALOG_MESSAGE_FROM_AGENT, test_session, 10, "Login Test", "Message", ByteArray(0));
    }
    
    timer()
    {
        if(msgcount != 0)
        {
            llSay(PUBLIC_CHANNEL, "ImprovedInstanceMessage should not be received");
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
