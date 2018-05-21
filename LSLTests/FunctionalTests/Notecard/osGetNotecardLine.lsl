//#!Mode:assl
//#!Enable:testing

integer line;
integer result;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        result = TRUE;
    
        integer line;
        for(line = 0; line < 12; ++line)
        {
            string data = osGetNotecardLine("Notecard", line);
            if(line == 11)
            {
                if(data != EOF)
                {
                    llSay(PUBLIC_CHANNEL, "FAIL: End of notecard not correctly detected");
                    result = FALSE;
                }
                break;
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
        }
        _test_Result(result);
        _test_Shutdown();
    }
}
