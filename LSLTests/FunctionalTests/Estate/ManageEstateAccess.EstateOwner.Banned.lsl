//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        integer result = TRUE;
        
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, llGetOwner()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE");
        if(!llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, llGetOwner()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD: Wrong agent");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE: Wrong agent");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_ADD: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_ADD, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_BANNED_AGENT_REMOVE: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_BANNED_AGENT_REMOVE, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}