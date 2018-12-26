//#!Mode:ASSL
//#!Enable:Testing

integer success = TRUE;

integer hitcount = 0;
default
{
	state_entry()
	{
		llSleep(1); /* get log buffer written */
		vector from = llGetPos() - <1,0,0>;
		vector to = llGetPos() + <1,0,0>;
		list result = asCastRayCollision(from, to, []);
		if(llList2Integer(result, -1) != 1)
		{
			llSay(PUBLIC_CHANNEL, "Unexpected number of hits");
			success = FALSE;
		}

		llSetTimerEvent(1);
	}
	
	timer()
	{
		llSetTimerEvent(0);
		
		if(hitcount != 3)
		{
			llSay(PUBLIC_CHANNEL, "Event count not matching");
			success = FALSE;
		}
		
		_test_Result(success);
		_test_Shutdown();
	}
	
	collision_start(integer num)
	{
		llSay(PUBLIC_CHANNEL, "collision_start");
		if(num != 1)
		{
			llSay(PUBLIC_CHANNEL, "collision_start: num != 1");
			success = FALSE;
		}
		else if(llDetectedKey(0) != llGetKey())
		{
			llSay(PUBLIC_CHANNEL, "collision_start not matching");
			success = FALSE;
		}
		else if(hitcount != 0)
		{
			llSay(PUBLIC_CHANNEL, "event order mismatch");
		}
		++hitcount;
	}
	
	collision(integer num)
	{
		llSay(PUBLIC_CHANNEL, "collision");
		if(num != 1)
		{
			llSay(PUBLIC_CHANNEL, "collision: num != 1");
			success = FALSE;
		}
		else if(llDetectedKey(0) != llGetKey())
		{
			llSay(PUBLIC_CHANNEL, "collision not matching");
			success = FALSE;
		}
		else if(hitcount != 1)
		{
			llSay(PUBLIC_CHANNEL, "event order mismatch");
		}
		++hitcount;
	}
	
	collision_end(integer num)
	{
		llSay(PUBLIC_CHANNEL, "collision_end");
		if(num != 1)
		{
			llSay(PUBLIC_CHANNEL, "collision_end: num != 1");
			success = FALSE;
		}
		else if(llDetectedKey(0) != llGetKey())
		{
			llSay(PUBLIC_CHANNEL, "collision_end not matching");
			success = FALSE;
		}
		else if(hitcount != 2)
		{
			llSay(PUBLIC_CHANNEL, "event order mismatch");
		}
		++hitcount;
	}
}