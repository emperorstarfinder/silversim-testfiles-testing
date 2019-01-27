//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list targetids = [
    TEXTURE_BLANK, TEXTURE_TRANSPARENT, TEXTURE_PLYWOOD, NULL_KEY]; /* just some known values */
    
default
{
    state_entry()
    {
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(targetid in targetids)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + targetid);
            ps.TargetID = targetid;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.TargetID != ps.TargetID)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.TargetID + " cur=" + cmp.TargetID);
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
