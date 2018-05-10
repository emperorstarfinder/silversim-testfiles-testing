//#!Mode:ASSL
//#!Enable:Testing
//#!Enable:VehicleTest
//#!Enable:Properties

vehicleinstance v;

default
{
    state_entry()
    {
        integer steps = 1000;
        _test_Result(FALSE);
        integer step;
        llSay(PUBLIC_CHANNEL, "Determine whether default testing vehicle parameters are not affecting vehicle");
        for(step = 0; step < steps; ++step)
        {
            v.Process(0.01);
        }
        integer result = TRUE;
        if(llFabs(v.Position.x)>0.000001 || llFabs(v.Position.y)>0.000001 || llFabs(v.Position.z)>0.000001)
        {
            llSay(PUBLIC_CHANNEL, "Position is not stable " + (string)v.Position);
            result = FALSE;
        }
        if(llFabs(v.Rotation.x)>0.000001 || llFabs(v.Rotation.y)>0.000001 || llFabs(v.Rotation.z)>0.000001|| llFabs(v.Rotation.s - 1.0)>0.000001)
        {
            llSay(PUBLIC_CHANNEL, "Rotation is not stable " + (string)v.Rotation);
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}