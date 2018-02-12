//#!Mode:ASSL

default
{
	state_entry()
	{
		foreach(line in Notecard["config"])
		{
			llSay(0, line);
		}
	}
}
