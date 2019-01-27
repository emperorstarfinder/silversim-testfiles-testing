//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer circuitcode;
key sessionid;
key securesessionid;
vieweragent vagent;
key agentid;
integer result = TRUE;

list expectedcaps = [
    "AvatarPickerSearch",
    "GroupMemberData",
    "RegionExperiences",
    "IsExperienceContributor",
    "IsExperienceAdmin",
    "UpdateExperience",
    "GroupExperiences",
    "ExperiencePreferences",
    "GetCreatorExperiences",
    "GetAdminExperiences",
    "GetExperienceInfo",
    "FindExperienceByName",
    "AgentExperiences",
    "GetExperiences",
    "GetMetadata",
    "SimulatorFeatures",
    "UpdateAgentLanguage",
    "EnvironmentSettings",
    "RenderMaterials",
    "SimConsoleAsync",
    "EventQueueGet",
    "GetTexture",
    "GetMesh",
    "GetMesh2",
    "GetDisplayNames",
    "MeshUploadFlag",
    "GetPhysicsObjectData",
    "ChatSessionRequest",
    "DispatchRegionInfo",
    "CopyInventoryFromNotecard",
    "ParcelPropertiesUpdate",
    "AgentPreferences",
    "ObjectAdd",
    "UploadBakedTexture",
    "NewFileAgentInventory",
    "NewFileAgentInventoryVariablePrice",
    "UpdateGestureAgentInventory",
    "UpdateNotecardAgentInventory",
    "UpdateSettingsAgentInventory",
    "UpdateScriptAgent",
    "UpdateScriptTask",
    "UpdateGestureTaskInventory",
    "UpdateNotecardTaskInventory",
    "UpdateSettingsTaskInventory",
    "ParcelNavigateMedia",
    "ObjectMedia",
    "ObjectMediaNavigate",
    "UpdateAvatarAppearance",
    "LandResources",
    "AttachmentResources",
    "ResourceCostSelected",
    "ViewerStats",
    "ViewerMetrics",
    "GetObjectCost",
    "CreateInventoryCategory",
    "InventoryAPIv3",
    "FetchInventory2",
    "FetchInventoryDescendents2"
];

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        circuitcode = (integer)llFrand(100000) + 100000;
        sessionid = llGenerateKey();
        securesessionid = llGenerateKey();
        
        agentid = vcCreateAccount("Login", "Test");
        
        vagent = vcLoginAgent(circuitcode, 
                "39702429-6b4f-4333-bac2-cd7ea688753e", 
                agentid,
                sessionid,
                securesessionid,
                "Test Viewer",
                "Test Viewer",
                llMD5String(llGenerateKey(), 0),
                llMD5String(llGenerateKey(), 0),
                TELEPORT_FLAGS_VIALOGIN,
                <128, 128, 23>,
                <1, 0, 0>);
        if(!vagent)
        {
            llSay(PUBLIC_CHANNEL, "Login failed");
            _test_Shutdown();
            return;
        }
        hashtable capsresult = vcSeedRequest(vagent.CapsPath, expectedcaps);
        foreach(capname in expectedcaps)
        {
            string actcapname = capname;
            if(capsresult.ContainsKey(actcapname))
            {
                llSay(PUBLIC_CHANNEL, capname + " => " + capsresult[actcapname]);
            }
        }
        integer count = 0;
        foreach(capname in expectedcaps)
        {
            string actcapname = capname;
            if(!capsresult.ContainsKey(actcapname))
            {
                llSay(PUBLIC_CHANNEL, "Capability " + capname + " is missing");
                result = FALSE;
                ++count;
            }
        }
        llSay(PUBLIC_CHANNEL, "Tested " + expectedcaps.Length + " capabilities");
        llSay(PUBLIC_CHANNEL, "Missing: " + count);
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        vagent.SendCompleteAgentMovement();
        llSetTimerEvent(2);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        state logout;
    }
}

state logout
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Requesting logout");
        llSetTimerEvent(1);
        vagent.Logout();
    }
    
    logoutreply_received(agentinfo agent)
    {
        llSay(PUBLIC_CHANNEL, "Logout confirmed");
        _test_Result(result);
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        _test_Shutdown();
    }
}