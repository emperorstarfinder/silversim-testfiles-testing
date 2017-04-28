//#!Enable:Testing

default
{
    state_entry()
    {
	list a = [1,2];
	a += [3.0];
	
	float f = llList2Float(a, 2);
	llSay(PUBLIC_CHANNEL, (string)f);
	_test_Result(f == 3.0);
	_test_Shutdown();
    }
}