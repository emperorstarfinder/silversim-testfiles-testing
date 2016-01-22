//#!Enable:Testing

string s;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	s = "Hello";
	_test_Result(TRUE);
	_test_Shutdown();
    }
}