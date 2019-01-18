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
        
        foreach(fullbright0 in fullbrights)
        {
            te[0].FullBright = fullbright0;
            foreach(fullbright1 in fullbrights)
            {
                te[1].FullBright = fullbright1;
                foreach(fullbright2 in fullbrights)
                {
                    te[2].FullBright = fullbright2;
                    foreach(fullbright3 in fullbrights)
                    {
                        te[3].FullBright = fullbright3;
                        foreach(fullbright4 in fullbrights)
                        {
                            te[4].FullBright = fullbright4;
                            foreach(fullbright5 in fullbrights)
                            {
                                te[5].FullBright = fullbright5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].FullBright != te[0].FullBright ||
                                    cmp[1].FullBright != te[1].FullBright ||
                                    cmp[2].FullBright != te[2].FullBright ||
                                    cmp[3].FullBright != te[3].FullBright ||
                                    cmp[4].FullBright != te[4].FullBright ||
                                    cmp[5].FullBright != te[5].FullBright)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].FullBright + " cur=" + cmp[0].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].FullBright + " cur=" + cmp[1].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].FullBright + " cur=" + cmp[2].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].FullBright + " cur=" + cmp[3].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].FullBright + " cur=" + cmp[4].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].FullBright + " cur=" + cmp[5].FullBright);
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
