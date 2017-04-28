//#!Enable:Testing

default
{
    state_entry()
    {
	list a = [1,2];
	a += [<1,1,1>];
	
	vector s = llList2Vector(a, 2);
	llSay(PUBLIC_CHANNEL, (string)s);
	_test_Result(s.x == 1 && s.y == 1 && s.z == 1);
	_test_Shutdown();
    }
}