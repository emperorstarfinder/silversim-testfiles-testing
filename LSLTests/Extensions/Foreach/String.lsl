//#!Mode:ASSL

default
{
	state_entry()
	{
		string a = "Hallo";
		foreach(elem in a)
		{
			llSay(0, elem);
		}
	}
}
