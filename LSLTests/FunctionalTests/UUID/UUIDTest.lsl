//#!Enable:Testing

default
{
    state_entry()
    {
        integer val = TRUE;
        _test_Result(FALSE);
        
        key a = llGenerateKey();
        key b = llGenerateKey();
        
        if(a == b)
        {
            llSay(PUBLIC_CHANNEL, "llGenerateKey is not generating random keys");
            val = FALSE;
        }
        
        if(!osIsUUID(a))
        {
            llSay(PUBLIC_CHANNEL, "osIsUUID is not detecting key a to be a UUID");
            val = FALSE;
        }
        
        if(!osIsUUID(b))
        {
            llSay(PUBLIC_CHANNEL, "osIsUUID is not detecting key b to be a UUID");
            val = FALSE;
        }
        
        if(osIsUUID(""))
        {
            llSay(PUBLIC_CHANNEL, "osIsUUID is not detecting string \"\" being something else");
            val = FALSE;
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}