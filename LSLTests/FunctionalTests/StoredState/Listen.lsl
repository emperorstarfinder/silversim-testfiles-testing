//#!Enable:testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
	
	on_rez(integer start_param)
	{
        integer hnd2 = llListen(2, "", NULL_KEY, "");
        integer hnd3 = llListen(3, "", NULL_KEY, "");
        integer hnd1 = llListen(1, "", NULL_KEY, "");
        integer hnd0 = llListen(0, "", NULL_KEY, "");
        integer result = TRUE;
        if(hnd0 != 0)
        {
            llSay(PUBLIC_CHANNEL, "Listener for channel 0 not correctly deserialized");
            result = FALSE;
        }
        if(hnd1 != 1)
        {
            llSay(PUBLIC_CHANNEL, "Listener for channel 1 not correctly deserialized");
            result = FALSE;
        }
        if(hnd2 != 2)
        {
            llSay(PUBLIC_CHANNEL, "Listener for channel 2 not created after deserialized handles");
            result = FALSE;
        }
        if(hnd3 != 3)
        {
            llSay(PUBLIC_CHANNEL, "Listener for channel 3 not created after deserialized handles");
            result = FALSE;
        }
        
		_test_Result(result);
		_test_Shutdown();
	}
}