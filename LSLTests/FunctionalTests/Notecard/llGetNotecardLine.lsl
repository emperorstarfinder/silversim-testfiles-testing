//#!Enable:testing

key q;
integer line;
integer result;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        result = TRUE;
        q = llGetNotecardLine("Notecard", line);
    }
    
    dataserver(key r, string data)
    {
        if(r != q)
        {
            llSay(PUBLIC_CHANNEL, "Invalid query response on line " + (string)line + ": " + r + "!=" + q);
            result = FALSE;
        }
        if(line == 11)
        {
            if(data != EOF)
            {
                llSay(PUBLIC_CHANNEL, "FAIL: End of notecard not correctly detected");
                result = FALSE;
            }
            _test_Result(result);
            _test_Shutdown();
            return;
        }
        
        data = llStringTrim(data, STRING_TRIM);
        
        if(line == 10)
        {
            if(data != "")
            {
                llSay(PUBLIC_CHANNEL, "FAIL: Content of line number " + (string)line + " = '" + (string)data + "'");
                result = FALSE;
            }
        }
        else if((string)line != data)
        {
            llSay(PUBLIC_CHANNEL, "FAIL: Content of line number " + (string)line + " = '" + (string)data + "'");
            result = FALSE;
        }
        ++line;
        q = llGetNotecardLine("Notecard", line);
    }
}
