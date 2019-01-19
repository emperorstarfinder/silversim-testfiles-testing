//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list burstspeedmaxs = [
    1.0, 2.0];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(burstspeedmax in burstspeedmaxs)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + burstspeedmax);
            ps.BurstSpeedMax = burstspeedmax;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.BurstSpeedMax != ps.BurstSpeedMax)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.BurstSpeedMax + " cur=" + cmp.BurstSpeedMax);
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
