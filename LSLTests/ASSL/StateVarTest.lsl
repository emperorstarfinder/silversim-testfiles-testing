//#!Mode:assl

string test = "Global";

default
{
	string test = "Hello";
	state_entry()
	{
		llOwnerSay(test);
	}
}

state s2
{
	string test = "World";
	state_entry()
	{
		llOwnerSay(test);
	}
}

state g
{
	state_entry()
	{
		llOwnerSay(test);
	}
}