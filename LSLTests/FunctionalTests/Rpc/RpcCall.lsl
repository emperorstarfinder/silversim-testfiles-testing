//#!Enable:extern
//#!Enable: testing

string scriptname;

extern(scriptname) rpc_1=rpccall(integer update);

extern rpccall(integer cmd)
{
	_test_Result(TRUE);
}

default
{
	state_entry()
	{
		_test_Result(FALSE);
		scriptname = llGetScriptName();
		rpc_1(0);
		llSetTimerEvent(0.5);
	}
	
	timer()
	{
		llSetTimerEvent(0);
		_test_Shutdown();
	}
}
