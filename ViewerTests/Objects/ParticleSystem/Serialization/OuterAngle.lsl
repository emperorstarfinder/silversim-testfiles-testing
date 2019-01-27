//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list outerangles = [
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
        
        foreach(outerangle in outerangles)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + outerangle);
            ps.OuterAngle = outerangle;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.OuterAngle != ps.OuterAngle)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.OuterAngle + " cur=" + cmp.OuterAngle);
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
