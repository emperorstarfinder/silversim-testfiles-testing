//#!Mode:ASSL

default
{
	state_entry()
	{
		list a = [1,2,3];
		
		llSay(0, a[-1]);
	}
}