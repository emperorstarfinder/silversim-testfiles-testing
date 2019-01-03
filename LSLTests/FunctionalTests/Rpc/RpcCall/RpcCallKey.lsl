//#!Enable:extern
//#!Enable: testing

key remotetarget;
string scriptname;

extern(remotetarget, scriptname) rpc_1=rpccall(integer update);

extern rpccall(integer cmd)
{
	_test_Result(TRUE);
}

default
{
	state_entry()
	{
		_test_Result(FALSE);
		remotetarget = llGetKey();
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
