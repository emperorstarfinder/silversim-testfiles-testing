//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list angularvelocities = [
    <0,0,0>,<1,1,1>,<-1,-1,-1>,<1,-1,1>,<-1,1,-1>];
    
default
{
    state_entry()
    {
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(angularvelocity in angularvelocities)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + angularvelocity);
            ps.AngularVelocity = angularvelocity;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.AngularVelocity != ps.AngularVelocity)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.AngularVelocity + " cur=" + cmp.AngularVelocity);
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
