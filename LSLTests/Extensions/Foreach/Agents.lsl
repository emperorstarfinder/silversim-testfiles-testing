//#!Mode:ASSL

default
{
	state_entry()
	{
		foreach(agent in Agents)
		{
			llSay(0, agent.Name);
		}
	}
}
