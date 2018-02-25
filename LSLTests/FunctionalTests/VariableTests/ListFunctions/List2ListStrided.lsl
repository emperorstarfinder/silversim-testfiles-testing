//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer result = TRUE;
		list test = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];
		string out;
		out = (string)llList2ListStrided(test, 0, -1, 0);
		if(out != "abcdefghi")
		{
			llSay(0, "llList2ListStrided(test, 0, -1, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, -1, 0, 0);
		if(out != "abcdefghi")
		{
			llSay(0, "llList2ListStrided(test, -1, 0, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 4, 3, 0);
		if(out != "abcdefghi")
		{
			llSay(0, "llList2ListStrided(test, 4, 3, 0): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 0, -1, 1);
		if(out != "abcdefghi")
		{
			llSay(0, "llList2ListStrided(test, 0, -1, 1): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 0, -1, 2);
		if(out != "acegi")
		{
			llSay(0, "llList2ListStrided(test, 0, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 1, -1, 2);
		if(out != "cegi")
		{
			llSay(0, "llList2ListStrided(test, 1, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 2, -1, 2);
		if(out != "cegi")
		{
			llSay(0, "llList2ListStrided(test, 2, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 3, -1, 2);
		if(out != "egi")
		{
			llSay(0, "llList2ListStrided(test, 3, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 4, -1, 2);
		if(out != "egi")
		{
			llSay(0, "llList2ListStrided(test, 4, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 5, -1, 2);
		if(out != "gi")
		{
			llSay(0, "llList2ListStrided(test, 4, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 6, -1, 2);
		if(out != "gi")
		{
			llSay(0, "llList2ListStrided(test, 4, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 7, -1, 2);
		if(out != "i")
		{
			llSay(0, "llList2ListStrided(test, 4, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 8, -1, 2);
		if(out != "i")
		{
			llSay(0, "llList2ListStrided(test, 4, -1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 0, 0, 2);
		if(out != "a")
		{
			llSay(0, "llList2ListStrided(test, 0, 0, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 1, 1, 2);
		if(out != "")
		{
			llSay(0, "llList2ListStrided(test, 1, 1, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 2, 2, 2);
		if(out != "c")
		{
			llSay(0, "llList2ListStrided(test, 2, 2, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 3, 3, 2);
		if(out != "")
		{
			llSay(0, "llList2ListStrided(test, 3, 3, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 4, 4, 2);
		if(out != "e")
		{
			llSay(0, "llList2ListStrided(test, 4, 4, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 4, 6, 2);
		if(out != "eg")
		{
			llSay(0, "llList2ListStrided(test, 4, 6, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 4, 7, 2);
		if(out != "eg")
		{
			llSay(0, "llList2ListStrided(test, 4, 7, 2): wrong " + out);
			result = FALSE;
		}
		out = (string)llList2ListStrided(test, 3, 7, 2);
		if(out != "eg")
		{
			llSay(0, "llList2ListStrided(test, 3, 7, 2): wrong " + out);
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}