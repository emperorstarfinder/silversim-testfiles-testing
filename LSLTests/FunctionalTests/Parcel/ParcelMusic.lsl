//#!Enable:Testing
//#!Mode:assl

string URL_1 = "http://example.com/stream1";
string URL_2 = "http://example.com/stream2";

default
{
	state_entry()
	{
		asSetForcedSleep(FALSE, 0);
		integer pass = TRUE;
		llSetParcelMusicURL(URL_1);
		if(llGetParcelMusicURL() != URL_1)
		{
			llSay(PUBLIC_CHANNEL, "Failed to set first URL");
			pass = FALSE;
		}
		llSetParcelMusicURL(URL_2);
		if(llGetParcelMusicURL() != URL_2)
		{
			llSay(PUBLIC_CHANNEL, "Failed to set second URL");
			pass = FALSE;
		}
		llSetParcelMusicURL("");
		if(llGetParcelMusicURL() != "")
		{
			llSay(PUBLIC_CHANNEL, "Failed to clear URL");
			pass = FALSE;
		}
		_test_Result(pass);
		_test_Shutdown();
	}
}
