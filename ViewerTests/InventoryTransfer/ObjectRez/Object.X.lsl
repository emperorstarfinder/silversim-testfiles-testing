//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:AgentInventory
//#!Enable:Testing

const integer ASSET_TYPE = AssetType.Object;
const integer INVENTORY_TYPE = InventoryType.Object;
const key ASSET_ID = "2edcee9f-fda5-484c-acb1-21d4182cc2b7";
const integer CHECK_FLAGS = 0xF1100;
key rezzableinventoryid;
integer rezzableidx = 0;
key rezzedobjectid;
integer rezzedobjectlocalid;

vieweragent vagent;
vieweragent vcontrolagent;
list inventoryids = [];
list inventorypermmasks = [];
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
        key folderid = vagent.GetFolderForType(ASSET_TYPE);
        vcontrolagent.CheckInventory();

        llSay(PUBLIC_CHANNEL, "Preparing inventory");
        integer x;
        for(x = 0; x < 2; ++x)
        {
            integer everyonemask = 0;
            if(x) everyonemask |= PERM_EXPORT;

            string inventoryname = "X" + x;
            key id = vagent.AddInventoryItem(folderid, 
                inventoryname, 
                "", 
                INVENTORY_TYPE,
                ASSET_TYPE, 
                ASSET_ID, 
                1048576, 
                PERM_ALL | PERM_EXPORT, 
                PERM_COPY | PERM_MODIFY | PERM_TRANSFER | PERM_MOVE | PERM_EXPORT, 
                0, 
                everyonemask, 
                PERM_COPY | PERM_MODIFY | PERM_TRANSFER | PERM_MOVE | everyonemask);
            inventoryids += id;
            inventorynames += inventoryname; 
            inventorypermmasks += everyonemask;
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
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Sending " + inventorynames[rezzableidx]);
        vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_INVENTORY_OFFERED, llGenerateKey(), 10, "Inventory Sender", inventorynames[rezzableidx], vcBuildInventoryOfferedData(ASSET_TYPE, inventoryids[rezzableidx]));
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
            llSay(PUBLIC_CHANNEL, "AssetType: Mismatch on " + inventorynames[rezzableidx] + ": " + assettype);
            success = FALSE;
        }
        
        if(message != inventorynames[rezzableidx])
        {
            llSay(PUBLIC_CHANNEL, "Message: Mismatch on " + inventorynames[rezzableidx] + ": " + message);
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
            integer expectedperm = inventorypermmasks[rezzableidx];
        
            if((item.Flags & CHECK_FLAGS) != CHECK_FLAGS)
            {
                llSay(PUBLIC_CHANNEL, "Flags: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + (item.Flags & CHECK_FLAGS) + " exp=" + CHECK_FLAGS);
                success = FALSE;
            }
            
            if((baseperm & PERM_EXPORT) != (expectedperm & PERM_EXPORT))
            {
                llSay(PUBLIC_CHANNEL, "BasePerms: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + decodeperms(baseperm) + " exp=" + decodeperms(expectedperm));
                success = FALSE;
            }
            
            if((everyoneperm & PERM_EXPORT) != (expectedperm & PERM_EXPORT))
            {
                llSay(PUBLIC_CHANNEL, "EveryOnePerms: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + decodeperms(everyoneperm));
                success = FALSE;
            }
            
            if((nextownerperm & PERM_EXPORT) != (expectedperm & PERM_EXPORT))
            {
                llSay(PUBLIC_CHANNEL, "NextOwnerPerms: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + decodeperms(nextownerperm) + " exp=" + decodeperms(expectedperm));
                success = FALSE;
            }
        }
        
        if(item)
        {
            rezzableinventoryid = inventoryid;
            state rezinventory;
        }
        else if(++rezzableidx < inventoryids.Length)
        {
            llSay(PUBLIC_CHANNEL, "Sending " + inventorynames[rezzableidx]);
            vagent.SendInstantMessage(FALSE, vcontrolagent.AgentID, 1, REGION_ID, llGetPos(), FALSE, DIALOG_INVENTORY_OFFERED, llGenerateKey(), 10, "Inventory Sender", inventorynames[rezzableidx], vcBuildInventoryOfferedData(ASSET_TYPE, inventoryids[rezzableidx]));
        }
        else
        {
            state logouttest;
        }
    }    
}

state rezinventory
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Rezzing " + inventorynames[rezzableidx]);
        rayrezobjectdata data;
        data.RayStart = <128, 128, 23>;
        data.RayEnd = <128, 128, 22>;
        vcontrolagent.SendRezObject(NULL_KEY, data, rezzableinventoryid);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        if(agent.AgentID == vcontrolagent.AgentID)
        {
            llSay(PUBLIC_CHANNEL, "Rezzed " + inventorynames[rezzableidx]);
            foreach(objdata in objectlist)
            {
                key id = objdata.FullID;
                if(id != vagent.AgentID && id != vcontrolagent.AgentID)
                {
                    rezzedobjectid = id;
                    rezzedobjectlocalid = objdata.LocalID;
                    state requestperms;
                }
            }
        }
    }
}

state requestperms
{
    state_entry()
    {
        vcontrolagent.SendRequestObjectPropertiesFamily(0, rezzedobjectid);
    }
    
    objectpropertiesfamily_received(agentinfo agent, integer requestFlags, key objectid, objectpropertiesfamilydata data)
    {
        integer baseperm = data.BaseMask;
        integer currentperm = data.OwnerMask;
        integer groupperm = data.GroupMask;
        integer everyoneperm = data.EveryoneMask;
        integer nextownerperm = data.NextOwnerMask;
        integer expectedperm = inventorypermmasks[rezzableidx];

        if((baseperm & PERM_EXPORT) != (expectedperm & PERM_EXPORT))
        {
            llSay(PUBLIC_CHANNEL, "BasePerms: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + decodeperms(baseperm) + " exp=" + decodeperms(expectedperm));
            success = FALSE;
        }
        
        if((everyoneperm & PERM_EXPORT) != (expectedperm & PERM_EXPORT))
        {
            llSay(PUBLIC_CHANNEL, "EveryOnePerms: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + decodeperms(everyoneperm));
            success = FALSE;
        }
        
        if((nextownerperm & PERM_EXPORT) != (expectedperm & PERM_EXPORT))
        {
            llSay(PUBLIC_CHANNEL, "NextOwnerPerms: Mismatch on " + inventorynames[rezzableidx] + ": cur=" + decodeperms(nextownerperm) + " exp=" + decodeperms(expectedperm));
            success = FALSE;
        }
        
        state derez;
    }    
}

state derez
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "De-Rezzing " + inventorynames[rezzableidx]);
        vcontrolagent.SendObjectDelete(TRUE, [rezzedobjectlocalid]);
    }
    
    killobject_received(agentinfo agent, list killedobjects)
    {
        if(llListFindList(killedobjects, rezzedobjectlocalid) >= 0)
        {
            llSay(PUBLIC_CHANNEL, "De-Rezzed " + inventorynames[rezzableidx]);
            if(++rezzableidx < inventoryids.Length)
            {
                state giveinventory;
            }
            else
            {
                state logouttest;
            }
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
