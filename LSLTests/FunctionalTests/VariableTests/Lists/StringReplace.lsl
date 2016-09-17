//#!Enable:Testing

list StringReplacePrepare(string fString, string fSearch)
{
	return llParseStringKeepNulls(fString, [fSearch], []);
}

string StringReplace(string fString, string fSearch, string fReplace )
{
  return llDumpList2String(
	StringReplacePrepare(fString, fSearch), 
	fReplace);
}

default
{
	state_entry()
	{
		string test = "Hallo;Welt";
		string newtest = StringReplace(test, ";", ",");
		_test_Result(TRUE);
		_test_Shutdown();
	}
}