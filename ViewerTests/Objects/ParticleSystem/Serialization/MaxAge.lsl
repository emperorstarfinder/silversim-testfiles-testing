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
            ps.MaxAge = maxage;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.MaxAge != ps.MaxAge)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.MaxAge + " cur=" + cmp.MaxAge);
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
