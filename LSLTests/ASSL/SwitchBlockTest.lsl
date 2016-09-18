//#!Mode:assl

string test = "Me";
default
{
	state_entry()
	{
		switch(test)
		{
			case "World":
				llOwnerSay("World");
				break;
			
			case "Program":
				llOwnerSay("Program");
			
			case "Fall-Through":
				llOwnerSay("Fall-Through");
				break;
			
			default:
				llOwnerSay("default");
				break;
		}
		llOwnerSay("me");
	}
}
