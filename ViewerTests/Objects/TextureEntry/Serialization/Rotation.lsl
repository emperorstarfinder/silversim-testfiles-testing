//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list rotations = [
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
        
        foreach(rotation0 in rotations)
        {
            te[0].Rotation = rotation0;
            foreach(rotation1 in rotations)
            {
                te[1].Rotation = rotation1;
                foreach(rotation2 in rotations)
                {
                    te[2].Rotation = rotation2;
                    foreach(rotation3 in rotations)
                    {
                        te[3].Rotation = rotation3;
                        foreach(rotation4 in rotations)
                        {
                            te[4].Rotation = rotation4;
                            foreach(rotation5 in rotations)
                            {
                                te[5].Rotation = rotation5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(llFabs(cmp[0].Rotation - te[0].Rotation) > 0.001 ||
                                    llFabs(cmp[1].Rotation - te[1].Rotation) > 0.001 ||
                                    llFabs(cmp[2].Rotation - te[2].Rotation) > 0.001 ||
                                    llFabs(cmp[3].Rotation - te[3].Rotation) > 0.001 ||
                                    llFabs(cmp[4].Rotation - te[4].Rotation) > 0.001 ||
                                    llFabs(cmp[5].Rotation - te[5].Rotation) > 0.001)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].Rotation + " cur=" + cmp[0].Rotation);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].Rotation + " cur=" + cmp[1].Rotation);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].Rotation + " cur=" + cmp[2].Rotation);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].Rotation + " cur=" + cmp[3].Rotation);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].Rotation + " cur=" + cmp[4].Rotation);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].Rotation + " cur=" + cmp[5].Rotation);
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
