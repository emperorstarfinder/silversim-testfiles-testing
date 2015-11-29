default
{
	state_entry()
	{
		list l;
		l = osGetPrimitiveParams(NULL_KEY, [PRIM_NAME]);
		l = osGetLinkPrimitiveParams(10, [PRIM_NAME]);
		osSetPrimitiveParams(NULL_KEY, [PRIM_NAME, "Hello"]);
		osSetProjectionParams(TRUE, TEXTURE_BLANK, 1, 1, 1);
		osSetProjectionParams(NULL_KEY, TRUE, TEXTURE_BLANK, 1, 1, 1);
		osForceCreateLink(NULL_KEY, 1);
		osForceBreakLink(1);
		osForceBreakAllLinks();
		osSetSpeed(NULL_KEY, 3);
		osMessageObject(NULL_KEY, "Hello");
		string s;
		s = osGetInventoryDesc("Hello");
		key k;
		k = osGetRezzingObject();
		integer i;
		i = osIsUUID(NULL_KEY);
		
	}
}