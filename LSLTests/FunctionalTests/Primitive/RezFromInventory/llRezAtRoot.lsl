//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		_test_Result(FALSE);
		llRezAtRoot("Rezzed", llGetPos() + <0,0,1>,ZERO_VECTOR, ZERO_ROTATION, 0);
	}
	
	object_rez(key id)
	{
		llSay(PUBLIC_CHANNEL, "Object rez event for " + id);
		list pos = llGetObjectDetails(id, [OBJECT_NAME]);
		string objname = llList2String(pos, 0);
		if(objname == "Rezzed")
		{
			llSay(PUBLIC_CHANNEL, "Object Name: " + objname);
			_test_Result(TRUE);
		}
		else
		{
			llSay(PUBLIC_CHANNEL, "Object not rezzed");
		}
		_test_Shutdown();
	}
}