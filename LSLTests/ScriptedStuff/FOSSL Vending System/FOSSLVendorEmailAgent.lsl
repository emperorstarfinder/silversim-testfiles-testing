//---------------------------------------------------------------------------------//
//Copyright Info Below... Please Do not Remove                                     //
//---------------------------------------------------------------------------------//

//(c)2007 Ilobmirt Tenk

//This file is part of the FOSSL Vendor Project

//    FOSSL Vendor is free software; you can redistribute it and/or modify
//    it under the terms of the Lesser GNU General Public License as published by
//    the Free Software Foundation; either version 3 of the License, or
//    (at your option) any later version.

//    FOSSL Vendor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    Lesser GNU General Public License for more details.

//    You should have received a copy of the Lesser GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

//---------------------------------------------------------------------------------//
//Copyright Info Above... Please Do not Remove                                     //
//---------------------------------------------------------------------------------//

default
{

    //Upon hearing "EmailRequest" send an e-mail to a designated target
    link_message(integer sender_number, integer number, string message, key id)
    {

        //split the message into manageable bits
        //intent of the message can be defined in index 0
        list lstMessageParsed = llParseString2List(message,["#"],[]);

        //Is it a request for an e-mail to be sent?
        if(llList2String(lstMessageParsed,0) == "EmailRequest"){

            //Send an e-mail using the rest of the list
            llEmail(llList2String(lstMessageParsed,1),llList2String(lstMessageParsed,2),llList2String(lstMessageParsed,3));
            
        }
        
    }
    
}