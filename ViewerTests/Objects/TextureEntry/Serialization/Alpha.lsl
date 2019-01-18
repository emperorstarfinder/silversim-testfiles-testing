//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list alphas = [
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
        
        foreach(alpha0 in alphas)
        {
            te[0].TextureAlpha = alpha0;
            foreach(alpha1 in alphas)
            {
                te[1].TextureAlpha = alpha1;
                foreach(alpha2 in alphas)
                {
                    te[2].TextureAlpha = alpha2;
                    foreach(alpha3 in alphas)
                    {
                        te[3].TextureAlpha = alpha3;
                        foreach(alpha4 in alphas)
                        {
                            te[4].TextureAlpha = alpha4;
                            foreach(alpha5 in alphas)
                            {
                                te[5].TextureAlpha = alpha5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].TextureAlpha != te[0].TextureAlpha ||
                                    cmp[1].TextureAlpha != te[1].TextureAlpha ||
                                    cmp[2].TextureAlpha != te[2].TextureAlpha ||
                                    cmp[3].TextureAlpha != te[3].TextureAlpha ||
                                    cmp[4].TextureAlpha != te[4].TextureAlpha ||
                                    cmp[5].TextureAlpha != te[5].TextureAlpha)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].TextureAlpha + " cur=" + cmp[0].TextureAlpha);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].TextureAlpha + " cur=" + cmp[1].TextureAlpha);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].TextureAlpha + " cur=" + cmp[2].TextureAlpha);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].TextureAlpha + " cur=" + cmp[3].TextureAlpha);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].TextureAlpha + " cur=" + cmp[4].TextureAlpha);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].TextureAlpha + " cur=" + cmp[5].TextureAlpha);
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
