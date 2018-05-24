//#!Enable:testing

rotation Rotation;
vector Vector;
integer Integer;
float Float;
string String;
list List1;
key Key;
list List2;

default
{
	state_entry()
	{
	}
	
	timer()
	{
		llSetTimerEvent(0);
		integer result = TRUE;
		if(llGetStartParameter() != 5)
		{
			llSay(PUBLIC_CHANNEL, "Restore of StartParameter failed: " + (string)llGetStartParameter());
			result = FALSE;
		}
		if(llFabs(Rotation.x - 1) > 0.000001 || 
			llFabs(Rotation.y - 2) > 0.000001 || 
			llFabs(Rotation.z - 3) > 0.000001 || 
			llFabs(Rotation.s - 4) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Restore of Rotation failed: " + (string)Rotation);
			result = FALSE;
		}
		if(llFabs(Vector.x - 1) > 0.000001 || 
			llFabs(Vector.y - 2) > 0.000001 || 
			llFabs(Vector.z - 3) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Restore of Vector failed: " + (string)Vector);
			result = FALSE;
		}
		if(Integer != 2)
		{
			llSay(PUBLIC_CHANNEL, "Restore of Integer failed: " + (string)Integer);
			result = FALSE;
		}
		if(llFabs(Float - 3) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Restore of Float failed: " + (string)Float);
			result = FALSE;
		}
		if(String != "Value")
		{
			llSay(PUBLIC_CHANNEL, "Restore of String failed: " + (string)String);
			result = FALSE;
		}
		if(List1 != [])
		{
			llSay(PUBLIC_CHANNEL, "Restore of List1 failed: " + (string)List1);
			result = FALSE;
		}
		if(Key != "key")
		{
			llSay(PUBLIC_CHANNEL, "Restore of Key failed: " + Key);
			result = FALSE;
		}
		if(llGetListLength(List2) != 5)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2 failed");
			result = FALSE;
		}
		_test_Result(result);
		_test_Shutdown();
	}
}