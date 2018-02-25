//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		string test = "abcdefghi";
		string out;
		out = llDeleteSubString(test, -1, -1);
		if(out != "abcdefgh")
		{
			llSay(0, "llDeleteSubString(test, -1, -1): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, -2, -2);
		if(out != "abcdefgi")
		{
			llSay(0, "llDeleteSubString(test, -2, -2): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, -2, -1);
		if(out != "abcdefg")
		{
			llSay(0, "llDeleteSubString(test, -2, -1): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 0, 0);
		if(out != "bcdefghi")
		{
			llSay(0, "llDeleteSubString(test, 0, 0): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 1, 1);
		if(out != "acdefghi")
		{
			llSay(0, "llDeleteSubString(test, 1, 1): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 2, 1);
		if(out != "")
		{
			llSay(0, "llDeleteSubString(test, 2, 1): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 4, 1);
		if(out != "cd")
		{
			llSay(0, "llDeleteSubString(test, 4, 1): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 9, 9);
		if(out != "abcdefghi")
		{
			llSay(0, "llDeleteSubString(test, 9, 9): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 9, 10);
		if(out != "abcdefghi")
		{
			llSay(0, "llDeleteSubString(test, 9, 10): wrong " + out);
			result = FALSE;
		}
		out = llDeleteSubString(test, 9, -10);
		if(out != "abcdefghi")
		{
			llSay(0, "llDeleteSubString(test, 9, -10): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}