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
		llTextBox(agentid, "Message", 1);
	}
	
	scriptdialog_received(agentinfo agent, key objectid, string firstname, string lastname, string objectname, string message, integer chatchannel, key imageid, list buttons, list ownerdata)
	{
		if(objectid != llGetKey())
		{
			llSay(PUBLIC_CHANNEL, "Unexpected objectid. Got " + objectid);
			result = FALSE;
		}
		if(firstname != "Script")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected firstname. Got " + firstname);
			result = FALSE;
		}
		if(lastname != "Test")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected lastname. Got " + lastname);
			result = FALSE;
		}
		if(objectname != "Test Object")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected lastname. Got " + objectname);
			result = FALSE;
		}
		if(message != "Message")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected message. Got " + message);
			result = FALSE;
		}
		if(chatchannel != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected chatchannel. Got " + chatchannel);
			result = FALSE;
		}
		if(imageid != NULL_KEY)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected imageid. Got " + imageid);
			result = FALSE;
		}
		if(llGetListLength(buttons) != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected buttons length. Got " + llGetListLength(buttons));
			result = FALSE;
		}
		if(llList2String(buttons, 0) != "!!llTextBox!!")
		{
			llSay(PUBLIC_CHANNEL, "Unexpected buttons[0]. Got " + llList2String(buttons, 0));
			result = FALSE;
		}
		if(llGetListLength(ownerdata) != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected ownerdata length. Got " + llGetListLength(ownerdata));
			result = FALSE;
		}
		if(llList2Key(ownerdata, 0) != llGetOwner())
		{
			llSay(PUBLIC_CHANNEL, "Unexpected ownerdata[0]. Got " + llList2Key(ownerdata, 0));
			result = FALSE;
		}
		++msgcount;
	}
	
	timer()
	{
		if(msgcount == 0)
		{
			llSay(PUBLIC_CHANNEL, "No scriptdialog_received");
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
		_test_Shutdown();
	}
}