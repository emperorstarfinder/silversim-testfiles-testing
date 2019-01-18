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
        
        foreach(shiny0 in shinys)
        {
            te[0].Shiny = shiny0;
            foreach(shiny1 in shinys)
            {
                te[1].Shiny = shiny1;
                foreach(shiny2 in shinys)
                {
                    te[2].Shiny = shiny2;
                    foreach(shiny3 in shinys)
                    {
                        te[3].Shiny = shiny3;
                        foreach(shiny4 in shinys)
                        {
                            te[4].Shiny = shiny4;
                            foreach(shiny5 in shinys)
                            {
                                te[5].Shiny = shiny5;
                                
                                textureentry cmp;
                                cmp.Bytes = te.Bytes;
                                
                                if(cmp[0].Shiny != te[0].Shiny ||
                                    cmp[1].Shiny != te[1].Shiny ||
                                    cmp[2].Shiny != te[2].Shiny ||
                                    cmp[3].Shiny != te[3].Shiny ||
                                    cmp[4].Shiny != te[4].Shiny ||
                                    cmp[5].Shiny != te[5].Shiny)
                                {
                                    llSay(PUBLIC_CHANNEL, "TE[0]: exp=" + te[0].Shiny + " cur=" + cmp[0].Shiny);
                                    llSay(PUBLIC_CHANNEL, "TE[1]: exp=" + te[1].Shiny + " cur=" + cmp[1].Shiny);
                                    llSay(PUBLIC_CHANNEL, "TE[2]: exp=" + te[2].Shiny + " cur=" + cmp[2].Shiny);
                                    llSay(PUBLIC_CHANNEL, "TE[3]: exp=" + te[3].Shiny + " cur=" + cmp[3].Shiny);
                                    llSay(PUBLIC_CHANNEL, "TE[4]: exp=" + te[4].Shiny + " cur=" + cmp[4].Shiny);
                                    llSay(PUBLIC_CHANNEL, "TE[5]: exp=" + te[5].Shiny + " cur=" + cmp[5].Shiny);
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
