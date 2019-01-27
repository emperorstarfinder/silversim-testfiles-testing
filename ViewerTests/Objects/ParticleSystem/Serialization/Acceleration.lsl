//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list accelerations = [
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
        
        foreach(acceleration in accelerations)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + acceleration);
            ps.PartAcceleration = acceleration;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartAcceleration != ps.PartAcceleration)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartAcceleration + " cur=" + cmp.PartAcceleration);
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
