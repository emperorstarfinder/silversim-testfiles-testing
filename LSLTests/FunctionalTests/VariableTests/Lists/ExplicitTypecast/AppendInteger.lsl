//#!Enable:Testing

default
{
    state_entry()
    {
	list a = [1,2];
	a += (list)3;
	
	integer i = llList2Integer(a, 2);
	llSay(PUBLIC_CHANNEL, (string)i);
	_test_Result(i == 3);
	_test_Shutdown();
    }
}