//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list textureids = [
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
        
        foreach(textureid0 in textureids)
        {
            te[0].TextureID = textureid0;
            foreach(textureid1 in textureids)
            {
                te[1].TextureID = textureid1;
                foreach(textureid2 in textureids)
                {
                    te[2].TextureID = textureid2;
                    foreach(textureid3 in textureids)
                    {
                        te[3].TextureID = textureid3;
                        foreach(textureid4 in textureids)
                        {
                            te[4].TextureID = textureid4;
                            foreach(textureid5 in textureids)
                            {
                                te[5].TextureID = textureid5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].TextureID != te[0].TextureID ||
                                    cmp[1].TextureID != te[1].TextureID ||
                                    cmp[2].TextureID != te[2].TextureID ||
                                    cmp[3].TextureID != te[3].TextureID ||
                                    cmp[4].TextureID != te[4].TextureID ||
                                    cmp[5].TextureID != te[5].TextureID)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].TextureID + " cur=" + cmp[0].TextureID);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].TextureID + " cur=" + cmp[1].TextureID);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].TextureID + " cur=" + cmp[2].TextureID);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].TextureID + " cur=" + cmp[3].TextureID);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].TextureID + " cur=" + cmp[4].TextureID);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].TextureID + " cur=" + cmp[5].TextureID);
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
