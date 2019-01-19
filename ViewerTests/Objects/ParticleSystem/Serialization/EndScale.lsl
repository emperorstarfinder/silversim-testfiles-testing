//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list scales = [
    <0,0,0>,<1,1,0>,<1,0,0>,<0,1,0>];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(scale in scales)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + scale);
            ps.PartEndScale = scale;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartEndScale != ps.PartEndScale)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartEndScale + " cur=" + cmp.PartEndScale);
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
