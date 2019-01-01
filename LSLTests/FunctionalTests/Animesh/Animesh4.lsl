//#!Mode:ASSL
//#!Enable:Testing

const key FALSE_ANIM_ID = "68d015cc-0df1-11e9-8494-448a5b2c3299";

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
		
		llSay(PUBLIC_CHANNEL, "Check that wrong asset does not trigger");
		llStartObjectAnimation(FALSE_ANIM_ID);
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