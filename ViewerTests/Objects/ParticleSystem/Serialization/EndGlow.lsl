//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list glows = [
    0.0, 1.0];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(glow in glows)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + glow);
            ps.PartEndGlow = glow;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartEndGlow != ps.PartEndGlow)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartEndGlow + " cur=" + cmp.PartEndGlow);
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
