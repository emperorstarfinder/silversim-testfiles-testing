default
{
	state_entry()
	{
		string s;
		s = osFormatString("{0} {1}", ["a", "b"]);
		list l;
		l = osMatchString(s, "a", 0);
		s = osUnixTimeToTimestamp(0);
		float a;
		a = osMax(1, 2);
		a = osMin(1, 2);
		integer i;
		i = osRegexIsMatch("a", "/a/");
		s = osReplaceString("a b", "a", "c", -1, 0);
	}
}