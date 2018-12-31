//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		list finddata = [5, 7.0, (key)"11223344-1122-1122-1122-112233445566", "Hello", <1,1,1>,<0,0,0,1>];
		integer pos;
		_test_Result(FALSE);
		integer success = TRUE;

		pos = llListFindList(finddata, [5]);
		llSay(PUBLIC_CHANNEL, "5: " + pos);
		if(pos != 0)
		{
			success = FALSE;
			llSay(PUBLIC_CHANNEL, "!! Expected: 0");
		}
		
		pos = llListFindList(finddata, [7.0]);
		llSay(PUBLIC_CHANNEL, "7.0: " + pos);
		if(pos != 1)
		{
			success = FALSE;
			llSay(PUBLIC_CHANNEL, "!! Expected: 1");
		}

		pos = llListFindList(finddata, [(key)"11223344-1122-1122-1122-112233445566"]);
		llSay(PUBLIC_CHANNEL, "11223344-1122-1122-1122-112233445566: " + pos);
		if(pos != 2)
		{
			success = FALSE;
			llSay(PUBLIC_CHANNEL, "!! Expected: 2");
		}

		pos = llListFindList(finddata, ["Hello"]);
		llSay(PUBLIC_CHANNEL, "Hello: " + pos);
		if(pos != 3)
		{
			success = FALSE;
			llSay(PUBLIC_CHANNEL, "!! Expected: 3");
		}

		pos = llListFindList(finddata, [<1,1,1>]);
		llSay(PUBLIC_CHANNEL, "<1,1,1>: " + pos);
		if(pos != 4)
		{
			success = FALSE;
			llSay(PUBLIC_CHANNEL, "!! Expected: 4");
		}

		pos = llListFindList(finddata, [<0,0,0,1>]);
		llSay(PUBLIC_CHANNEL, "<0,0,0,1>: " + pos);
		if(pos != 5)
		{
			success = FALSE;
			llSay(PUBLIC_CHANNEL, "!! Expected: 5");
		}

		_test_Result(success);
		_test_Shutdown();
	}
}