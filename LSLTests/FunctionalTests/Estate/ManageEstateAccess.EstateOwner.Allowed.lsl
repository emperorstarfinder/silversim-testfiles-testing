//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        integer result = TRUE;
        
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_ADD");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_ADD, llGetOwner()))
        {
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_REMOVE");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_REMOVE, llGetOwner()))
        {
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}