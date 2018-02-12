//#!Mode:ASSL
//#!Enable:bytearray

default
{
	state_entry()
	{
		bytearray a=ByteArray(5);
		foreach(elem in a)
		{
			llSay(0, elem);
		}
	}
}
