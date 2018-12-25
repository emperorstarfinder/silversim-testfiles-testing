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
        v = VehicleInstance();
        v.Buoyancy = 0;
        v.Process(0.2);
        if(v.Velocity.z > 0 || llFabs(v.Velocity.y) > 0.000001 || llFabs(v.Velocity.x) > 0.000001)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Buoyancy pushed in wrong direction " + (string)v.Velocity);
        }
        _test_Result(result);
        _test_Shutdown();
    }
}