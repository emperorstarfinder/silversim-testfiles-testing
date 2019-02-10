//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:AgentInventory
//#!Enable:Testing

vieweragent vagent;
vieweragent vcontrolagent;
list inventoryids = [];
list inventorynames = [];
integer success = TRUE;
const key REGION_ID = "39702429-6b4f-4333-bac2-cd7ea688753e";

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        integer controlcircuitcode = (integer)llFrand(100000) + 200000;
        integer circuitcode = (integer)llFrand(100000) + 100000;
        
        key senderagentid = vcCreateAccount("Inventory", "Sender");
        key controlagentid = vcCreateAccount("Inventory", "Receiver");
        _test_AddAvatarName(controlagentid, "Inventory", "Receiver");
        
        vcontrolagent = vcLoginAgent(controlcircuitcode, 
                REGION_ID, 
                controlagentid,
                llGenerateKey(),
                llGenerateKey(),
                "Test Viewer",
                "Test Viewer",
                llMD5String(llGenerateKey(), 0),
                llMD5String(llGenerateKey(), 0),
                TELEPORT_FLAGS_VIALOGIN,
                <128, 128, 23>,
                <1, 0, 0>);
                
        if(!vcontrolagent)
        {
            llSay(PUBLIC_CHANNEL, "Login failed");
            _test_Shutdown();
            return;
        }
        
        vagent = vcLoginAgent(circuitcode, 
                REGION_ID, 
                senderagentid,
                llGenerateKey(),
                llGenerateKey(),
                "Test Viewer",
                "Test Viewer",
                llMD5String(llGenerateKey(), 0),
                llMD5String(llGenerateKey(), 0),
                TELEPORT_FLAGS_VIALOGIN,
                <128, 128, 23>,
                <1, 0, 0>);
        if(!vagent)
        {
            vcontrolagent.Logout();
            llSay(PUBLIC_CHANNEL, "Login failed");
            _test_Shutdown();
            return;
        }
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        if(agent.AgentID == vagent.AgentID)
        {
            vagent.SendCompleteAgentMovement();
        }
        else if(agent.AgentID == vcontrolagent.AgentID)
        {
            vcontrolagent.SendCompleteAgentMovement();
        }
        llSetTimerEvent(2);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        state inventorysetup;
    }
}

state inventorysetup
{
    state_entry()
    {
        vagent.CheckInventory();
        key folderid = vagent.GetFolderForType(AssetType.Notecard);
        vcontrolagent.CheckInventory();

        llSay(PUBLIC_CHANNEL, "Preparing inventory");
        integer v;
        for(v = 0; v < 2; ++v)
        {
            integer everyonemask = 0;
            if(v) everyonemask |= PERM_MOVE;

            string inventoryname = "V" + v;
            key id = vagent.AddInventoryItem(folderid, 
                inventoryname, 
                "", 
                InventoryType.Notecard,
                AssetType.Notecard, 
                "2819d06c-5d08-11e8-a086-448a5b2c3299", 
                0, 
                PERM_ALL, 
                PERM_COPY | PERM_MODIFY | PERM_TRANSFER | PERM_MOVE, 
                everyonemask, 
                everyonemask, 
                PERM_COPY | PERM_MODIFY | PERM_TRANSFER | PERM_MOVE | PERM_EXPORT);
            inventoryids += id;
            inventorynames += inventoryname; 
        }
        state giveinventory;
    }
}

string decodeperms(integer flags)
{
    string res;
    if(flags & PERM_EXPORT)
    {
        res += "X";
    }
    else
    {
        res += "-";
    }
    return res;
}

state giveinventory
{
    integer idx = 0;
    
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Sending " + inventorynames[idx]);
        vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_INVENTORY_OFFERED, llGenerateKey(), 10, "Inventory Sender", inventorynames[idx], vcBuildInventoryOfferedData(AssetType.Notecard, inventoryids[idx]));
    }
    
    improvedinstantmessage_received(
        agentinfo agent, 
        integer fromGroup, 
        key toagentid, 
        integer parentestateid, 
        key regionid, 
        vector position, 
        integer isoffline, 
        integer dialog, 
        key id, 
        long timestamp, 
        string fromagentname, 
        string message, 
        bytearray binarybucket)
    {
        if(dialog != DIALOG_INVENTORY_OFFERED)
        {
            return;
        }
        
        integer assettype = binarybucket[0];
        key inventoryid = binarybucket[1,16].ToKey();
        if(assettype != AssetType.Notecard)
        {
            llSay(PUBLIC_CHANNEL, "AssetType: Mismatch on " + inventorynames[idx] + ": " + assettype);
            success = FALSE;
        }
        
        if(message != inventorynames[idx])
        {
            llSay(PUBLIC_CHANNEL, "Message: Mismatch on " + inventorynames[idx] + ": " + message);
            success = FALSE;
        }
        
        integer baseperm = vcontrolagent.GetInventoryItemBasePerm(inventoryid);
        integer currentperm = vcontrolagent.GetInventoryItemOwnerPerm(inventoryid);
        integer groupperm = vcontrolagent.GetInventoryItemGroupPerm(inventoryid);
        integer everyoneperm = vcontrolagent.GetInventoryItemEveryOnePerm(inventoryid);
        integer nextownerperm = vcontrolagent.GetInventoryItemNextOwnerPerm(inventoryid);
        if((baseperm & PERM_MOVE) == 0)
        {
            llSay(PUBLIC_CHANNEL, "Item missing");
            success = FALSE;
        }
        else
        {
            if((groupperm & PERM_MOVE) != 0)
            {
                llSay(PUBLIC_CHANNEL, "GroupPerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(everyoneperm));
                success = FALSE;
            }
            
            if((everyoneperm & PERM_MOVE) != 0)
            {
                llSay(PUBLIC_CHANNEL, "EveryOnePerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(everyoneperm));
                success = FALSE;
            }
            
            if((nextownerperm & PERM_MOVE) != PERM_MOVE)
            {
                llSay(PUBLIC_CHANNEL, "NextOwnerPerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(nextownerperm));
                success = FALSE;
            }
        }
        
        if(++idx < inventoryids.Length)
        {
            llSay(PUBLIC_CHANNEL, "Sending " + inventorynames[idx]);
            vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_INVENTORY_OFFERED, llGenerateKey(), 10, "Inventory Sender", inventorynames[idx], vcBuildInventoryOfferedData(AssetType.Notecard, inventoryids[idx]));
        }
        else
        {
            state logouttest;
        }
    }    
}

state logouttest
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Requesting logout for Inventory Sender");
        llSetTimerEvent(5);
        vagent.Logout();
    }
    
    logoutreply_received(agentinfo agent)
    {

        llSetTimerEvent(1);
    }
    
    timer()
    {
        state logoutcontrol;
    }
}

state logoutcontrol
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Requesting logout for Inventory Receiver");
        llSetTimerEvent(1);
        vcontrolagent.Logout();
    }
    
    logoutreply_received(agentinfo agent)
    {
        _test_Result(success);
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        _test_Shutdown();
    }
}
