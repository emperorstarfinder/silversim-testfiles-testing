///////////////////////////////////////////////////////////////////////////////////////////
// Shuffles Left Display Script
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
// XyText Message Map.
integer DISPLAY_STRING      = 204000;
integer DISPLAY_EXTENDED    = 204001;
integer REMAP_INDICES       = 204002;
integer RESET_INDICES       = 204003;
integer SET_CELL_INFO       = 204004;

// This sets which widgets are enabled.
integer SET_ENABLED     = 1013349680;

// Viewable widget flags.
integer DISABLE_ALL             = 0;
integer SHUFFLE_BUTTON          = 1;
integer GET_HINT_BUTTON         = 2;
integer GIVE_UP_BUTTON          = 4;
integer PLAY_GAME_BUTTON        = 8;
integer SCORE_DISPLAY           = 16;
integer SHUFFLES_LEFT_DISPLAY   = 32;
integer ROUND_DISPLAY           = 64;

integer THIS_WIDGET     = SHUFFLES_LEFT_DISPLAY;

// Channel to listen for new scores on.
integer SET_SHUFFLES_LEFT   = 503402;

// Text for the static portion of the display.
string  STATIC_TEXT_1 = "Shuffl";
string  STATIC_TEXT_2 = "es Lef";
string  PREFIX        = "t: ";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
/////////// END GLOBAL VARIABLES ////////////

default {
    state_entry() {        
        // We start in this state:
        state Disabled;
    }
}

state Disabled {
    state_entry() {
        // Clear these three display prims.
        integer ThisLink = llGetLinkNumber();
        llMessageLinked(ThisLink - 2, DISPLAY_STRING, "", "");
        llMessageLinked(ThisLink - 1, DISPLAY_STRING, "", "");
        llMessageLinked(ThisLink,     DISPLAY_STRING, "", "");
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        // Wait for a message to become enabled.
        if (channel == SET_ENABLED) {
            // See if this button is being enabled.
            integer Flags = (integer) data;
            if (Flags & THIS_WIDGET) {
                state Enabled;
            }
        }
    }
}

state Enabled {
    state_entry() {
        integer ThisLink = llGetLinkNumber();
        // Show the static display text.
        llMessageLinked(ThisLink - 2, DISPLAY_STRING, STATIC_TEXT_1, "");
        llMessageLinked(ThisLink - 1, DISPLAY_STRING, STATIC_TEXT_2, "");
        // Assume 3 shuffles to start.
        llMessageLinked(ThisLink,     DISPLAY_STRING, PREFIX + "3", "");
    }
        
    link_message(integer sender, integer channel, string mesg, key id) {
        if (channel == SET_SHUFFLES_LEFT) {                
            // Render the number of shuffles left.
            llMessageLinked(llGetLinkNumber(), DISPLAY_STRING, PREFIX + mesg, "");   
            return;      
        }  
        // Wait for a message to become disabled.
        if (channel == SET_ENABLED) {
            // See if this button is being disabled.
            integer Flags = (integer) mesg;
            if (Flags & THIS_WIDGET)
                // Still enabled, just return;
                return;
            else
                // No longer enabled.
                state Disabled;
        }      
    }    
}
