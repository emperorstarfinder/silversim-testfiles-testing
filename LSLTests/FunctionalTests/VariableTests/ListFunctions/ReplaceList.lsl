//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		list test = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];
		string out;
		out = (string)llListReplaceList(test, "0", 0, 0);
		if(out != "0bcdefghi")
		{
			llSay(0, "llListReplaceList(test, \"0\", 0, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, "0", 1, 1);
		if(out != "a0cdefghi")
		{
			llSay(0, "llListReplaceList(test, \"0\", 1, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, "0", 9, 9);
		if(out != "abcdefghi0")
		{
			llSay(0, "llListInsertList(test, \"0\", 9, 9): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, "0", -1, -1);
		if(out != "abcdefgh0")
		{
			llSay(0, "llListReplaceList(test, \"0\", -1, -1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, "0", -2, -2);
		if(out != "abcdefg0i")
		{
			llSay(0, "llListReplaceList(test, \"0\", -2, -2): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, "0", 0, 0);
		if(out != "0bcdefghi")
		{
			llSay(0, "llListReplaceList(test, \"0\", 0, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, "0", 0, 1);
		if(out != "0cdefghi")
		{
			llSay(0, "llListReplaceList(test, \"0\", 0, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, ["0", "1"], 0, 0);
		if(out != "01bcdefghi")
		{
			llSay(0, "llListReplaceList(test, [\"0\", \"1\"], 0, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, ["0", "1"], 2, 1);
		if(out != "01")
		{
			llSay(0, "llListReplaceList(test, [\"0\", \"1\"], 2, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, ["0", "1"], 3, 1);
		if(out != "c01")
		{
			llSay(0, "llListReplaceList(test, [\"0\", \"1\"], 2, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, ["0", "1"], 4, 1);
		if(out != "cd01")
		{
			llSay(0, "llListReplaceList(test, [\"0\", \"1\"], 2, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, ["0", "1"], 0, 10);
		if(out != "01")
		{
			llSay(0, "llListReplaceList(test, [\"0\", \"1\"], 2, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llListReplaceList(test, ["0", "1"], -100, 10);
		if(out != "01")
		{
			llSay(0, "llListReplaceList(test, [\"0\", \"1\"], 2, 1): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}