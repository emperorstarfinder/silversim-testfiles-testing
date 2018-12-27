//#!Mode:ASSL
//#!Enable:Testing

key requrl_id;
string url;
string pathinfo;
integer before;
integer after;

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Http Test");
        _test_Result(FALSE);
		before = llGetFreeURLs();
		llSay(PUBLIC_CHANNEL, "Free Urls Before: " + (string)before);
		requrl_id = llRequestURL();
	}
	
	http_request(key request_id, string method, string body)
	{
		if(request_id == requrl_id)
		{
			if(method == URL_REQUEST_GRANTED)
			{
				after = llGetFreeURLs();
				llSay(PUBLIC_CHANNEL, "Free Urls After: " + (string)after);
				llSay(PUBLIC_CHANNEL, "Http Url: " + body);
				url = body;
				llHTTPRequest(url + "/my-path", [], "");
			}
			else
			{
				llSay(PUBLIC_CHANNEL, "Failed to acquire URL");
			}
		}
		else
		{
			pathinfo = llGetHTTPHeader(request_id, "x-path-info");
			llSay(PUBLIC_CHANNEL, "x-path-info: " + pathinfo);
			llHTTPResponse(request_id, 200, "Http Test");
		}
	}
	
	http_response(key reqid, integer status, list metadata, string body)
	{
		llSay(PUBLIC_CHANNEL, "Received: " + body);
		_test_Result(status == 200 && body == "Http Test" && pathinfo == "/my-path" && after + 1 == before);
        _test_Shutdown();
	}
}
