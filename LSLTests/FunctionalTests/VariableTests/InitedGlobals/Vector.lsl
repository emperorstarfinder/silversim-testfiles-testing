//#!Enable:Testing

vector v = <0.6, 1.0, 1.0>;

default
{
    state_entry()
    {
	_test_Result(TRUE);
	_test_Shutdown();
    }
}