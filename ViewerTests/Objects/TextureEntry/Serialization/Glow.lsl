//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list glows = [
    0.0, 1.0];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(glow0 in glows)
        {
            te[0].Glow = glow0;
            foreach(glow1 in glows)
            {
                te[1].Glow = glow1;
                foreach(glow2 in glows)
                {
                    te[2].Glow = glow2;
                    foreach(glow3 in glows)
                    {
                        te[3].Glow = glow3;
                        foreach(glow4 in glows)
                        {
                            te[4].Glow = glow4;
                            foreach(glow5 in glows)
                            {
                                te[5].Glow = glow5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].Glow != te[0].Glow ||
                                    cmp[1].Glow != te[1].Glow ||
                                    cmp[2].Glow != te[2].Glow ||
                                    cmp[3].Glow != te[3].Glow ||
                                    cmp[4].Glow != te[4].Glow ||
                                    cmp[5].Glow != te[5].Glow)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].Glow + " cur=" + cmp[0].Glow);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].Glow + " cur=" + cmp[1].Glow);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].Glow + " cur=" + cmp[2].Glow);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].Glow + " cur=" + cmp[3].Glow);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].Glow + " cur=" + cmp[4].Glow);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].Glow + " cur=" + cmp[5].Glow);
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
