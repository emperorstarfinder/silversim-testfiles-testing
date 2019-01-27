//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list mediaflags = [
    0, 1];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(mediaflag0 in mediaflags)
        {
            te[0].MediaFlags = mediaflag0;
            foreach(mediaflag1 in mediaflags)
            {
                te[1].MediaFlags = mediaflag1;
                foreach(mediaflag2 in mediaflags)
                {
                    te[2].MediaFlags = mediaflag2;
                    foreach(mediaflag3 in mediaflags)
                    {
                        te[3].MediaFlags = mediaflag3;
                        foreach(mediaflag4 in mediaflags)
                        {
                            te[4].MediaFlags = mediaflag4;
                            foreach(mediaflag5 in mediaflags)
                            {
                                te[5].MediaFlags = mediaflag5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].MediaFlags != te[0].MediaFlags ||
                                    cmp[1].MediaFlags != te[1].MediaFlags ||
                                    cmp[2].MediaFlags != te[2].MediaFlags ||
                                    cmp[3].MediaFlags != te[3].MediaFlags ||
                                    cmp[4].MediaFlags != te[4].MediaFlags ||
                                    cmp[5].MediaFlags != te[5].MediaFlags)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].MediaFlags + " cur=" + cmp[0].MediaFlags);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].MediaFlags + " cur=" + cmp[1].MediaFlags);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].MediaFlags + " cur=" + cmp[2].MediaFlags);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].MediaFlags + " cur=" + cmp[3].MediaFlags);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].MediaFlags + " cur=" + cmp[4].MediaFlags);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].MediaFlags + " cur=" + cmp[5].MediaFlags);
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
