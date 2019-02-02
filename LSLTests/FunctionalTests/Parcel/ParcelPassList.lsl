//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        integer result = TRUE;
        key otheragentid = llGenerateKey();
        _test_AddAvatarName(otheragentid, "List", "Test");
        key otheragentid2 = llGenerateKey();
        _test_AddAvatarName(otheragentid2, "List", "Test");
        
        llSay(PUBLIC_CHANNEL, "llAddToLandPassList");
        llAddToLandPassList(otheragentid, 0);
        list banlist = _test_GetLandPassList();
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llRemoveFromLandPassList");
        llRemoveFromLandPassList(otheragentid);
        if(_test_GetLandPassList().Length != 0)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llAddToLandPassList");
        llAddToLandPassList(otheragentid, 120);
        banlist = _test_GetLandPassList();
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llResetLandPassList");
        llResetLandPassList();
        if(_test_GetLandPassList().Length != 0)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "**** Test Multiple ****");
        llSay(PUBLIC_CHANNEL, "llAddToLandPassList");
        llAddToLandPassList(otheragentid, 120);
        banlist = _test_GetLandPassList();
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llAddToLandPassList");
        llAddToLandPassList(otheragentid2, 120);
        banlist = _test_GetLandPassList();
        if(banlist.Length != 6)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llRemoveFromLandPassList");
        llRemoveFromLandPassList(otheragentid);
        if(_test_GetLandPassList().Length != 3)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }        
        
        llSay(PUBLIC_CHANNEL, "llResetLandPassList");
        llResetLandPassList();
        if(_test_GetLandPassList().Length != 0)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        _test_Result(result);
        _test_Shutdown();
    }
}