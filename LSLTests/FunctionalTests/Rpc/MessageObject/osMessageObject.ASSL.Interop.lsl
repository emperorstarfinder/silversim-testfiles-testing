//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		_test_setserverparam("OSSL.osMessageObject.IsEveryoneAllowed", "true");
		llSleep(1); /* ensure start up time */
		llSetTimerEvent(1);
		osMessageObject("11223344-1122-1122-1122-000000000001", "Hello");
	}
	
	object_message(key id, string query)
	{
		llSetTimerEvent(0);
		_test_Result(id == "11223344-1122-1122-1122-000000000001" && query == "Hello");
		_test_Shutdown();
	}
	
	timer()
	{
		llSay(PUBLIC_CHANNEL, "No dataserver received");
		_test_Shutdown();
	}
}