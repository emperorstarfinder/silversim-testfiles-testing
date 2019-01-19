//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list fullbrights = [
    FALSE, TRUE];
    
default
{
	state_entry()
	{
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(fullbright in fullbrights)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + fullbright);
            
            te.Default.FullBright = !(integer)fullbright;
            te[0].FullBright = fullbright;
            te[1].FullBright = fullbright;
            te[2].FullBright = fullbright;
            te[3].FullBright = fullbright;
            te[4].FullBright = fullbright;
            te[5].FullBright = fullbright;
                                
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
            
            if(!cmp.Default.FullBright != !fullbright)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + fullbright + " cur=" + cmp.Default.FullBright);
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
