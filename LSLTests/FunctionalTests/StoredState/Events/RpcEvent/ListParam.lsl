//#!Mode:ASSL
//#!Enable:extern
//#!Enable:testing

extern(public, everyone) rpccall(list val)
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
	if(llGetListLength(val) != 2 || llList2Integer(val, 0) != 4711 || llList2String(val, 1) != "0815")
	{
		llSay(PUBLIC_CHANNEL, "Unexpected parameter 1");
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