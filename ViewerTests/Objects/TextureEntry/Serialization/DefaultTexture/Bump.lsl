//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list bumps = [
    PRIM_BUMP_NONE, PRIM_BUMP_WOOD, PRIM_BUMP_CONCRETE, PRIM_BUMP_WEAVE];
    
default
{
	state_entry()
	{
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(bump in bumps)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing bump " + i);
            te.Default.Bump = 3 - (integer)bump;
            te[0].Bump = bump;
            te[1].Bump = bump;
            te[2].Bump = bump;
            te[3].Bump = bump;
            te[4].Bump = bump;
            te[5].Bump = bump;
            
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
            
            if(cmp.Default.Bump != bump)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + bump + " cur=" + cmp.Default.Bump);
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
