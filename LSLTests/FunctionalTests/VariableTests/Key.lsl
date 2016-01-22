//#!Enable:Testing

key k;

default
{
    state_entry()
    {
	_test_Result(FALSE);
	k = "00000000-0000-0000-0000-000000000000";
	_test_Result(TRUE);
	_test_Shutdown();
    }
}