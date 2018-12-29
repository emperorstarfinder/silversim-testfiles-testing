//#!Enable:Testing

// Global constants
integer NUM_STAT_FUNCTIONS = 10;    // The total number of statistics functions being tested
float PRECISION = 0.000001;          // Precision for deciding if two floats are equal.

// Lists of random numbers and expected results for list statistic tests.
list pos_i_nums = [60, 9, 52, 46, 15, 93, 1, 38, 2, 2, 19, 35, 98, 40, 81, 63, 33, 7, 14, 57];
list pos_i_nums_exp = [21.946033, 98.000000, 38.250000, 36.500000, 1.000000, 20.000000, 97.000000, 30.322607, 765.000000, 46731.000000];

list i_nums = [-70, 13, 57, 40, 64, 69, -4, -82, 65, 12, -38, -2, -87, -56, 16, -3, 42, 72, 88, 9];
list i_nums_exp = [0.000000, 88.000000, 10.250000, 12.500000, -87.000000, 20.000000, 175.000000, 53.789917, 205.000000, 57075.000000];

list pos_f_nums = [82.417809, 91.809250, 76.745857, 30.112839, 59.592426, 69.273590, 45.307995, 75.208054, 76.048752, 68.020439, 8.152950, 75.462746, 41.539265, 29.632532, 78.000549, 92.402588, 6.669974, 27.978504, 5.558228, 39.094364];
list pos_f_nums_exp = [41.9261492153628, 92.402588, 53.951435, 63.8064325, 5.558228, 20.000000, 86.844360, 28.6963301154461, 1079.028711, 73861.2558379147];

list f_nums = [-0.139381, -27.304054, 94.030289, 13.192818, -47.015236, -65.352325, -19.218590, -46.622826, 74.704987, 81.610138, 77.102188, 37.365799, 71.920914, -6.563972, 75.492142, -66.262222, -14.630196, 42.237671, 50.809509, 60.678391];
list f_nums_exp = [0.000000, 94.030289, 19.301802, 25.279308, -66.262222, 20.000000, 160.292511, 53.5495206419919, 386.036044, 61934.6634221136];

list pos_nums = [73.602554, 51, 81.272957, 1, 99.056290, 51, 49, 4, 40, 7.409000, 14.304935, 33.760963, 55, 74.717239, 93, 62, 79.556740, 80.807838, 68, 6];
list pos_nums_exp = [33.224949, 99.056290, 51.224426, 53.000000, 1.000000, 20.000000, 98.056290, 31.284027, 1024.488516, 71073.9525178974];

list nums = [83.584778, -60.052635, 18, -8.325104, 96, 38.019531, 8.437393, 43, -68.145966, 47.279388, -34.522865, -66.681480, 57, -52, 76.156738, -79.752159, -6.773018, -25.028397, -2, -12];
list nums_exp = [0.000000, 96.000000, 2.609810, -4.386509, -79.752159, 20.000000, 175.752159, 53.7452591909598, 52.196205, 55018.7270101659];

list mix = [<54.256630, 3.637493, 84.144615>, <29.411591, 13.690305, 41.204464, 47.844841>, <75.334404, 88.659325, 45.068050>, "hb", <81.319321, 28.139233, 44.470226, 90.885689>, "+:N:5[9-e", "=", <59.082222, 22.229565, 52.013420>, 23, -65.739204,-95.452667, <62.925495, 44.109821, 87.012184, 41.697239>, <82.293236, 35.758636, 34.232937>, <99.836624, 42.692303, 93.425766, 4.260778>, 63, 94, "ja 4q", "bp", "c", <70.304001, 52.908825, 50.068676>];
list mix_exp = [0.000000, 94.000000, 3.761626, 23.000000, -95.452667, 5.000000, 189.452667, 81.694714389412, 18.808129, 26766.8545799665];

// Floats don't behave well with ==.  
// This function does a 'close enough' equals, as determined by PRECISION.
integer equal(float a, float b)
{
    return ( llFabs(a-b) < PRECISION );
}

// Test a single list statistic function
// list test        The list being tested
// list expected    The expected results of each list statistics function.  Order matters.
// integer stat     The statistics function to test
// string name      The name of the list being tested
// string stat_name The name of the statistics function being tested
integer stat_test(list test, float exp, integer stat, string name, string stat_name)
{
    float res;
    
    res = llListStatistics(stat,test);
    if (!equal(res,exp))
    {
        llSay(PUBLIC_CHANNEL, " * Test Failed: " + stat_name + " for " + name + 
							"   Expected: " + (string)exp + " Actual: " + (string)res);
        return FALSE;
    }
    return TRUE;
}

// Run the full suite of list statistics on a given list
// list test        The list being tested
// list expected    The expected results of each list statistics function.  Order matters.
// string name      The name of the list being tested
integer list_stats_test(list test, list expected, string name)
{
    integer i;
    integer pass;
    
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_GEOMETRIC_MEAN,name,"LIST_STAT_GEOMETRIC_MEAN");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_MAX,name,"LIST_STAT_MAX");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_MEAN,name,"LIST_STAT_MEAN");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_MEDIAN,name,"LIST_STAT_MEDIAN");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_MIN,name,"LIST_STAT_MIN");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_NUM_COUNT,name,"LIST_STAT_NUM_COUNT");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_RANGE,name,"LIST_STAT_RANGE");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_STD_DEV,name,"LIST_STAT_STD_DEV");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_SUM,name,"LIST_STAT_SUM");
    pass += stat_test(test,llList2Float(expected,i++),LIST_STAT_SUM_SQUARES,name,"LIST_STAT_SUM_SQUARES");
    
    if (pass == NUM_STAT_FUNCTIONS)
    {
        llSay(PUBLIC_CHANNEL, "All tests passed for " + name);
    }
   return pass;
}

// Used to get all the statistics results for a given list.
get(list test)
{
    list results;
    results += llListStatistics(LIST_STAT_GEOMETRIC_MEAN,test);
    results += llListStatistics(LIST_STAT_MAX,test);
    results += llListStatistics(LIST_STAT_MEAN,test);
    results += llListStatistics(LIST_STAT_MEDIAN,test);
    results += llListStatistics(LIST_STAT_MIN,test);
    results += llListStatistics(LIST_STAT_NUM_COUNT,test);
    results += llListStatistics(LIST_STAT_RANGE,test);
    results += llListStatistics(LIST_STAT_STD_DEV,test);
    results += llListStatistics(LIST_STAT_SUM,test);
    results += llListStatistics(LIST_STAT_SUM_SQUARES,test);
    llSay(PUBLIC_CHANNEL, llList2CSV(results));
}

default
{
    state_entry()
    {
        integer passed;
        integer total_passed;
        integer total_failed;
		
        passed = list_stats_test(pos_i_nums,pos_i_nums_exp,"Positive Integers");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);

        passed = list_stats_test(i_nums,i_nums_exp,"Integers");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);
        
        passed = list_stats_test(pos_f_nums,pos_f_nums_exp,"Positive Floats");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);

        passed = list_stats_test(f_nums,f_nums_exp,"Floats");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);
        
        passed = list_stats_test(pos_nums,pos_nums_exp,"Positive Numbers");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);
        
        passed = list_stats_test(nums,nums_exp,"Numbers");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);

        passed = list_stats_test(mix,mix_exp,"Mixed Types");
        total_passed += passed;
        total_failed += (NUM_STAT_FUNCTIONS - passed);

        llSay(PUBLIC_CHANNEL, "Passed: " + (string)total_passed + "  Failed: " + (string)total_failed);
		_test_Result(total_failed == 0);
		_test_Shutdown();
    }
}