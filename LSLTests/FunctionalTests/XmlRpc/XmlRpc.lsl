//#!Mode:ASSL
//#!Enable: Testing

key ownedchannel;
integer success = TRUE;

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
			ownedchannel = channel;
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
			llSay(PUBLIC_CHANNEL, "Sender: " + sender);
			llSay(PUBLIC_CHANNEL, "idata: " + (string)idata);
			llSay(PUBLIC_CHANNEL, "sdata: " + sdata);
			if(idata != 10 || sdata != "str")
			{
				llSay(PUBLIC_CHANNEL, "!! Mismatch at response");
				success = FALSE;
			}
			state closechannel;
		}
    }
}

state closechannel
{
	state_entry()
	{
		llCloseRemoteDataChannel(ownedchannel);
		llSendRemoteData(ownedchannel, "http://127.0.0.1:9300/", 10, "str");
	}
		
	remote_data( integer event_type, key channel, key message_id, string sender, integer idata, string sdata )
    {
		if(event_type == REMOTE_DATA_REPLY)
		{
			llSay(PUBLIC_CHANNEL, "Failed response received");
			llSay(PUBLIC_CHANNEL, "Sender: " + sender);
			llSay(PUBLIC_CHANNEL, "idata: " + (string)idata);
			llSay(PUBLIC_CHANNEL, "sdata: " + sdata);
			if(idata != 1 || sdata != "Unknown channel")
			{
				llSay(PUBLIC_CHANNEL, "!! Mismatch at failed response");
				success = FALSE;
			}
			_test_Result(success);
			_test_Shutdown();
		}
    }
}