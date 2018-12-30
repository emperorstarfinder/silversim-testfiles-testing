//#!Mode:ASSL
//#!Enable: Testing

immutablechangelist(list a)
{
	a[0] = 5;
}

default
{
	state_entry()
	{
		list a = [4];
		immutablechangelist(a);
		llSay(PUBLIC_CHANNEL, a[0]);
		_test_Result(llList2Integer(a, 0) == 4);
		_test_Shutdown();
	}
}