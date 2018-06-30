default
{
	state_entry()
	{
		integer cnt;
		{
			@mylabel;
			if(cnt)
			{
				jump mylabel;
			}
		}
		{
			@mylabel;
			if(cnt)
			{
				jump mylabel;
			}
		}
	}
}