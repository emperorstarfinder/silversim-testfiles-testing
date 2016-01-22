//#!Enable:Testing

float f;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	f = 0.5;
	_test_Result(TRUE);
	_test_Shutdown();
    }
}