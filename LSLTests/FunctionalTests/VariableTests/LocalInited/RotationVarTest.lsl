//#!Enable: Testing

default
{
	state_entry()
	{
		rotation r=<1,1,1,1>;
		llSay(PUBLIC_CHANNEL, (string)r);
		_test_Result(r == <1,1,1,1>);
		_test_Shutdown();
	}
}
