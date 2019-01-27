//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list mediaflags = [
    0, 1];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(mediaflag in mediaflags)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + mediaflag);
        
            te.Default.MediaFlags = 1 - (integer)mediaflag;
            te[0].MediaFlags = mediaflag;
            te[1].MediaFlags = mediaflag;
            te[2].MediaFlags = mediaflag;
            te[3].MediaFlags = mediaflag;
            te[4].MediaFlags = mediaflag;
            te[5].MediaFlags = mediaflag;

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
            
            if(cmp.Default.MediaFlags != mediaflag)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + mediaflag + " cur=" + cmp.Default.MediaFlags);
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
