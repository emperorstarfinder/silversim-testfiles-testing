//#!Enable:Testing

key k = "00000000-0000-0000-0000-000000000000";

default
{
    state_entry()
    {
	_test_Result(TRUE);
	_test_Shutdown();
    }
}