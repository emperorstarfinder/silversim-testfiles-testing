//#!Enable:Testing

string s;

default
{
    state_entry()
    {
		integer res1;
		integer res2;
		integer res3;
		integer res4;
		_test_Result(FALSE);
		s = "Hello";
		res1 = s == "Hello";
		res3 = s != "";
		s = "";
		res2 = s == "";
		res4 = s != "Hello";
		_test_Result(res1 && res2 && res3 && res4);
		_test_Shutdown();
	}
}