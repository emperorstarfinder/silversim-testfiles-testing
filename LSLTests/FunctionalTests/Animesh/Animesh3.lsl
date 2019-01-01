//#!Mode:ASSL
//#!Enable:Testing

const key ANIM2_ID = "10d91ec0-0dee-11e9-ac18-448a5b2c3299";

default
{
	state_entry()
	{
		_test_Result(FALSE);
		integer success = TRUE;
		llSay(PUBLIC_CHANNEL, "Setting up animesh");
		llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_SCULPT, llGenerateKey(), 5]);
		_test_EnableAnimesh(llGetKey(), TRUE);
		
		list anims;
		integer cnt;
		
		llSay(PUBLIC_CHANNEL, "Check that missing anim does not trigger");
		llStartObjectAnimation(ANIM2_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		
		_test_Result(success);
		_test_Shutdown();
	}
}