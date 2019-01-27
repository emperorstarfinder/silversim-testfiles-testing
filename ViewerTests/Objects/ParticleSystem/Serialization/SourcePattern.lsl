//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list sourcepatterns = [
    PSYS_SRC_PATTERN_EXPLODE, PSYS_SRC_PATTERN_ANGLE_CONE, PSYS_SRC_PATTERN_ANGLE, PSYS_SRC_PATTERN_DROP, PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY];
    
default
{
    state_entry()
    {
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(sourcepattern in sourcepatterns)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + sourcepattern);
            ps.SourcePattern = sourcepattern;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.SourcePattern != ps.SourcePattern)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.SourcePattern + " cur=" + cmp.SourcePattern);
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
