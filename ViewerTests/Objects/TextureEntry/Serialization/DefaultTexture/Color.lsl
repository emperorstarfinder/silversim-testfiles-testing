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
        
        foreach(color in colors)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + color);
            vector tcolor = color;
            te.Default.TextureColor = <1 - tcolor.x, 1 - tcolor.y, 1 - tcolor.z>;
            te[0].TextureColor = tcolor;
            te[1].TextureColor = tcolor;
            te[2].TextureColor = tcolor;
            te[3].TextureColor = tcolor;
            te[4].TextureColor = tcolor;
            te[5].TextureColor = tcolor;
            
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
            
            if(cmp.Default.TextureColor != tcolor)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + tcolor + " cur=" + cmp.Default.TextureColor);
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
