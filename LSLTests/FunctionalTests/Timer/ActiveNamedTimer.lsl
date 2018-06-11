//#!Mode:ASSL
//#!Enable:Testing

integer timerseen = FALSE;
integer timer2seen = FALSE;
integer result = TRUE;

timer(Hello) timerfunc()
{
	llSay(PUBLIC_CHANNEL, "Timer Hello triggered");
	timerseen = TRUE;
	if(!Timer["Hello"].IsInEvent)
	{
		llSay(PUBLIC_CHANNEL, "Hello: Timer[\"Hello\"].IsInEvent not true");
		result = FALSE;
	}
	if(!Timer.Active.IsInEvent)
	{
		llSay(PUBLIC_CHANNEL, "Hello: Timer.Active.IsInEvent not true");
		result = FALSE;
	}
	string timerName = ActiveTimerName;
	if(timerName != "Hello")
	{
		llSay(PUBLIC_CHANNEL, "Hello: ActiveTimerName not \"Hello\": \"" + timerName + "\"");
		result = FALSE;
	}
	if(!IsInTimerEvent)
	{
		llSay(PUBLIC_CHANNEL, "Hello: IsInTimerEvent not true");
		result = FALSE;
	}
	llSay(PUBLIC_CHANNEL, "Timer Hello triggered done");
}

timer(Hello2) timerfunc()
{
	llSay(PUBLIC_CHANNEL, "Timer Hello2 triggered");
	timer2seen = TRUE;
	if(!Timer["Hello2"].IsInEvent)
	{
		llSay(PUBLIC_CHANNEL, "Hello2: Timer[\"Hello2\"].IsInEvent not true");
		result = FALSE;
	}
	if(!Timer.Active.IsInEvent)
	{
		llSay(PUBLIC_CHANNEL, "Hello2: Timer.Active.IsInEvent not true");
		result = FALSE;
	}
	string timerName = ActiveTimerName;
	if(timerName != "Hello2")
	{
		llSay(PUBLIC_CHANNEL, "Hello2: ActiveTimerName not \"Hello2\": \"" + timerName + "\"");
		result = FALSE;
	}
	if(!IsInTimerEvent)
	{
		llSay(PUBLIC_CHANNEL, "Hello2: IsInTimerEvent not true");
		result = FALSE;
	}
	llSay(PUBLIC_CHANNEL, "Timer Hello2 triggered done");
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
	_test_Result(timerseen && timer2seen && result);
	_test_Shutdown();
    }
}