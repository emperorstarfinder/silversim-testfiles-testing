//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list faces = [
    ALL_SIDES, 0, 1, 2, 3, 4, 5, 6, 7];
    
default
{
    state_entry()
    {
        textureanimationentry te;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(face in faces)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + face);
            te.Face = face;

            textureanimationentry cmp;
            cmp.Bytes = te.Bytes;
            
            if(cmp.Face != te.Face)
            {
                llSay(PUBLIC_CHANNEL, "TEXANIM: exp=" + te.Face + " cur=" + cmp.Face);
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
