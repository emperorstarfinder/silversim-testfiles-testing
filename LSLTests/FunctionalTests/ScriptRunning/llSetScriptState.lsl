//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		if(!_test_InjectScript("TestState", "../tests/LSLTests/FunctionalTests/ScriptRunning/Responder.lsli", 0, NULL_KEY))
		{
			llSay(PUBLIC_CHANNEL, "Failed to inject script");
			_test_Shutdown();
		}
		llSleep(1);
		llSetTimerEvent(1);
		llMessageLinked(LINK_SET, 0, "Hello", "World");
	}
	
	link_message(integer sender, integer num, string data, key id)
	{
		if(num == 1 && data == "Hello" && id == "World")
		{
			llSetTimerEvent(0);
			state setnotrunning;
		}
	}
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, "TestState script not running");
		_test_Shutdown();
	}
}

state setnotrunning
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Set script to not running");
		llSetTimerEvent(1);
		llSetScriptState("TestState", FALSE);
		llMessageLinked(LINK_SET, 0, "Hello", "World");
	}
	
	link_message(integer sender, integer num, string data, key id)
	{
		if(num == 1 && data == "Hello" && id == "World")
		{
			llSetTimerEvent(0);
			llSay(PUBLIC_CHANNEL, "TestState script is still running");
		}
	}
	
	timer()
	{
		llSetTimerEvent(0);
		state setrunning;
	}
}

state setrunning
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Set script to running");
		llSetTimerEvent(1);
		llSetScriptState("TestState", TRUE);
		llMessageLinked(LINK_SET, 0, "Hello", "World");
	}
	
	link_message(integer sender, integer num, string data, key id)
	{
		if(num == 1 && data == "Hello" && id == "World")
		{
			llSetTimerEvent(0);
			_test_Result(TRUE);
			_test_Shutdown();
		}
	}
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, "TestState script not set back to running");
		_test_Shutdown();
	}
}
