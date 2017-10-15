default
{
	state_entry()
	{
		string val;
		val = llJsonSetValue("[]", [0], "a");
		val = llList2Json(JSON_OBJECT, ["a", "b"]);
		list l = llJson2List(val);
		val = llJsonGetValue(val, ["a"]);
		val = llJsonValueType(val, ["a"]);
	}
}
