//#!Mode:ASSL

default
{
	state_entry()
	{
		char c= 'E';
		string h = "Hello";
		h[1] = c;
		llSay(0, h[1]);
	}
}