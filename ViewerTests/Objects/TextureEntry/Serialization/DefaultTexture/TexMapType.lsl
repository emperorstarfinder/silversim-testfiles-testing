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
        
        foreach(texgen in texgens)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + texgen);
        
            te.Default.TexMapType = 1 - (integer)texgen;
            te[0].TexMapType = texgen;
            te[1].TexMapType = texgen;
            te[2].TexMapType = texgen;
            te[3].TexMapType = texgen;
            te[4].TexMapType = texgen;
            te[5].TexMapType = texgen;

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
            
            if(cmp.Default.TexMapType != texgen)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + texgen + " cur=" + cmp.Default.TexMapType);
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
