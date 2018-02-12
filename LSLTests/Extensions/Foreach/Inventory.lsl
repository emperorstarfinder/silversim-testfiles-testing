//#!Mode:ASSL

default
{
	state_entry()
	{
		foreach(name, type in Inventory)
		{
			llSay(0, name + "|" + type);
		}
		foreach(name in Inventory.Scripts)
		{
			llSay(0, name);
		}
	}
}
