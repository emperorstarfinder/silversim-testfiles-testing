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
        v.VerticalAttractionEfficency = <1,1,1>;
        v.VerticalAttractionTimescale = <1,1,1>;
        integer x;
        integer result = TRUE;
        for(x = 0; x < 359; ++x)
        {
            v = VehicleInstance();
            v.Rotation = llEuler2Rot(<x,0,0>*DEG_TO_RAD);
            integer step;
            for(step = 0; step < steps; ++step)
            {
                v.Process(0.2);
                vector orientation = llRot2Euler(v.Rotation)*RAD_TO_DEG;
                if(llFabs(orientation.y) > 0.000001 && llFabs(orientation.z) > 0.000001)
                {
                    result = FALSE;
                    llSay(PUBLIC_CHANNEL, "=== starting at angle " + (string)x + " ===");
                    llSay(PUBLIC_CHANNEL, "converging to roll = 0 should not produce angular movement on pitch or yaw: " + (string)orientation);
                    break;
                }
            }
            for(step = 0; step < steps; ++step)
            {
                v.Process(0.2);
                vector orientation = llRot2Euler(v.Rotation)*RAD_TO_DEG;
                if(llFabs(orientation.x) > 1 && llFabs(orientation.y) > 0.000001 && llFabs(orientation.z) > 0.000001)
                {
                    result = FALSE;
                    llSay(PUBLIC_CHANNEL, "=== starting at angle " + (string)x + " ===");
                    llSay(PUBLIC_CHANNEL, "algorithm did not stabilize to roll = 0: " + (string)orientation);
                    break;
                }
            }
        }
        llSay(0, (string)result);
        _test_Result(result);
        _test_Shutdown();
    }
}