//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list burstspeedmins = [
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
        
        foreach(burstspeedmin in burstspeedmins)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + burstspeedmin);
            ps.BurstSpeedMin = burstspeedmin;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.BurstSpeedMin != ps.BurstSpeedMin)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.BurstSpeedMin + " cur=" + cmp.BurstSpeedMin);
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
