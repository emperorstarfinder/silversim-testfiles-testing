default
{
	state_entry()
	{
		lsSetWindlightScene([]);
		llRegionSayTo(NULL_KEY, PUBLIC_CHANNEL, "test");
	}
}