//#!Enable:Testing

rotation r;

default
{
    state_entry()
    {
        rotation r;
        rotation t;
        integer i;
        _test_Result(FALSE);
        integer result = TRUE;
        
        for(i = 0; i < 360; ++i)
        {
            r = llEuler2Rot(<i, 0, 0>*DEG_TO_RAD);
            t = llEuler2Rot(<360-i, 0, 0>*DEG_TO_RAD);
            rotation norot = r * t;
            vector nrot = llRot2Euler(norot);
            if(llFabs(nrot.x) >= 0.000001 || llFabs(nrot.y) >= 0.000001 || llFabs(nrot.z) >= 0.000001)
            {
                llSay(PUBLIC_CHANNEL, "FAIL: x-rot-angle " + (string)i + " = " + (string)nrot);
                result = FALSE;
            }
        }
        
        for(i = 0; i < 360; ++i)
        {
            r = llEuler2Rot(<0, i, 0>*DEG_TO_RAD);
            t = llEuler2Rot(<0, 360-i, 0>*DEG_TO_RAD);
            rotation norot = r * t;
            vector nrot = llRot2Euler(norot);
            if(llFabs(nrot.x) >= 0.000001 || llFabs(nrot.y) >= 0.000001 || llFabs(nrot.z) >= 0.000001)
            {
                llSay(PUBLIC_CHANNEL, "FAIL: y-rot-angle " + (string)i + " = " + (string)nrot);
                result = FALSE;
            }
        }
        
        for(i = 0; i < 360; ++i)
        {
            r = llEuler2Rot(<0, 0, i>*DEG_TO_RAD);
            t = llEuler2Rot(<0, 0, 360-i>*DEG_TO_RAD);
            rotation norot = r * t;
            vector nrot = llRot2Euler(norot);
            if(llFabs(nrot.x) >= 0.000001 || llFabs(nrot.y) >= 0.000001 || llFabs(nrot.z) >= 0.000001)
            {
                llSay(PUBLIC_CHANNEL, "FAIL: z-rot-angle " + (string)i + " = " + (string)nrot);
                result = FALSE;
            }
        }
        
        _test_Result(result);
        _test_Shutdown();
    }
}