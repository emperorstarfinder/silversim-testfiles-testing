//#!Mode:ASSL

default
{
	state_entry()
	{
		integer i;
		
		switch(i)
		{
			case 4:
				break;
			
			case 5:
				break;
			
			case 6:
			case 7:
				llSay(0, "Hello");
			default:
				break;
		}
	}
}