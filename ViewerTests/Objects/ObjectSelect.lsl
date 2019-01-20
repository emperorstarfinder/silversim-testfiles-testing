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
    integer msgcount = 0;
    integer msg2count = 0;
    integer localid;
    state_entry()
    {
        llSleep(1); /* ensure init */
        llSay(PUBLIC_CHANNEL, "Sending ObjectSelect");
        llSetTimerEvent(1.0);
        localid = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        vagent.SendObjectSelect([localid]);
    }
    
    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objects)
    {
        foreach(objdata in objects)
        {
            if(localid == objdata.LocalID)
            {
                llSay(PUBLIC_CHANNEL, "Flags " + objdata.UpdateFlags);
                if((objdata.UpdateFlags & 2))
                {
                    llSay(PUBLIC_CHANNEL, "Select received");
                    ++msgcount;
                }
            }
        }
    }
    
    objectproperties_received(agentinfo agent, objectpropertieslist objlist)
	{
        foreach(data in objlist)
        {
            if(data.ObjectID == "11223344-1122-1122-1122-000000000001")
            {
                ++msg2count;
                if(data.Name != "SelectMe")
                {
                    llSay(PUBLIC_CHANNEL, "ObjectProperties name wrong");
                    llSay(PUBLIC_CHANNEL, "Name: " + data.Name);
                    result = FALSE;
                }
            }
        }
    }    
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "Object not selected");
            result = FALSE;
        }
        if(msg2count == 0)
        {
            llSay(PUBLIC_CHANNEL, "ObjectProperties not received");
            result = FALSE;
        }
        state test2;
    }
}

state test2
{
    integer msgcount = 0;
    integer localid;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Sending ObjectDeselect");
        llSetTimerEvent(1.0);
        localid = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
        vagent.SendObjectDeselect([_test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001")]);
    }
    
    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objects)
    {
        foreach(objdata in objects)
        {
            if(localid == objdata.LocalID)
            {
                llSay(PUBLIC_CHANNEL, "Flags " + objdata.UpdateFlags);
                if(!(objdata.UpdateFlags & 2))
                {
                    llSay(PUBLIC_CHANNEL, "Deselect received");
                    ++msgcount;
                }
            }
        }
    }
    
    timer()
    {
        if(msgcount == 0)
        {
            llSay(PUBLIC_CHANNEL, "Object not unselected");
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