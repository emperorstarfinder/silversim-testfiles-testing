//#!Enable:Testing

default
{
    state_entry()
    {
        float before;
        float after;
        
        llSleep(0.2);
        before = llGetAndResetTime();
        after = llGetTime();
    
        float diff = after - before;
        llSay(PUBLIC_CHANNEL, (string)diff);
        
        _test_Result(diff < 0 && before > 0.2);
        _test_Shutdown();
    }
}