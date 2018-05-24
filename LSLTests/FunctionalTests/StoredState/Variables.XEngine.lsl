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
		if(llGetListLength(List2) != 6)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2 failed");
			result = FALSE;
		}
		vector v;
		v = llList2Vector(List2, 0);
		if(llFabs(v.x - 1) > 0.000001 || llFabs(v.y - 2) > 0.000001 || llFabs(v.z - 3) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2[0] failed: " + (string)v);
			result = FALSE;
		}
		rotation r = llList2Rot(List2, 1);
		if(llFabs(r.x - 1) > 0.000001 || llFabs(r.y - 2) > 0.000001 || llFabs(r.z - 3) > 0.000001 || llFabs(r.s - 4) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2[1] failed: " + (string)r);
			result = FALSE;
		}
		float f = llList2Float(List2, 2);
		if(llFabs(f - 0.5) > 0.000001)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2[2] failed: " + (string)f);
			result = FALSE;
		}
		integer i = llList2Integer(List2, 3);
		if(i != 5)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2[3] failed: " + (string)i);
			result = FALSE;
		}
		string s = llList2String(List2, 4);
		if(i != 5)
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2[4] failed: " + s);
			result = FALSE;
		}
		key k = llList2Key(List2, 5);
		if(k != "Key")
		{
			llSay(PUBLIC_CHANNEL, "Restore of List2[5] failed: " + k);
			result = FALSE;
		}
		
		_test_Result(result);
		_test_Shutdown();
	}
}