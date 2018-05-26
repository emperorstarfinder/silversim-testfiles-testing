//#!Mode:ASSL
//#!Enable:testing


default
{
    state_entry()
    {
        integer i;
        _test_Result(FALSE);
        do 
	{
            llSay(PUBLIC_CHANNEL, i);
            continue;
        } while(i++ < 10);
        _test_Result(TRUE);
        _test_Shutdown();
    }
}