//FOSSLVendorBuyModule
//---------------------------------------------------------------------------------//
//Copyright Info Below... Please Do not Remove //
//---------------------------------------------------------------------------------//

//(c)2007 Ilobmirt Tenk

//This file is part of the FOSSL Vendor Project

// FOSSL Vendor is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.

// FOSSL Vendor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

//---------------------------------------------------------------------------------//
//Copyright Info Above... Please Do not Remove //
//---------------------------------------------------------------------------------//
// modified by Fleur Dollinger 6 April 2008 - enable income splitting
// modified by Fleur Dollinger 28 April 2008 - option to disable deed to group

//=================================================================//
//List all the global variables here...
//=================================================================//

//This is the current L$ to US$ rate
float gfltLindenToUSDollarRate = 0.004;
//This is the key used to retrieve the L$ to US$ data via http
key gkeyHTTPLindenToUSDollarRate = NULL_KEY;

//This is the current price of the object displayed in the vendor
integer gintCurrentPrice = 0;

//count of the current Notecard line to read
integer gintSettingLines = 0;

//key of the notecard line to be read
key gkeySettingsId;

//determines if this object displays debugging output
integer gblnDebug = FALSE;

//income can be split between any number of avatars (as well as owner)
//Set gintNumSplit to a value greater than zero and set set up appropriate details for each split.
integer gintNumSplit = 0;

//Each Split is based upon 3 indexes of a list
//Split Array = [(Avatar Key), (Split amount), (Split Type)]
//Avatar Key - The key of the avatar that one plans to split a profit with
//Split Amount - How much that avatar will get per sale
//Split Type - What kind of measurement are we talking about? Percent? L$? US$?
list glstDefaultSplits = []; //Splitting scheme for all items sold by the vendor

//DEFAULT IS TO DISABLE DEED TO GROUP
// note that that the vendor will not be able to refund overpayments or split and distribute money if the vendor is deeded to group so its recommended to always leave this disabled
integer gintDeedToGroup = FALSE;
//get the object's owner - NULL_KEY
list groupD;

//This displays messages to the owner if debug mode has been set to true
debugMessage(string strMessage){

    if(gblnDebug == TRUE){

        llOwnerSay("FOSSLVendorBuy: " + strMessage);

    }
}


//Calculate the amount of cash given as it goes with profit splitting
splitMoney(integer amount)
{

    integer intIndex = 0;
    integer intLength = llGetListLength(glstDefaultSplits);
    key keyAvatar = NULL_KEY;
    integer intSplitCurrency = 0;
    string strType = "";

    for(intIndex = 0; intIndex < intLength; intIndex += 3 ){

        keyAvatar = llList2Key(glstDefaultSplits,intIndex);
        strType = llToUpper(llList2Key(glstDefaultSplits,intIndex + 2));
        if(keyAvatar != NULL_KEY && keyAvatar != llGetOwner()){

            //Is the type in US Dollars?
            if(strType == "US$" || strType == "$"){

                intSplitCurrency = (integer) (llList2Float(glstDefaultSplits,intIndex + 1) / gfltLindenToUSDollarRate);

            }
            //Is the type shown as a percentage?
            else if(strType == "%"){

                intSplitCurrency = (integer) ((llList2Float(glstDefaultSplits,intIndex + 1) * (float) amount) / 100.0);

            }
            //It must be a flat out L$ rate
            else{

                intSplitCurrency = llList2Integer(glstDefaultSplits,intIndex + 1);

            }

            llGiveMoney(keyAvatar, intSplitCurrency);
            debugMessage("Splitting with "+ (string) keyAvatar +" L$" + (string) intSplitCurrency +".");
            
        }
            
    }

}

//In this state, vendor must accept debit permissions before using the vendor
default
{

state_entry()
{

    groupD = llGetObjectDetails(llGetOwner(), [OBJECT_GROUP]);
    debugMessage("GroupD:" + (string) llList2String(groupD,0));

    //request permission on startup if not deeded to a group
    if((gintDeedToGroup == 0 && (key) llList2String(groupD,0) == NULL_KEY) || gintDeedToGroup == 1){

        //Asks vendor owner for the ability to withdraw cash from vendor owner's account.
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT );

    }
    else{

        llWhisper(0,"Deeding this vendor to a group is not permitted. Debit permission has been denied.");
    }

}


on_rez(integer start_param)
{

    //reset script upon rezz
    llResetScript();

}

link_message(integer sender_number, integer number, string message, key id)
{

    //Separate the linked message into the function and variables
    list lstMessage = llParseString2List(message,["#"],[]);
    string strFunction = llList2String(lstMessage,0);

    if(strFunction == "goingOnline"){

        //prevent vendor from staying online untill permissions are granted
        llMessageLinked(LINK_SET,0,"goOffline",NULL_KEY); //Tell Vendor to go offline if not already


    }
    //debugMode#blnEnabled
    else if(strFunction == "debugMode"){

        gblnDebug = (integer) llList2String(lstMessage,1);

    }


}

//Depending on if avatar accepts or declines request, either stay in this state, or move on...
run_time_permissions(integer permissions){

    //if user accepted debit permissions
    if(permissions & PERMISSION_DEBIT){

        state transactionsSetup; //Change state to setup for transactions

    }
    else if(!(permissions & PERMISSION_DEBIT)){

        llOwnerSay("Sorry, but this vendor requires its owner to allow for debit permissions.");
        llOwnerSay("To enable vendor service, touch the containing prim of the payment script, and accept the debit request.");

    }

}

touch(integer total_number){

    if ((gintDeedToGroup == 0 && (key) llList2String(groupD,0) == NULL_KEY) || gintDeedToGroup == 1){

        //Asks vendor owner for the ability to withdraw cash from vendor owner's account.
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT );

    }
    else{

        llWhisper(0,"Deeding this vendor to a group is not permitted. Debit permission has been denied.");
    }

}

}

//This state sets up all the data before transactions are to occur
state transactionsSetup{

state_entry(){

    llOwnerSay("Vendor is now able to make transactions with this script.\nReading Configuration data...");
    //Obtain the first line of the vendor buy settings;
    gkeySettingsId = llGetNotecardLine("FOSSL_BUY_SETTINGS", gintSettingLines);


}

changed( integer vBitChanges ){

    //Detect change of ownership, as this may indicate that the owner has deeded this object to a group, in which case we may want to disable Debit permission.
    //If any kind of split is activated you will have to disallow deeding this vendor to the group as groups cannot 'pay' other people out of the split.
    //This is really only relevant if you are giving this vendor to other people to sell your products for you.
    if (vBitChanges & CHANGED_OWNER){

        llResetScript();

    }

}

//Reset the vendor upon rezzing
on_rez(integer start_param){

    llResetScript();

}

//Read the link settings notecard. Configure the link based on each line.
dataserver(key query_id, string data) {

    if (query_id == gkeySettingsId) {

        if (data != EOF) { // not at the end of the notecard

            debugMessage("Notecard Line = \"" + data + "\"");
            //split the record into variable names and values
            list lstSplit = llParseString2List(data,["="],[]);
            string strVariable = llToUpper(llStringTrim(llList2String(lstSplit,0),STRING_TRIM));
            string strValue = llStringTrim(llList2String(lstSplit,1),STRING_TRIM );

            // get setting for intDeedToGroup (default is 0 = disable)
            if(strVariable == "DEED TO GROUP"){

                gintDeedToGroup = (integer) strValue;
                debugMessage("intDeedToGroup = " + strValue);

            }

            //Get settings for splits
            //Start By looking for "split"
            //Since there's some dynamicism to this, some more proccessing is neccesary
            if(llGetSubString(strVariable, 0, 4) == "SPLIT"){

                list lstSplitVariableDetails = llParseString2List(strVariable,[" "],[]);

                //If it was just "Split" after all, user just wants to set the number of profit splitting in the vendor
                if(llGetListLength(lstSplitVariableDetails) == 1){

                    gintNumSplit = (integer) strValue;
                    //if income splitting is enabled, must disable Deed To Group
                    if (gintNumSplit > 0){

                        gintDeedToGroup = 0;
                        debugMessage("DEED TO GROUP DISABLED AS INCOME SPLITTING HAS BEEN ACTIVATED");

                    }

                    debugMessage("SPLIT = " + (string) gintNumSplit);
                    
                    //Create an array of splits with just default values
                    integer intIndex;

                    //Reset values of default split
                    glstDefaultSplits = [];

                    for(intIndex = 0; intIndex < gintNumSplit; intIndex++){

                        //Add an entity to split with using default values
                        glstDefaultSplits += [NULL_KEY,0,"L$"];

                    }

                }
                //There's more to it than that, Find out what part of the split needs to be set
                else{

                    //Get the index that will be enacted upon
                    integer intSplitIndexDetails = llList2Integer(lstSplitVariableDetails, 1) - 1;
                    //Get more info on what the user wants set for the split
                    string strSubVariable = llList2String(lstSplitVariableDetails, 2);

                    //The user wants to set the recipient key for the split
                    if(strSubVariable == "KEY"){

                        //Replace the index with the new key of the recipient
                        glstDefaultSplits = llListReplaceList(glstDefaultSplits, [strValue], (intSplitIndexDetails * 3), (intSplitIndexDetails * 3));
                        debugMessage("glstDefaultSplits["+ (string) (intSplitIndexDetails * 3) +"] = " + strValue);

                    }
                    //The user wants to set the amount the recipient gets
                    else if(strSubVariable == "AMOUNT"){

                        //Replace the index with the new currency value to be shared
                        glstDefaultSplits = llListReplaceList(glstDefaultSplits, [strValue], ((intSplitIndexDetails * 3) + 1), ((intSplitIndexDetails * 3) + 1));
                        debugMessage("glstDefaultSplits["+ (string) ((intSplitIndexDetails * 3) + 1) +"] = " + strValue);

                    }
                    //The user wants to set the type of split the recipient gets
                    else if(strSubVariable == "TYPE"){

                        //Replace the index with the new type of split to be shared
                        glstDefaultSplits = llListReplaceList(glstDefaultSplits, [strValue], ((intSplitIndexDetails * 3) + 2), ((intSplitIndexDetails * 3) + 2));
                        debugMessage("glstDefaultSplits["+ (string) ((intSplitIndexDetails * 3) + 2) +"] = " + strValue);

                    }

                }
            
            }

            gkeySettingsId = llGetNotecardLine("FOSSL_BUY_SETTINGS", ++gintSettingLines); // request next line
        }
        //No more lines to read in the configuration notecard
        else{

            llOwnerSay("Vendor is now able to sell products. Enabling transactions.");
            llMessageLinked(LINK_SET,0,"goOnline",NULL_KEY); //Tell Vendor to go online if not already
            state transactionsAcceptable; //Change state to allow for transactions

        }

    }

}
}

//In this state, vendor is ready to sell products
//Allow transactions to commence
state transactionsAcceptable{
    
state_entry(){
 
    //Time to start getting lindex data
    gkeyHTTPLindenToUSDollarRate = llHTTPRequest("http://secondlife.com/httprequest/homepage.php", [HTTP_METHOD, "GET"], "");
    //Poll For Lindex Data every five minutes (300 seconds)
    llSetTimerEvent(300.0);
          
}

changed( integer vBitChanges ){

    //Detect change of ownership, as this may indicate that the owner has deeded this object to a group, in which case we may want to disable Debit permission.
    //If any kind of split is activated you will have to disallow deeding this vendor to the group as groups cannot 'pay' other people out of the split.
    //This is really only relevant if you are giving this vendor to other people to sell your products for you.
    if (vBitChanges & CHANGED_OWNER){

        llResetScript();

    }

}

//Reset the vendor upon rezzing
on_rez(integer start_param){

    llResetScript();

}

//set the current price to the value of num. This is incase that the user over/under pays for the item
link_message(integer sender_num, integer num, string str, key id){

    if(str == "updatePrice"){

        gintCurrentPrice = num;
        
        //If the price of the item is free
        if(gintCurrentPrice == 0){
            
            state giveAwayFreeProducts;
            
        }

    }

}

//Whenever an avatar pays an object that this script is in, check for correct amount.
//Then if correct amount is payed, notify the system of a sale
money(key giver, integer amount) {

    // has the user paid the correct amount?
    if (amount == gintCurrentPrice){

        // if so, thank the payer by name.
        llSay(0,"Thank you, " + llKey2Name(giver) + ".");
        //give them the lovely object displayed on the vendor

        //send message back to root object to give out product
        llMessageLinked(LINK_ROOT,0,"itemBought#" + (string)giver,NULL_KEY);

        // if settings card includes split details
        if (gintNumSplit > 0){
            
            debugMessage("Splitting Income...");
            splitMoney (amount);

        }

    }

    // is the amount paid less than it needs to be?
    else if (amount < gintCurrentPrice){

        // if so, tell them they're getting a refund, then refund their money.
        llSay(0,"You didn't pay enough, " + llKey2Name(giver) + ". Refunding your payment of L$" + (string)amount + ".");
        llGiveMoney(giver, amount); // refund amount paid.

    }

    // if it's not exactly the amount required, and it's not less than the amount required,
    // the payer has paid too much.
    else{

        // tell them they've overpaid.
        integer intRefund = amount - gintCurrentPrice; // determine how much extra they've paid.
        llSay(0,"You paid too much, " + llKey2Name(giver) + ". Your change is L$" + (string)intRefund + ".");
        llGiveMoney(giver, intRefund); // refund their change.
        //give them the lovely object displayed on the vendor

        //send message back to root object to give out product.
        llMessageLinked(LINK_ROOT,0,"itemBought#" + (string)giver,NULL_KEY);

        // if settings card includes split details
        if (gintNumSplit > 0){
            
            debugMessage("Splitting Income...");
            splitMoney (amount);

        }

    }

}

//Five minutes have elapsed, lets refresh our lindex data
timer(){
    
    //Time to start getting lindex data
    gkeyHTTPLindenToUSDollarRate = llHTTPRequest("http://secondlife.com/httprequest/homepage.php", [HTTP_METHOD, "GET"], "");

}

//Use http in this script pureley to collect lindex data
http_response(key request_id, integer status, list metadata, string body){
    
    //If the requested lindex page reponded correctly
    if(request_id == gkeyHTTPLindenToUSDollarRate && status == 200){
        
        //Split that garbled mess into data we can actually use
        list lstMetaData = llParseString2List(body,["\t","\n"],[]);
        //Set the rate using the 17th element of that data
        gfltLindenToUSDollarRate = 1.0 / llList2Float(lstMetaData,17);
        
        
    }
    
}

}

//In This state, the item is purchased whenever a prim is clicked upon
//This state is exited whenever the price changes to something that isn't free
state giveAwayFreeProducts{
    
changed( integer vBitChanges ){

    //Detect change of ownership, as this may indicate that the owner has deeded this object to a group, in which case we may want to disable Debit permission.
    //If any kind of split is activated you will have to disallow deeding this vendor to the group as groups cannot 'pay' other people out of the split.
    //This is really only relevant if you are giving this vendor to other people to sell your products for you.
    if (vBitChanges & CHANGED_OWNER){

        llResetScript();

    }

}

//Reset the vendor upon rezzing
on_rez(integer start_param){

    llResetScript();

}

//set the current price to the value of num. This is incase that the user over/under pays for the item
link_message(integer sender_num, integer num, string str, key id){

    if(str == "updatePrice"){

        gintCurrentPrice = num;
        
        //If the price isn't free anymore
        if(gintCurrentPrice > 0){
            
            state transactionsAcceptable;
            
        }

    }

}

//The User simply needs to touch the prim in order to get the item
touch_end(integer num_detected){
    
    //send message back to root object to give out product.
    llMessageLinked(LINK_ROOT,0,"itemBought#" + (string) llDetectedKey(0),NULL_KEY);
    
}
    
}