//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list blendfuncs = [
    PSYS_PART_BF_ONE, PSYS_PART_BF_ZERO, PSYS_PART_BF_DEST_COLOR, PSYS_PART_BF_SOURCE_COLOR, PSYS_PART_BF_ONE_MINUS_DEST_COLOR, PSYS_PART_BF_ONE_MINUS_SOURCE_COLOR, PSYS_PART_BF_SOURCE_ALPHA, PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA];
    
default
{
    state_entry()
    {
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(blendfunc in blendfuncs)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + blendfunc);
            ps.BlendFuncDest = blendfunc;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.BlendFuncDest != ps.BlendFuncDest)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.BlendFuncDest + " cur=" + cmp.BlendFuncDest);
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
