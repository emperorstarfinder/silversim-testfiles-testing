//#!Enable:Testing

list INVENTORY_TYPES = [
    INVENTORY_NONE,
    INVENTORY_ANIMATION,
    INVENTORY_BODYPART,
    INVENTORY_CLOTHING,
    INVENTORY_GESTURE,
    INVENTORY_LANDMARK,
    INVENTORY_NOTECARD,
    INVENTORY_OBJECT,
    INVENTORY_SCRIPT,
    INVENTORY_SOUND,
    INVENTORY_TEXTURE ];
    
list INVENTORY_NAMES = [
    "not a known item",
    "Animation",
    "Bodypart",
    "Clothing",
    "Gesture",
    "Landmark",
    "Notecard",
    "Object",
    "Script",
    "Sound",
    "Texture" ];

default
{
    state_entry()
    {
		integer success = TRUE;
		_test_Result(FALSE);
        integer i;
		if(llGetInventoryNumber(INVENTORY_ALL) != llGetListLength(INVENTORY_NAMES) - 1)
		{
			llSay(PUBLIC_CHANNEL, "ERROR: Count of inventory items does not match");
			success = FALSE;
		}
		for(i = 0; i < llGetInventoryNumber(INVENTORY_ALL); ++i)
		{
			llSay(PUBLIC_CHANNEL, llGetInventoryName(INVENTORY_ALL, i));
		}
		
		for(i = 1; i < llGetListLength(INVENTORY_TYPES); ++i)
		{
			integer type = llList2Integer(INVENTORY_TYPES, i);
			integer cnt = llGetInventoryNumber(type);
			if(cnt != 1)
			{
				llSay(PUBLIC_CHANNEL, "type " + (string)type + " has wrong count " + (integer)cnt);
				success = FALSE;
			}
		}
		
		for(i = 0; i < llGetListLength(INVENTORY_NAMES); ++i)
        {
			string name = llList2String(INVENTORY_NAMES, i);
            integer type = llGetInventoryType(name);
			if(type != llList2Integer(INVENTORY_TYPES, i))
			{
				llSay(PUBLIC_CHANNEL, "ERROR: Wrong type for item '" + name + "'. Got " + (string)type + " Expected " + (string)llList2Integer(INVENTORY_TYPES, i));
				success = FALSE;
			}
        }
		_test_Result(success);
		_test_Shutdown();
    }
}