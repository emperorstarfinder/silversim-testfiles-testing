//#!Enable:Testing

default
{
    state_entry()
    {
        _test_Result(llGetObjectName() == "Test Object");
        _test_Shutdown();
    }
}