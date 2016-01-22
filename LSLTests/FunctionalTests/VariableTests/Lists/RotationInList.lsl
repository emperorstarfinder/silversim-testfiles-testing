//#!Enable:Testing

list l;
default
{
    state_entry()
    {
	_test_Result(FALSE);
        l = [<1., 1., 1., 1.>];
	_test_Result(TRUE);
	_test_Shutdown();
    }
}