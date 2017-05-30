//#!Mode:ASSL

default
{
	state_entry()
	{
		this.Name = "Hallo, Welt";
		llSay(0, this.Name);
		llSay(0, this.Description);
	}
}
