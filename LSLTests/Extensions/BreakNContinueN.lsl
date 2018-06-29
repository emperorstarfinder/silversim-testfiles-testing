//#!Mode:ASSL

default
{
	state_entry()
	{
		integer i;
		integer j;
		for(j = 0; j < 10; ++j)
		{
			for(i = 0; i < 10; ++i)
			{
				if(i == 5)
				{
					continue 2;
				}
				if(i == 8)
				{
					break 2;
				}
			}
		}
	}
}