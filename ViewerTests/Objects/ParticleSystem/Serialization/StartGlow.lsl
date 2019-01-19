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
            ps.PartStartGlow = glow;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartStartGlow != ps.PartStartGlow)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartStartGlow + " cur=" + cmp.PartStartGlow);
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
