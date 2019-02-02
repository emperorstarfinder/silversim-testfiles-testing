//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        integer result = TRUE;
        key groupid = llGenerateKey();
        _test_AddGroupName(groupid, "List Test");
        
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_ADD: Valid Group");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_ADD, groupid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        list grouplist = _test_GetEstateAllowedGroupsList();
        if(grouplist.Length != 3)
        {
            llSay(PUBLIC_CHANNEL, "Fail: List length not correct");
            result = FALSE;
        }
        if(grouplist[0] != groupid)
        {
            llSay(PUBLIC_CHANNEL, "Fail: Group not added");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE: Valid Group");
        if(!llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_REMOVE, groupid))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        grouplist = _test_GetEstateAllowedGroupsList();
        if(grouplist.Length != 0)
        {
            llSay(PUBLIC_CHANNEL, "Fail: List length not correct");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_ADD: Wrong group");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_ADD, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE: Wrong group");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_REMOVE, llGenerateKey()))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_ADD: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_ADD, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        llSay(PUBLIC_CHANNEL, "ESTATE_ACCESS_ALLOWED_GROUP_REMOVE: NULL_KEY");
        if(llManageEstateAccess(ESTATE_ACCESS_ALLOWED_GROUP_REMOVE, NULL_KEY))
        {
            llSay(PUBLIC_CHANNEL, "Fail");
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}