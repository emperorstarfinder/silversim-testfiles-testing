//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list shinys = [
    PRIM_SHINY_NONE, PRIM_SHINY_LOW, PRIM_SHINY_MEDIUM, PRIM_SHINY_HIGH];
    
default
{
	state_entry()
	{
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(shiny in shinys)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + shiny);
        
            te.Default.Shiny = 3 - (integer)shiny;
            te[0].Shiny = shiny;
            te[1].Shiny = shiny;
            te[2].Shiny = shiny;
            te[3].Shiny = shiny;
            te[4].Shiny = shiny;
            te[5].Shiny = shiny;

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
            
            if(cmp.Default.Shiny != shiny)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + shiny + " cur=" + cmp.Default.Shiny);
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
