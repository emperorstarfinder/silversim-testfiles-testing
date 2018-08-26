//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        q = llKeyCountKeyValue();
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
        _test_Result(data=="1,0");
        _test_Shutdown();
    }
}
