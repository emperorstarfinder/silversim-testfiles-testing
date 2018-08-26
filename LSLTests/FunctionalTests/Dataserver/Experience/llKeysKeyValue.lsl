//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        q = llKeysKeyValue(0, 1);
    }
    
    dataserver(key r, string data)
    {
        if(r != q)
        {
            llSay(PUBLIC_CHANNEL, "Invalid query response: " + r + "!=" + q);
            _test_Shutdown();
            return;
        }
    
        llSay(PUBLIC_CHANNEL, data);
        _test_Result(data=="0,14");
        _test_Shutdown();
    }
}
