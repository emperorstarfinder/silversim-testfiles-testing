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
		
		llSay(PUBLIC_CHANNEL, "Test initial status of animesh");
		list anims = llGetObjectAnimationNames();
		integer cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		
		llSay(PUBLIC_CHANNEL, "Starting anim 1");
		llStartObjectAnimation(ANIM1_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 1)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM1_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 1 is not running");
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM2_ID]) >= 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 2 is running");
			success = FALSE;
		}
		
		llSay(PUBLIC_CHANNEL, "Starting anim 2");
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
		
		llSay(PUBLIC_CHANNEL, "Stopping anim 1");
		llStopObjectAnimation(ANIM1_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 1)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM1_ID]) >= 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 1 is running");
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM2_ID]) < 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 2 is not running");
			success = FALSE;
		}
		
		llSay(PUBLIC_CHANNEL, "Stopping anim 2");
		llStopObjectAnimation(ANIM2_ID);
		anims = llGetObjectAnimationNames();
		cnt = anims.Length;
		llSay(PUBLIC_CHANNEL, "Anims: " + llList2CSV(anims));
		
		if(cnt != 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Wrong cnt " + cnt);
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM1_ID]) >= 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 1 is running");
			success = FALSE;
		}
		if(llListFindList(anims, [ANIM2_ID]) >= 0)
		{
			llSay(PUBLIC_CHANNEL, "ERROR! Anim 2 is running");
			success = FALSE;
		}
		
		_test_Result(success);
		_test_Shutdown();
	}
}