//#!Enable:Testing

default
{
    state_entry()
    {
	_test_Result(FALSE);
        _test_Log(LOG_INFO, "Starting timer");
        llSetTimerEvent(1);
    }
    timer()
    {
        llSetTimerEvent(0);
        _test_Log(LOG_INFO, "Hello");
	_test_Result(TRUE);
	_test_Shutdown();
    }
}