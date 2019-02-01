//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        integer result = TRUE;
        key otheragentid = llGenerateKey();
        _test_AddAvatarName(otheragentid, "List", "Test");
        
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_ADD: Estate Owner");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_ADD, llGetOwner()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_REMOVE: Estate Owner");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_REMOVE, llGetOwner()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_ADD: Other agent");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_ADD, otheragentid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_REMOVE: Other agent");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_REMOVE, otheragentid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_ADD: Wrong agent");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_ADD, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_REMOVE: Wrong agent");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_REMOVE, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_ADD: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_ADD, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_AGENT_REMOVE: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_AGENT_REMOVE, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}