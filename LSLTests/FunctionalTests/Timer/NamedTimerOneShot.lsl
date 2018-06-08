//#!Mode:ASSL
//#!Enable:Testing

integer timercnt = 0;

timer(Hello) timerfunc()
{
	llSay(PUBLIC_CHANNEL, "Timer Hello triggered");
	++timercnt;
}

default
{
    state_entry()
    {
	_test_Result(FALSE);
        _test_Log(LOG_INFO, "Starting timer");
        llSetTimerEvent(1);
		Timer["Hello"].IsOneshot = TRUE;
		Timer["Hello"].Interval = 0.25;
    }
    timer()
    {
        llSetTimerEvent(0);
        _test_Log(LOG_INFO, "Hello");
	_test_Result(timercnt==1);
	_test_Shutdown();
    }
}