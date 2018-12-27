//---------------------------------------------------------------------------------//
//Copyright Info Below... Please Do not Remove                                     //
//---------------------------------------------------------------------------------//

//(c)2007 Ilobmirt Tenk

//This file is part of the FOSSL Vendor Project

//    FOSSL Vendor is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 3 of the License, or
//    (at your option) any later version.

//    FOSSL Vendor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

//---------------------------------------------------------------------------------//
//Copyright Info Above... Please Do not Remove                                     //
//---------------------------------------------------------------------------------//

//=================================================================//
//List all the global variables here...
//=================================================================//

//count of the current Notecard line to read
integer intSettingLines = 0;

//key of the notecard line to be read
key keySettingsId;

//This is the slurl to the server location
string strServerLocation = "";

//This counts the number of times the server has been made to deliver an item
integer intServerDeliveries = 0;

//determines if this object displays debugging output
integer blnDebug = FALSE;

//=================================================================//
//Customize the following variables
//=================================================================//

//determines if this script will outsource its e-mail functionality to save itself from that horrid 20 second delay
integer blnEmailAgents = FALSE;

//The name of the products notecard vendor clients will be reading off of
string strProductsCardName = "FOSSL_PRODUCTS_LIST";

//The channel in which server will listen to its owner
integer intListenChannel = 54;

//The key in which communication wil be encrypted with
string strEncryptionKey = "";

//determines if this server will allow others inworld to access the server
integer blnAnonAccess = TRUE;

//determines if this server will allow others outside of Secondlife to access the server
integer blnOutsideAccess = FALSE;

//Email this address upon a deliverey to say that an item has been given to the customer
string strEmailOnDeliverey = ""; 

//=================================================================//
//Customize the above variables
//=================================================================//

//This displays messages to the owner if debug mode has been set to true
debugMessage(string strMessage){

    if(blnDebug == TRUE){

        llOwnerSay(strMessage);
        
    }
    
}

//Used for encrypting communications between itself and the inworld server
string encrypt(string strPayload){

    //If there is an encryption key...
    if(strEncryptionKey != ""){

        //Use this simple Algrorythm to encrypt/decrypt input string
        return llXorBase64StringsCorrect(llStringToBase64(strPayload), llStringToBase64(strEncryptionKey));

    }
    //otherwise...
    else{

        //Just return the string as is.
        return strPayload;

    }

}

//Used for decrypting communications between itself and the inworld server
string decrypt(string strPayload){

    //If there is an encryption key...
    if(strEncryptionKey != ""){

        //Use this simple Algrorythm to encrypt/decrypt input string
        return llBase64ToString(llXorBase64StringsCorrect(strPayload, llStringToBase64(strEncryptionKey)));

    }
    //otherwise...
    else{

        //Just return the string as is.
        return strPayload;
            
    }

}

default
{
    state_entry(){

        //Obtain the first line of the vendor link settings
        keySettingsId = llGetNotecardLine("FOSSL_SERVER_SETTINGS", intSettingLines);
        
        vector vectSimLocation = llGetPos();
        string strPosX = (string) llRound(vectSimLocation.x);
        string strPosY = (string) llRound(vectSimLocation.y);
        string strPosZ = (string) llRound(vectSimLocation.z);
        
        strServerLocation = "http://slurl.com/secondlife/" + llEscapeURL(llGetRegionName()) + "/" + strPosX + "/" + strPosY + "/" + strPosZ;
        debugMessage("Server Location = " + strServerLocation );
        
    }

    //Reset the script when the container object gets rezzed
    on_rez(integer intParam){
     
        llResetScript();
              
    }

    //If somehing within the server changed, update the setting by resetting the script
    changed(integer change){
     
        // If I change the contents of the server
        if(change & CHANGED_INVENTORY){ 

            llOwnerSay("Server contents changed!");
            llOwnerSay("Resetting script to make use of those changes.");
            //reset the script to make use of the changes
            llResetScript();
            
        }
              
    }

    //Read the server settings notecard. Configure the server based on each line.
    dataserver(key query_id, string data) {
        
        if (query_id == keySettingsId) {
            if (data != EOF) {    // not at the end of the notecard

                debugMessage("Notecard Line = \"" + data + "\"");
                //split the record into variable names and values
                list lstSplit = llParseString2List(data,["="],[]);
                string strVariable = llToUpper(llStringTrim(llList2String(lstSplit,0),STRING_TRIM));
                string strValue = llStringTrim(llList2String(lstSplit,1),STRING_TRIM);

                if(strVariable == "PRODUCT CARD"){

                    strProductsCardName = strValue;
                    debugMessage("strProductsCardName = " + strProductsCardName);
            
            
                }
                if(strVariable == "EMAIL AGENTS"){

                    blnEmailAgents = (integer) strValue;
                    debugMessage("blnEmailAgents = " + (string) blnEmailAgents);
            
                }
                
                if(strVariable == "CHANNEL"){

                    intListenChannel = (integer) strValue;
                    debugMessage("intListenChannel = " + (string) intListenChannel);
                    
                }

                if(strVariable == "KEY"){

                    strEncryptionKey = strValue;
                    debugMessage("strEncryptionKey = " + strEncryptionKey);
                    
                }

                if(strVariable == "ANON ACCESS"){

                    blnAnonAccess = (integer) strValue;
                    debugMessage("blnAnonAccess = " + (string) blnAnonAccess);
                    
                }

                if(strVariable == "OUTSIDE ACCESS"){

                    blnOutsideAccess = (integer) strValue;
                    debugMessage("blnOutsideAccess = " + (string) blnOutsideAccess);
                    
                }        
                if(strVariable == "EMAIL"){
                
                    strEmailOnDeliverey = strValue;
                
                }

                keySettingsId = llGetNotecardLine("FOSSL_SERVER_SETTINGS", ++intSettingLines); // request next line
            }
            //Server is done reading its settings. Start listening to the owner and start ilstening in for those e-mails
            else{

                //Capture toggle of Debug Setings
                llListen(intListenChannel,"",llGetOwner(),"debug");
                llListen(intListenChannel,"",llGetOwner(),"id");
                llListen(intListenChannel,"",llGetOwner(),"reset");
                llListen(intListenChannel,"",llGetOwner(),"count");

                llOwnerSay("Server has completed setup.");
                llOwnerSay("Please use \"" + (string) llGetKey() + "\" as the value of \"SERVER\" in the client vendors if you want them to point to this server.");

                llSetTimerEvent(1.0); //set e-mail poll time to 1 second
                                      
            }
        }
        
    }

    //Follow the commands spoken by its owner
    listen(integer channel, string name, key id, string message)
    {

        //If owner wants to listen to the vendor's debug messages
        if(message == "debug"){

            blnDebug = !blnDebug;
            llOwnerSay("Debug Mode set to: " + (string) blnDebug);
            
        }
        //If Owner wants to listen to the server's Id
        else if(message == "id"){

            llOwnerSay("Please use \"" + (string) llGetKey() + "\" as the value of \"SERVER\" in the client vendors if you want them to point to this server.");
            
        }
        //If Owner wants the server to reset its script
        else if(message == "reset"){

            llOwnerSay("Resetting the Server upon command...");
            llResetScript();
            
        }
        else if(message == "count"){
         
            llOwnerSay( "This server has delivered " + (string) intServerDeliveries + " objects since script initialization.");
               
        }
        //Owner didn't give it an adequate command
        else{

            llOwnerSay("I don't know what you want me to do.");
            
        }
        
    }

    //Use this event to poll for incomming e-mails
    timer()
    {

        //poll for any incomming e-mail
        //filtering happens at the e-mail event
        llGetNextEmail("","");
        
    }

    //Triggered when e-mail poll yeids an incomming e-mail
    email(string time, string address, string subject, string body, integer remaining)
    {

        key keyRequester = (key) llGetSubString(address,0,35); //obtain requester uuid from address
        key keyRequesterOwner = llGetOwnerKey(keyRequester); //obtain the owner of the requesting object
        string strMessage = decrypt(llDeleteSubString(body, 0, llSubStringIndex(body, "\n\n") + 1)); //the message without e-mail headers
        string strSubject = decrypt(subject);
        debugMessage("E-mail From: " + address);
        debugMessage("E-mail Subject: " + subject);
        debugMessage("E-mail Message: " + strMessage);
        
        debugMessage("Object Key: " + (string) keyRequester);
        debugMessage("E-mail Owner: " + (string) keyRequesterOwner);
        debugMessage("Server Owner: " + (string) llGetOwner());

        //First condition:
        //Did the e-mail originate with an object made by the same person who owns this server?
        //Its considered safe to accept your own requests, not from others
        integer blnFirstCondition = (keyRequesterOwner == llGetOwner());

        //Second condition:
        //Does the server allow e-mail originate with an object made by someone else within Secondlife?
        //Its considered less safe than condition 1, but its safer than an a sophisticated attack by a web server
        integer blnSecondCondition = ((keyRequester != NULL_KEY) && (blnAnonAccess == TRUE));

        //Third condition:
        //Does the Server allow for ananymous outside access to thie server?
        //Careful, this is the least safest permission of all!!!
        //Source will not be checked for authenticity!!!
        integer blnThirdCondition = ((blnAnonAccess == TRUE) && (blnOutsideAccess == TRUE));
        

        //Does the source of the message meet any of the specified conditions?
        if( (blnFirstCondition == TRUE) || (blnSecondCondition == TRUE) || (blnThirdCondition == TRUE) ){

            debugMessage("Requester Passed Verification, processing request...");
            llSetTimerEvent(0.0); //Stop the polling timer in case there are more e-mails
            
            //If a client vendor requests for a new product card uuid
            if(strSubject == "Requesting Product List"){

                debugMessage("Giving " + (string) keyRequester + " the UUID of the product card.");
                
                //If there are available scripts dedicated to offloading the delay in llEmail, do so.
                //If not, make the e-mail request within this script taking into account the 20 second
                //script delay set in by LL to prevent e-mail spam. <:P
                if(blnEmailAgents == TRUE){

                    llMessageLinked(LINK_SET,0,"EmailRequest#" + address + "#" + encrypt("Update Product List") + "#" + encrypt((string) llGetInventoryKey(strProductsCardName)) ,NULL_KEY);

                }
                else{

                    llEmail(address,encrypt("Update Product List"),encrypt((string) llGetInventoryKey(strProductsCardName)));

                }
                
            }
            //If a client vendor requests for a product to be delivered
            else if(strSubject == "Give Item"){

                intServerDeliveries++;

                //Start by getting the person uuid and the object name
                list lstRequestSplit = llParseString2List(strMessage,["^"],[]);
                debugMessage("Giving " + llKey2Name((key) llList2String(lstRequestSplit,0)) + " a \"" + decrypt(llList2String(lstRequestSplit,1)) + "\"");
                //using the split list, give a person a product as described in the e-mail
                llGiveInventory((key) llList2String(lstRequestSplit,0), llList2String(lstRequestSplit,1));
                
                //Notify the certain e-mail address of a sale
                if(strEmailOnDeliverey != ""){
                    
                    //Send another E-mail Request hopefully, its just a missed e-mail request
                    //Make Request for product card UUID
                    //If there are available scripts dedicated to offloading the delay in llEmail, do so.
                    //If not, make the e-mail request within this script taking into account the 20 second
                    //script delay set in by LL to prevent e-mail spam. <:P
                    if(blnEmailAgents == TRUE){
                        
                        llMessageLinked(LINK_SET,0,"EmailRequest#" + strEmailOnDeliverey + "#Item Delivered - "+ llList2String(lstRequestSplit,1) +"#Purchaser - " + llList2String(lstRequestSplit,0) + "\nItem Purchased - " + llList2String(lstRequestSplit,1) +"\nLocation - " + strServerLocation,NULL_KEY);
                         debugMessage("Sent email notification to " + strEmailOnDeliverey);
                        
                    }
                    else{
                        
                        llEmail(strEmailOnDeliverey ,"Item Delivered - "+ llList2String(lstRequestSplit,1), "Purchaser - " + llList2String(lstRequestSplit,0) + "\nItem Purchased - " + llList2String(lstRequestSplit,1) +"\nLocation - " + strServerLocation);
                        
                    }
            
                }
                    
            }
        }

        //If there are no more e-mail requests, start polling using the timer
        if(remaining <= 0){

            llSetTimerEvent(1.0);
            
        }
        //Otherwise, just get the next message right here
        else{

            llGetNextEmail("","");
            
        }
            
    }

}