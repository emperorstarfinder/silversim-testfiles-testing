//#!Mode:ASSL

default
{
	state_entry()
	{
		this.Name = "Hello, World";
		llSay(0, this.Name);
		llSay(0, this.Description);
	}
}
