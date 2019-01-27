//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list materialids = [
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
        
        foreach(materialid in materialids)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + materialid);
        
            te.Default.MaterialID = TEXTURE_MEDIA;
            te[0].MaterialID = materialid;
            te[1].MaterialID = materialid;
            te[2].MaterialID = materialid;
            te[3].MaterialID = materialid;
            te[4].MaterialID = materialid;
            te[5].MaterialID = materialid;

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
            
            if(cmp.Default.MaterialID != materialid)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + materialid + " cur=" + cmp.Default.MaterialID);
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
