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
        
        foreach(repeatu0 in repeatus)
        {
            te[0].RepeatU = repeatu0;
            foreach(repeatu1 in repeatus)
            {
                te[1].RepeatU = repeatu1;
                foreach(repeatu2 in repeatus)
                {
                    te[2].RepeatU = repeatu2;
                    foreach(repeatu3 in repeatus)
                    {
                        te[3].RepeatU = repeatu3;
                        foreach(repeatu4 in repeatus)
                        {
                            te[4].RepeatU = repeatu4;
                            foreach(repeatu5 in repeatus)
                            {
                                te[5].RepeatU = repeatu5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].RepeatU != te[0].RepeatU ||
                                    cmp[1].RepeatU != te[1].RepeatU ||
                                    cmp[2].RepeatU != te[2].RepeatU ||
                                    cmp[3].RepeatU != te[3].RepeatU ||
                                    cmp[4].RepeatU != te[4].RepeatU ||
                                    cmp[5].RepeatU != te[5].RepeatU)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].RepeatU + " cur=" + cmp[0].RepeatU);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].RepeatU + " cur=" + cmp[1].RepeatU);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].RepeatU + " cur=" + cmp[2].RepeatU);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].RepeatU + " cur=" + cmp[3].RepeatU);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].RepeatU + " cur=" + cmp[4].RepeatU);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].RepeatU + " cur=" + cmp[5].RepeatU);
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
