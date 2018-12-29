//#!Mode:ASSL
//#!Enable:Testing

integer success = TRUE;
integer received;

default
{
    state_entry()
    {
        llSetTimerEvent(1);
    }
    
    timer()
    {
		if(llGetObjectDetails("11223344-1122-1122-1122-000000000001", [OBJECT_NAME]) == [])
		{
			llSay(PUBLIC_CHANNEL, "Test prim missing");
			success = FALSE;
		}
		else
		{
			llSay(PUBLIC_CHANNEL, "Test prim is expectedly there");
		}
		state checkscript;
    }
}

state checkscript
{
	state_entry()
	{
		received = FALSE;
		llListen(10, "", NULL_KEY, "");
		llSay(10, "Hello");
	}
	
	listen(integer ch, string name, key id, string data)
	{
		llSay(PUBLIC_CHANNEL, "Script is responding");
		received = TRUE;
	}
	
	timer()
	{
		if(!received)
		{
			llSay(PUBLIC_CHANNEL, "Script is not responding");
			success = FALSE;
		}
		osDie("11223344-1122-1122-1122-000000000001");
		state checknotdie;
	}
}

state checknotdie
{
	timer()
	{
		if(llGetObjectDetails("11223344-1122-1122-1122-000000000001", [OBJECT_NAME]) != [])
		{
			llSay(PUBLIC_CHANNEL, "Test prim ignored osDie()");
		}
		else
		{
			llSay(PUBLIC_CHANNEL, "Test prim executed osDie() unexpectedly");
			success = FALSE;
		}
		state checklisten;
	}
}

state checklisten
{
	state_entry()
	{
		received = FALSE;
		llListen(10, "", NULL_KEY, "");
		llSay(10, "Hello");
	}
	
	listen(integer ch, string name, key id, string data)
	{
		received = TRUE;
		llSay(PUBLIC_CHANNEL, "Script is responding");
	}
	
	timer()
	{
		if(!received)
		{
			llSay(PUBLIC_CHANNEL, "Script is not responding");
			success = FALSE;
		}
		_test_Result(success);
		_test_Shutdown();
	}
}
