//#!Mode:ASSL
//#!Enable:testing


default
{
    state_entry()
    {
        integer i;
        _test_Result(FALSE);
        for(i = 0; i < 10; ++i)
        {
            llSay(PUBLIC_CHANNEL, i);
            continue;
        }
        _test_Result(TRUE);
        _test_Shutdown();
    }
}