//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:AgentInventory
//#!Enable:Testing

const integer ASSET_TYPE = AssetType.Object;
const integer INVENTORY_TYPE = InventoryType.Object;
const key ASSET_ID = "2edcee9f-fda5-484c-acb1-21d4182cc2b7";
const integer CHECK_FLAGS = 0xF1100;

vieweragent vagent;
vieweragent vcontrolagent;
list inventoryids = [];
list inventorypermmasks = [];
list inventorynames = [];
integer success = TRUE;
const key REGION_ID = "39702429-6b4f-4333-bac2-cd7ea688753e";
const integer CHECK_PERM = PERM_MODIFY | PERM_TRANSFER | PERM_COPY;

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
        key folderid = vagent.GetFolderForType(ASSET_TYPE);
        vcontrolagent.CheckInventory();

        llSay(PUBLIC_CHANNEL, "Preparing inventory");
        integer m;
        integer t;
        for(m = 0; m < 2; ++m)
        {
            for(t = 0; t < 2; ++t)
            {
                integer nextownermask = 0;
                if(m) nextownermask |= PERM_MODIFY;
                if(t) nextownermask |= PERM_TRANSFER;

                string inventoryname = "NoCopy M" + m + "-T" + t;
                key id = vagent.AddInventoryItem(folderid, 
                    inventoryname, 
                    "", 
                    INVENTORY_TYPE,
                    ASSET_TYPE, 
                    ASSET_ID, 
                    0, 
                    PERM_MODIFY | PERM_TRANSFER | PERM_MOVE | PERM_EXPORT, 
                    PERM_MODIFY | PERM_TRANSFER | PERM_MOVE, 
                    0, 
                    0, 
                    nextownermask);
                inventoryids += id;
                inventorynames += inventoryname; 
                inventorypermmasks += nextownermask;
            }
        }
        state giveinventory;
    }
}

string decodeperms(integer flags)
{
    string res;
    if(flags & PERM_COPY)
    {
        res += "C";
    }
    else
    {
        res += "-";
    }
    if(flags & PERM_MODIFY)
    {
        res += "M";
    }
    else
    {
        res += "-";
    }
    if(flags & PERM_TRANSFER)
    {
        res += "T";
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
        vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_INVENTORY_OFFERED, llGenerateKey(), 10, "Inventory Sender", inventorynames[idx], vcBuildInventoryOfferedData(ASSET_TYPE, inventoryids[idx]));
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
        if(assettype != ASSET_TYPE)
        {
            llSay(PUBLIC_CHANNEL, "AssetType: Mismatch on " + inventorynames[idx] + ": " + assettype);
            success = FALSE;
        }
        
        if(message != inventorynames[idx])
        {
            llSay(PUBLIC_CHANNEL, "Message: Mismatch on " + inventorynames[idx] + ": " + message);
            success = FALSE;
        }
        
        agentinventory srcinvaccess = vcontrolagent.GetLocalAgentInventory();
        key originid = inventoryids[idx];
        if(srcinvaccess.Items[originid])
        {
            llSay(PUBLIC_CHANNEL, "No Copy item was not deleted");
            success = FALSE;
        }
        
        agentinventory invaccess = vcontrolagent.GetLocalAgentInventory();
        agentinventoryitem item = invaccess.Items[inventoryid];
        if(!item)
        {
            llSay(PUBLIC_CHANNEL, "Item missing");
            success = FALSE;
        }
        else
        {
            integer baseperm = item.BasePermissions;
            integer currentperm = item.CurrentPermissions;
            integer groupperm = item.GroupPermissions;
            integer everyoneperm = item.EveryOnePermissions;
            integer nextownerperm = item.NextOwnerPermissions;
            integer expectedperm = inventorypermmasks[idx];
            
            if((item.Flags & CHECK_FLAGS) != CHECK_FLAGS)
            {
                llSay(PUBLIC_CHANNEL, "Flags: Mismatch on " + inventorynames[idx] + ": cur=" + (item.Flags & CHECK_FLAGS) + " exp=" + CHECK_FLAGS);
                success = FALSE;
            }
            
            if((baseperm & CHECK_PERM) != (expectedperm & CHECK_PERM))
            {
                llSay(PUBLIC_CHANNEL, "BasePerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(baseperm) + " exp=" + decodeperms(expectedperm));
                success = FALSE;
            }
            
            if((currentperm & CHECK_PERM) != (expectedperm & CHECK_PERM))
            {
                llSay(PUBLIC_CHANNEL, "CurrentPerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(currentperm) + " exp=" + decodeperms(expectedperm));
                success = FALSE;
            }
            
            if(0 != (groupperm & CHECK_PERM))
            {
                llSay(PUBLIC_CHANNEL, "GroupPerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(groupperm));
                success = FALSE;
            }
            
            if(0 != (everyoneperm & CHECK_PERM))
            {
                llSay(PUBLIC_CHANNEL, "EveryOnePerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(everyoneperm));
                success = FALSE;
            }
            
            if((nextownerperm & CHECK_PERM) != (expectedperm & CHECK_PERM))
            {
                llSay(PUBLIC_CHANNEL, "NextOwnerPerms: Mismatch on " + inventorynames[idx] + ": cur=" + decodeperms(nextownerperm) + " exp=" + decodeperms(expectedperm));
                success = FALSE;
            }
        }
        
        if(++idx < inventoryids.Length)
        {
            llSay(PUBLIC_CHANNEL, "Sending " + inventorynames[idx]);
            vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_INVENTORY_OFFERED, llGenerateKey(), 10, "Inventory Sender", inventorynames[idx], vcBuildInventoryOfferedData(ASSET_TYPE, inventoryids[idx]));
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
