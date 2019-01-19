//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list innerangles = [
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
        
        foreach(innerangle in innerangles)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + innerangle);
            ps.InnerAngle = innerangle;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.InnerAngle != ps.InnerAngle)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.InnerAngle + " cur=" + cmp.InnerAngle);
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
