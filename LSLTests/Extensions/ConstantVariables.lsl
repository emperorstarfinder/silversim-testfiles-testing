//#!Mode:ASSL
//#!Enable:PureFunctions

const string HALLO_WELT = "Hallo,Welt!";

default
{
	state_entry()
	{
		llOwnerSay(HALLO_WELT);
	}
}