//#!Enable:testing

default
{
	state_entry()
	{
		key k1 = "abcd";
		key k2 = "abcde";
		string s1 = "abcd";
		string s2 = "abcde";
		
		integer result = TRUE;
		_test_Result(FALSE);
		if(k1 == k1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k1 == k1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k1 == k1");
			result = FALSE;
		}
		if(k2 == k2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k2 == k2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k2 == k2");
			result = FALSE;
		}
		if(k1 != k2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k1 != k2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k1 != k2");
			result = FALSE;
		}
		if(s1 == s1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s1 == s1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s1 == s1");
			result = FALSE;
		}
		if(s2 == s2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s2 == s2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s2 == s2");
			result = FALSE;
		}
		if(s1 != s2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s1 != s2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s1 != s2");
			result = FALSE;
		}
		if(s2 != s1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s2 != s1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s2 != s1");
			result = FALSE;
		}
		if(k1 == s1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k1 == s1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k1 == s1");
			result = FALSE;
		}
		if(s1 == k1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s1 == k1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s1 == k1");
			result = FALSE;
		}
		if(k2 == s2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k2 == s1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k2 == s1");
			result = FALSE;
		}
		if(s2 == k2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s2 == k2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s2 == k2");
			result = FALSE;
		}
		if(k2 != s1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k2 != s1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k2 != s1");
			result = FALSE;
		}
		if(k1 != s2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: k1 != s2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: k1 != s2");
			result = FALSE;
		}
		if(s2 != k1)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s2 != k1");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s2 != k1");
			result = FALSE;
		}
		if(s1 != k2)
		{
			llSay(PUBLIC_CHANNEL,"GOOD: s1 != k2");
		}
		else
		{
			llSay(PUBLIC_CHANNEL,"FAIL: s1 != k2");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}
