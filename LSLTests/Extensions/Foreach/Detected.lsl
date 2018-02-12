//#!Mode:ASSL

default
{
	state_entry()
	{
		foreach(det in Detected)
		{
			llSay(0, det.Key);
		}
	}
}
