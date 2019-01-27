//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list offsetus = [
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
        
        foreach(offsetu0 in offsetus)
        {
            te[0].OffsetU = offsetu0;
            foreach(offsetu1 in offsetus)
            {
                te[1].OffsetU = offsetu1;
                foreach(offsetu2 in offsetus)
                {
                    te[2].OffsetU = offsetu2;
                    foreach(offsetu3 in offsetus)
                    {
                        te[3].OffsetU = offsetu3;
                        foreach(offsetu4 in offsetus)
                        {
                            te[4].OffsetU = offsetu4;
                            foreach(offsetu5 in offsetus)
                            {
                                te[5].OffsetU = offsetu5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].OffsetU != te[0].OffsetU ||
                                    cmp[1].OffsetU != te[1].OffsetU ||
                                    cmp[2].OffsetU != te[2].OffsetU ||
                                    cmp[3].OffsetU != te[3].OffsetU ||
                                    cmp[4].OffsetU != te[4].OffsetU ||
                                    cmp[5].OffsetU != te[5].OffsetU)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].OffsetU + " cur=" + cmp[0].OffsetU);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].OffsetU + " cur=" + cmp[1].OffsetU);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].OffsetU + " cur=" + cmp[2].OffsetU);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].OffsetU + " cur=" + cmp[3].OffsetU);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].OffsetU + " cur=" + cmp[4].OffsetU);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].OffsetU + " cur=" + cmp[5].OffsetU);
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
