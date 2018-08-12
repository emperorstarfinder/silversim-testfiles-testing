//#!Enable:Testing

default
{
    state_entry()
    {
	_test_Result(llGetObjectPrimCount(llGetKey()) == 1);
	_test_Shutdown();
    }
}