//#!Enable:Testing

float f = 0.5;

default
{
    state_entry()
    {
	_test_Result(TRUE);
	_test_Shutdown();
    }
}