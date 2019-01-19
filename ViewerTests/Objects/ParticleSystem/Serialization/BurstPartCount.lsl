//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list burstpartcounts = [
    1, 2, 3, 4, 255];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(burstpartcount in burstpartcounts)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + burstpartcount);
            ps.BurstPartCount = burstpartcount;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.BurstPartCount != ps.BurstPartCount)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.BurstPartCount + " cur=" + cmp.BurstPartCount);
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
