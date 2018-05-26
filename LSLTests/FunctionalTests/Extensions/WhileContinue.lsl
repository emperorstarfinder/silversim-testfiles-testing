//#!Mode:ASSL
//#!Enable:testing


default
{
    state_entry()
    {
        integer i;
        _test_Result(FALSE);
	while(i++ < 10)
        {
            llSay(PUBLIC_CHANNEL, i);
            continue;
        }
        _test_Result(TRUE);
        _test_Shutdown();
    }
}