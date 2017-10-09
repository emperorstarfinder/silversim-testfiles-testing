//#!Enable:Testing

default
{
    state_entry()
    {
	llSay(PUBLIC_CHANNEL, "Testing sensor");
	llSensor("", NULL_KEY, PASSIVE, 10, PI);
    }
    
    sensor(integer num_detected)
    {
	llSay(PUBLIC_CHANNEL, "Found objects " + (string)num_detected);
	integer i;
	for(i = 0; i < num_detected; ++i)
	{
	    llSay(PUBLIC_CHANNEL, "Name(" + (string)i + "): " + llDetectedName(i));
	    llSay(PUBLIC_CHANNEL, "Id(" + (string)i + "): " + llDetectedKey(i));
	    llSay(PUBLIC_CHANNEL, "Pos(" + (string)i + "): " + (string)llDetectedPos(i));
	}
	_test_Result(num_detected == 4);
	_test_Shutdown();
    }
    
    no_sensor()
    {
	llSay(PUBLIC_CHANNEL, "Failed to find objects");
	_test_Result(FALSE);
	_test_Shutdown();
    }
}