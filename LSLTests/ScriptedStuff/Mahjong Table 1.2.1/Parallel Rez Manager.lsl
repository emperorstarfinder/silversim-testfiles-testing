///////////////////////////////////////////////////////////////////////////////////////////
// Parallel Rez Manager Script
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
integer REZ_BASE        = 600300;

// Parallel Rezzer Comm Channels. (Public)
integer PARALLEL_REZ    = 600100;
integer DONE_REZZING    = 600101;

// Seperator to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// How many rezzers are currently registered.
integer gNumRegistered;
// How many rezzers have completed their task.
integer gNumCompleted;
/////////// END GLOBAL VARIABLES ////////////

default {
    state_entry() {
        // Tell the parallel rez scripts to re-register.
        llMessageLinked(llGetLinkNumber(), FORCE_REREGISTER, "", "");
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == REZZER_COMPLETED) {
            gNumCompleted++;
            if (gNumCompleted == gNumRegistered) {
                // We are done, send this info back.
                llMessageLinked(LINK_SET, DONE_REZZING, "", "");
            }
            return;
        }
        if (channel == PARALLEL_REZ) {
            // If there isn't anything registered, we can't do anything!
            if (gNumRegistered == 0) {
                llSay(0, "ERROR: No rezzers registered.");
                return;
            }
            
            // Split up the rez request.
            list Parsed = llParseString2List(data, [FIELD_SEPERATOR], []);
            
            string Object   =           llList2String(Parsed, 0);
            vector Position = (vector)  llList2String(Parsed, 1);
            vector Velocity = (vector)  llList2String(Parsed, 2);
            rotation Rot    = (rotation)llList2String(Parsed, 3);
            integer BaseParam=(integer) llList2String(Parsed, 4);
            integer Count   = (integer) llList2String(Parsed, 5);
            
            // We want to rez this object Count times, with a base parameter we
            // add the current count to for the parameter.
            integer ChunkSize = Count / gNumRegistered;
            
            // Loop through all the registered rezzers except the last one
            // which will rez all the remaining objects.
            integer i;
            integer ThisLink = llGetLinkNumber();
            integer LastRegistered = gNumRegistered - 1;
            for (i = 0; i < LastRegistered; i++) {
                // Tell the rezzer to rez its 'chunk'.
                llMessageLinked(ThisLink, REZ_BASE + i, llDumpList2String(
                        [Object, Position, Velocity, Rot, BaseParam + i * ChunkSize, ChunkSize],
                        FIELD_SEPERATOR), "");
            }
            
            // Rez the last chunk.
            integer NumLeft = Count - LastRegistered * ChunkSize;
            llMessageLinked(ThisLink, REZ_BASE + LastRegistered, llDumpList2String(
                        [Object, Position, Velocity, Rot, 
                            BaseParam + LastRegistered * ChunkSize, NumLeft], 
                        FIELD_SEPERATOR), "");
            
            // Wait for the rezzers to send back completion notification.
            gNumCompleted = 0;
            return;
        }
        if (channel == REGISTER) {
            // Return back the channel this rezzer should listen on.
            integer ResponseChannel = (integer) data;
            llMessageLinked(sender, ResponseChannel, (string) (REZ_BASE + gNumRegistered), "");
            
            llSay(0, "Rezzer #" + (string) gNumRegistered + " registered on channel " +
                        (string) (REZ_BASE + gNumRegistered) + ".");
            // Increase how many rezzers we have registered.
            gNumRegistered++;
            return;
        }
    }
}
