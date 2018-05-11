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
        for(x = 0; x < 179; ++x)
        {
            v = VehicleInstance();
            v.VerticalAttractionEfficency = <1,1,1>;
            v.VerticalAttractionTimescale = <1,1,1>;
            v.Rotation = llEuler2Rot(<x,0,0>*DEG_TO_RAD);
            v.Process(0.2);
            if(v.AngularVelocity.x > 0)
            {
                result = FALSE;
                llSay(PUBLIC_CHANNEL, "=== starting at angle " + (string)x + " ===");
                llSay(PUBLIC_CHANNEL, "vertical attraction went wrong direction");
                break;
            }
        }
        for(x = 181; x < 360; ++x)
        {
            v = VehicleInstance();
            v.Rotation = llEuler2Rot(<x,0,0>*DEG_TO_RAD);
            v.Process(0.2);
            if(v.AngularVelocity.x < 0)
            {
                result = FALSE;
                llSay(PUBLIC_CHANNEL, "=== starting at angle " + (string)x + " ===");
                llSay(PUBLIC_CHANNEL, "vertical attraction went wrong direction");
                break;
            }
        }
        _test_Result(result);
        _test_Shutdown();
    }
}