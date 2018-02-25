//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		string test = "abcdefghi";
		string out;
		out = llGetSubString(test, -1, -1);
		if(out != "i")
		{
			llSay(0, "llGetSubString(test, -1, -1): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, -2, -2);
		if(out != "h")
		{
			llSay(0, "llGetSubString(test, -2, -2): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, -2, -1);
		if(out != "hi")
		{
			llSay(0, "llGetSubString(test, -2, -1): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 0, 0);
		if(out != "a")
		{
			llSay(0, "llGetSubString(test, 0, 0): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 1, 1);
		if(out != "b")
		{
			llSay(0, "llGetSubString(test, 1, 1): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 2, 1);
		if(out != "abcdefghi")
		{
			llSay(0, "llGetSubString(test, 2, 1): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 4, 1);
		if(out != "abefghi")
		{
			llSay(0, "llGetSubString(test, 4, 1): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 9, 9);
		if(out != "")
		{
			llSay(0, "llGetSubString(test, 9, 9): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 9, 10);
		if(out != "")
		{
			llSay(0, "llGetSubString(test, 9, 10): wrong " + out);
			result = FALSE;
		}
		out = llGetSubString(test, 9, -10);
		if(out != "")
		{
			llSay(0, "llGetSubString(test, 9, -10): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}