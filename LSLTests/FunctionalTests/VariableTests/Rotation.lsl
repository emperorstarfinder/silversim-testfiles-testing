//#!Enable:Testing

rotation r;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	r = <1.0, 1.0, 1.0, 1.0>;
	_test_Result(TRUE);
	_test_Shutdown();
    }
}