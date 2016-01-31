default
{
	state_entry()
	{
		osForceAttachToOtherAvatarFromInventory(NULL_KEY, "Hello", 10);
		list at = osGetNumberOfAttachments(NULL_KEY, [ATTACH_HEAD, ATTACH_LHAND, ATTACH_RHAND]);
		osDropAttachmentAt(<1,1,1>, ZERO_ROTATION);
		osForceDropAttachmentAt(<1,1,1>,ZERO_ROTATION);
	}
}