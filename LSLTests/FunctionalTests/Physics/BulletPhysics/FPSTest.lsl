//#!Mode:ASSL
//#!Enable:Testing
//#!Enable:BulletPhysicsTest

default
{
	state_entry()
	{
		integer start;
		integer end;
		
		start = asGetPhysicsFrameNumber();
		llSleep(10);
		end = asGetPhysicsFrameNumber();
		
		integer diff = end - start;
		
		llSay(PUBLIC_CHANNEL, "Start Frame: " + (string)start);
		llSay(PUBLIC_CHANNEL, "End Frame: " + (string)end);
		llSay(PUBLIC_CHANNEL, "Processed Frames: " + (string)diff);
		
		if(diff < 595)
		{
			llSay(PUBLIC_CHANNEL, "Did not reach expected FPS");
			_test_Result(FALSE);
		}
		else
		{
			_test_Result(TRUE);
		}
		
		_test_Shutdown();
	}
}