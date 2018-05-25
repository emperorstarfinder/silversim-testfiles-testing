//#!Mode:ASSL
//#!Enable:extern
//#!Enable:testing

extern(public, everyone) rpccall(string p)
{
	llSay(PUBLIC_CHANNEL, "rpccall(string) should not be called");
	_test_Shutdown();
}

extern(public, everyone) rpccall(key p)
{
	integer result = TRUE;
	if(rpcGetRemoteKey() != "5e97c1ef-b536-4035-b8b0-d6ab33cd86b8")
	{
		llSay(PUBLIC_CHANNEL, "Unexpected remote link key");
		result = FALSE;
	}
	if(rpcGetRemoteLinkNumber() != 2)
	{
		llSay(PUBLIC_CHANNEL, "Unexpected remote link number");
		result = FALSE;
	}
	if(rpcGetSenderScriptName() != "Script 1")
	{
		llSay(PUBLIC_CHANNEL, "Unexpected remote script name");
		result = FALSE;
	}
	if(rpcGetSenderScriptKey() != "5e97c1ef-b536-4035-b8b0-d6ab33cd86b7")
	{
		llSay(PUBLIC_CHANNEL, "Unexpected remote script key");
		result = FALSE;
	}
	if(p != "Key")
	{
		llSay(PUBLIC_CHANNEL, "Unexpected parameter value: " + p);
		result = FALSE;
	}
	_test_Result(result);
	_test_Shutdown();
}

default
{
	state_entry()
	{
		_test_Result(FALSE);
		_test_Shutdown();
	}
}