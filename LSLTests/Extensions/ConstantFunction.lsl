//#!Mode:ASSL
//#!Enable:PureFunctions
default
{
	state_entry()
	{
		float b = llCos(1);
		string a = "Hallo".Trim(STRING_TRIM);
		llOwnerSay(a);
	}
}