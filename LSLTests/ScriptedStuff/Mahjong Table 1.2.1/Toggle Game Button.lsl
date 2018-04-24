///////////////////////////////////////////////////////////////////////////////////////////
// Toggle Game Button Script
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
key     PLAY_GAME_TEXTURE   = "45591f57-491e-ba0f-4539-ebf2a195581b";
key     GIVE_UP_TEXTURE     = "aba5237a-0d53-7568-86da-a0b82dfb6b6a";
// Texture to show when disabled.
key     TRANSPARENT         = "701917a8-d614-471f-13dd-5f4644e36e3c";

// This sets which widgets are viewable.
integer SET_ENABLED     = 1013349680;

// Viewable widget flags.
integer VIEW_NOTHING            = 0;
integer SHUFFLE_BUTTON          = 1;
integer GET_HINT_BUTTON         = 2;
integer GIVE_UP_BUTTON          = 4;
integer PLAY_GAME_BUTTON        = 8;
integer SCORE_DISPLAY           = 16;
integer SHUFFLES_LEFT_DISPLAY   = 32;
integer ROUND_DISPLAY           = 64;

// Button channels.
integer SHUFFLE         = 1014923100;
integer GET_HINT        = 1014923101;
integer TOGGLE_GAME     = 1014923102;
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// Only this avatar can use the button.
key gPlayer         = NULL_KEY;
/////////// END GLOBAL VARIABLES ////////////

default {
    state_entry() {
        // Start off in disabled state.
        state Disabled;
    }
}

state Disabled {
    state_entry() {
        // Remove the button texture.
        llSetTexture(TRANSPARENT, FACE);
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        // Just wait for a message to become enabled.
        if (channel == SET_ENABLED) {
            // Keep track of this.
            gPlayer = id;
            // See if this button is being enabled.
            integer Flags = (integer) data;
                    
            if (Flags & PLAY_GAME_BUTTON) {
                state PlayGameButton;
            }
            if (Flags & GIVE_UP_BUTTON) {
                state GiveUpButton;
            }
        }    
    }
}
    
state PlayGameButton {
    state_entry() {
        // Switch the texture offset to show the button up portion.
        llOffsetTexture(-0.25, 0.0, FACE);
        // Show the button texture.
        llSetTexture(PLAY_GAME_TEXTURE, FACE);
    }
    
    touch_start(integer num_detected) {
        // Send off a message that this button was pressed.
        llMessageLinked(LINK_SET, TOGGLE_GAME, "", llDetectedKey(0));
            
        // Switch the texture offset to show the button down portion.
        llOffsetTexture(0.25, 0.0, FACE);
    }
    
    touch_end(integer num_detected) {            
        // Switch the texture offset to show the button up portion.
        llOffsetTexture(-0.25, 0.0, FACE);
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        // Wait for a message to become disabled.
        if (channel == SET_ENABLED) {
            // See if this button is being disabled.
            integer Flags = (integer) data;
                      
            if (Flags & PLAY_GAME_BUTTON) {
                // Already active, just return;
                return;
            }
            if (Flags & GIVE_UP_BUTTON) {
                state GiveUpButton;
            }
            // Neither were enabled...
            state Disabled;
        }
    }
}

    
state GiveUpButton {
    state_entry() {
        // Switch the texture offset to show the button up portion.
        llOffsetTexture(-0.25, 0.0, FACE);
        // Show the button texture.
        llSetTexture(GIVE_UP_TEXTURE, FACE);
    }
    
    touch_start(integer num_detected) {
        // Make sure only the player clicks this.
        if (llDetectedKey(0) != gPlayer)
            return;
            
        // Send off a message that this button was pressed.
        llMessageLinked(LINK_SET, TOGGLE_GAME, "", llDetectedKey(0));
            
        // Switch the texture offset to show the button down portion.
        llOffsetTexture(0.25, 0.0, FACE);
    }
    
    touch_end(integer num_detected) { 
        // Make sure only the player clicks this.
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
                      
            if (Flags & GIVE_UP_BUTTON) {
                // Already active, just return;
                return;
            }
            if (Flags & PLAY_GAME_BUTTON) {
                state PlayGameButton;
            }
            // Neither were enabled...
            state Disabled;
        }
    }
}
