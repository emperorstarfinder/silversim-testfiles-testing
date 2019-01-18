//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list repeatvs = [
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
        
        foreach(repeatv0 in repeatvs)
        {
            te[0].RepeatV = repeatv0;
            foreach(repeatv1 in repeatvs)
            {
                te[1].RepeatV = repeatv1;
                foreach(repeatv2 in repeatvs)
                {
                    te[2].RepeatV = repeatv2;
                    foreach(repeatv3 in repeatvs)
                    {
                        te[3].RepeatV = repeatv3;
                        foreach(repeatv4 in repeatvs)
                        {
                            te[4].RepeatV = repeatv4;
                            foreach(repeatv5 in repeatvs)
                            {
                                te[5].RepeatV = repeatv5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].RepeatV != te[0].RepeatV ||
                                    cmp[1].RepeatV != te[1].RepeatV ||
                                    cmp[2].RepeatV != te[2].RepeatV ||
                                    cmp[3].RepeatV != te[3].RepeatV ||
                                    cmp[4].RepeatV != te[4].RepeatV ||
                                    cmp[5].RepeatV != te[5].RepeatV)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].RepeatV + " cur=" + cmp[0].RepeatV);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].RepeatV + " cur=" + cmp[1].RepeatV);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].RepeatV + " cur=" + cmp[2].RepeatV);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].RepeatV + " cur=" + cmp[3].RepeatV);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].RepeatV + " cur=" + cmp[4].RepeatV);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].RepeatV + " cur=" + cmp[5].RepeatV);
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
