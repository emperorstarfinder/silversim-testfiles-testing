//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list sizes = [
    1, 2, 3, 4, 5, 6, 7, 10, 255];
    
default
{
	state_entry()
	{
        textureanimationentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(size in sizes)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + size);
            te.SizeY = size;

            textureanimationentry cmp;
            cmp.Bytes = te.Bytes;
            
            if(cmp.SizeY != te.SizeY)
            {
                llSay(PUBLIC_CHANNEL, "TEXANIM: exp=" + te.SizeY + " cur=" + cmp.SizeY);
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
