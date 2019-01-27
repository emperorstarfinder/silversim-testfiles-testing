//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

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
        llSleep(1); /* ensure init */
        llSay(PUBLIC_CHANNEL, "Sending ObjectExtraParams => Light on");
        llSetTimerEvent(1.0);
        vcextraparamsdatalist paramslist;
        vcextraparamsdata params;
        vcextraparams extraparams;
        extraparams.HasLight = TRUE;
        extraparams.LightColor = <1,1,1>;
        extraparams.LightIntensity = 1;
        extraparams.LightRadius = 10;
        extraparams.LightCutoff = 0;
        extraparams.LightFalloff = 0;
        params.LocalID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        params.Flags = VC_EXTRA_PARAMS_DATA_SET_LIGHT_EP;
        params.ExtraParams = extraparams;
        paramslist.Add(params);
        vagent.SendObjectExtraParams(paramslist);
    }
    
    timer()
    {
        integer action = llList2Integer(osGetPrimitiveParams("11223344-1122-1122-1122-000000000001", [PRIM_POINT_LIGHT]), 0);
        if(action != TRUE)
        {
            llSay(PUBLIC_CHANNEL, "Not changed to Light on");
            result = FALSE;
        }
        state test2;
    }
}

state test2
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Sending ObjextExtraParams => Light off");
        llSetTimerEvent(1.0);
        vcextraparamsdatalist paramslist;
        vcextraparamsdata params;
        vcextraparams extraparams;
        extraparams.HasLight = FALSE;
        extraparams.LightColor = <1,1,1>;
        extraparams.LightIntensity = 1;
        extraparams.LightRadius = 10;
        extraparams.LightCutoff = 0;
        extraparams.LightFalloff = 0;
        params.LocalID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        params.Flags = VC_EXTRA_PARAMS_DATA_SET_LIGHT_EP;
        params.ExtraParams = extraparams;
        paramslist.Add(params);
        vagent.SendObjectExtraParams(paramslist);
    }
    
    timer()
    {
        integer action = llList2Integer(llGetObjectDetails("11223344-1122-1122-1122-000000000001", [PRIM_POINT_LIGHT]), 0);
        if(action != FALSE)
        {
            llSay(PUBLIC_CHANNEL, "Not changed to Light off");
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