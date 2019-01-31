//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test llGetSimulatorHostname");
        string res = llGetSimulatorHostname();
        llSay(PUBLIC_CHANNEL, "Got " + res);
        _test_Result(res == "localhost");
        _test_Shutdown();
    }
}