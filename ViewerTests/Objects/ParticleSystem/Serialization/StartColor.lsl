//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list colors = [
    <0,0,0>,<1,1,1>,<1,0,1>,<0,1,0>];
    
default
{
    state_entry()
    {
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(color in colors)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + color);
            ps.PartStartColor = color;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartStartColor != ps.PartStartColor)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartStartColor + " cur=" + cmp.PartStartColor);
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
