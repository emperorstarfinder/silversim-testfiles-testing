//#!Mode:ASSL

default
{
	state_entry()
	{
		string mystr = "Hello";
		string newstr = mystr.Substring(0, 1);
	}
}