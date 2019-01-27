//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list colors = [
    <0, 0, 0>, <1, 1, 1>, <1, 0, 1>, <0, 1, 0>];
    
default
{
    state_entry()
    {
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(color0 in colors)
        {
            te[0].TextureColor = color0;
            foreach(color1 in colors)
            {
                te[1].TextureColor = color1;
                foreach(color2 in colors)
                {
                    te[2].TextureColor = color2;
                    foreach(color3 in colors)
                    {
                        te[3].TextureColor = color3;
                        foreach(color4 in colors)
                        {
                            te[4].TextureColor = color4;
                            foreach(color5 in colors)
                            {
                                te[5].TextureColor = color5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].TextureColor != te[0].TextureColor ||
                                    cmp[1].TextureColor != te[1].TextureColor ||
                                    cmp[2].TextureColor != te[2].TextureColor ||
                                    cmp[3].TextureColor != te[3].TextureColor ||
                                    cmp[4].TextureColor != te[4].TextureColor ||
                                    cmp[5].TextureColor != te[5].TextureColor)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].TextureColor + " cur=" + cmp[0].TextureColor);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].TextureColor + " cur=" + cmp[1].TextureColor);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].TextureColor + " cur=" + cmp[2].TextureColor);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].TextureColor + " cur=" + cmp[3].TextureColor);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].TextureColor + " cur=" + cmp[4].TextureColor);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].TextureColor + " cur=" + cmp[5].TextureColor);
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
