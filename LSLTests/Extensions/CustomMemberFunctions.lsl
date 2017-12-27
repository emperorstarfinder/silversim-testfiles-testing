//#!Mode:ASSL

integer StringValues(this string v)
{
	return v.Length;
}

default
{
	state_entry()
	{
		string mystr = "MyStr";
		integer l = mystr.StringValues();
	}
}
