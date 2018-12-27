//#!Mode:ASSL
//#!Enable: Testing

default
{
	state_entry()
	{
        _test_Result(FALSE);
		llOpenRemoteDataChannel();
	}

	remote_data( integer event_type, key channel, key message_id, string sender, integer idata, string sdata )
    {
        if (event_type == REMOTE_DATA_CHANNEL) 
		{ // channel created
			llSay(PUBLIC_CHANNEL, "Channel created: "+ (string)channel);
			llSendRemoteData(channel, "http://127.0.0.1:9300/", 10, "str");
        }
		if(event_type == REMOTE_DATA_REQUEST)
		{
			llSay(PUBLIC_CHANNEL, "Request received");
			llRemoteDataReply(channel, message_id, sdata, idata);
		}
		if(event_type == REMOTE_DATA_REPLY)
		{
			llSay(PUBLIC_CHANNEL, "Response received");
			_test_Result(idata == 10 && sdata == "str");
			_test_Shutdown();
		}
    }
}