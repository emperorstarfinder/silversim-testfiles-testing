//#!Enable:extern

key rpctarget;

extern(rpctarget, "hello") rpc_7=rpc2(integer update, integer para);
extern(return) rpcret(integer update, integer para);

extern(public, everyone) rpccall(integer cmd)
{
	rpcret(1, 1);
}

extern(public) rpccall2(integer cmd)
{
}

default
{
	state_entry()
	{
		rpctarget = llGetKey();
		rpc_7(7, 0);
	}
}
