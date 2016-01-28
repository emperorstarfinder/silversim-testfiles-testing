//#!Enable:Testing

string s = "Hello";

default
{
    state_entry()
    {
	_test_Result(TRUE);
	_test_Shutdown();
    }
}