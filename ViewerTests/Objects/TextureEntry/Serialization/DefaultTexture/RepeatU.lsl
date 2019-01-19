//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list repeatus = [
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
        
        foreach(repeatu in repeatus)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + repeatu);
        
            te.Default.RepeatU = -(float)repeatu;
            te[0].RepeatU = repeatu;
            te[1].RepeatU = repeatu;
            te[2].RepeatU = repeatu;
            te[3].RepeatU = repeatu;
            te[4].RepeatU = repeatu;
            te[5].RepeatU = repeatu;

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
            
            if(cmp.Default.RepeatU != repeatu)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + repeatu + " cur=" + cmp.Default.RepeatU);
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
