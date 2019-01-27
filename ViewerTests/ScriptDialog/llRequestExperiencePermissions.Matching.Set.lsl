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
        state test;
    }
}

state test
{
    state_entry()
    {
        llSetTimerEvent(1);
        msgcount = 0;
        llRequestExperiencePermissions(agentid, "");
    }
    
    scriptquestion_received(agentinfo agent, key objectid, key itemid, string objectname, string objectowner, integer questions, key experienceid)
    {
        if(objectid != llGetKey())
        {
            llSay(PUBLIC_CHANNEL, "Unexpected objectid. Got " + objectid);
            result = FALSE;
        }
        if(objectname != "Test Object")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected objectname. Got " + objectname);
            result = FALSE;
        }
        if(objectowner != "Script.Test @localhost:9300")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected objectowner. Got " + objectowner);
            result = FALSE;
        }
        if(questions != (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH | PERMISSION_TRACK_CAMERA | PERMISSION_CONTROL_CAMERA | PERMISSION_TELEPORT))
        {
            llSay(PUBLIC_CHANNEL, "Unexpected questions. Got " + questions);
            result = FALSE;
        }
        if(experienceid != "5d93a628-1bfb-4c72-892b-542d16457c71")
        {
            llSay(PUBLIC_CHANNEL, "Unexpected experienceid. Got " + experienceid);
            result = FALSE;
        }
        ++msgcount;
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "No scriptquestion_received");
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