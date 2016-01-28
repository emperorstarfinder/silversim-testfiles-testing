//
//          HAIKUvend 1prim vendor
//          version 2.0
//
//          You may not resell any part of this system, nor give it away.
//          Please forward other people towards http://code.google.com/p/haikuvend/ if you want to recommend this system.
//
//          An up-to-date version will always be available at:
//          http://code.google.com/p/haikuvend/
//
//          Please report any errors in the code to "haikuvend Resident"
//          and feel free to contact me if you have any improvements
//
//          This is the configuration notecard file: "HAIKUvend 1prim.cfg"
//
//          This is the main vendor script without floattext
//

key NOTECARD_QUERY;
integer NOTECARD_LINE;
integer found;

integer currentItem;

key defaultTexture = "a9eeaec9-d846-2c26-1e22-1ce4a2f17b4a";

string VENDOR_TEXTURE;
list FOLDER_NAMES;
list FOLDER_PRICES;
list FREE_OPTIONAL_ITEMS;

string EMAIL_ADDRESS;

integer menuChannel;
integer menuHandle;
key user;

list ITEMS_IN_FOLDER_01; list ITEMS_IN_FOLDER_02; list ITEMS_IN_FOLDER_03;
list ITEMS_IN_FOLDER_04; list ITEMS_IN_FOLDER_05; list ITEMS_IN_FOLDER_06;
list ITEMS_IN_FOLDER_07; list ITEMS_IN_FOLDER_08; list ITEMS_IN_FOLDER_09;

say(string str) { llOwnerSay("/me ["+llGetScriptName()+"]: " + str); }

init()
{
    llSetTimerEvent(30.0);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[
        PRIM_TEXTURE, 5, "85893bc8-1eb5-8728-00fd-3d67e6abd868",<1.0,1.0,0.0>, ZERO_VECTOR, (float)FALSE,
        PRIM_TEXTURE, 6, "5d834853-4348-4cc0-5fec-f4f299064a70",<1.0,1.0,0.0>, ZERO_VECTOR, (float)FALSE]);
    user = NULL_KEY;
    menuChannel = (integer)llFrand((-1000000 - 1000000) - 1000);
    menuHandle = FALSE;
    NOTECARD_QUERY  = llGetNotecardLine("HAIKUvend 1prim.cfg",NOTECARD_LINE);
}

config_parse(string input_string)
{
    string line = llStringTrim(input_string,STRING_TRIM);
    if (llGetSubString(line,0,1) != "//" && line != "")
    {
        list ldata  = llParseStringKeepNulls(line, ["=","#"], [""]);
        string cmd  = llToUpper(llStringTrim(llList2String(ldata,0),STRING_TRIM));
        string arg1  = llStringTrim(llList2String(ldata,1),STRING_TRIM);
        string arg2  = llStringTrim(llList2String(ldata,2),STRING_TRIM);
        string arg3  = llStringTrim(llList2String(ldata,3),STRING_TRIM);
        string arg4  = llStringTrim(llList2String(ldata,4),STRING_TRIM);
        if (cmd == "@") { EMAIL_ADDRESS = arg1; }
        else if (cmd == "FOLDER1") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_01 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER2") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_02 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER3") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_03 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER4") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_04 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER5") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_05 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER6") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_06 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER7") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_07 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER8") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_08 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "FOLDER9") { FOLDER_NAMES += [arg1]; ITEMS_IN_FOLDER_09 = llCSV2List(arg2); FOLDER_PRICES += [(integer)arg3]; FREE_OPTIONAL_ITEMS += [arg4]; }
        else if (cmd == "VENDOR_TEXTURE") { VENDOR_TEXTURE = arg1; }
    }
}

config_dump()
{
    say("Folder 1 named '" + llList2String(FOLDER_NAMES,0) + "' is being sold for " + llList2String(FOLDER_PRICES,0) + " L$.");
    say("Folder 2 named '" + llList2String(FOLDER_NAMES,1) + "' is being sold for " + llList2String(FOLDER_PRICES,1) + " L$.");
    say("Folder 3 named '" + llList2String(FOLDER_NAMES,2) + "' is being sold for " + llList2String(FOLDER_PRICES,2) + " L$.");
    say("Folder 4 named '" + llList2String(FOLDER_NAMES,3) + "' is being sold for " + llList2String(FOLDER_PRICES,3) + " L$.");
    say("Folder 5 named '" + llList2String(FOLDER_NAMES,4) + "' is being sold for " + llList2String(FOLDER_PRICES,4) + " L$.");
    say("Folder 6 named '" + llList2String(FOLDER_NAMES,5) + "' is being sold for " + llList2String(FOLDER_PRICES,5) + " L$.");
    say("Folder 7 named '" + llList2String(FOLDER_NAMES,6) + "' is being sold for " + llList2String(FOLDER_PRICES,6) + " L$.");
    say("Folder 8 named '" + llList2String(FOLDER_NAMES,7) + "' is being sold for " + llList2String(FOLDER_PRICES,7) + " L$.");
    say("Folder 9 named '" + llList2String(FOLDER_NAMES,8) + "' is being sold for " + llList2String(FOLDER_PRICES,8) + " L$.");
    say("'" + llList2String(FOLDER_NAMES,0) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_01));
    say("'" + llList2String(FOLDER_NAMES,1) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_02));
    say("'" + llList2String(FOLDER_NAMES,2) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_03));
    say("'" + llList2String(FOLDER_NAMES,3) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_04));
    say("'" + llList2String(FOLDER_NAMES,4) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_05));
    say("'" + llList2String(FOLDER_NAMES,5) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_06));
    say("'" + llList2String(FOLDER_NAMES,6) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_07));
    say("'" + llList2String(FOLDER_NAMES,7) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_08));
    say("'" + llList2String(FOLDER_NAMES,8) + "' contains: " + llList2CSV(ITEMS_IN_FOLDER_09));
}

config_check()
{
    integer i;
    for (i=0;i<llGetListLength(FREE_OPTIONAL_ITEMS);++i) { if(llGetInventoryType(llList2String(FREE_OPTIONAL_ITEMS,i)) == INVENTORY_NONE && llList2String(FREE_OPTIONAL_ITEMS,i) != "") { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_01);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_01,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_02);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_02,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_03);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_03,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_04);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_04,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_05);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_05,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_06);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_06,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_07);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_07,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_08);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_08,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(ITEMS_IN_FOLDER_09);++i) { if(llGetInventoryType(llList2String(ITEMS_IN_FOLDER_09,i)) == INVENTORY_NONE) { found = FALSE; } }
    for (i=0;i<llGetListLength(FOLDER_PRICES);++i) { if(llList2Integer(FOLDER_PRICES,i) < 0) { found = FALSE; } }
}

SetCurrentItem(integer item)
{
    currentItem = item;
    if (currentItem == 0) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.668,0.314,0.000>, (float)FALSE]); }
    if (currentItem == 1) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.000,0.314,0.000>, (float)FALSE]); }
    if (currentItem == 2) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.332,0.314,0.000>, (float)FALSE]); }
    if (currentItem == 3) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.668,0.026,0.000>, (float)FALSE]); }
    if (currentItem == 4) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.000,0.026,0.000>, (float)FALSE]); }
    if (currentItem == 5) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.332,0.026,0.000>, (float)FALSE]); }
    if (currentItem == 6) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.668,0.736,0.000>, (float)FALSE]); }
    if (currentItem == 7) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.000,0.736,0.000>, (float)FALSE]); }
    if (currentItem == 8) { llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 5, VENDOR_TEXTURE,<0.327,0.285,0.000>, <0.332,0.736,0.000>, (float)FALSE]); }
    llSetPayPrice(PAY_HIDE,[llList2Integer(FOLDER_PRICES,currentItem),PAY_HIDE,PAY_HIDE,PAY_HIDE]);
}

open_menu_handle(key id)
{
    menuChannel = (integer)llFrand((-1000000 - 1000000) - 1000);
    user = id;
    menuHandle = llListen(menuChannel, "", user, "");
    llSetTimerEvent(30.0);
}

open_menu(key id, string input_string, list input_list)
{
    if (id)
    {
        string dialog = input_string;
        list buttons = input_list;
        
        if (!menuHandle || id != user)
            open_menu_handle(id);
            
        llDialog(user, dialog, buttons, menuChannel);
    }
}

close_menu()
{
    llSetTimerEvent((float)FALSE);
    user = NULL_KEY;
    menuChannel = (integer)llFrand((-1000000 - 1000000) - 1000);
    llListenRemove(menuHandle);
    menuHandle = FALSE;
    
}

default
{
    on_rez(integer start_param) { llResetScript(); }

    state_entry() { init(); }

    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) llResetScript(); }

    dataserver(key requested, string data)
    {
        if (requested == NOTECARD_QUERY)
        {
            if (data != EOF)
            {
                config_parse(data);
                ++NOTECARD_LINE;
                NOTECARD_QUERY = llGetNotecardLine("HAIKUvend 1prim.cfg",NOTECARD_LINE);
            }
            else
            {
                llSetTimerEvent((float)FALSE);
                config_dump();
                found = TRUE;
                config_check();
                if (!found)
                {
                    say("The contents in your vendor and the settings in the configuration notecard DO NOT MATCH!");
                    state disabled;
                }
                else
                    state perms_check;
            }
        }
    }

    timer()
    {
        llSetTimerEvent((float)FALSE);
        say("Time-out during notecard reading, resetting script now...");
        llResetScript();
    }

    state_exit()
    {
        llSetTimerEvent((float)FALSE);
    }
}

state perms_check
{
    on_rez(integer start_param) { llResetScript(); }

    state_entry()
    {
        llSetTimerEvent(30.0);
        say("Main vendor script is requesting debit permissions...");
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }

    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) { llResetScript(); } }
    
    run_time_permissions (integer perm)
    {
        if(perm & PERMISSION_DEBIT)
        {
            llSetTimerEvent((float)FALSE);
            state vendor_idle;
        }
        else
        {
            llSetTimerEvent((float)FALSE);
            say("\n \nYOU MUST GRANT DEBIT PERMISSIONS NEXT TIME!\n");
            state disabled;
        }
    }

    timer()
    {
        llSetTimerEvent((float)FALSE);
        say("\n \nYOU MUST GRANT DEBIT PERMISSIONS NEXT TIME!\n");
        state disabled;
    }

    state_exit()
    {
        llSetTimerEvent((float)FALSE);
    }
}

state vendor_idle
{
    on_rez(integer startParam) { llResetScript(); }
    
    state_entry()
    {
        close_menu();
        SetCurrentItem(currentItem);
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE, 6, VENDOR_TEXTURE,<1.0,1.0,0.0>, ZERO_VECTOR, (float)FALSE]);
    }

    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) { llResetScript(); } }

    link_message(integer sender,integer num,string message,key id)
    {
        if (message == "1a1") { SetCurrentItem(0);}
        else if (message == "2a2") { SetCurrentItem(1);}
        else if (message == "3a3") { SetCurrentItem(2);}
        else if (message == "4a4") { SetCurrentItem(3);}
        else if (message == "5a5") { SetCurrentItem(4);}
        else if (message == "6a6") { SetCurrentItem(5);}
        else if (message == "7a7") { SetCurrentItem(6);}
        else if (message == "8a8") { SetCurrentItem(7);}
        else if (message == "9a9") { SetCurrentItem(8);}
        else if (num == 1000) { llResetScript();}
        else if (num == 1100) { state disabled;}
    }

    touch_start(integer num_detected)
    {
        user = llDetectedKey(0);
        if (llDetectedTouchFace(0) == 5 && user == llGetOwner())
        {
            say("Touch backside to reset scripts or turn off vendor.");
            say("Free memory is: " + (string)llGetFreeMemory() + ".");
        }
        if (llDetectedTouchFace(0) == 5 && llList2Integer(FOLDER_PRICES,currentItem) > 0 && llList2String(FREE_OPTIONAL_ITEMS,currentItem) == "")
        {
            llInstantMessage(user,"Touch small items on the left to view in large on the right, right click on large panel and pay to purchase.");
        }
        else if (llDetectedTouchFace(0) == 5 && llList2Integer(FOLDER_PRICES,currentItem) > 0 && llList2String(FREE_OPTIONAL_ITEMS,currentItem) != "")
        {
            llInstantMessage(user,"\n \nRight click on large panel and pay to purchase.\n"
                                    + "Handing out information notecard...please wait...");
            llGiveInventory(user,llList2String(FREE_OPTIONAL_ITEMS,currentItem));
        }
        else if (llDetectedTouchFace(0) == 5 && llList2Integer(FOLDER_PRICES,currentItem) == 0 && llList2String(FREE_OPTIONAL_ITEMS,currentItem) == "")
        {
            open_menu(user,"\n\n\n\nWant to have it? This item is free!\n", ["item"]);
        }
        else if (llDetectedTouchFace(0) == 5 && llList2Integer(FOLDER_PRICES,currentItem) == 0 && llList2String(FREE_OPTIONAL_ITEMS,currentItem) != "")
        {
            open_menu(user,"\n\n\n\nWhat do you want to get? This item is free!\n", ["item","notecard"]);
        }
    }

    money(key id,integer amount)
    {
        string name = llKey2Name(id);
        integer currentPrice = llList2Integer(FOLDER_PRICES,currentItem);
        integer AMOUNT_IS_AT_LEAST_PRICE;
        if (amount < currentPrice)
        {
            llInstantMessage(id,name + "You paid " +(string)amount+ "L$ - not enough for current item. Refunding ...");
            llGiveMoney(id,amount);
            AMOUNT_IS_AT_LEAST_PRICE = FALSE;
        }
        else if (amount > currentPrice)
        {
            integer change = amount - currentPrice;
            llInstantMessage(id,name +"You paid " +(string)amount+ "LS your change is " +(string)change+"L$.");
            llGiveMoney(id,change);
            AMOUNT_IS_AT_LEAST_PRICE = TRUE;
        }
        else
        {
            AMOUNT_IS_AT_LEAST_PRICE = TRUE;
        }
        if(AMOUNT_IS_AT_LEAST_PRICE)
        {
            llInstantMessage(id,name+ " , thank you for your purchase .");
            if (currentItem == 0) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_01); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold1",id);}
            else if (currentItem == 1) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_02); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold2",id);}
            else if (currentItem == 2) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_03); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold3",id);}
            else if (currentItem == 3) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_04); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold4",id);}
            else if (currentItem == 4) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_05); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold5",id);}
            else if (currentItem == 5) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_06); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold6",id);}
            else if (currentItem == 6) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_07); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold7",id);}
            else if (currentItem == 7) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_08); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold8",id);}
            else if (currentItem == 8) { llGiveInventoryList(id,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_09); llMessageLinked(LINK_SET,(integer)llList2Integer(FOLDER_PRICES, currentItem),"totalsold9",id);}
            llMessageLinked(LINK_SET,0,"totalsold",id);
            if(EMAIL_ADDRESS != "") { llEmail(EMAIL_ADDRESS, "SL Sales Notification",name+  " purchased '" +llList2String(FOLDER_NAMES,currentItem)+ "' for " + (string)amount + "L$ from your vendor at '" + llGetRegionName() + "' Region."); }
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == menuChannel)
        {
            if (llListFindList(["item","notecard"], [message]) != -1)
            {
                llInstantMessage(user, " You have selected: '" + message + "'.");
                {
                    if (message == "item")
                    {
                        integer i;
                        llInstantMessage(user, "Giving you now: '" + llList2String(FOLDER_NAMES,currentItem) + "'.");
                        if (currentItem == 0) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_01); llMessageLinked(LINK_SET,0,"totalsold1",user);}
                        else if (currentItem == 1) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_02); llMessageLinked(LINK_SET,0,"totalsold2",user);}
                        else if (currentItem == 2) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_03); llMessageLinked(LINK_SET,0,"totalsold3",user);}
                        else if (currentItem == 3) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_04); llMessageLinked(LINK_SET,0,"totalsold4",user);}
                        else if (currentItem == 4) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_05); llMessageLinked(LINK_SET,0,"totalsold5",user);}
                        else if (currentItem == 5) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_06); llMessageLinked(LINK_SET,0,"totalsold6",user);}
                        else if (currentItem == 6) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_07); llMessageLinked(LINK_SET,0,"totalsold7",user);}
                        else if (currentItem == 7) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_08); llMessageLinked(LINK_SET,0,"totalsold8",user);}
                        else if (currentItem == 8) { llGiveInventoryList(user,llList2String(FOLDER_NAMES,currentItem),ITEMS_IN_FOLDER_09); llMessageLinked(LINK_SET,0,"totalsold9",user);}
                        llMessageLinked(LINK_SET,0,"totalsold",user);
                        if (EMAIL_ADDRESS != "") { llEmail(EMAIL_ADDRESS, "SL Sales Notification",llKey2Name(user) + " got '" +llList2String(FOLDER_NAMES,currentItem)+ "' from your vendor at '" + llGetRegionName() + "' Region for free."); }
                    }
                    else if (message == "notecard")
                    {
                        llInstantMessage(user, "Giving you now: '" + llList2String(FREE_OPTIONAL_ITEMS,currentItem) + "'.");
                        llGiveInventory(user,llList2String(FREE_OPTIONAL_ITEMS,currentItem));
                    }
                }
            }
            else { llInstantMessage(user, name + ", you picked an invalid option '" + llToLower(message) + "'."); }
        }
        close_menu();
    }
    
    timer() { close_menu(); }

    state_exit()
    {
        llSetTimerEvent((float)FALSE);
    }
}

state disabled
{
    on_rez(integer start_param) { llResetScript(); }

    state_entry()
    {
        say("Shutting down.");
        say("Your Vendor in '" + llGetRegionName() + "' Region can't deliver FOLDER_NAMES. Please update your Vendor.");
        if(EMAIL_ADDRESS != "") { llEmail(EMAIL_ADDRESS, llGetObjectName() ,"Your Vendor in '" + llGetRegionName() + "' Region can't deliver FOLDER_NAMES. Please update your Vendor."); }
        llSetLinkPrimitiveParamsFast(LINK_THIS,[
            PRIM_TEXTURE, 5, "15a3ad51-aa37-2cad-c5d5-5e4b0be6c43b",<1.0,1.0,0.0>, ZERO_VECTOR, (float)FALSE,
            PRIM_TEXTURE, 6, "e296bd16-864a-ce79-ba45-2033b2edeeee",<1.0,1.0,0.0>, ZERO_VECTOR, (float)FALSE]);
    }

    link_message(integer sender,integer num,string message,key id)
    {
        if (num == 1000) { llResetScript(); }
        else { llSay(PUBLIC_CHANNEL, "Sorry this vendor is offline."); }
    }

    changed(integer change) { if (change & (CHANGED_INVENTORY | CHANGED_OWNER)) { llResetScript(); } }
}
