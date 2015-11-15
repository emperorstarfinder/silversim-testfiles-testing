integer com_chan = -280619750;//channel used for talking between food and animals
key target;
default
{
    state_entry()
    {
        llListen(com_chan,"","","");
    }

    listen(integer c,string n,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        if(m == "pet_ready_for_update")
        {
            target = id;
            llSay(com_chan,(string)target+"^update_pet");
        }else if(m == "clean_ready" && id == target)
        {
            llGiveInventory(target,llGetInventoryName(INVENTORY_OBJECT,0));
            llRemoteLoadScriptPin(target,"menu",-19842007,TRUE,-19842007);
            llRemoteLoadScriptPin(target,"scale",-19842007,TRUE,-19842007);
            llRemoteLoadScriptPin(target,"main",-19842007,TRUE,-19842007);
        }
    }
}
