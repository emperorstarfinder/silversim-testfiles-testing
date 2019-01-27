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
        
        foreach(offsetv0 in offsetvs)
        {
            te[0].OffsetV = offsetv0;
            foreach(offsetv1 in offsetvs)
            {
                te[1].OffsetV = offsetv1;
                foreach(offsetv2 in offsetvs)
                {
                    te[2].OffsetV = offsetv2;
                    foreach(offsetv3 in offsetvs)
                    {
                        te[3].OffsetV = offsetv3;
                        foreach(offsetv4 in offsetvs)
                        {
                            te[4].OffsetV = offsetv4;
                            foreach(offsetv5 in offsetvs)
                            {
                                te[5].OffsetV = offsetv5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].OffsetV != te[0].OffsetV ||
                                    cmp[1].OffsetV != te[1].OffsetV ||
                                    cmp[2].OffsetV != te[2].OffsetV ||
                                    cmp[3].OffsetV != te[3].OffsetV ||
                                    cmp[4].OffsetV != te[4].OffsetV ||
                                    cmp[5].OffsetV != te[5].OffsetV)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].OffsetV + " cur=" + cmp[0].OffsetV);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].OffsetV + " cur=" + cmp[1].OffsetV);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].OffsetV + " cur=" + cmp[2].OffsetV);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].OffsetV + " cur=" + cmp[3].OffsetV);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].OffsetV + " cur=" + cmp[4].OffsetV);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].OffsetV + " cur=" + cmp[5].OffsetV);
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
