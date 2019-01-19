//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list textureids = [
    TEXTURE_BLANK, TEXTURE_TRANSPARENT, TEXTURE_PLYWOOD, NULL_KEY];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(textureid in textureids)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + textureid);
            ps.TextureID = textureid;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.TextureID != ps.TextureID)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.TextureID + " cur=" + cmp.TextureID);
                result = FALSE;
                ++failcnt;
            }
            else
            {
                ++successcnt;
            }
        }
        
        llSay(PUBLIC_CHANNEL, "Success Count: " + successcnt);
        llSay(PUBLIC_CHANNEL, "Fail Count: " + failcnt);
        _test_Result(result);
        
		_test_Shutdown();
	}
}
