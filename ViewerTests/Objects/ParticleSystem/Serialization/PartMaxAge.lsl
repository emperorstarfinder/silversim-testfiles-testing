//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list maxages = [
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
        
        foreach(maxage in maxages)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + maxage);
            ps.PartMaxAge = maxage;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartMaxAge != ps.PartMaxAge)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartMaxAge + " cur=" + cmp.PartMaxAge);
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
