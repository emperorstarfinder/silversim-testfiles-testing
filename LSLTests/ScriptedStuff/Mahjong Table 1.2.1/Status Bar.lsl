///////////////////////////////////////////////////////////////////////////////////////////
// Status Bar Script
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
// This is the channel we listen to for status messages.
integer STATUS_BAR      = 502000;
// This is the modified message, now centered.
integer STATUS_CENTERED = 502001;

// How many characters can be displayed on this status bar.
integer MAX_CHARS       = 18;  // 6 chars x 3 prims

// XyText Message Map.
integer DISPLAY_STRING      = 204000;
integer DISPLAY_EXTENDED    = 204001;
integer REMAP_INDICES       = 204002;
integer RESET_INDICES       = 204003;
integer SET_CELL_INFO       = 204004;

// Used for padding.
string  SPACES  = "                    ";

// Index values for characters of interest.
integer ELLIPSE = 15;
integer TILDE   = 126;
///////////// END CONSTANTS ////////////////

default {
    state_entry() {
        // Assume the other 2 displays of the status bar are the
        // 2 links after this link.
        integer ThisLink = llGetLinkNumber();
        
        // Set up each prim to listen on the same channel, but to render only a part of the string.
        llMessageLinked(ThisLink    , SET_CELL_INFO, llList2CSV([STATUS_CENTERED, 0]), "");
        llMessageLinked(ThisLink + 1, SET_CELL_INFO, llList2CSV([STATUS_CENTERED, 6]), "");
        llMessageLinked(ThisLink + 2, SET_CELL_INFO, llList2CSV([STATUS_CENTERED, 12]), "");
        
        // Set up the last prim to display '~' as an ellipse character instead.
        llMessageLinked(ThisLink + 2, RESET_INDICES, "", "");
        llMessageLinked(ThisLink + 2, REMAP_INDICES, llList2CSV([TILDE, ELLIPSE]), "");
    }
    
    link_message(integer sender, integer channel, string mesg, key id) {
        if (channel == STATUS_BAR) {
            // Center it, and pass it on to the XyText prims.
            integer MesgLen = llStringLength(mesg);
            
            // If mesg is too short, pad it with spaces.
            if (MesgLen < MAX_CHARS - 1)
                // Prepend some spaces to center the message.
                mesg = llGetSubString(SPACES, 0, (MAX_CHARS - MesgLen - 2) / 2) + mesg;
            // If mesg is too long, clip it.
            else if (MesgLen > MAX_CHARS)
                // Clip the message, and show an ellipse.
                mesg = llGetSubString(mesg, 0, MAX_CHARS - 2) + "~";
                
            // Show the message.
            llMessageLinked(LINK_SET, STATUS_CENTERED, mesg, "");
        }
    }
}
