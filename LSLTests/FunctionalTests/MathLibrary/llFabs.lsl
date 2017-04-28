//#!Enable:Testing

default
{
    state_entry()
    {
        float frompos = llFabs(1);
        float fromneg = llFabs(-1);
    
        llSay(PUBLIC_CHANNEL, (string)frompos);
        llSay(PUBLIC_CHANNEL, (string)fromneg);
        
        _test_Result(frompos >= 0.9999 && frompos <= 1.0001 && fromneg >= 0.9999 && fromneg <= 1.0001);
        _test_Shutdown();
    }
}