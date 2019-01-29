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
        state trackcamerapos_x;
    }
}

state trackcamerapos_x
{
    vector camerapos = <128, 128, 128>;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Testing x-position " + camerapos.x);
        llSetTimerEvent(0.2);
        vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, camerapos, ZERO_VECTOR, ZERO_VECTOR, ZERO_VECTOR, 100, 0, 0);
    }
    
    timer()
    {
        vector pos = llGetCameraPos();
        if(llFabs(pos.x - camerapos.x) > 0.001 ||
            llFabs(pos.y - camerapos.y) > 0.001 ||
            llFabs(pos.z - camerapos.z) > 0.001)
        {
            llSay(PUBLIC_CHANNEL, "Not received correct camera position");
            result = FALSE;
        }
        if(camerapos.x < 128.01)
        {
            camerapos.x += 0.001;
            llSay(PUBLIC_CHANNEL, "Testing x-position " + camerapos.x);
            vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, camerapos, ZERO_VECTOR, ZERO_VECTOR, ZERO_VECTOR, 100, 0, 0);
        }
        else
        {
            state trackcamerapos_y;
        }
    }
}

state trackcamerapos_y
{
    vector camerapos = <128, 128, 128>;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Testing y-position " + camerapos.y);
        llSetTimerEvent(0.2);
        vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, camerapos, ZERO_VECTOR, ZERO_VECTOR, ZERO_VECTOR, 100, 0, 0);
    }
    
    timer()
    {
        vector pos = llGetCameraPos();
        if(llFabs(pos.x - camerapos.x) > 0.001 ||
            llFabs(pos.y - camerapos.y) > 0.001 ||
            llFabs(pos.z - camerapos.z) > 0.001)
        {
            llSay(PUBLIC_CHANNEL, "Not received correct camera position");
            result = FALSE;
        }
        if(camerapos.y < 128.01)
        {
            camerapos.y += 0.001;
            llSay(PUBLIC_CHANNEL, "Testing y-position " + camerapos.y);
            vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, camerapos, ZERO_VECTOR, ZERO_VECTOR, ZERO_VECTOR, 100, 0, 0);
        }
        else
        {
            state trackcamerapos_z;
        }
    }
}


state trackcamerapos_z
{
    vector camerapos = <128, 128, 128>;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Testing z-position " + camerapos.z);
        llSetTimerEvent(0.2);
        vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, camerapos, ZERO_VECTOR, ZERO_VECTOR, ZERO_VECTOR, 100, 0, 0);
    }
    
    timer()
    {
        vector pos = llGetCameraPos();
        if(llFabs(pos.x - camerapos.x) > 0.001 ||
            llFabs(pos.y - camerapos.y) > 0.001 ||
            llFabs(pos.z - camerapos.z) > 0.001)
        {
            llSay(PUBLIC_CHANNEL, "Not received correct camera position");
            result = FALSE;
        }
        if(camerapos.z < 128.01)
        {
            camerapos.z += 0.001;
            llSay(PUBLIC_CHANNEL, "Testing z-position " + camerapos.z);
            vagent.SendAgentUpdate(ZERO_ROTATION, ZERO_ROTATION, 0, camerapos, ZERO_VECTOR, ZERO_VECTOR, ZERO_VECTOR, 100, 0, 0);
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