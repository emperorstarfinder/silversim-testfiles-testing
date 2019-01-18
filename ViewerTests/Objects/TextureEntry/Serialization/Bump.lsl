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
        
        foreach(bump0 in bumps)
        {
            te[0].Bump = bump0;
            foreach(bump1 in bumps)
            {
                te[1].Bump = bump1;
                foreach(bump2 in bumps)
                {
                    te[2].Bump = bump2;
                    foreach(bump3 in bumps)
                    {
                        te[3].Bump = bump3;
                        foreach(bump4 in bumps)
                        {
                            te[4].Bump = bump4;
                            foreach(bump5 in bumps)
                            {
                                te[5].Bump = bump5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].Bump != te[0].Bump ||
                                    cmp[1].Bump != te[1].Bump ||
                                    cmp[2].Bump != te[2].Bump ||
                                    cmp[3].Bump != te[3].Bump ||
                                    cmp[4].Bump != te[4].Bump ||
                                    cmp[5].Bump != te[5].Bump)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].Bump + " cur=" + cmp[0].Bump);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].Bump + " cur=" + cmp[1].Bump);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].Bump + " cur=" + cmp[2].Bump);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].Bump + " cur=" + cmp[3].Bump);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].Bump + " cur=" + cmp[4].Bump);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].Bump + " cur=" + cmp[5].Bump);
                                    result = FALSE;
                                    ++failcnt;
                                }
                                else
                                {
                                    ++successcnt;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        llSay(PUBLIC_CHANNEL, "Success Count: " + successcnt);
        llSay(PUBLIC_CHANNEL, "Fail Count: " + failcnt);
        _test_Result(result);
        
		_test_Shutdown();
	}
}
