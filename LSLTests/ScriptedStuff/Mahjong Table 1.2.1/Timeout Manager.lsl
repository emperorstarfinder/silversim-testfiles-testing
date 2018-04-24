///////////////////////////////////////////////////////////////////////////////////////////
// Timeout Manager Script
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
// Message to issue as a warning.
string  WARNING_MESSAGE     = "Your game is about to end, due to inactivity.  Please select a tile to avoid this. =)";
// How long after no activity before doing
// a sensor sweep to see if the player is still there.
float   NO_ACTIVITY_TIMEOUT = 300.0;
// How long after no activity sensor sweep
// to give a warning, if the player is still there.
float   WARNING_TIMEOUT     = 240.0;
// How long after the warning before telling the
// game to time out.
float   FINAL_TIMEOUT       = 60.0;

// How far away a player can be from the table (in meters)
float   MAX_PLAYER_DISTANCE = 35.0;

// Channels for communicating with the timeout manager.
integer TIMEOUT_MANAGER_START_CHECKING  = 1230934100;
integer TIMEOUT_MANAGER_STOP_CHECKING   = 1230934101;
integer TIMEOUT_MANAGER_PLAYER_GONE     = 1230934102;

// Misc Constant.
integer NONE    = -1;

integer DEBUG   = FALSE;
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// The channel used to check for activity.
integer gActivityChannel;
// Key of the player to check for.
key     gPlayer;
/////////// END GLOBAL VARIABLES ////////////

TimeOut() {
    // Tell the game that this player timed out.
    llMessageLinked(llGetLinkNumber(), TIMEOUT_MANAGER_PLAYER_GONE, "", gPlayer);
}

default {
    state_entry() {
        state WaitForRequest;
    }
}

state WaitForRequest {  
    state_entry() {
        if (DEBUG) llSay(0, "state: WaitForRequest");
    }
          
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == TIMEOUT_MANAGER_START_CHECKING) {
            // Keep track of the channel, and player.
            gActivityChannel = (integer) data;
            gPlayer          = id;
            
            // Switch to the first state.
            state CheckForActivity;
        }
    }
}

state CheckForActivity {
    state_entry() {
        if (DEBUG) llSay(0, "state: CheckForActivity");
        // Start listening to this channel for activity.
        llListen(gActivityChannel, "", "", "");
        
        // Start the first timeout.
        llSetTimerEvent(NO_ACTIVITY_TIMEOUT);
    }
    
    listen(integer channel, string name, key id, string mesg) {
        // There was activity, push back the timeout.
        llSetTimerEvent(NO_ACTIVITY_TIMEOUT);        
    }
    
    timer() {
        // We timed out, no activity.
        state CheckForPlayer;
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == TIMEOUT_MANAGER_STOP_CHECKING) {
            // Stop checking, and wait for another request.
            state WaitForRequest;
        }
    }    
}

state CheckForPlayer {
    state_entry() {
        if (DEBUG) llSay(0, "state: CheckForPlayer");
        // Start listening to this channel for activity.
        llListen(gActivityChannel, "", "", "");
        
        // Do a sensor sweep to check for the player nearby.
        llSensor("", gPlayer, AGENT, MAX_PLAYER_DISTANCE, PI);
    }
    
    sensor(integer num_detected) {
        // The player is there, wait a little bit before bothering them.
        llSetTimerEvent(WARNING_TIMEOUT);
    }
    
    no_sensor() {
        // The player isn't even around, tell the game to time out.
        TimeOut();
        state WaitForRequest;
    }
    
    timer() {
        // We timed out, no activity.  Issue a warning.
        state Warning;
    }
    
    listen(integer channel, string name, key id, string mesg) {
        // There was activity, go back to waiting for more activity.
        state CheckForActivity;   
    }
        
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == TIMEOUT_MANAGER_STOP_CHECKING) {
            // Stop checking, and wait for another request.
            state WaitForRequest;
        }
    }    
}

state Warning {
    state_entry() {
        if (DEBUG) llSay(0, "state: Warning");
        // Start listening to this channel for activity.
        llListen(gActivityChannel, "", "", "");
        
        // Set up the final timeout.
        llSetTimerEvent(FINAL_TIMEOUT);
        
        // Warn the player.
        llInstantMessage(gPlayer, WARNING_MESSAGE);
    }
    
    listen(integer channel, string name, key id, string mesg) {
        // There was activity, go back to waiting for more activity.
        state CheckForActivity;   
    }
    
    timer() {
        // We timed out, no activity.
        TimeOut();
        state WaitForRequest;
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == TIMEOUT_MANAGER_STOP_CHECKING) {
            // Stop checking, and wait for another request.
            state WaitForRequest;
        }
    }    
}




