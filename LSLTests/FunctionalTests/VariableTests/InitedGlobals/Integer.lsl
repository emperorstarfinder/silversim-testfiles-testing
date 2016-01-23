//#!Enable:Testing

integer i = 1;

default
{
    state_entry()
    {
	_test_Result(TRUE);
	_test_Shutdown();
    }
}