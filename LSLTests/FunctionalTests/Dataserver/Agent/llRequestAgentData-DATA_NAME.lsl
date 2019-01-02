//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        q = llRequestAgentData(llGetOwner(), DATA_NAME);
        llSay(PUBLIC_CHANNEL, "Query " + (string)q);
    }
    
    dataserver(key r, string data)
    {
        if(r != q)
        {
            llSay(PUBLIC_CHANNEL, "Invalid query response: " + r + "!=" + q);
        }
        else
        {
            llSay(PUBLIC_CHANNEL, data);
            _test_Result(data == "Script.Test @localhost:9300");
        }
        _test_Shutdown();
    }
}
