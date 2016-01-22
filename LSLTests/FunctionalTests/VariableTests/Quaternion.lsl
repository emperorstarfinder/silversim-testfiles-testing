//#!Enable:Testing

quaternion q;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	q = <1.0, 1.0, 1.0, 1.0>;
	_test_Result(TRUE);
	_test_Shutdown();
    }
}