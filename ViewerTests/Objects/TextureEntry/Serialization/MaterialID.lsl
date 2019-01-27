//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list materialids = [
    TEXTURE_BLANK, TEXTURE_PLYWOOD, TEXTURE_TRANSPARENT]; /* just some known values */
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(materialid0 in materialids)
        {
            te[0].MaterialID = materialid0;
            foreach(materialid1 in materialids)
            {
                te[1].MaterialID = materialid1;
                foreach(materialid2 in materialids)
                {
                    te[2].MaterialID = materialid2;
                    foreach(materialid3 in materialids)
                    {
                        te[3].MaterialID = materialid3;
                        foreach(materialid4 in materialids)
                        {
                            te[4].MaterialID = materialid4;
                            foreach(materialid5 in materialids)
                            {
                                te[5].MaterialID = materialid5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].MaterialID != te[0].MaterialID ||
                                    cmp[1].MaterialID != te[1].MaterialID ||
                                    cmp[2].MaterialID != te[2].MaterialID ||
                                    cmp[3].MaterialID != te[3].MaterialID ||
                                    cmp[4].MaterialID != te[4].MaterialID ||
                                    cmp[5].MaterialID != te[5].MaterialID)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].MaterialID + " cur=" + cmp[0].MaterialID);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].MaterialID + " cur=" + cmp[1].MaterialID);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].MaterialID + " cur=" + cmp[2].MaterialID);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].MaterialID + " cur=" + cmp[3].MaterialID);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].MaterialID + " cur=" + cmp[4].MaterialID);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].MaterialID + " cur=" + cmp[5].MaterialID);
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
