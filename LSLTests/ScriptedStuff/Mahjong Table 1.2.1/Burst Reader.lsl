///////////////////////////////////////////////////////////////////////////////////////////
// Burst Reader Script
//
// Copyright (c) 2004 Xylor Baysklef
//
// This file is part of MahJong for SL.
//
// MahJong for SL is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// MahJong for SL is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with MahJong for SL; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
///////////////////////////////////////////////////////////////////////////////////////////

/////////////// CONSTANTS ///////////////////
integer BURST_READ  = 8000;
// Seperator to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
/////////// END GLOBAL VARIABLES ////////////

default {    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == BURST_READ) {
            // Split up the message.
            list Parsed = llParseString2List(data, [FIELD_SEPERATOR], []);
            
            string Notecard     =           llList2String(Parsed, 0);
            integer FirstLine   = (integer) llList2String(Parsed, 1);
            integer NumToRead   = (integer) llList2String(Parsed, 2);
            
            // Burst read.
            integer i;
            for (i = FirstLine; i < FirstLine + NumToRead; i++) {
                llGetNotecardLine(Notecard, i);
            }
        }
    }
}
