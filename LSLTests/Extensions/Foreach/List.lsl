//#!Mode:ASSL

default
{
	state_entry()
	{
		list a = [1,2,3];
		foreach(elem in a)
		{
			llSay(0, elem);
		}
	}
}
