//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
		_test_Result(FALSE);
        _test_Log(LOG_INFO, "Starting timer");
        llSetTimerEvent(0.5);
    }
    timer()
    {
		integer result = TRUE;
        llSetTimerEvent(0);
        _test_Log(LOG_INFO, "Hello");
		if(!Timer.IsInEvent)
		{
			llSay(PUBLIC_CHANNEL, "Timer.IsInEvent not true");
			result = FALSE;
		}
		if(!Timer.Active.IsInEvent)
		{
			llSay(PUBLIC_CHANNEL, "Timer.Active.IsInEvent not true");
			result = FALSE;
		}
		string timerName = ActiveTimerName;
		if(timerName != "")
		{
			llSay(PUBLIC_CHANNEL, "ActiveTimerName not an empty string: \"" + timerName + "\"");
			result = FALSE;
		}
		if(!IsInTimerEvent)
		{
			llSay(PUBLIC_CHANNEL, "IsInTimerEvent not true");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
    }
}