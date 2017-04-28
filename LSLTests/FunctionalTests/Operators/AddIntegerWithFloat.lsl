//#!Enable:Testing

default
{
    state_entry()
    {
        float f = 1 + 1.1;
    
        llSay(PUBLIC_CHANNEL, (string)f);
        
        _test_Result(f >= 2.0999 && f <= 2.1001);
        _test_Shutdown();
    }
}