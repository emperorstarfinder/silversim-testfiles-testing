//#!Mode:ASSL
//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        if(!_test_InjectScript("RemoteScript", "../tests/LSLTests/FunctionalTests/Primitive/Inventory/RemoteLoadScriptPin.Script.lsli", 0))
        {
            llSay(PUBLIC_CHANNEL, "Failed to inject script");
            _test_Shutdown();
        }
        llSetTimerEvent(1);
        llListen(5, "", NULL_KEY, "");
    }
    
    timer()
    {
        llSetTimerEvent(0);
		llSay(PUBLIC_CHANNEL, "Remote loading script");
        integer result = asRemoteLoadScriptPin("11223344-1122-1122-1122-000000000001", "RemoteScript", 10, TRUE, 5);
		llSay(PUBLIC_CHANNEL, "Remote Load Result: "+ (string)result);
		if(result != 0)
		{
			_test_Shutdown();
		}
    }
    
    listen(integer channel, string name, key id, string data)
    {
        if(id == "11223344-1122-1122-1122-000000000001")
        {
            llSay(PUBLIC_CHANNEL, "Other prim notified us");
            _test_Result(TRUE);
            _test_Shutdown();
        }
    }
}
