// MESSAGE OBJECT ADD-ON FOR PMAC 1.x
// by Aine Caoimhe (c. LACM) July 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// REQUIRES THAT THE OSSL COMMAND osMessageObject() IS ENABLED IN THE REGION (and that the target object is scripted to do something)
// 
// Command format for this addon:
// PAO_MSG_OBJECT{OBJECT_KEY::msg::...}
// you can message multiple objects by appending additional key::message pairs inside the braces
// Keep in mind that the string to be sent cannot use any of the following characters:
//      \           used by LSL as a text flag and these are passed as strings so it would almost certainly bugger things up
//      |           reserved as a separator for PMAC core animations
//      {           reserved for as a separator for PMAC core commmands
//      }           reserved for as a separator for PMAC core commands
//      ::          reserved as a separator for this addon
// If your command needs to pass arguments with separators I suggest using something like @ or # or ^ as your separator
//
// DO NOT include any extra spaces between the separators or before/after the curly braces
//
// THIS SCRIPT CAN BE CHANGED AND RESET DURING OPERATION WITHOUT CAUSING ANY ISSUES

default
{
    link_message(integer sender, integer num, string message, key sitters)
    {
        list parsed=llParseString2List(message,["|"],[]);
        string command=llList2String(parsed,0);
        if (command=="GLOBAL_NEXT_AN")
        {
            list commandBlock=llParseString2List(llList2String(parsed,1),["{","}"],[]);
            list mySitters=llParseString2List(sitters,["|"],[]);
            integer myBlock=llListFindList(commandBlock,"PAO_MSG_OBJECT");
            if (myBlock>=0)
            {
                list myData=llParseString2List(llList2String(commandBlock,myBlock+1),["::"],[]);
                integer i;
                integer l=llGetListLength(myData);
                while (i<l)
                {
                    key target=llList2Key(myData,i);
                    string msg=llList2String(myData,i+1);
                    if (llGetListLength(llGetObjectDetails(target,[OBJECT_POS]))==0) llOwnerSay("ERROR! PAO_MSG_OBJECT addon was told to send a message to a prim with UUID "+(string)target+" but it is not in the scene");
                    else osMessageObject(target,msg);
                    i+=2;
                }
            }
        }
    }
}