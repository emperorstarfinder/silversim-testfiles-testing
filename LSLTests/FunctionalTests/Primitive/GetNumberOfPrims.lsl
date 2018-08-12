//#!Enable:Testing

default
{
    state_entry()
    {
	_test_Result(llGetNumberOfPrims() == 1);
	_test_Shutdown();
    }
}