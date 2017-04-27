//#!Enable:Testing

default
{
    state_entry()
    {
	key k = "00000000-1122-1122-1122-000000000000";
	list a = [1,2];
	a += k;
	
	key s = llList2Key(a, 2);
	llSay(PUBLIC_CHANNEL, s);
	_test_Result(s == k);
	_test_Shutdown();
    }
}