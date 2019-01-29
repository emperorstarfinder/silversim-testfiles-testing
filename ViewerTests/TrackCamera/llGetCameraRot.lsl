//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing
//#!Enable:PermGranter

vieweragent vagent;
key agentid;
integer result = TRUE;

default
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
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        vagent.SendCompleteAgentMovement();
        _test_GrantScriptPerm(PERMISSION_TRACK_CAMERA);
        state trackcamerarot_x;
    }
}

state trackcamerarot_x
{
    float cameraangle = 0;
    rotation camerarot;
    state_entry()
    {
        llSetTimerEvent(0.2);
        camerarot = llEuler2Rot(<cameraangle, 0, 0> * DEG_TO_RAD);
        llSay(PUBLIC_CHANNEL, "Testing x-angle " + cameraangle);
        vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, llGetPos(), llRot2Fwd(camerarot), llRot2Left(camerarot), llRot2Up(camerarot), 100, 0, 0);
    }
    
    timer()
    {
        rotation rot = llGetCameraRot();
        if(llFabs(rot.x - camerarot.x) > 0.001 ||
            llFabs(rot.y - camerarot.y) > 0.001 ||
            llFabs(rot.z - camerarot.z) > 0.001 ||
            llFabs(rot.s - camerarot.s) > 0.001)
        {
            llSay(PUBLIC_CHANNEL, "Not received correct camera rotation");
            result = FALSE;
        }
        if(cameraangle < 1)
        {
            cameraangle += 0.1;
            camerarot = llEuler2Rot(<cameraangle, 0, 0> * DEG_TO_RAD);
            llSay(PUBLIC_CHANNEL, "Testing x-angle " + cameraangle);
            vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, llGetPos(), llRot2Fwd(camerarot), llRot2Left(camerarot), llRot2Up(camerarot), 100, 0, 0);
        }
        else
        {
            state trackcamerarot_y;
        }
    }
}

state trackcamerarot_y
{
    float cameraangle = 0;
    rotation camerarot;
    state_entry()
    {
        llSetTimerEvent(0.2);
        camerarot = llEuler2Rot(<0, cameraangle, 0> * DEG_TO_RAD);
        llSay(PUBLIC_CHANNEL, "Testing y-angle " + cameraangle);
        vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, llGetPos(), llRot2Fwd(camerarot), llRot2Left(camerarot), llRot2Up(camerarot), 100, 0, 0);
    }
    
    timer()
    {
        rotation rot = llGetCameraRot();
        if(llFabs(rot.x - camerarot.x) > 0.001 ||
            llFabs(rot.y - camerarot.y) > 0.001 ||
            llFabs(rot.z - camerarot.z) > 0.001 ||
            llFabs(rot.s - camerarot.s) > 0.001)
        {
            llSay(PUBLIC_CHANNEL, "Not received correct camera rotation");
            result = FALSE;
        }
        if(cameraangle < 1)
        {
            cameraangle += 0.1;
            camerarot = llEuler2Rot(<cameraangle, 0, 0> * DEG_TO_RAD);
            llSay(PUBLIC_CHANNEL, "Testing y-angle " + cameraangle);
            vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, llGetPos(), llRot2Fwd(camerarot), llRot2Left(camerarot), llRot2Up(camerarot), 100, 0, 0);
        }
        else
        {
            state trackcamerarot_z;
        }
    }
}

state trackcamerarot_z
{
    float cameraangle = 0;
    rotation camerarot;
    state_entry()
    {
        llSetTimerEvent(0.2);
        camerarot = llEuler2Rot(<0, 0, cameraangle> * DEG_TO_RAD);
        llSay(PUBLIC_CHANNEL, "Testing z-angle " + cameraangle);
        vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, llGetPos(), llRot2Fwd(camerarot), llRot2Left(camerarot), llRot2Up(camerarot), 100, 0, 0);
    }
    
    timer()
    {
        rotation rot = llGetCameraRot();
        if(llFabs(rot.x - camerarot.x) > 0.001 ||
            llFabs(rot.y - camerarot.y) > 0.001 ||
            llFabs(rot.z - camerarot.z) > 0.001 ||
            llFabs(rot.s - camerarot.s) > 0.001)
        {
            llSay(PUBLIC_CHANNEL, "Not received correct camera rotation");
            result = FALSE;
        }
        if(cameraangle < 1)
        {
            cameraangle += 0.1;
            camerarot = llEuler2Rot(<0, 0, cameraangle> * DEG_TO_RAD);
            llSay(PUBLIC_CHANNEL, "Testing z-angle " + cameraangle);
            vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, llGetPos(), llRot2Fwd(camerarot), llRot2Left(camerarot), llRot2Up(camerarot), 100, 0, 0);
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