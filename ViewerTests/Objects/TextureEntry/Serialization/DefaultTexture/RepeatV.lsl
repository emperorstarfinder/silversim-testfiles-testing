//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list repeatvs = [
    -2.0, -1.0, 1.0, 2.0];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(repeatv in repeatvs)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + repeatv);
        
            te.Default.RepeatV = -(float)repeatv;
            te[0].RepeatV = repeatv;
            te[1].RepeatV = repeatv;
            te[2].RepeatV = repeatv;
            te[3].RepeatV = repeatv;
            te[4].RepeatV = repeatv;
            te[5].RepeatV = repeatv;

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
            
            if(cmp.Default.RepeatV != repeatv)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + repeatv + " cur=" + cmp.Default.RepeatV);
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
