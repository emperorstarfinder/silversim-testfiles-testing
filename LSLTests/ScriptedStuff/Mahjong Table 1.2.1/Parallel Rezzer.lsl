///////////////////////////////////////////////////////////////////////////////////////////
// Parallel Rezzer Script
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
// Parallel Rezzer Comm Channels. (Private)
integer REGISTER        = 600200;
integer FORCE_REREGISTER= 600203;
integer REZZER_COMPLETED= 600204;

// Seperate to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// Temporary channel for registration response.
integer gResponseChannel;
// This is the channel we wait for rez commands.
integer gRezChannel;
/////////// END GLOBAL VARIABLES ////////////

default {
    state_entry() {
        // Register ourselves with the manager.
        state Register;
    }
}

state Register {
    state_entry() {
        // Create a random response channel, to listen for the 
        // registration response.
        gResponseChannel = llRound( llFrand(1.0) * 2000000000 ) + 1000000;
        
        // Register ourselves.
        llMessageLinked(llGetLinkNumber(), REGISTER, (string) gResponseChannel, "");
    }
        
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == gResponseChannel) {
            // We are registered, start waiting for commands on the given channel.
            gRezChannel = (integer) data;
            state WaitForCommand;
        }
    }
}


state WaitForCommand {
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == gRezChannel) {
            // Split up the rez request.
            list Parsed = llParseString2List(data, [FIELD_SEPERATOR], []);
            
            string Object   =           llList2String(Parsed, 0);
            vector Position = (vector)  llList2String(Parsed, 1);
            vector Velocity = (vector)  llList2String(Parsed, 2);
            rotation Rot    = (rotation)llList2String(Parsed, 3);
            integer BaseParam=(integer) llList2String(Parsed, 4);
            integer Count   = (integer) llList2String(Parsed, 5);
            
            // Rez this object count number of times.
            integer i;
            for (i = 0; i < Count; i++) {
                llRezObject(Object, Position, Velocity, Rot, BaseParam + i);
            }
            
            // Tell the manager we are done.
            llMessageLinked(sender, REZZER_COMPLETED, "", "");
                        
            return;
        }
        if (channel == FORCE_REREGISTER) {
            // Just register again.
            state Register;
            return;
        }
    }
}



