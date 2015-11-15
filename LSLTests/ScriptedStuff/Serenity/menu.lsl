show_menu()//display generic dialog menu
{
    llListenRemove(menulis);
    menuchan = llFloor(llFrand(DEBUG_CHANNEL));
    menulis = llListen(menuchan,"","","");
    llDialog(llGetOwner(),"Choose an option below.",["Home Pet","Name Pet","Update","Range","Reset"],menuchan);
}
integer com_chan = -280619750;//channel used for talking between food and animals
integer menulis;//menu listener
integer menuchan;//menu channel. this actually gets randomized
integer zerobit;//bit operator used to switch between chat listeners
integer name_listener;//change name listener
integer range_listener;//change range listener
default
{
    touch_start(integer x)
    {
        if(llDetectedKey(0)!=llGetOwner())return;
        show_menu();
        llSay(com_chan,"target_pet^"+(string)llGetKey());
    }

    listen(integer c,string name,key id,string m)
    {
        if(id!=llGetOwner())return;
        if(c==menuchan)
        {
            if(m == "Home Pet")
            {
                llMessageLinked(LINK_SET,123,"sethome","");
                llWhisper(0,"Home Position set to "+(string)llGetPos());
            }else if(m == "Name Pet")
            {
                zerobit = 0;
                llOwnerSay("You have 60 seconds to type a new name: (Format \"name, Charlie\")");
                name_listener = llListen(0,"","","");
            }else if(m == "Update")
            {
                llMessageLinked(LINK_SET,123,"update","");
            }else if(m == "Range")
            {
                zerobit = 1;
                llOwnerSay("You have 60 seconds to type a new range: (Format \"range, 5\")");
                range_listener = llListen(0,"","","");
            }else if(m == "Reset")
            {
                llMessageLinked(LINK_SET,123,"reset","");
            }
        }else if(c == 0)
        {
            if(zerobit == 0)
            {
                list name_parts = llParseString2List(m, [","], []);
                if (llToLower(llList2String(name_parts, 0)) == "name") 
                {//change the pets name
                    string myname = llStringTrim(llList2String(name_parts, 1), STRING_TRIM);
                    llWhisper(0, "My new name is " + myname);
                    llSetObjectName(myname);
                    llListenRemove(name_listener);
                    llMessageLinked(LINK_SET,123,"nameupdate",myname);
                }
            }else if(zerobit == 1)
            {
                list range_parts = llParseString2List(m, [","], []);
                if (llToLower(llList2String(range_parts, 0)) == "range") 
                {
                    string newrange = llStringTrim(llList2String(range_parts, 1), STRING_TRIM);
                    llWhisper(0, "My new range is " + newrange);
                    llListenRemove(range_listener);
                    llMessageLinked(LINK_SET,123,"rangeupdate",newrange);
                }
            }
        }
    }
}