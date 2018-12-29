//#!Enable:Testing

default 
{ 
	state_entry()
	{
		list foo = ["1", "2", "3", "4"];
		list bar = ["a", "b"];
		integer result = TRUE;
		string data;
		
		data = llList2CSV(llListReplaceList(foo,bar,0,0));
		if(data != "a,b,2,3,4")
		{
			llSay(PUBLIC_CHANNEL, "A: " + data + " != a,b,2,3,4");
			result = FALSE;
		}
		
		data = llList2CSV(llListReplaceList(foo,bar,-1,-1));
		if(data != "1,2,3,a,b")
		{
			llSay(PUBLIC_CHANNEL, "B: " + data + " != 1,2,3,a,b");
			result = FALSE;
		}
		data = llList2CSV(llListReplaceList(foo,bar,0,-1));
		if(data != "a,b")
		{
			llSay(PUBLIC_CHANNEL, "C: " + data + " != a,b");
			result = FALSE;
		}
		data = llList2CSV(llListReplaceList(foo,bar,6,6)); 
		if(data != "1,2,3,4,a,b")
		{
			llSay(PUBLIC_CHANNEL, "D: " + data + " != 1,2,3,4,a,b");
			result = FALSE;
		}
		data = llList2CSV(llListReplaceList(foo,bar,1,2));
		if(data != "1,a,b,4")
		{
			llSay(PUBLIC_CHANNEL, "E: " + data + " != 1,a,b,4");
			result = FALSE;
		}
		data = llList2CSV(llListReplaceList(foo,bar,2,1));
		if(data != "a,b")
		{
			llSay(PUBLIC_CHANNEL, "F: " + data + " != a,b");
			result = FALSE;
		}
		data = llList2CSV(llListReplaceList(foo,bar,3,1));
		if(data != "3,a,b")
		{
			llSay(PUBLIC_CHANNEL, "G: " + data + " != 3,a,b");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	} 
}