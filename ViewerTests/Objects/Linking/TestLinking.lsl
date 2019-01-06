//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

const key ROOT_ID = "11223344-1122-1122-1122-000000000000";
const key LINK1_ID = "11223344-1122-1122-1122-000000000001";
const key LINK2_ID = "11223344-1122-1122-1122-000000000002";
const key LINK3_ID = "11223344-1122-1122-1122-000000000003";
const key LINK4_ID = "11223344-1122-1122-1122-000000000004";

const integer ROOT_LOCALID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000000");
const integer LINK1_LOCALID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000001");
const integer LINK2_LOCALID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000002");
const integer LINK3_LOCALID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000003");
const integer LINK4_LOCALID = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000004");

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
		llSleep(1); /* ensure init */
		state test;
	}
}

state test
{
    state_entry()
    {
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK4_ID);
		vagent.SendObjectLink([ROOT_LOCALID, LINK4_LOCALID]);
    }
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK4_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(2) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				result = FALSE;
			}
			state link_link3;
		}
	}
}

/******************************************************************************/
state link_link3
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK3_ID);
		vagent.SendObjectLink([ROOT_LOCALID, LINK3_LOCALID]);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK3_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(2) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(3) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				result = FALSE;
			}
			state link_link2;
		}
	}
}

/******************************************************************************/
state link_link2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK2_ID);
		vagent.SendObjectLink([ROOT_LOCALID, LINK2_LOCALID]);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK2_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(2) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(3) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(4) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 4 not matching expected linking rules");
				result = FALSE;
			}
			state link_link1;
		}
	}
}

/******************************************************************************/
state link_link1
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK1_ID);
		vagent.SendObjectLink([ROOT_LOCALID, LINK1_LOCALID]);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK1_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(2) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(3) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(4) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 4 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetLinkKey(5) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 5 not matching expected linking rules");
				result = FALSE;
			}
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