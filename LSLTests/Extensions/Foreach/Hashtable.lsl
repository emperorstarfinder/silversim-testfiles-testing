//#!Mode:ASSL

default
{
	state_entry()
	{
		hashtable a;
		a["Hello"] = 5;
		a["World"] = 6;
		foreach(k,v in a)
		{
			llSay(0, k + " " + v);
		}
	}
}
