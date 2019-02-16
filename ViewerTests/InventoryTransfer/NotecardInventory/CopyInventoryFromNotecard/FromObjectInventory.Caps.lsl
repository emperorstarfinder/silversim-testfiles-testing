//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

integer circuitcode;
key sessionid;
key securesessionid;
vieweragent vagent;
key agentid;
string capsuri;
const key NCITEMID = "874cca63-fbde-43fc-a38c-d6748b3d0ba2";
const key NCITEMINVENTORYID = "cab22caa-7484-4487-b151-308ad1967841";
integer success = TRUE;

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
        hashtable capsresult = vcSeedRequest(vagent.CapsPath, ["CopyInventoryFromNotecard"]);
        capsuri = capsresult["CopyInventoryFromNotecard"];
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        vagent.SendCompleteAgentMovement();
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        state copyfromnotecard;
    }
}

state copyfromnotecard
{
    state_entry()
    {
        vagent.CheckInventory();
        capsCopyInventoryFromNotecard(capsuri, NULL_KEY, llGetKey(), NCITEMID, NCITEMINVENTORYID, 1);
    }
    
    updatecreateinventoryitem_received(agentinfo agent, integer simapproved, key transactionid, updateinventoryitemlist items)
    {
        foreach(item in items)
        {
            llSay(PUBLIC_CHANNEL, "Item created");
            if(item.CallbackID != 1)
            {
                llSay(PUBLIC_CHANNEL, "Item callbackid mismatch");
                success = FALSE;
            }
            state logout;
        }
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
        _test_Result(success);
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        _test_Shutdown();
    }
}