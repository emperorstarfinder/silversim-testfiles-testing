//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing
//#!Enable:PermGranter

integer circuitcode;
key sessionid;
key securesessionid;
vieweragent vagent;
key agentid;
integer result = TRUE;

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        circuitcode = (integer)llFrand(100000) + 100000;
        sessionid = llGenerateKey();
        securesessionid = llGenerateKey();
        
        agentid = llGetOwner();
        
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
        state test;
    }
}

state test
{
    state_entry()
    {
        _test_GrantScriptPerm(PERMISSION_OVERRIDE_ANIMATIONS);
        llSetAnimationOverride("Standing", "sit");
        llSetAnimationOverride("Sitting", "stand");
        if("sit" != llGetAnimationOverride("Standing") || "stand" != llGetAnimationOverride("Sitting"))
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Prerequisite for testing function not set correctly");
        }
        llResetAnimationOverride("Standing");
        if("stand" != llGetAnimationOverride("Standing"))
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Value for animation override Stand is not back to \"stand\": " + llGetAnimationOverride("Standing"));
        }
        if("stand" != llGetAnimationOverride("Sitting"))
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Value for animation override Sitting is not left unchanged: " + llGetAnimationOverride("Sitting"));
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