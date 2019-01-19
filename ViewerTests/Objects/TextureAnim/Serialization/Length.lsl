//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list values = [
    1.0, 2.0, 4.0];
    
default
{
	state_entry()
	{
        textureanimationentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(value in values)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + value);
            te.Length = value;

            textureanimationentry cmp;
            cmp.Bytes = te.Bytes;
            
            if(cmp.Length != te.Length)
            {
                llSay(PUBLIC_CHANNEL, "TEXANIM: exp=" + te.Length + " cur=" + cmp.Length);
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
