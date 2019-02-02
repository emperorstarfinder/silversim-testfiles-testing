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
        
        llSay(PUBLIC_CHANNEL, "llAddToLandBanList");
        llAddToLandBanList(otheragentid, 0);
        list banlist = _test_GetLandBanList();
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llRemoveFromLandBanList");
        llRemoveFromLandBanList(otheragentid);
        if(_test_GetLandBanList().Length != 0)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llAddToLandBanList");
        llAddToLandBanList(otheragentid, 0);
        banlist = _test_GetLandBanList();
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llResetLandBanList");
        llResetLandBanList();
        if(_test_GetLandBanList().Length != 0)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "**** Test Multiple ****");
        llSay(PUBLIC_CHANNEL, "llAddToLandBanList");
        llAddToLandBanList(otheragentid, 0);
        banlist = _test_GetLandBanList();
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llAddToLandBanList");
        llAddToLandBanList(otheragentid2, 0);
        banlist = _test_GetLandBanList();
        if(banlist.Length != 6)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        llSay(PUBLIC_CHANNEL, "llRemoveFromLandBanList");
        llRemoveFromLandBanList(otheragentid);
        if(_test_GetLandBanList().Length != 3)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        if(banlist[0] != otheragentid)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }        
        
        llSay(PUBLIC_CHANNEL, "llResetLandBanList");
        llResetLandBanList();
        if(_test_GetLandBanList().Length != 0)
        {
            result = FALSE;
            llSay(PUBLIC_CHANNEL, "Fail");
        }
        
        _test_Result(result);
        _test_Shutdown();
    }
}