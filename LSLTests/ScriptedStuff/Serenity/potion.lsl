integer com_chan = -280619750;//channel used for talking between food and animals
key target;
integer which = 0;//change this to match the number of the item in the below. the counting starts at 0
list potions = ["ager","sexchange","foodinject","shineboost1","shineboost2","shineboost3","glowboost","seedboost","deseed","revive"];
list potionresponses = ["used_ager","used_sexchanger","used_foodinjector","used_sb1","used_sb2","used_sb3","used_gb1","used_seedboost","used_deseeder","used_revive"];
default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1);
        llListen(com_chan,"","","");
    }

    listen(integer c,string n,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m,["^"],[]);
        if(llList2String(t,0)=="target_pet")
        {
            if(llList2String(t,1)==(string)id)
            {
                llSetText("Targeting "+n,<1,1,1>,1);
                target = id;
                state ready;
            }
        }
    }
}
state ready
{
    on_rez(integer sp)
    {
        llResetScript();
    }
    state_entry()
    {
        llListen(com_chan,"","","");
    }
    touch_start(integer x)
    {
        llSay(com_chan,(string)target+"^potion^"+llList2String(potions,which));
    }
    listen(integer c,string n,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        if(id != target)return;
        if(m == llList2String(potionresponses,which))
        {
            llDie();
            llRemoveInventory(llGetScriptName());
        }
    }
}