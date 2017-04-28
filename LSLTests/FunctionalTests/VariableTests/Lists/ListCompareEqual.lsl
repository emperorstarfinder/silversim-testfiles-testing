//#!Enable:Testing

default
{
    state_entry()
    {
	list l1 = [1, 2];
	list l2 = [1, 3];
	list l3 = [1, 2];
	
	_test_Result(l1 == l2 && l1 == l3);
	_test_Shutdown();
    }
}