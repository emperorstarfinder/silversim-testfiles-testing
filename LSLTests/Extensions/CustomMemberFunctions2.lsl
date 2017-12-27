//#!Mode:ASSL

integer StringValues(this string v)
{
	return v.Length;
}

default
{
	state_entry()
	{
		integer l = "MyStr".StringValues();
	}
}
