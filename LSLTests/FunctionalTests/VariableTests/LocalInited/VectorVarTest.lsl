//#!Enable: Testing

default
{
	state_entry()
	{
		vector v = <1,1,1>;
		llSay(PUBLIC_CHANNEL, (string)v);
		_test_Result(v == <1,1,1>);
		_test_Shutdown();
	}
}
