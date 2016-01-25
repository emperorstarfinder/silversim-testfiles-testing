//#!Enable:Testing

enterfunction(integer para)
{
    _test_Log(LOG_INFO, "Called user function");
    _test_Result(para);
}

default
{
    state_entry()
    {
        _test_Result(FALSE);
        _test_Log(LOG_INFO, "Calling user function");
        enterfunction(TRUE);
    }
}
