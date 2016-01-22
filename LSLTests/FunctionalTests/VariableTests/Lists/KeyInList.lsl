//#!Enable:Testing

list l;
default
{
    state_entry()
    {
	_test_Result(FALSE);
        l = [(key)NULL_KEY];
	_test_Result(TRUE);
	_test_Shutdown();
    }
}