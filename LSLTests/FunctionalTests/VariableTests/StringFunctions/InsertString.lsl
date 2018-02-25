//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		string test = "abcdefghi";
		string out;
		out = llInsertString(test, 0, "0");
		if(out != "0abcdefghi")
		{
			llSay(0, "llInsertString(test, 0, \"0\"): wrong " + out);
			result = FALSE;
		}
		out = llInsertString(test, 1, "0");
		if(out != "a0bcdefghi")
		{
			llSay(0, "llInsertString(test, 1, \"0\"): wrong " + out);
			result = FALSE;
		}
		out = llInsertString(test, 9, "0");
		if(out != "abcdefghi0")
		{
			llSay(0, "llInsertString(test, 9, \"0\"): wrong " + out);
			result = FALSE;
		}
		out = llInsertString(test, -1, "0");
		if(out != "abcdefgh0i")
		{
			llSay(0, "llInsertString(test, -1, \"0\"): wrong " + out);
			result = FALSE;
		}
		out = llInsertString(test, -2, "0");
		if(out != "abcdefg0hi")
		{
			llSay(0, "llInsertString(test, -2, \"0\"): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}