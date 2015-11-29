default
{
	state_entry()
	{
		string s;
		list l;
		key k;
		
		s = osGetAgentIP(NULL_KEY);
		l = osGetAgents();
		l = osGetAvatarList();
		k = osAvatarName2Key("Test", "User");
		integer i;
		s = osGetGender(k);
		s = osKey2Name(k);
	}
}
