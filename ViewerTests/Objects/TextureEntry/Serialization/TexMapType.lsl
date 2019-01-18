//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list texgens = [
    PRIM_TEXGEN_DEFAULT, PRIM_TEXGEN_PLANAR];
    
default
{
	state_entry()
	{
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(texgen0 in texgens)
        {
            te[0].TexMapType = texgen0;
            foreach(texgen1 in texgens)
            {
                te[1].TexMapType = texgen1;
                foreach(texgen2 in texgens)
                {
                    te[2].TexMapType = texgen2;
                    foreach(texgen3 in texgens)
                    {
                        te[3].TexMapType = texgen3;
                        foreach(texgen4 in texgens)
                        {
                            te[4].TexMapType = texgen4;
                            foreach(texgen5 in texgens)
                            {
                                te[5].TexMapType = texgen5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].TexMapType != te[0].TexMapType ||
                                    cmp[1].TexMapType != te[1].TexMapType ||
                                    cmp[2].TexMapType != te[2].TexMapType ||
                                    cmp[3].TexMapType != te[3].TexMapType ||
                                    cmp[4].TexMapType != te[4].TexMapType ||
                                    cmp[5].TexMapType != te[5].TexMapType)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].TexMapType + " cur=" + cmp[0].TexMapType);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].TexMapType + " cur=" + cmp[1].TexMapType);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].TexMapType + " cur=" + cmp[2].TexMapType);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].TexMapType + " cur=" + cmp[3].TexMapType);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].TexMapType + " cur=" + cmp[4].TexMapType);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].TexMapType + " cur=" + cmp[5].TexMapType);
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
