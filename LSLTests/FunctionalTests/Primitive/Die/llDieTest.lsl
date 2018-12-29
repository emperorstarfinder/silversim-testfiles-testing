//#!Mode:ASSL
//#!Enable:Testing

integer success = TRUE;

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
		llSay(10, "Die");
		state checkdie;
    }
}

state checkdie
{
	timer()
	{
		if(llGetObjectDetails("11223344-1122-1122-1122-000000000001", [OBJECT_NAME]) != [])
		{
			llSay(PUBLIC_CHANNEL, "Test prim did not execute llDie()");
			success = FALSE;
		}
		else
		{
			llSay(PUBLIC_CHANNEL, "Test prim executed die correctly");
		}
		_test_Result(success);
		_test_Shutdown();
	}
}
