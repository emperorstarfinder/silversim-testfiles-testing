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

/******************************************************************************/
key getrootkey(key id)
{
	return llList2Key(llGetObjectDetails(id, [OBJECT_ROOT]), 0);
}

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

/******************************************************************************/
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
			state unlink2;
		}
	}
}

/******************************************************************************/
state unlink2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2");
		vagent.SendObjectDelink([LINK1_LOCALID]);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				result = FALSE;
			}
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
			
			state unlink2a;
		}
	}
}


/******************************************************************************/
state unlink2a
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2a");
		vagent.SendObjectDelink([LINK2_LOCALID]);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				result = FALSE;
			}
			if(getrootkey(LINK2_ID) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link2 not correctly unlinked");
				result = FALSE;
			}
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
			
			state unlink2b;
		}
	}
}

/******************************************************************************/
state unlink2b
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2b");
		vagent.SendObjectDelink([LINK3_LOCALID]);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				result = FALSE;
			}
			if(getrootkey(LINK2_ID) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link2 not correctly unlinked");
				result = FALSE;
			}
			if(getrootkey(LINK3_ID) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link3 not correctly unlinked");
				result = FALSE;
			}
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
			
			state unlink2c;
		}
	}
}

/******************************************************************************/
state unlink2c
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2c");
		vagent.SendObjectDelink([LINK4_LOCALID]);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				result = FALSE;
			}
			if(getrootkey(LINK2_ID) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link2 not correctly unlinked");
				result = FALSE;
			}
			if(getrootkey(LINK3_ID) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link3 not correctly unlinked");
				result = FALSE;
			}
			if(getrootkey(LINK4_ID) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link4 not correctly unlinked");
				result = FALSE;
			}
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				result = FALSE;
			}
			if(llGetNumberOfPrims() != 1)
			{
				llSay(PUBLIC_CHANNEL, "Number of links wrong");
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