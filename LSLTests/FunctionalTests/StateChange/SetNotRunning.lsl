//#!Enable:Testing

default
{
    state_entry()
    {
        _test_Result(FALSE);
        llSetScriptState(llGetScriptName(), FALSE);
        /* the event should continue after that */
        _test_Result(TRUE);
        _test_Shutdown();
    }
}
