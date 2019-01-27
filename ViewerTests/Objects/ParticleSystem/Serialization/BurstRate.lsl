//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list burstrates = [
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
        
        foreach(burstrate in burstrates)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + burstrate);
            ps.BurstRate = burstrate;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.BurstRate != ps.BurstRate)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.BurstRate + " cur=" + cmp.BurstRate);
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
