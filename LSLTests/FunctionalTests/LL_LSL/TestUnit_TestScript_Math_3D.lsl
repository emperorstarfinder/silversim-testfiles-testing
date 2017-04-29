//#!Enable:Testing
//#!UsesSinglePrecision
///////////////////////////////////////////////////////////////////////////////////
/////// Script derived from TestUnit_TestScript_Math_3D.lsl
/////// http://wiki.secondlife.com/wiki/TestUnit_TestScript_Math_3D.lsl
///////
///////            TestUnit_TestScript
///////             
///////            Math_3D
///////
///////  This is the test script for the 3D math functions.  
///////      
///////              
//////////////////////////////////////////////////////////////////////////////////////    
 
integer llAngleBetweenPASS;            // 
integer llAxes2RotPASS;                //  
integer llAxisAngle2RotPASS;           //  These are global pass/fail
integer llEuler2RotPASS;               //  indicators for the various
integer llRot2EulerPASS;               //  Math 3D functions that are
integer llRotBetweenPASS;              //  being tested. These variables
integer llVecDistPASS;                 //  are used in the Run Test 
integer llVecMagPASS;                  //  and Report Functions of this 
integer llVecNormPASS;                 //  script.
 
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////
//////////      Function:   RunTest
//////////
//////////      Input:      no input parameters
//////////                    
//////////      Output:     link message on passFailChannel test status
//////////                    
//////////      Purpose:    This function is where you put the scripts that you want to test
//////////                  with this unit.
//////////                    
//////////      Issues:        no known issues 
//////////                    
//////////                    
/////////////////////////////////////////////////////////////////////////////////////////////////
RunTest()
{
 
     /////////////////////////////////////////////////////////////////
     // Function: float llAngleBetween( rotation a, rotation b ); 
     // Returns a float that is the angle between rotation a and b.
     // • rotation     a     –     start rotation     
     // • rotation     b     –     end rotation     
     /////////////////////////////////////////////////////////////////
    //initialize a pass variable to TRUE 
    llAngleBetweenPASS = 0;
 
     //compare two rotations with no angle in between
     if( (string)0.0 == (string)llAngleBetween( <0.0, 0.0, 0.0, 1.0>, <0.0, 0.0, 0.0, 1.0> ) &
            (string)2.094395 == (string)llAngleBetween( <1.0, 1.0, 1.0, 1.0>, <0.0, 0.0, 0.0, 1.0> ) &
            (string)2.094395 == (string)llAngleBetween( <0.0, 0.0, 0.0, 1.0>, <1.0, 1.0, 1.0, 1.0> ) )
     {
         llAngleBetweenPASS = 1;    
     }
 
     /////////////////////////////////////////////////////////////////////////
     // Function: rotation llAxes2Rot( vector fwd, vector left, vector up );
     // Returns a rotation that is defined by the 3 coordinate axes
     // • vector     fwd             
     // • vector     left             
     // • vector     up
     /////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llAxes2RotPASS = 0;
 
     //test four sets of vector configurations to hard-coded values
     if( (string)<1.00000, 0.00000, 0.00000, 0.00000> == (string)llAxes2Rot( <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0>) &
            (string)<0.00000, -0.3535534, 0.3535534, 0.7071068> == (string)llAxes2Rot( <1.0, 1.0, 1.0>, <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0>) &
            (string)<0.3535534, 0.00000, -0.3535534, 0.7071068> == (string)llAxes2Rot( <0.0, 0.0, 0.0>, <1.0, 1.0, 1.0>, <0.0, 0.0, 0.0>) &
            (string)<-0.3535534, 0.3535534, 0.00000, 0.7071068> == (string)llAxes2Rot( <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0>, <1.0, 1.0, 1.0>) )
     {
         llAxes2RotPASS = 1; 
     }
 
     /////////////////////////////////////////////////////////////////////////
     // Function: rotation llAxisAngle2Rot( vector axis, float angle );
     // Returns a rotation that is a generated angle about axis
     // • vector     axis             
     // • float     angle     –     expressed in radians.     
     /////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llAxisAngle2RotPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)<0.00000, 0.00000, 0.00000, 1.00000> == (string)llAxisAngle2Rot( < 0.0, 0.0, 0.0>, 0.0 ) &
            (string)<0.841471, 0.00000, 0.00000, 0.5403023> ==  (string)llAxisAngle2Rot( < 1.0, 0.0, 0.0>, 2.0 ) &
            (string)<0.2767965, 0.2767965, 0.2767965, 0.8775826> == (string)llAxisAngle2Rot( < 1.0, 1.0, 1.0>, 1.0 ) &
            (string)<0.00000, 0.00000, 0.4794255, 0.8775826> == (string)llAxisAngle2Rot( < 0.0, 0.0, 1.0>, 1.0 ) )
     {
         llAxisAngle2RotPASS = 1; 
     }
 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
     //////////////////////////////////////////////////////////////////////////////
     // Function: rotation llEuler2Rot( vector v );
     // Returns a rotation representation of Euler Angles v.
     // • vector     v         
     //////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llEuler2RotPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)<0.00000, 0.00000, 0.00000, 1.00000> == (string)llEuler2Rot( < 0.0, 0.0, 0.0> ) &
            (string)<0.4794255, 0.00000, 0.00000, 0.8775826> ==  (string)llEuler2Rot( < 1.0, 0.0, 0.0> ) &
            (string)<0.5709414, 0.1675188, 0.5709414, 0.5656758> == (string)llEuler2Rot( < 1.0, 1.0, 1.0> ) &
            (string)<0.00000, 0.00000, 0.4794255, 0.8775826> == (string)llEuler2Rot( < 0.0, 0.0, 1.0> ) )
     {
         llEuler2RotPASS = 1; 
     }
 
       ///////////////////////////////////////////////////////////////////////////////////    
       // Function: vector llRot2Euler( rotation quat );
       // Returns a vector that is the Euler representation (roll, pitch, yaw) of quat.
       // • rotation     quat     –     Any valid rotation     
       ///////////////////////////////////////////////////////////////////////////////////    
 
    //initialize a pass variable to TRUE 
    llRot2EulerPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)<0.00000, 0.00000, 0.00000> == (string)llRot2Euler( <0.00000, 0.00000, 0.00000, 1.00000> ) &
            (string)<1.575741, 0.1106669, -0.08921522> ==  (string)llRot2Euler( <1.00000, 0.10000, 0.01100, 1.00000> ) &
            (string)<-1.107149, 0.7297277, 2.034444> == (string)llRot2Euler( <0.00000, 1.00000, 1.00000, 1.00000> ) &
            (string)<0.00000, 1.570796, 1.570796> == (string)llRot2Euler( <1.00000, 1.00000, 1.00000, 1.00000> ) )
     {
         llRot2EulerPASS = 1; 
     }     
 
 
     /////////////////////////////////////////////////////////////////////////////////
     // Function: rotation llRotBetween( vector start, vector end );
     // Returns a rotation that is the rotation between start to end
     // • vector     start             
     // • vector     end
     /////////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llRotBetweenPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)<0.00000, 0.00000, 0.00000, 1.00000> == (string)llRotBetween( < 0.0, 0.0, 0.0>, < 0.0, 0.0, 0.0> ) &
            (string)<0.00000, 0.03531123, -0.7062246, 0.7071068> ==  (string)llRotBetween( < -10.0, 0.0, 0.0>, < 0.0, 10.0, 0.5> ) &
            (string)<0.627963, 0.627963, 0.00000, 0.4597009> == (string)llRotBetween( < 10.0, -10.0, 10.0>, < 0.0, 0.0, -1.0> ) &
            (string)<0.00000, -0.999688, 0.00000, 0.0249766> == (string)llRotBetween( < 0.0, 0.0, -10.0>, < 0.5, 0.0, 10.0> ) )
     {
         llRotBetweenPASS = 1; 
     }     
 
     /////////////////////////////////////////////////////////////////////////////////////////////////////
     // Function: float llVecDist( vector vec_a, vector vec_b );
     // Returns a float that is the distance between vec_a and vec_b (llVecMag(vec_a - vec_b)).
     // • vector     vec_a     –     Any valid vector     
     // • vector     vec_b     –     Any valid vector
     //////////////////////////////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llVecDistPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)0.0 == (string)llVecDist( < 0.0, 0.0, 0.0>, < 0.0, 0.0, 0.0> ) &
            (string)1.0 ==  (string)llVecDist( < 1.0, 0.0, 0.0>, < 0.0, 0.0, 0.0> ) &
            (string)1.732051 == (string)llVecDist( < 1.0, 1.0, 1.0>, < 0.0, 0.0, 0.0> ) &
            (string)1.0 == (string)llVecDist( < 0.0, 0.0, -1.0>, < 0.0, 0.0, 0.0> ) )
     {
         llVecDistPASS = 1; 
     }     
 
 
     //////////////////////////////////////////////////////////////////////////////////////////////////////
     // Function: float llVecMag( vector vec );
     // Returns a float that is the magnitude of the vector (the distance from vec to <0.0, 0.0, 0.0>).
     // • vector     vec             
     //////////////////////////////////////////////////////////////////////////////////////////////////////
 
 
    //initialize a pass variable to TRUE 
    llVecMagPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)0.0 == (string)llVecMag( < 0.0, 0.0, 0.0>) &
            (string)1.0 ==  (string)llVecMag( < 1.0, 0.0, 0.0>) &
            (string)1.732051 == (string)llVecMag( < 1.0, 1.0, 1.0> ) &
            (string)1.414214 == (string)llVecMag( < 1.0, 0.0, -1.0> ) )
     {
         llVecMagPASS = 1; 
     }     
 
 
     ///////////////////////////////////////////////////////////////////////////////
     // Function: vector llVecNorm( vector vec );
     // Returns a vector that is the normal of the vector (vec / llVecMag(vec)).
     // • vector     vec     –     Any valid vector     
     ///////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llVecNormPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)< 0.0, 0.0, 0.0> == (string)llVecNorm( < 0.0, 0.0, 0.0>) &
            (string)< 1.0, 0.0, 0.0> ==  (string)llVecNorm( < 1.0, 0.0, 0.0>) &
            (string)<0.5773503, 0.5773503, 0.5773503> == (string)llVecNorm( < 1.0, 1.0, 1.0> ) &
            (string)<0.7071068, 0.00000, -0.7071068> == (string)llVecNorm( < 1.0, 0.0, -1.0> ) )
     {
         llVecNormPASS = 1; 
     }         
 
 
     //multiple all of the individual pass variables together to check for any failures.
     integer pass = llAngleBetweenPASS *
     llAxes2RotPASS *
     llAxisAngle2RotPASS *
     llEuler2RotPASS *
     llRot2EulerPASS *
     llRotBetweenPASS *
     llVecDistPASS *
     llVecMagPASS *
     llVecNormPASS;
 
    _test_Result(pass);
}
 
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////
//////////      Function:   Report
//////////
//////////      Input:      broadcastChannel - chat channel to send report
//////////                  reportType - determines length and content of report type
//////////                                         -> NORMAL - failures and summary information
//////////                                         -> QUITE - summary information only
//////////                                         -> VERBOSE - everything
//////////                    
//////////      Output:     llSay on broadcastChannel 
//////////                    
//////////      Purpose:    This function is where you design the three level of reports
//////////                  available upon request by the Coordinator
//////////                    
//////////      Issues:        no known issues 
//////////                    
//////////                    
/////////////////////////////////////////////////////////////////////////////////////////////////
Report(  )
{
    //this string will be sent out regardless of reporting mode
    string reportString;
 
    // Initialize with FAIL
    string llAngleBetweenPASSstring = "FAIL";            
    string llAxes2RotPASSstring = "FAIL";
    string llAxisAngle2RotPASSstring = "FAIL";
    string llEuler2RotPASSstring = "FAIL";
    string llRot2EulerPASSstring = "FAIL";
    string llRotBetweenPASSstring = "FAIL";
    string llVecDistPASSstring = "FAIL";
    string llVecMagPASSstring = "FAIL";
    string llVecNormPASSstring = "FAIL";
 
    //translate integer conditional into text string for the report. 
    if ( llAngleBetweenPASS )
    {
          llAngleBetweenPASSstring = "PASS";
    }
    if ( llAxes2RotPASS )
    {
          llAxes2RotPASSstring = "PASS";
    }
    if ( llAxisAngle2RotPASS )
    {
        llAxisAngle2RotPASSstring = "PASS";
    }
    if ( llEuler2RotPASS)
    {
          llEuler2RotPASSstring = "PASS";
    }
    if ( llRot2EulerPASS )
    {
          llRot2EulerPASSstring = "PASS";
    }
    if ( llRotBetweenPASS )
    {
          llRotBetweenPASSstring = "PASS";
    }
    if ( llVecDistPASS )
    {
          llVecDistPASSstring = "PASS";
    }
    if ( llVecMagPASS )
    {
          llVecMagPASSstring = "PASS";
    }
    if ( llVecNormPASS )
    {
          llVecNormPASSstring = "PASS";
    }
 
    //Normal - moderate level of reporting
      reportString = "Function: float llAngleBetween( rotation a, rotation b ) -> " 
                                                + llAngleBetweenPASSstring + "\n"
                   + "Function: rotation llAxes2Rot( vector fwd, vector left, vector up) ->" 
                                                + llAxes2RotPASSstring + "\n"
                   + "Function: rotation llAxisAngle2Rot( vector axis, float angle ) -> " 
                                                + llAxisAngle2RotPASSstring + "\n"
                   + "Function: rotation llEuler2Rot( vector v ) -> " 
                                                + llEuler2RotPASSstring + "\n"
                   + "Function: vector llRot2Euler( rotation quat ) -> " 
                                                + llRot2EulerPASSstring + "\n"
                   + "Function: rotation llRotBetween( vector start, vector end ) -> "
                                                + llRotBetweenPASSstring + "\n"
                   + "Function: float llVecDist( vector vec_a, vector vec_b ) -> " 
                                                + llVecDistPASSstring + "\n"
                   + "Function: float llVecMag( vector vec ) -> " 
                                                + llVecMagPASSstring + "\n"
                   + "Function: vector llVecNorm( vector vec ) -> " 
                                                + llVecNormPASSstring + "\n";

    //AddUnitReport()
    //send to Coordinator on the broadcastChannel the selected report
    //format example -> AddUnitReport::unitKey::00000-0000-0000-00000::Report::Successful Completion of Test
    llSay( 0, reportString);
 
}
 
default
{
    state_entry()
    {
        RunTest();
        Report();
        _test_Shutdown();
    }
}