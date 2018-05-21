//#!Enable:Testing

rotation r;

default
{
    state_entry()
    {
        rotation r;
        integer i;
        _test_Result(FALSE);
        integer result = TRUE;
        
        for(i = 0; i < 360; ++i)
        {
            r = llEuler2Rot(<i, i, i>*DEG_TO_RAD);
            rotation t = r;
            rotation norot = r / t;
            if(llFabs(norot.x) >= 0.000001 || llFabs(norot.y) >= 0.000001 || llFabs(norot.z) >= 0.000001 || llFabs(norot.s - 1) >= 0.000001)
            {
                llSay(PUBLIC_CHANNEL, "FAIL: rot-angle " + (string)i);
                result = FALSE;
            }
        }
        
        _test_Result(result);
        _test_Shutdown();
    }
}