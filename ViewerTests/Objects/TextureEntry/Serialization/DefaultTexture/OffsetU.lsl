//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list offsetus = [
    -1.0, 0.0, 1.0];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(offsetu in offsetus)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + offsetu);
        
            te.Default.OffsetU = 0 - (float)offsetu;
            te[0].OffsetU = offsetu;
            te[1].OffsetU = offsetu;
            te[2].OffsetU = offsetu;
            te[3].OffsetU = offsetu;
            te[4].OffsetU = offsetu;
            te[5].OffsetU = offsetu;

            te.OptimizeDefault(6); 
            for(i = 0; i < 6; ++i)
            {
                if(te.ContainsKey(i))
                {
                    llSay(PUBLIC_CHANNEL, "TE[" + i + "]: Not optimized");
                    okay = FALSE;
                }
            }
            
            textureentry cmp;
            cmp.Bytes = te.Bytes;
            
            for(i = 0; i < 6; ++i)
            {
                if(cmp.ContainsKey(i))
                {
                    llSay(PUBLIC_CHANNEL, "TE[" + i + "]: Has non-default");
                    okay = FALSE;
                }
            }
            
            if(cmp.Default.OffsetU != offsetu)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + offsetu + " cur=" + cmp.Default.OffsetU);
                okay = FALSE;
            }
            
            if(!okay)
            {
                ++failcnt;
            }
            else
            {
                ++successcnt;
            }
            result=result&&okay;
        }
        
        llSay(PUBLIC_CHANNEL, "Success Count: " + successcnt);
        llSay(PUBLIC_CHANNEL, "Fail Count: " + failcnt);
        _test_Result(result);
        
        _test_Shutdown();
    }
}
