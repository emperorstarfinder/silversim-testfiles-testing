//#!Mode:ASSL
//#!Enable:Testing

integer cnt;

default
{
    state_entry()
    {
        llSetTimerEvent(1);
        _test_Result(FALSE);
    }
    
    timer()
    {
        state test;
    }
    
}

state test
{
    state_entry()
    {
        cnt = 0;
        llSetTimerEvent(1);
        llListen(5, "", NULL_KEY, "");
        llSay(5, "Hello");
    }

    listen(integer channel, string name, key id, string data)
    {
        llSay(PUBLIC_CHANNEL, "Received: " + (string)id + ":" + data);
        ++cnt;
    }
    
    timer()
    {
        llSetTimerEvent(0);
        llSay(PUBLIC_CHANNEL, "Received cnt: " + (string)cnt);
        _test_Result(cnt == 1);
        _test_Shutdown();
    }
}