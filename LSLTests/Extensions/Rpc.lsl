//#!Enable:extern

integer rpctarget;

extern("hello") rpc_1(integer update);
extern("hello") rpc_2=rpc2(integer update);
extern("prim", "hello") rpc_3(string t);
extern(4, "hello") rpc_4(string t);
extern("prim", "hello") rpc_5=rpc2(integer update);
extern(4, "hello") rpc_6=rpc2(integer update, integer para);
extern(rpctarget, "hello") rpc_7=rpc2(integer update, integer para);

extern rpccall(integer cmd)
{
}

default
{
	state_entry()
	{
		rpc_1(1);
		rpc_2(2);
		rpc_3("3");
		rpc_4("4");
		rpc_5(5);
		rpc_6(6, 0);
		rpc_7(7, 0);
	}
}
