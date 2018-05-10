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
        integer result = TRUE;
        integer step;
    
        llSay(PUBLIC_CHANNEL, "Determine whether default testing vehicle parameters are not affecting vehicle");
        
        integer x;
        integer y;
        integer z;
        for(x = 0; x < 4; ++x)
        {
            for(y = 0; y < 4; ++y)
            {
                for(z = 0; z < 4; ++z)
                {
                    vector orientation = <x, y, z>*90;
                    llSay(PUBLIC_CHANNEL, "=== testing " + (string)orientation);
                    v = VehicleInstance();
                    v.ReferenceFrame = llEuler2Rot(orientation*DEG_TO_RAD);
                    v.Rotation = llEuler2Rot(orientation*DEG_TO_RAD);
                    for(step = 0; step < steps; ++step)
                    {
                        v.Process(0.01);
                    }
                    if(llFabs(v.Position.x)>0.000001 || llFabs(v.Position.y)>0.000001 || llFabs(v.Position.z)>0.000001)
                    {
                        llSay(PUBLIC_CHANNEL, "Position is not stable " + (string)v.Position);
                        llSay(PUBLIC_CHANNEL, "LinearMotorForce = " + (string)v.LinearMotorForce);
                        llSay(PUBLIC_CHANNEL, "HoverMotorForce = " + (string)v.HoverMotorForce);
                        llSay(PUBLIC_CHANNEL, "LinearFrictionForce = " + (string)v.LinearFrictionForce);
                        llSay(PUBLIC_CHANNEL, "LinearWindForce = " + (string)v.LinearWindForce);
                        llSay(PUBLIC_CHANNEL, "LinearCurrentForce = " + (string)v.LinearCurrentForce);
                        llSay(PUBLIC_CHANNEL, "LinearDeflectionForce = " + (string)v.LinearDeflectionForce);
                        result = FALSE;
                    }
                    orientation = llRot2Euler(v.Rotation)*RAD_TO_DEG;
                    if(llFabs(orientation.x-orientation.x)>1 || llFabs(orientation.y-orientation.y)>1 || llFabs(orientation.z-orientation.z)>1)
                    {
                        llSay(PUBLIC_CHANNEL, "Rotation is not stable " + (string)orientation);
                        llSay(PUBLIC_CHANNEL, "AngularMotorTorque = " + (string)v.AngularMotorTorque);
                        llSay(PUBLIC_CHANNEL, "WorldZTorque = " + (string)v.WorldZTorque);
                        llSay(PUBLIC_CHANNEL, "AngularFrictionTorque = " + (string)v.AngularFrictionTorque);
                        llSay(PUBLIC_CHANNEL, "VerticalAttractorTorque = " + (string)v.VerticalAttractorTorque);
                        llSay(PUBLIC_CHANNEL, "AngularWindTorque = = " + (string)v.AngularWindTorque);
                        llSay(PUBLIC_CHANNEL, "AngularCurrentTorque = " + (string)v.AngularCurrentTorque);
                        llSay(PUBLIC_CHANNEL, "BankingTorque = " + (string)v.BankingTorque);
                        llSay(PUBLIC_CHANNEL, "AngularDeflectionTorque = " + (string)v.AngularDeflectionTorque);
                        result = FALSE;
                    }
                }
            }
        }
        _test_Result(result);
        _test_Shutdown();
    }
}