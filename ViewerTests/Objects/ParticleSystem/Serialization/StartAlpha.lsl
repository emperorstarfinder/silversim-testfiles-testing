//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list alphas = [
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
        
        foreach(alpha in alphas)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + alpha);
            ps.PartStartAlpha = alpha;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartStartAlpha != ps.PartStartAlpha)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartStartAlpha + " cur=" + cmp.PartStartAlpha);
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
