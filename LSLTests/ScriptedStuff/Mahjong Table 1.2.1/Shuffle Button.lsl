///////////////////////////////////////////////////////////////////////////////////////////
// Shuffle Button Script
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
// Face that the button is on.
integer FACE            = 0;

// Texture to show when enabled.
key     BUTTON_TEXTURE  = "71c8d78c-28d8-8f88-97ad-ec19441f5b06";
// Texture to show when disabled.
key     TRANSPARENT     = "701917a8-d614-471f-13dd-5f4644e36e3c";

// This sets which widgets are viewable.
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

integer THIS_WIDGET     = SHUFFLE_BUTTON;

// Button channels.
integer SHUFFLE         = 1014923100;
integer GET_HINT        = 1014923101;
integer TOGGLE_GAME     = 1014923102;

integer THIS_CHANNEL    = SHUFFLE;
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// Only this avatar can use the button.
key gPlayer         = NULL_KEY;
/////////// END GLOBAL VARIABLES ////////////

default {
    state_entry() {
        // Be sure nothing is being shown.
        llSetTexture(TRANSPARENT, FACE);
        // Start off in disabled state.
        state Disabled;
    }
}

state Disabled {
    link_message(integer sender, integer channel, string data, key id) {
        // Just wait for a message to become enabled.
        if (channel == SET_ENABLED) {
            // See if this button is being enabled.
            integer Flags = (integer) data;
            if (Flags & THIS_WIDGET) {
                // Keep track of the player's id.
                gPlayer = id;
                state Enabled;
            }
        }
    }
}
    
state Enabled {
    state_entry() {
        // Show the button texture.
        llSetTexture(BUTTON_TEXTURE, FACE);
    }
    
    state_exit() {
        // Remove the button texture.
        llSetTexture(TRANSPARENT, FACE);
    }
    
    touch_start(integer num_detected) {
        // Make sure this is the player.
        if (llDetectedKey(0) != gPlayer)
            return;
            
        // Send off a message that this button was pressed.
        llMessageLinked(LINK_SET, THIS_CHANNEL, "", gPlayer);
            
        // Switch the texture offset to show the button down portion.
        llOffsetTexture(0.25, 0.0, FACE);
    }
    
    touch_end(integer num_detected) {
        // Make sure this is the player.
        if (llDetectedKey(0) != gPlayer)
            return;
            
        // Switch the texture offset to show the button up portion.
        llOffsetTexture(-0.25, 0.0, FACE);
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        // Wait for a message to become disabled.
        if (channel == SET_ENABLED) {
            // See if this button is being disabled.
            integer Flags = (integer) data;
            if (Flags & THIS_WIDGET)
                // This widget is still enabled, just return.
                return;
            else
                // This widget isn't flagged to be enabled; become disabled.
                state Disabled;
        }
    }
}
