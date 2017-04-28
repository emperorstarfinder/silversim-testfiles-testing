//#!Enable:Testing

default
{
    state_entry()
    {
        float frompos = llFloor(1.5);
        float fromneg = llFloor(-1.5);
    
        llSay(PUBLIC_CHANNEL, (string)frompos);
        llSay(PUBLIC_CHANNEL, (string)fromneg);
        
        _test_Result(frompos >= 0.9999 && frompos <= 1.0001 && fromneg <= -1.9999 && fromneg >= -2.0001);
        _test_Shutdown();
    }
}