//#!Mode:ASSL
//#!Enable:Testing

integer timercnt = 0;

timer(Hello) timerfunc()
{
	llSetTimerEvent(0);
	_test_Result(timercnt==1);
	_test_Shutdown();
}

default
{
    state_entry()
    {
		_test_Result(FALSE);
        _test_Log(LOG_INFO, "Starting timer");
		Timer["Hello"].IsOneshot = TRUE;
		Timer["Hello"].Interval = 1;
		Timer.IsOneshot = TRUE;
		Timer.Interval = 0.25;
    }
    timer()
    {
		++timercnt;
    }
}