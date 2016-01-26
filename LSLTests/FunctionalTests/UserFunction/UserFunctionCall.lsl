//#!Enable:Testing

integer val;

enterfunction(integer para)
{
    _test_Log(LOG_INFO, "Called user function");
    val = para;
}

default
{
    state_entry()
    {
	val = FALSE;
        _test_Result(FALSE);
        _test_Log(LOG_INFO, "Calling user function");
        enterfunction(TRUE);
	_test_Result(val);
	_test_Shutdown();
    }
}
