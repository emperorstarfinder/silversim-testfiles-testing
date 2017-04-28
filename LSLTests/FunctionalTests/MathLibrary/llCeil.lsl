//#!Enable:Testing

default
{
    state_entry()
    {
        float frompos = llCeil(1.5);
        float fromneg = llCeil(-1.5);
    
        llSay(PUBLIC_CHANNEL, (string)frompos);
        llSay(PUBLIC_CHANNEL, (string)fromneg);
        
        _test_Result(frompos >= 1.9999 && frompos <= 2.0001 && fromneg <= -0.9999 && fromneg >= -1.0001);
        _test_Shutdown();
    }
}