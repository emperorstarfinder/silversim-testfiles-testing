//#!Enable:Testing

vector v;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	v = <0.6, 1.0, 1.0>;
	_test_Result(TRUE);
	_test_Shutdown();
    }
}