//#!Enable:Testing

default
{
    state_entry()
    {
	_test_Result(FALSE);
	llSay(PUBLIC_CHANNEL, "Testing Sensor Target 1");
	llSensor("", "11223344-1122-1122-1122-000000000001", PASSIVE, 10, PI);
    }
    
    sensor(integer num_detected)
    {
	if(num_detected == 1 && llDetectedName(0) == "Sensor Target 1")
	{
		state target2;
	}
	else
	{
		if(num_detected < 1)
		{
			llSay(PUBLIC_CHANNEL, "Failed to find any object");
		}
		else if(llDetectedName(0) != "Sensor Target 1")
		{
			llSay(PUBLIC_CHANNEL, "Found wrong object");
		}
		llSay(PUBLIC_CHANNEL, "Found number: " + (string)num_detected);
		_test_Shutdown();
	}
    }
    
    no_sensor()
    {
	llSay(PUBLIC_CHANNEL, "Failed to find object");
	_test_Shutdown();
    }
}

state target2
{
    state_entry()
    {
	llSay(PUBLIC_CHANNEL, "Testing Sensor Target 2");
	llSensor("", "11223344-1122-1122-1122-000000000002", PASSIVE, 10, PI);
    }
    
    sensor(integer num_detected)
    {
	if(num_detected == 1 && llDetectedName(0) == "Sensor Target 2")
	{
		state target3;
	}
	else
	{
		if(num_detected < 1)
		{
			llSay(PUBLIC_CHANNEL, "Failed to find any object");
		}
		else if(llDetectedName(0) != "Sensor Target 2")
		{
			llSay(PUBLIC_CHANNEL, "Found wrong object");
		}
		llSay(PUBLIC_CHANNEL, "Found number: " + (string)num_detected);
		_test_Shutdown();
	}
    }
    
    no_sensor()
    {
	llSay(PUBLIC_CHANNEL, "Failed to find object");
	_test_Shutdown();
    }
}


state target3
{
    state_entry()
    {
	llSay(PUBLIC_CHANNEL, "Testing Sensor Target 3");
	llSensor("", "11223344-1122-1122-1122-000000000003", PASSIVE, 10, PI);
    }
    
    sensor(integer num_detected)
    {
	if(num_detected == 1 && llDetectedName(0) == "Sensor Target 3")
	{
		state target4;
	}
	else
	{
		if(num_detected < 1)
		{
			llSay(PUBLIC_CHANNEL, "Failed to find any object");
		}
		else if(llDetectedName(0) != "Sensor Target 3")
		{
			llSay(PUBLIC_CHANNEL, "Found wrong object");
		}
		llSay(PUBLIC_CHANNEL, "Found number: " + (string)num_detected);
		_test_Shutdown();
	}
    }
    
    no_sensor()
    {
	llSay(PUBLIC_CHANNEL, "Failed to find object");
	_test_Shutdown();
    }
}

state target4
{
    state_entry()
    {
	llSay(PUBLIC_CHANNEL, "Testing Sensor Target 4");
	llSensor("", "11223344-1122-1122-1122-000000000004", PASSIVE, 10, PI);
    }
    
    sensor(integer num_detected)
    {
	if(num_detected == 1 && llDetectedName(0) == "Sensor Target 4")
	{
		_test_Result(TRUE);
	}
	else
	{
		if(num_detected < 1)
		{
			llSay(PUBLIC_CHANNEL, "Failed to find any object");
		}
		else if(llDetectedName(0) != "Sensor Target 4")
		{
			llSay(PUBLIC_CHANNEL, "Found wrong object");
		}
		llSay(PUBLIC_CHANNEL, "Found number: " + (string)num_detected);
	}
	_test_Shutdown();
    }
    
    no_sensor()
    {
	llSay(PUBLIC_CHANNEL, "Failed to find object");
	_test_Shutdown();
    }
}