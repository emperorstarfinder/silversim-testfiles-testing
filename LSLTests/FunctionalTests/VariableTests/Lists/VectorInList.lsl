//#!Enable:Testing

list l;
default
{
    state_entry()
    {
	_test_Result(FALSE);
        l = [<5., 5., 5.>];
	_test_Result(TRUE);
	_test_Shutdown();
    }
}