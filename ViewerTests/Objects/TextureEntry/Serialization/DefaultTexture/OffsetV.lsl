//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list offsetvs = [
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
        
        foreach(offsetv in offsetvs)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + offsetv);
        
            te.Default.OffsetV = 0 - (float)offsetv;
            te[0].OffsetV = offsetv;
            te[1].OffsetV = offsetv;
            te[2].OffsetV = offsetv;
            te[3].OffsetV = offsetv;
            te[4].OffsetV = offsetv;
            te[5].OffsetV = offsetv;

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
            
            if(cmp.Default.OffsetV != offsetv)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + offsetv + " cur=" + cmp.Default.OffsetV);
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
