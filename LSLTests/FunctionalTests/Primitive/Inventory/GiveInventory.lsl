//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        llSetTimerEvent(1);
        llListen(1, "", NULL_KEY, "");
        _test_Result(FALSE);
    }
    
    timer()
    {
		llSetTimerEvent(0);
        llSay(PUBLIC_CHANNEL, "Sending our notecard");
        llGiveInventory("11223344-1122-1122-1122-000000000001", "Notecard");
    }
    
    listen(integer channel, string name, key id, string data)
    {
        if(data == "Notecard")
        {
            llSay(PUBLIC_CHANNEL, "Receiver got our notecard");
            _test_Result(TRUE);
            _test_Shutdown();
        }
    }
}