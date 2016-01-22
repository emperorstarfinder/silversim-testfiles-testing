//#!Enable:Testing

integer cnt;

default
{
    state_entry()
    {
        cnt = 0;
        _test_Result(FALSE);
        state state1;
    }
    
    state_exit()
    {
        ++cnt;
    }
}

state state1
{
    state_entry()
    {
        state state2;
    }
    
    state_exit()
    {
        ++cnt;
    }
}

state state2
{
    state_entry()
    {
        _test_Result(cnt == 2);
        _test_Shutdown();
    }
}
    