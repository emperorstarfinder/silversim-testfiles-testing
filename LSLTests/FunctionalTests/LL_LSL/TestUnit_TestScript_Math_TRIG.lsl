//#!Enable:Testing
//#!UsesSinglePrecision
///////////////////////////////////////////////////////////////////////////////////
/////// Script derived from TestUnit_TestScript_Math_3D.lsl
/////// http://wiki.secondlife.com/wiki/TestUnit_TestScript_Math_TRIG.lsl
///////
///////            TestUnit_TestScript
///////             
///////            Math_TRIG
///////
///////  This is the test script for the trigonometry math functions.  
///////      
///////              
//////////////////////////////////////////////////////////////////////////////////////    
 
// Global Variables
 
integer llAcosPASS;                    // These are global pass/fail
integer llAsinPASS;                    // indicators for the various
integer llAtan2PASS;                   // Math trig functions that are 
integer llCosPASS;                     // being tested. These variables 
integer llSinPASS;                     // are used in the Run Test and
integer llTanPASS;                     // Report Functions of this script. 
 
 
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
 
     ///////////////////////////////////////////////////////////////////////////////////////////
     // Function: float llAcos( float val );
     // Returns a float that is the arccosine in radians of val
     // • float     val     –     val must fall in the range [-1.0, 1.0]. (-1.0 <= val <= 1.0)     
     ///////////////////////////////////////////////////////////////////////////////////////////
 
     //initialize a pass variable to TRUE 
     llAcosPASS = 0;
 
     //compare known cosine of some angles
     if( (string)3.141593 == (string)llAcos( -1.0 ) &
     		(string)1.570796 == (string)llAcos( 0.0 ) &
     		(string)0.0 == (string)llAcos( 1.0 ) )
     {
         llAcosPASS = 1;    
     }
 
     ///////////////////////////////////////////////////////////////////////////////////////
     // Function: float llAsin( float val );
     // Returns a float that is the arcsine in radians of val
     // • float     val     –     must fall in the range [-1.0, 1.0]. (-1.0 <= val <= 1.0)     
     ////////////////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llAsinPASS = 0;
 
     //test four sets of vector configurations to hard-coded values
     if( (string)-1.570796 == (string)llAsin( -1.0) &
     		(string)0.0 == (string)llAsin( 0.0 ) &
     		(string)1.570796 == (string)llAsin( 1.0 ) )
     {
         llAsinPASS = 1; 
     }
 
 
     /////////////////////////////////////////////////////////////////////////
     // Function: float llAtan2( float y, float x );
     // Returns a float that is the arctangent2 of y, x.
     // • float     y             
     // • float     x             
     // Similar to the arctangent(y/x) except it utilizes the signs of x & y to 
     // determine the quadrant. Returns zero if x and y are zero. 
     ////////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llAtan2PASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)0.0 == (string)llAtan2( 0.0, 0.0) &
     		(string)0.0 ==  (string)llAtan2( 0.0, 1.0 ) &
     		(string)0.7853982 == (string)llAtan2( 1.0, 1.0 ) )
     {
         llAtan2PASS = 1; 
     }
 
     //////////////////////////////////////////////////////////////////////////////
     // Function: float llCos( float theta );
     // Returns a float that is the cosine of theta.
     // • float     theta     –     angle expressed in radians.     
     /////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llCosPASS = 0;

     //test four sets of configurations to hard-coded values
     if( (string)1.0 == (string)llCos( 0.0 ) &
     		(string)0.5403023 ==  (string)llCos( 1.0 ) &
     		(string)0.5403023 == (string)llCos( -1.0 ) )
     {
         llCosPASS = 1; 
     }
 
       ///////////////////////////////////////////////////////////////////////////////////    
       // Function: float llSin( float theta );
       // Returns a float that is the sine of theta.
       // • float     theta     –     angle expressed in radians.     
       //////////////////////////////////////////////////////////////////////////////////   
 
    //initialize a pass variable to TRUE 
    llSinPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)0.0 == (string)llSin( 0.0 ) &
     		(string)0.841471 ==  (string)llSin( 1.0 ) &
     		(string)-0.841471 == (string)llSin( -1.0 ) )
     {
         llSinPASS = 1; 
     }   
 
 
     /////////////////////////////////////////////////////////////////////////////////
     // Function: float llTan( float theta );
     // Returns a float that is the tangent of theta.
     // • float     theta     –     angle expressed in radians.
     /////////////////////////////////////////////////////////////////////////////////
 
    //initialize a pass variable to TRUE 
    llTanPASS = 0;
 
     //test four sets of configurations to hard-coded values
     if( (string)0.0 == (string)llTan( 0.0 ) &
     		(string)1.557408 ==  (string)llTan( 1.0 ) &
     		(string)-1.557408 == (string)llTan( -1.0 ) )
     {
         llTanPASS = 1; 
     }
 
     //check to see if any failures occurred. 
     integer pass = llAcosPASS &
                    llAsinPASS &
                    llAtan2PASS &
                    llCosPASS &
                    llSinPASS &
                    llTanPASS;
 
     // if all of the individual 
     _test_Result( pass );
}
 
Report(  )
{
    //this string will be sent out regardless of reporting mode
    string reportString;
 
    // PASS or FAIL wording for the report
    string llAcosPASSstring = "FAIL";
    string llAsinPASSstring = "FAIL";
    string llAtan2PASSstring = "FAIL";
    string llCosPASSstring = "FAIL";
    string llSinPASSstring = "FAIL";
    string llTanPASSstring = "FAIL";
 
 
 
    //translate integer conditional into text string for the report. 
    if ( llAcosPASS )
    {
          llAcosPASSstring = "PASS";
    }
    if ( llAsinPASS )
    {
          llAsinPASSstring = "PASS";
    }
    if ( llAtan2PASS )
    {
          llAtan2PASSstring = "PASS";
    }
    if ( llCosPASS  )
    {
          llCosPASSstring = "PASS";
    }
    if ( llSinPASS )
    {
          llSinPASSstring = "PASS";
    }
    if ( llTanPASS )
    {
          llTanPASSstring = "PASS";
    }
 
      reportString = "Function: float llAcos( float val ) -> " 
                                                + llAcosPASSstring + "\n"
                   + "Function: float llAsin( float val ) ->" 
                                                + llAsinPASSstring + "\n"
                   + "Function: float llAtan2( float y, float x ) -> " 
                                                + llAtan2PASSstring + "\n"
                   + "Function: float llCos( float theta ) -> " 
                                                + llCosPASSstring + "\n"
                   + "Function: float llSin( float theta ) -> " 
                                                + llSinPASSstring + "\n"
                   + "Function: float llTan( float theta ) -> "
                                                + llTanPASSstring + "\n";
 
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
} // end default