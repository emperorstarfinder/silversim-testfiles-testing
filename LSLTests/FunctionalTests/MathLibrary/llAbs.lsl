//#!Enable:Testing

default
{
    state_entry()
    {
        integer frompos = llAbs(1);
        integer fromneg = llAbs(-1);
    
        llSay(PUBLIC_CHANNEL, (string)frompos);
        llSay(PUBLIC_CHANNEL, (string)fromneg);
        
        _test_Result(frompos == 1 && fromneg == 1);
        _test_Shutdown();
    }
}