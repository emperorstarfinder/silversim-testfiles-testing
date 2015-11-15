integer SECRET_NUMBER = 280619750;//our secret rezzing number. this tells the object its being configured
integer com_chan = -280619750;//the channel all objects listen to
integer com_lis;//listener handle for channel
key egg;//the key of the prim we rez
default
{
    touch_start(integer total_number)
    {
        llListenRemove(com_lis);
        com_lis = llListen(com_chan,"","","");
        llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),llGetPos(),ZERO_VECTOR,ZERO_ROTATION,SECRET_NUMBER);//rez a the first item in inventory which should be our pet
    }
    object_rez(key id)
    {
        egg = id;
    }
    listen(integer c,string n,key id,string m)
    {
        if(id!=egg)return;
        llGiveInventory(id,llGetInventoryName(INVENTORY_OBJECT,0));//give a copy of the pet to the new pet being rezzed
        integer sex = llFloor(llFrand(2))+1;if(sex>2)sex=1;//choose a random sex for the pet
        integer shine = 0;//set the shine for the pet
        float glow = 0.0;//set the glow for the pet
        string special = "Normal";//set the special for the pet
        string mother = "Starter Mom";//set the mothers name for the pet
        string father = "Starter Dad";//set the fathers name for the pet
        string breeder = llKey2Name(llGetOwner());//set the breeders name for the pet
        integer generation = 0;//set the generation for the pet
        string name;
        if(sex == 1)name = "Starter Pet Male";
        else name = "Starter Pet Female";
        llSay(com_chan,(string)id+"^configure_pet^"+name+"^"+special+"^"+mother+"^"+father+"^"+breeder+"^"+(string)sex+"^"+(string)shine+"^"+(string)glow+"^"+(string)generation);//tell the new pet its glow and shine and stuff
        llResetScript();//reset the script
    }
}
