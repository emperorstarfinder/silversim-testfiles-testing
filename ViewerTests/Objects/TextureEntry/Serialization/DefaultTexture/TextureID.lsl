//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list textureids = [
    TEXTURE_BLANK, TEXTURE_PLYWOOD, TEXTURE_TRANSPARENT];
    
default
{
	state_entry()
	{
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(textureid in textureids)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + textureid);
        
            te.Default.TextureID = TEXTURE_MEDIA;
            te[0].TextureID = textureid;
            te[1].TextureID = textureid;
            te[2].TextureID = textureid;
            te[3].TextureID = textureid;
            te[4].TextureID = textureid;
            te[5].TextureID = textureid;

            te.OptimizeDefault(6); 
            for(i = 0; i < 6; ++i)
            {
                if(te.ContainsKey(i))
                {
                    llSay(PUBLIC_CHANNEL, "TE[" + i + "]: Not optimized");
                    okay = FALSE;
                }
            }
            
            textureentry cmp;
            cmp.Bytes = te.Bytes;
            
            for(i = 0; i < 6; ++i)
            {
                if(cmp.ContainsKey(i))
                {
                    llSay(PUBLIC_CHANNEL, "TE[" + i + "]: Has non-default");
                    okay = FALSE;
                }
            }
            
            if(cmp.Default.TextureID != textureid)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + textureid + " cur=" + cmp.Default.TextureID);
                okay = FALSE;
            }
            
            if(!okay)
            {
                ++failcnt;
            }
            else
            {
                ++successcnt;
            }
            result=result&&okay;
        }
        
        llSay(PUBLIC_CHANNEL, "Success Count: " + successcnt);
        llSay(PUBLIC_CHANNEL, "Fail Count: " + failcnt);
        _test_Result(result);
        
		_test_Shutdown();
	}
}
