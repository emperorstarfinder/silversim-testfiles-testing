//#!Mode:ASSL
//#!Enable:Testing
//#!Enable:VehicleTest
//#!Enable:Properties

vehicleinstance v;

default
{
    state_entry()
    {
        integer steps = 300;
        _test_Result(FALSE);
        integer x;
        integer result = TRUE;
        for(x = 0; x < 359; ++x)
        {
            v = VehicleInstance();
            v.VerticalAttractionEfficency = <1,0,1>;
            v.VerticalAttractionTimescale = <0.1,0.1,0.1>;
            v.ReferenceFrame = llEuler2Rot(<x,0,0>*DEG_TO_RAD);
            integer step;
            for(step = 0; step < steps; ++step)
            {
                v.Process(0.2);
            }
            for(step = 0; step < steps; ++step)
            {
                v.Process(0.2);
                vector check = llRot2Euler(v.Rotation / v.ReferenceFrame)*RAD_TO_DEG;
                if(llFabs(check.x) > 1 || llFabs(check.y) > 1 || llFabs(check.z) > 1)
                {
                    result = FALSE;
                    llSay(PUBLIC_CHANNEL, "=== starting at roll angle " + (string)x + " ===");
                    llSay(PUBLIC_CHANNEL, "algorithm did not stabilize to reference frame: " + (string)check);
                    break;
                }
            }
        }
        for(x = 0; x < 359; ++x)
        {
            v = VehicleInstance();
            v.VerticalAttractionEfficency = <0,1,1>;
            v.VerticalAttractionTimescale = <0.1,0.1,0.1>;
            v.ReferenceFrame = llEuler2Rot(<0,x,0>*DEG_TO_RAD);
            integer step;
            for(step = 0; step < steps; ++step)
            {
                v.Process(0.2);
            }
            for(step = 0; step < steps; ++step)
            {
                v.Process(0.2);
                vector check = llRot2Euler(v.Rotation / v.ReferenceFrame)*RAD_TO_DEG;
                if(llFabs(check.x) > 1 || llFabs(check.y) > 1 || llFabs(check.z) > 1)
                {
                    result = FALSE;
                    llSay(PUBLIC_CHANNEL, "=== starting at pitch angle " + (string)x + " ===");
                    llSay(PUBLIC_CHANNEL, "algorithm did not stabilize to reference frame: " + (string)check);
                    break;
                }
            }
        }
        _test_Result(result);
        _test_Shutdown();
    }
}