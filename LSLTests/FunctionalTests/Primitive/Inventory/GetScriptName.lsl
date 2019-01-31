//#!Enable:Testing

default
{
    state_entry()
    {
        string res = llGetScriptName();
        llSay(PUBLIC_CHANNEL, "Got " + res);
        _test_Result(res == "Test Script");
        _test_Shutdown();
    }
}