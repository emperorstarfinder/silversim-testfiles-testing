//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		list test = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];
		string out;
		out = (string)llListInsertList(test, "0", 0);
		if(out != "0abcdefghi")
		{
			llSay(0, "llListInsertList(test, \"0\", 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llListInsertList(test, "0", 1);
		if(out != "a0bcdefghi")
		{
			llSay(0, "llInsertString(test, \"0\", 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListInsertList(test, "0", 9);
		if(out != "abcdefghi0")
		{
			llSay(0, "llListInsertList(test, \"0\", 9): wrong " + out);
			result = FALSE;
		}
		out = (string)llListInsertList(test, "0", -1);
		if(out != "abcdefgh0i")
		{
			llSay(0, "llListInsertList(test, \"0\", -1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListInsertList(test, "0", -2);
		if(out != "abcdefg0hi")
		{
			llSay(0, "llListInsertList(test, \"0\", -2): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}