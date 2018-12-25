//#!Mode:ASSL
//#!Enable:Testing
//#!Enable:BulletPhysicsTest

default
{
	state_entry()
	{
		llSleep(1); /* get log buffer written */
		llSay(PUBLIC_CHANNEL, "** Begin Test **");
		integer before = llList2Integer(btGetPrimParams(llGetKey(), [BULLET_PARAM_CUR_PHYSICS_PARAMETER_UPDATE_SERIAL]), 0);
		llSleep(1);
		integer before2 = llList2Integer(btGetPrimParams(llGetKey(), [BULLET_PARAM_ACT_PHYSICS_PARAMETER_UPDATE_SERIAL]), 0);
		llSay(PUBLIC_CHANNEL, "Change Position");
		llSetPos(llGetPos() + <0,0,1>);
		llSleep(1);
		integer after = llList2Integer(btGetPrimParams(llGetKey(), [BULLET_PARAM_CUR_PHYSICS_PARAMETER_UPDATE_SERIAL]), 0);
		integer after2 = llList2Integer(btGetPrimParams(llGetKey(), [BULLET_PARAM_ACT_PHYSICS_PARAMETER_UPDATE_SERIAL]), 0);
		
		llSay(PUBLIC_CHANNEL, "CUR_PARAMETER_UPDATE_SERIAL before: " + (string)before);
		llSay(PUBLIC_CHANNEL, "ACT_PARAMETER_UPDATE_SERIAL before: " + (string)before2);
		llSay(PUBLIC_CHANNEL, "CUR_PARAMETER_UPDATE_SERIAL after: " + (string)after);
		llSay(PUBLIC_CHANNEL, "ACT_PARAMETER_UPDATE_SERIAL after: " + (string)after2);
		_test_Result(after == before && after2 == before2 && before == before2);
		
		_test_Shutdown();
	}
}