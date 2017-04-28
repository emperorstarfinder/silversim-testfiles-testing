//#!Enable:Testing

default
{
    state_entry()
    {
	list a = [1,2];
	a += (list)"3";
	
	string s = llList2String(a, 2);
	llSay(PUBLIC_CHANNEL, s);
	_test_Result(s == "3");
	_test_Shutdown();
    }
}