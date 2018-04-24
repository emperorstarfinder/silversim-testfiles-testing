///////////////////////////////////////////////////////////////////////////////////////////
// Score Display Script
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

integer THIS_WIDGET     = SCORE_DISPLAY;

// Channel to listen for new scores on.
integer SET_SCORE   = 503400;

// How many characters can be displayed on this score widget.
integer MAX_CHARS       = 6;  // 6 chars x 1 prim

// Used for padding.
string  SPACES  = "                    ";

// Text for the static portion of the display.
string  STATIC_TEXT = "Score:";

// Index values for characters of interest.
integer ELLIPSE = 15;
integer TILDE   = 126;

///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
/////////// END GLOBAL VARIABLES ////////////

default {
    state_entry() {
        // Set up this prim to display '~' as an ellipse character instead.
        integer ThisLink = llGetLinkNumber();
        llMessageLinked(ThisLink, RESET_INDICES, "", "");
        llMessageLinked(ThisLink, REMAP_INDICES, llList2CSV([TILDE, ELLIPSE]), "");
        
        // We start in this state:
        state Disabled;
    }
}

state Disabled {
    state_entry() {
        // Clear these two display prims.
        integer ThisLink = llGetLinkNumber();
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
        llMessageLinked(ThisLink - 1, DISPLAY_STRING, STATIC_TEXT, "");
        // Assume a score of '0' to start.
        llMessageLinked(ThisLink,     DISPLAY_STRING, "     0", "");
        
    }
        
    link_message(integer sender, integer channel, string mesg, key id) {
        if (channel == SET_SCORE) {
            integer MesgLen = llStringLength(mesg);
            // If mesg is too short, pad it with spaces.
            if (MesgLen < MAX_CHARS)
                // Prepend some spaces to right-align the message.
                mesg = llGetSubString(SPACES, MesgLen, MAX_CHARS - 1) + mesg;
            // If mesg is too long, clip it.
            else if (MesgLen > MAX_CHARS)
                // Clip the message, and show an ellipse.
                mesg = llGetSubString(mesg, 0, MAX_CHARS - 2) + "~";    
                
            // Render the score.
            llMessageLinked(llGetLinkNumber(), DISPLAY_STRING, mesg, "");   
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
