//#!Enable:Testing

default
{
    state_entry()
    {
		llSay(PUBLIC_CHANNEL, llGetObjectDesc());
        _test_Result(llGetObjectDesc() == "Object Description");
        _test_Shutdown();
    }
}