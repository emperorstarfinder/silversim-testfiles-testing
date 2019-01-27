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
                                cmp.Bytes = te.GetBytesLimited(TRUE, 1.0);
                                
                                if(cmp[0].FullBright != FALSE ||
                                    cmp[1].FullBright != FALSE ||
                                    cmp[2].FullBright != FALSE ||
                                    cmp[3].FullBright != FALSE ||
                                    cmp[4].FullBright != FALSE ||
                                    cmp[5].FullBright != FALSE)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=0 cur=" + cmp[0].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=0 cur=" + cmp[1].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=0 cur=" + cmp[2].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=0 cur=" + cmp[3].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=0 cur=" + cmp[4].FullBright);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=0 cur=" + cmp[5].FullBright);
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
