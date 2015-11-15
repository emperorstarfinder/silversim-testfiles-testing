integer com_chan = -280619750;//channel used for talking between food and animals
integer capacity = 126;
integer food;
key YOURKEY = "098bcbe1-391c-4283-933f-3da0cc3f1468";//this is your key
default
{
    state_entry()
    {
        if (llGetOwner() != YOURKEY)
        {
            llDie();
        }
        llSetText("", <1,1,1>, 1.0);
        food = capacity;
        llListen(com_chan, "", "", "");
        llSetText((string)food + " servings remaining.", <1,1,1>, 1.0);
    }
    listen(integer channel, string name, key id, string message)
    {
        list data = llParseString2List(message, ["^"] , []);
        if (llList2String(data, 0) == "pet_search_food")
        {
            integer r = llList2Integer(data,1);
            food--;
            llSay(com_chan,(string)id+"^eat_food^"+(string)r+"^1");//change that 1 to the amount of hunger to drop off that pet.
            llSetText((string)food + " servings remaining.", <1,1,1>, 1.0);
            if (food <= 0) 
            {
                llDie();
            }
        }
    }
}
