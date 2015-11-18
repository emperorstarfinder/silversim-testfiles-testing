localFunc(string command)
{
	integer a = 1;
	if(a)
	{
		integer b;
		for(b = 0; b < 10; ++b)
		{
		}
		++a;
		b = 5;
	}
}

default
{
	state_entry()
	{
		localFunc("");
	}
}
