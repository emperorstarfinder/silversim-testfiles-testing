//#!Enable:Testing

default
{
    state_entry()
    {
        float before;
        float after;
        
        before = llGetTime();
        llSleep(0.2);
        after = llGetTime();
        float exectime = after - before;
        llSay(PUBLIC_CHANNEL, (string)exectime);
        
        _test_Result(exectime > 0.19 && exectime < 0.21);
        _test_Shutdown();
    }
}