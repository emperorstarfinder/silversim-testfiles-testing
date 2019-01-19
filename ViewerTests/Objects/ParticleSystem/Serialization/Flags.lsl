//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list flags = [
    0, 1, 2, 3];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(flag in flags)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + flag);
            ps.Flags = flag;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.Flags != ps.Flags)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.Flags + " cur=" + cmp.Flags);
                result = FALSE;
                ++failcnt;
            }
            else
            {
                ++successcnt;
            }
        }
        
        llSay(PUBLIC_CHANNEL, "Success Count: " + successcnt);
        llSay(PUBLIC_CHANNEL, "Fail Count: " + failcnt);
        _test_Result(result);
        
		_test_Shutdown();
	}
}
