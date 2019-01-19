//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list flags = [
    0, ANIM_ON, LOOP, REVERSE, PING_PONG, SMOOTH, ROTATE, SCALE];
    
default
{
	state_entry()
	{
        textureanimationentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(flag in flags)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + flag);
            te.Flags = flag;

            textureanimationentry cmp;
            cmp.Bytes = te.Bytes;
            
            if(cmp.Flags != te.Flags)
            {
                llSay(PUBLIC_CHANNEL, "TEXANIM: exp=" + te.Flags + " cur=" + cmp.Flags);
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
