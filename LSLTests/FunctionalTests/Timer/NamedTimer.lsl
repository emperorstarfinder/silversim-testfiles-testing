//#!Mode:ASSL
//#!Enable:Testing

integer timerseen = FALSE;
integer timer2seen = FALSE;

timer(Hello) timerfunc()
{
	llSay(PUBLIC_CHANNEL, "Timer Hello triggered");
	timerseen = TRUE;
}

timer(Hello2) timerfunc()
{
	llSay(PUBLIC_CHANNEL, "Timer Hello2 triggered");
	timer2seen = TRUE;
}

default
{
    state_entry()
    {
	_test_Result(FALSE);
        _test_Log(LOG_INFO, "Starting timer");
        llSetTimerEvent(0.5);
		Timer["Hello"].IsOneshot = TRUE;
		Timer["Hello2"].IsOneshot = TRUE;
		Timer["Hello"].Interval = 0.25;
		Timer["Hello2"].Interval = 0.25;
    }
    timer()
    {
        llSetTimerEvent(0);
        _test_Log(LOG_INFO, "Hello");
	_test_Result(timerseen);
	_test_Shutdown();
    }
}