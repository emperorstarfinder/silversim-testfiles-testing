//#!Enable:Testing

list l;
default
{
    state_entry()
    {
	_test_Result(FALSE);
        l = ["string"];
	_test_Result(TRUE);
	_test_Shutdown();
    }
}