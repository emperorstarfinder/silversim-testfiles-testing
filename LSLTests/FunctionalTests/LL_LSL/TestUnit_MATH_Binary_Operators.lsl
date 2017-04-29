//#!Enable:Testing
///////////////////////////////////////////////////////////////////////////////////
/////// Script derived from TestUnit_MATH_Binary_Operators.lsl
/////// http://wiki.secondlife.com/wiki/TestUnit_MATH_Binary_Operators.lsl
///////
///////            TestUnit_TestScript
///////             
///////            MATH_BinaryOperators
///////
///////  This is the test script for the data types.  
///////
///////  Original script created by Vektor Linden    
///////               
//////////////////////////////////////////////////////////////////////////////////////    
 
//TestUnit_TestScript    .1 -> initial framework  6.23.2007
//TestUnit_TestScript    .2 -> tested with minor bug fixes  7.2.2007
 
//BinaryOperators        .3 -> Formal creation of script 2/18/10
 
integer ArithmeticAddition_PASS;                    // These are global pass/fail
integer ArithmeticSubtraction_PASS;                    // indicators for the various
integer ArithmeticMultiplication_PASS;                   // Data Types that are 
integer ArithmeticDivision_PASS;                     // being tested. These variables 
integer ArithmeticModulo_PASS;                     // are used in the Run Test and
integer ArithmeticGreaterThan_PASS;                     // Report Functions of this script. 
integer ArithmeticLessThan_PASS;
integer ArithmeticGreaterThanOrEqualTo_PASS; 
integer ArithmeticLessThanOrEqualTo_PASS; 
integer LogicalInequality_PASS; 
integer LogicalEquality_PASS; 
integer LogicalAND_PASS; 
integer LogicalOR_PASS; 
integer BitwiseAND_PASS; 
integer BitwiseOR_PASS; 
integer BitwiseLeftShift_PASS; 
integer BitwiseRightShift_PASS;
integer BitwiseExclusiveOR_PASS; 
 
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////
//////////      Function:   RunTest
//////////
//////////      Input:      no input paramaters
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
        // initialize PASS variable        
        ArithmeticAddition_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (1 + 1 == 2)
        {
            ArithmeticAddition_PASS = 1;
        }
 
        // initialize PASS variable        
        ArithmeticSubtraction_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (1 - 1 == 0)
        {
            ArithmeticSubtraction_PASS = 1;
        }
 
        // initialize PASS variable        
        ArithmeticMultiplication_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (2 * 2 == 4)
        {
            ArithmeticMultiplication_PASS = 1;
        }
 
        // initialize PASS variable        
        ArithmeticDivision_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (4 / 2 == 2)
        {
            ArithmeticDivision_PASS = 1;
        }
 
        // initialize PASS variable        
        ArithmeticModulo_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (5 % 2 == 1)
        {
            ArithmeticModulo_PASS = 1;
        }
 
        // initialize PASS variable
        ArithmeticGreaterThan_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (2 > 1)
        {
            ArithmeticGreaterThan_PASS = 1;
        }
 
        // initialize PASS variable
        ArithmeticLessThan_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (1 < 2)
        {
            ArithmeticLessThan_PASS = 1;
        }
 
        // initialize PASS variable        
        ArithmeticGreaterThanOrEqualTo_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (2 >= 1)
        {
            if (1 >= 1)
            {
                ArithmeticGreaterThanOrEqualTo_PASS = 1;
            }
        }
 
        // initialize PASS variable        
        ArithmeticLessThanOrEqualTo_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (1 <= 2)
        {
            if (1 <= 1)
            {
                ArithmeticLessThanOrEqualTo_PASS = 1;
            }
        }
 
        // initialize PASS variable        
        LogicalInequality_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (1 != 2)
        {
            LogicalInequality_PASS = 1;
        }
 
        // initialize PASS variable        
        LogicalEquality_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (1 == 1)
        {
            LogicalEquality_PASS = 1;
        }
 
        // initialize PASS variable        
        LogicalAND_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (TRUE && TRUE == TRUE)
        {
            LogicalAND_PASS = 1;
        }
 
        // initialize PASS variable
        LogicalOR_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (TRUE || TRUE == TRUE)
        {
            LogicalOR_PASS = 1;
        }
 
        // initialize PASS variable
        BitwiseAND_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if  (TRUE & TRUE == TRUE)
        {
            BitwiseAND_PASS = 1;
        }
 
        // initialize PASS variable        
        BitwiseOR_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if  (TRUE | TRUE == TRUE)
        {
            BitwiseOR_PASS = 1;
        }
 
        // initialize PASS variable        
        BitwiseLeftShift_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (2 << 1 == 4)
        {
            BitwiseLeftShift_PASS = 1;
        }
 
        // initialize PASS variable        
        BitwiseRightShift_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.        
        if (2 >> 1 == 1)
        {
            BitwiseRightShift_PASS = 1;
        }
 
        // initialize PASS variable        
        BitwiseExclusiveOR_PASS = 0;
        // Compare data against criteria in GetType function, which returns an integer corresponding to the type.
        if (0 ^ 0 == 0)
        {
            if (0 ^ 1 == 1)
            {
                if (1 ^ 0 == 1)
                {
                    if (1 ^ 1 == 0)
                    {
                        BitwiseExclusiveOR_PASS = 1;
                    }
                }
            }
        }
 
     //check to see if any failures occured. 
        integer pass = ArithmeticAddition_PASS &
                       ArithmeticSubtraction_PASS &
                       ArithmeticMultiplication_PASS &
                       ArithmeticModulo_PASS &
                       ArithmeticDivision_PASS &
                       ArithmeticGreaterThan_PASS &
                       ArithmeticLessThan_PASS &
                       ArithmeticGreaterThanOrEqualTo_PASS &
                       ArithmeticLessThanOrEqualTo_PASS &
                       LogicalInequality_PASS &
                       LogicalEquality_PASS &
                       LogicalAND_PASS &
                       LogicalOR_PASS &
                       BitwiseAND_PASS &
                       BitwiseOR_PASS &
                       BitwiseLeftShift_PASS &                       
                       BitwiseRightShift_PASS &
                       BitwiseExclusiveOR_PASS;
 
     // if all of the individual cases pass, test passes.                                
    _test_Result(pass);

}
 
 
////////////////////////////////////////////////////////////////////////////////////////////////// 
//////////
//////////      Function:   Report
//////////
//////////      Input:      broadcastChannel - chat channel to send report
//////////                  reportType - determines length and content of report type
//////////                                         -> NORMAL - failures and summary information
//////////                                         -> QUIET - summary information only
//////////                                         -> VERBOSE - everything
//////////                    
//////////      Output:     llSay on broadcastChannel 
//////////                    
//////////      Purpose:    This function is where you design the three level of reports
//////////                  avaliable upon request by the Coordinator
//////////                    
//////////      Issues:        no known issues 
//////////                    
//////////                    
/////////////////////////////////////////////////////////////////////////////////////////////////
Report(  )
{
    //this string will be sent out reguardless of reporting mode
    string reportString;
 
    // PASS or FAIL wording for the report
    string ArithmeticAddition_PASSstring = "FAIL";
    string ArithmeticSubtraction_PASSstring = "FAIL";
    string ArithmeticMultiplication_PASSstring = "FAIL";
    string ArithmeticDivision_PASSstring = "FAIL";
    string ArithmeticModulo_PASSstring = "FAIL";
    string ArithmeticGreaterThan_PASSstring = "FAIL";
    string ArithmeticLessThan_PASSstring = "FAIL";
    string ArithmeticGreaterThanOrEqualTo_PASSstring = "FAIL";
    string ArithmeticLessThanOrEqualTo_PASSstring = "FAIL";
    string LogicalInequality_PASSstring = "FAIL";
    string LogicalEquality_PASSstring = "FAIL";
    string LogicalAND_PASSstring = "FAIL";
    string LogicalOR_PASSstring = "FAIL";
    string BitwiseAND_PASSstring = "FAIL";  
    string BitwiseOR_PASSstring = "FAIL";
    string BitwiseLeftShift_PASSstring = "FAIL";
    string BitwiseRightShift_PASSstring = "FAIL";
    string BitwiseExclusiveOR_PASSstring = "FAIL";
 
    //translate integer conditional into text string for the report. 
    if ( ArithmeticAddition_PASS )
    {
          ArithmeticAddition_PASSstring = "PASS";
    }
    if ( ArithmeticSubtraction_PASS )
    {
          ArithmeticSubtraction_PASSstring = "PASS";
    }
    if ( ArithmeticMultiplication_PASS )
    {
          ArithmeticMultiplication_PASSstring = "PASS";
    }
    if ( ArithmeticDivision_PASS  )
    {
          ArithmeticDivision_PASSstring = "PASS";
    }
    if ( ArithmeticModulo_PASS )
    {
          ArithmeticModulo_PASSstring = "PASS";
    }
    if ( ArithmeticGreaterThan_PASS )
    {
          ArithmeticGreaterThan_PASSstring = "PASS";
    }
    if ( ArithmeticLessThan_PASS )
    {
          ArithmeticLessThan_PASSstring = "PASS";
    }   
    if ( ArithmeticGreaterThanOrEqualTo_PASS )
    {
          ArithmeticGreaterThanOrEqualTo_PASSstring = "PASS";
    }
    if ( ArithmeticLessThanOrEqualTo_PASS )
    {
          ArithmeticLessThanOrEqualTo_PASSstring = "PASS";
    }
    if ( LogicalInequality_PASS )
    {
          LogicalInequality_PASSstring = "PASS";
    }
    if ( LogicalEquality_PASS  )
    {
          LogicalEquality_PASSstring = "PASS";
    }
    if ( LogicalAND_PASS )
    {
          LogicalAND_PASSstring = "PASS";
    }
    if ( LogicalOR_PASS )
    {
          LogicalOR_PASSstring = "PASS";
    }
    if ( BitwiseAND_PASS )
    {
          BitwiseAND_PASSstring = "PASS";
    }   
    if ( BitwiseOR_PASS )
    {
          BitwiseOR_PASSstring = "PASS";
    }
    if ( BitwiseLeftShift_PASS )
    {
          BitwiseLeftShift_PASSstring = "PASS";
    }
    if ( BitwiseRightShift_PASS )
    {
          BitwiseRightShift_PASSstring = "PASS";
    }
    if ( BitwiseExclusiveOR_PASS  )
    {
          BitwiseExclusiveOR_PASSstring = "PASS";
    }
 
 
      reportString = "Type: ArithmeticAddition -> " 
                                                + ArithmeticAddition_PASSstring + "\n"
                   + "Type: ArithmeticSubtraction -> " 
                                                + ArithmeticSubtraction_PASSstring + "\n"
                   + "Type: ArithmeticMultiplication -> " 
                                                + ArithmeticMultiplication_PASSstring + "\n"
                   + "Type: ArithmeticDivision -> " 
                                                + ArithmeticDivision_PASSstring + "\n"
                   + "Type: ArithmeticModulo -> "
                                                + ArithmeticModulo_PASSstring + "\n"
                   + "Type: ArithmeticGreaterThan ->" 
                                                + ArithmeticGreaterThan_PASSstring + "\n"
                   + "Type: ArithmeticLessThan -> " 
                                                + ArithmeticLessThan_PASSstring + "\n"
                   + "Type: ArithmeticGreaterThanOrEqualTo -> " 
                                                + ArithmeticGreaterThanOrEqualTo_PASSstring + "\n"
                   + "Type: ArithmeticLessThanOrEqualTo -> " 
                                                + ArithmeticLessThanOrEqualTo_PASSstring + "\n"
                   + "Type: LogicalInequality -> "
                                                + LogicalInequality_PASSstring + "\n"
                   + "Type: LogicalEquality ->" 
                                                + LogicalEquality_PASSstring + "\n"
                   + "Type: LogicalAND -> " 
                                                + LogicalAND_PASSstring + "\n"
                   + "Type: LogicalOR -> " 
                                                + LogicalOR_PASSstring + "\n"
                   + "Type: BitwiseAND -> " 
                                                + BitwiseAND_PASSstring + "\n"
                   + "Type: BitwiseOR -> "
                                                + BitwiseOR_PASSstring + "\n"                                                                 + "Type: BitwiseLeftShift -> "
                                                + BitwiseLeftShift_PASSstring + "\n"                                           
                   + "Type: BitwiseRightShift -> "
                                                + BitwiseRightShift_PASSstring + "\n"
                   + "Type: BitwiseExclusiveOR ->" 
                                                + BitwiseExclusiveOR_PASSstring + "\n";
 
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
