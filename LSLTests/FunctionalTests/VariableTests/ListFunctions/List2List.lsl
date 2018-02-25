//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		list test = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];
		string out;
		out = (string)llList2List(test, -1, -1);
		if(out != "i")
		{
			llSay(0, "llList2List(test, -1, -1): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, -2, -2);
		if(out != "h")
		{
			llSay(0, "llList2List(test, -2, -2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, -2, -1);
		if(out != "hi")
		{
			llSay(0, "llList2List(test, -2, -1): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 0, 0);
		if(out != "a")
		{
			llSay(0, "llList2List(test, 0, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 1, 1);
		if(out != "b")
		{
			llSay(0, "llList2List(test, 1, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 2, 1);
		if(out != "abcdefghi")
		{
			llSay(0, "llList2List(test, 2, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 4, 1);
		if(out != "abefghi")
		{
			llSay(0, "llList2List(test, 4, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 9, 9);
		if(out != "")
		{
			llSay(0, "llList2List(test, 9, 9): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 9, 10);
		if(out != "")
		{
			llSay(0, "llList2List(test, 9, 10): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2List(test, 9, -10);
		if(out != "")
		{
			llSay(0, "llList2List(test, 9, -10): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}