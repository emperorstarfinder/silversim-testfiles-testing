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
            te.Rate = value;

            textureanimationentry cmp;
            cmp.Bytes = te.Bytes;
            
            if(cmp.Rate != te.Rate)
            {
                llSay(PUBLIC_CHANNEL, "TEXANIM: exp=" + te.Rate + " cur=" + cmp.Rate);
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
