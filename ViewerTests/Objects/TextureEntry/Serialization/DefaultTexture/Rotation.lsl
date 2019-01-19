//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list rotations = [
    0.0, 1.0];
    
default
{
	state_entry()
	{
        textureentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(rot in rotations)
        {
            integer i;
            integer okay = TRUE;
            
            llSay(PUBLIC_CHANNEL, "Testing " + rot);
        
            te.Default.Rotation = -1.0;
            te[0].Rotation = rot;
            te[1].Rotation = rot;
            te[2].Rotation = rot;
            te[3].Rotation = rot;
            te[4].Rotation = rot;
            te[5].Rotation = rot;

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
            
            if(llFabs(cmp.Default.Rotation - (float)rot) > 0.001)
            {
                llSay(PUBLIC_CHANNEL, "TE[Default]: exp=" + rot + " cur=" + cmp.Default.Rotation);
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
