//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list alphas = [
    0.0, 1.0];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(alpha in alphas)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + alpha);
            te.Default.TextureAlpha = 1.0 - (float)alpha;
            te[0].TextureAlpha = alpha;
            te[1].TextureAlpha = alpha;
            te[2].TextureAlpha = alpha;
            te[3].TextureAlpha = alpha;
            te[4].TextureAlpha = alpha;
            te[5].TextureAlpha = alpha;
            
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
            
            if(cmp.Default.TextureAlpha != alpha)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + alpha + " cur=" + cmp.Default.TextureAlpha);
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
