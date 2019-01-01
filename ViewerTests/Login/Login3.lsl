//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer controlcircuitcode;
integer circuitcode;
vieweragent vagent;
vieweragent vcontrolagent;
key controlagentid;
key agentid;
integer agentlocalid;
list test_seenobjects;
list control_seenobjects;
integer success = TRUE;
integer control_seenself = FALSE;
integer control_seenprim = FALSE;
integer control_seenother = FALSE;
integer control_seenkillother = FALSE;
integer control_seenkillother_excessive = FALSE;

integer test_seenself = FALSE;
integer test_seenprim = FALSE;
integer test_seenother = FALSE;

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Logging in agent");
		_test_Result(FALSE);
		controlcircuitcode = (integer)llFrand(100000) + 200000;
		circuitcode = (integer)llFrand(100000) + 100000;
		
		agentid = vcCreateAccount("Login", "Test");
		controlagentid = vcCreateAccount("Login", "Control");
		
		vcontrolagent = vcLoginAgent(controlcircuitcode, 
				"39702429-6b4f-4333-bac2-cd7ea688753e", 
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
	
	objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
	{
		llSay(PUBLIC_CHANNEL, "objectupdate_received(" + objectlist.Count +")");
		if(agent.AgentID == agentid)
		{
			foreach(objdata in objectlist)
			{
				key id = objdata.FullID;
				if(id == agentid)
				{
					agentlocalid = objdata.LocalID;
					test_seenself = TRUE;
					if(objdata.Material != PRIM_MATERIAL_FLESH)
					{
						llSay(PUBLIC_CHANNEL, "Not flesh for agent: "+ objdata.Material);
						success = FALSE;
					}
				}
				if(id == controlagentid)
				{
					test_seenother = TRUE;
					if(objdata.Material != PRIM_MATERIAL_FLESH)
					{
						llSay(PUBLIC_CHANNEL, "Not flesh for agent: "+ objdata.Material);
						success = FALSE;
					}
				}
				if(id == llGetKey())
				{
					test_seenprim = TRUE;
					if(objdata.Material != PRIM_MATERIAL_WOOD)
					{
						llSay(PUBLIC_CHANNEL, "Not wood for prim: " + objdata.Material);
						success = FALSE;
					}
				}
				if(llListFindList(test_seenobjects, [id]) < 0)
				{
					test_seenobjects += id;
				}
			}
		}
		
		if(agent.AgentID == controlagentid)
		{
			foreach(objdata in objectlist)
			{
				key id = objdata.FullID;
				if(id == agentid)
				{
					agentlocalid = objdata.LocalID;
					control_seenother = TRUE;
					if(objdata.Material != PRIM_MATERIAL_FLESH)
					{
						llSay(PUBLIC_CHANNEL, "Not flesh for agent: "+ objdata.Material);
						success = FALSE;
					}
				}
				if(id == controlagentid)
				{
					control_seenself = TRUE;
					if(objdata.Material != PRIM_MATERIAL_FLESH)
					{
						llSay(PUBLIC_CHANNEL, "Not flesh for agent: "+ objdata.Material);
						success = FALSE;
					}
				}
				if(id == llGetKey())
				{
					control_seenprim = TRUE;
					if(objdata.Material != PRIM_MATERIAL_WOOD)
					{
						llSay(PUBLIC_CHANNEL, "Not wood for prim: " + objdata.Material);
						success = FALSE;
					}
				}
				if(llListFindList(control_seenobjects, [id]) < 0)
				{
					control_seenobjects += id;
				}
			}
		}
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
	
	killobject_received(agentinfo agent, list killedobjects)
	{
		if(agent.AgentID != controlagentid)
		{
			return;
		}
		llSay(PUBLIC_CHANNEL, "killobject_received");
		if(llListFindList(killedobjects, agentlocalid) >= 0)
		{
			if(control_seenkillother)
			{
				control_seenkillother_excessive = TRUE;
			}
			control_seenkillother = TRUE;
		}
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
		integer control_received_objects = llGetListLength(control_seenobjects);
		integer test_received_objects = llGetListLength(test_seenobjects);
		llSay(PUBLIC_CHANNEL, "Logout confirmed");
		llSay(PUBLIC_CHANNEL, "Login Test: Seen objects " + test_received_objects);
		llSay(PUBLIC_CHANNEL, "Login Control: Seen objects " + control_received_objects);
		if(test_received_objects != 3)
		{
			success = FALSE;
		}
		if(control_received_objects != 3)
		{
			success = FALSE;
		}
		if(!test_seenprim)
		{
			llSay(PUBLIC_CHANNEL, "Login Test: Prim not seen");
			success = FALSE;
		}
		if(!control_seenprim)
		{
			llSay(PUBLIC_CHANNEL, "Login Control: Prim not seen");
			success = FALSE;
		}
		if(!test_seenself)
		{
			llSay(PUBLIC_CHANNEL, "Agent(Login Test) not seen self");
			success = FALSE;
		}
		if(!control_seenself)
		{
			llSay(PUBLIC_CHANNEL, "Agent(Login Control) not seen self");
			success = FALSE;
		}
		if(!test_seenother)
		{
			llSay(PUBLIC_CHANNEL, "Agent(Login Test) not seen other");
			success = FALSE;
		}
		if(!control_seenother)
		{
			llSay(PUBLIC_CHANNEL, "Agent(Login Control) not seen other");
			success = FALSE;
		}
		if(!control_seenkillother)
		{
			llSay(PUBLIC_CHANNEL, "Agent(Login Test) did not trigger KillObject");
			success = FALSE;
		}
		/*
		if(control_seenkillother_excessive)
		{
			llSay(PUBLIC_CHANNEL, "Excessive killobject seen");
			success = FALSE;
		}*/
		_test_Result(success);
		llSetTimerEvent(1);
	}
	
	timer()
	{
		_test_Shutdown();
	}
}
