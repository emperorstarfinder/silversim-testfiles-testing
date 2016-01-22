//#!Enable:Testing

integer i;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	i = 1;
	_test_Result(TRUE);
	_test_Shutdown();
    }
}