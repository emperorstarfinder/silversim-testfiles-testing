//#!Mode:ASSL

default
{
	state_entry()
	{
		long a = 5;
		long b = 5;
		long c = a + b;
		
		llSay(0, (string)c);
	}
}