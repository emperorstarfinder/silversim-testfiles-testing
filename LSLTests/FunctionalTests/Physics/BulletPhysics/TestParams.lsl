//#!Enable:Testing
//#!Enable:BulletPhysicsTest

default
{
	state_entry()
	{
		/* ensure that physics is settled */
		llSleep(1);
		
		list physresults = btGetPrimParams(llGetKey(), [
				BULLET_PARAM_WORLDPOSITION, /* 0 */
				BULLET_PARAM_WORLDROTATION, /* 1 */
				BULLET_PARAM_LOCALPOSITION, /* 2 */
				BULLET_PARAM_LOCALROTATION, /* 3 */
				BULLET_PARAM_ISACTIVATED, /* 4 */
				BULLET_PARAM_BUOYANCY, /* 5 */
				BULLET_PARAM_ADDGRAVITYACCEL, /* 6 */
				BULLET_PARAM_COMBINEDGRAVITYACCEL, /* 7 */
				BULLET_PARAM_TORQUE, /* 8 */
				BULLET_PARAM_FORCE, /* 9 */
				BULLET_PARAM_MASS, /* 10 */
				BULLET_PARAM_APPLIEDINERTIA, /* 11 */
				BULLET_PARAM_TERRAINCOLLIDE, /* 12 */
				BULLET_PARAM_LOCALID, /* 13 */
				BULLET_PARAM_ROOTPARTLOCALID, /* 14 */
				BULLET_PARAM_COLLISIONSIZE /* 15 */]);
			
		list primresults = llGetPrimitiveParams([
				PRIM_SIZE,
				PRIM_POSITION,
				PRIM_ROTATION
				]);
		
		integer success = TRUE;
		if(!llList2Integer(physresults, 4))
		{
			llSay(PUBLIC_CHANNEL, "Prim is not activated in physics");
			success = FALSE;
		}
		if(llGetListLength(physresults) != 16)
		{
			llSay(PUBLIC_CHANNEL, "Prim physics is not returning 16 values");
			success = FALSE;
		}
		_test_Result(success);
		_test_Shutdown();
	}
}