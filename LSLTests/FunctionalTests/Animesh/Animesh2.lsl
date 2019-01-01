//#!Mode:ASSL
//#!Enable:Testing

const key ANIM1_ID = "9e06424c-0178-82eb-ff21-6c0e4e5a7e6d";
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
		
		llSay(PUBLIC_CHANNEL, "Starting anims");
		llStartObjectAnimation(ANIM1_ID);
		llStartObjectAnimation(ANIM2_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 2)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM1_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 1 is not running");
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM2_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 2 is not running");
			success = FALSE;
		}
		
		llSay(PUBLIC_CHANNEL, "Another start of anim 1");
		llStartObjectAnimation(ANIM1_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 2)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM1_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 1 is not running");
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM2_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 2 is not running");
			success = FALSE;
		}

		llSay(PUBLIC_CHANNEL, "Another start of anim 2");
		llStartObjectAnimation(ANIM2_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 2)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM1_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 1 is not running");
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM2_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 2 is not running");
			success = FALSE;
		}
		
		_test_Result(success);
		_test_Shutdown();
	}
}