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
    integer localid;
	state_entry()
	{
		llSleep(1); /* ensure init */
		llSay(PUBLIC_CHANNEL, "Sending Touch");
		llSetTimerEvent(1.0);
        localid = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000000");
		vagent.SendObjectGrab(localid, ZERO_VECTOR, [<0.1,0.1,0.0>,<0.2,0.2,0>,0,llGetPos(),<1.0,0,0>,<0,1.0,0>]);
		vagent.SendObjectGrabUpdate(llGetKey(), ZERO_VECTOR, llGetPos(), 1, [<0.1,0.1,0.0>,<0.2,0.2,0>,0,llGetPos(),<1.0,0,0>,<0,1.0,0>]);
        vagent.SendObjectDeGrab(localid, [<0.1,0.1,0.0>,<0.2,0.2,0>,0,llGetPos(),<1.0,0,0>,<0,1.0,0>]);
	}
    
    touch_start(integer det)
    {
        llSay(PUBLIC_CHANNEL, "touch_start()");
        if(det != 1)
        {
            llSay(PUBLIC_CHANNEL, "touch_start(num_detected) not matching. " + det);
            result = FALSE;
        }
        if(!(llDetectedType(0) & AGENT))
        {
            llSay(PUBLIC_CHANNEL, "llDetectedType(0) not matching. " + llDetectedType(0));
            result = FALSE;
        }
        if(llDetectedKey(0) != llGetOwner())
        {
            llSay(PUBLIC_CHANNEL, "llDetectedKey(0) not matching. " + llDetectedKey(0));
            result = FALSE;
        }
        if(llDetectedPos(0) != llGetPos())
        {
            llSay(PUBLIC_CHANNEL, "llDetectedPos(0) not matching. " + llDetectedPos(0));
            result = FALSE;
        }
        if(llVecDist(llDetectedTouchUV(0), <0.1,0.1,0.0>) > 0.000001)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchUV(0) not matching. " + llDetectedTouchUV(0));
            result = FALSE;
        }
        if(llVecDist(llDetectedTouchST(0), <0.2,0.2,0.0>) > 0.000001)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchST(0) not matching. " + llDetectedTouchST(0));
            result = FALSE;
        }
        if(llDetectedTouchNormal(0) != <1.0,0.0,0.0>)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchNormal(0) not matching. " + llDetectedTouchNormal(0));
            result = FALSE;
        }
        if(llDetectedTouchBinormal(0) != <0.0,1.0,0.0>)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchBinormal(0) not matching. " + llDetectedTouchBinormal(0));
            result = FALSE;
        }
        msgcount |= 1;
    }
    
    touch(integer det)
    {
        llSay(PUBLIC_CHANNEL, "touch()");
        if(det != 1)
        {
            llSay(PUBLIC_CHANNEL, "touch(num_detected) not matching. " + det);
            result = FALSE;
        }
        if(!(llDetectedType(0) & AGENT))
        {
            llSay(PUBLIC_CHANNEL, "llDetectedType(0) not matching. " + llDetectedType(0));
            result = FALSE;
        }
        if(llDetectedKey(0) != llGetOwner())
        {
            llSay(PUBLIC_CHANNEL, "llDetectedKey(0) not matching. " + llDetectedKey(0));
            result = FALSE;
        }
        if(llDetectedPos(0) != llGetPos())
        {
            llSay(PUBLIC_CHANNEL, "llDetectedPos(0) not matching. " + llDetectedPos(0));
            result = FALSE;
        }
        if(llVecDist(llDetectedTouchUV(0), <0.1,0.1,0.0>) > 0.000001)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchUV(0) not matching. " + llDetectedTouchUV(0));
            result = FALSE;
        }
        if(llVecDist(llDetectedTouchST(0), <0.2,0.2,0.0>) > 0.000001)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchST(0) not matching. " + llDetectedTouchST(0));
            result = FALSE;
        }
        if(llDetectedTouchNormal(0) != <1.0,0.0,0.0>)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchNormal(0) not matching. " + llDetectedTouchNormal(0));
            result = FALSE;
        }
        if(llDetectedTouchBinormal(0) != <0.0,1.0,0.0>)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchBinormal(0) not matching. " + llDetectedTouchBinormal(0));
            result = FALSE;
        }
        msgcount |= 2;
    }
    
    touch_end(integer det)
    {
        llSay(PUBLIC_CHANNEL, "touch_end()");
        if(det != 1)
        {
            llSay(PUBLIC_CHANNEL, "touch_end(num_detected) not matching. " + det);
            result = FALSE;
        }
        if(!(llDetectedType(0) & AGENT))
        {
            llSay(PUBLIC_CHANNEL, "llDetectedType(0) not matching. " + llDetectedType(0));
            result = FALSE;
        }
        if(llDetectedKey(0) != llGetOwner())
        {
            llSay(PUBLIC_CHANNEL, "llDetectedKey(0) not matching. " + llDetectedKey(0));
            result = FALSE;
        }
        if(llDetectedPos(0) != llGetPos())
        {
            llSay(PUBLIC_CHANNEL, "llDetectedPos(0) not matching. " + llDetectedPos(0));
            result = FALSE;
        }
        if(llVecDist(llDetectedTouchUV(0), <0.1,0.1,0.0>) > 0.000001)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchUV(0) not matching. " + llDetectedTouchUV(0));
            result = FALSE;
        }
        if(llVecDist(llDetectedTouchST(0), <0.2,0.2,0.0>) > 0.000001)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchST(0) not matching. " + llDetectedTouchST(0));
            result = FALSE;
        }
        if(llDetectedTouchNormal(0) != <1.0,0.0,0.0>)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchNormal(0) not matching. " + llDetectedTouchNormal(0));
            result = FALSE;
        }
        if(llDetectedTouchBinormal(0) != <0.0,1.0,0.0>)
        {
            llSay(PUBLIC_CHANNEL, "llDetectedTouchBinormal(0) not matching. " + llDetectedTouchBinormal(0));
            result = FALSE;
        }
        msgcount |= 4;
    }
	
	timer()
	{
		if((msgcount & 1) == 0)
		{
			llSay(PUBLIC_CHANNEL, "touch_start not processed correctly");
			result = FALSE;
		}
		if((msgcount & 2) == 0)
		{
			llSay(PUBLIC_CHANNEL, "touch not processed correctly");
			result = FALSE;
		}
		if((msgcount & 4) == 0)
		{
			llSay(PUBLIC_CHANNEL, "touch_end not processed correctly");
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