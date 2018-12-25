//#!Mode:ASSL
//#!Enable:Testing
//#!Enable:VehicleTest
//#!Enable:Properties

vehicleinstance v;

list referenceframes = [<0,0,0>,<90,0,0>,<0,90,0>,<90,90,0>,<0,0,90>];

default
{
    state_entry()
    {
        _test_Result(FALSE);
        integer result = TRUE;
	
        foreach(referenceframe in referenceframes)
        {
            v = VehicleInstance();
            vector ref = referenceframe;
            v.Rotation = llEuler2Rot(ref*DEG_TO_RAD);
            v.ReferenceFrame = v.Rotation;
            v.LinearMotorDecayTimescale = <1,1,1>;
            v.LinearMotorTimescale = <1,1,1>;
            v.Buoyancy = 0.0;
            v.LinearMotorDirection = <10,0,0>;
            llSay(PUBLIC_CHANNEL, v.LinearForce);
            v.Process(0.2);
            vector dir = v.LinearForce;
            if(dir.x < 0 || llFabs(dir.y) > 0.000001 || llFabs(dir.z) > 0.000001)
            {
                result = FALSE;
                llSay(PUBLIC_CHANNEL, "failed at " + (string)ref + " => " + (string)dir);
            }
        }
        _test_Result(result);
        _test_Shutdown();
    }
}