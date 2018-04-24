///////////////////////////////////////////////////////////////////////////////////////////
// Partner Manager Script
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
// Mode enumeration
integer FIND_PLAYER     = 0;
integer FIND_ALL        = 1;

// Farthest a partner can be from the player.
float   MAX_DISTANCE    = 100;

// Comm channel for partner script.
integer FIND_PARTNER    = 1023405620;
integer PARTNER_KEY     = 1023405621;

// Seperate to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
key     gPlayer;
vector  gPlayerPos;
integer gTileChannel;
integer gMode;
list    gNames;
list    gKeys;
integer gCallback = -1;
integer gDialogChannel;
/////////// END GLOBAL VARIABLES ////////////

SetPartner(key partner) {
    // Set this key in the tiles.
    llShout(gTileChannel, llDumpList2String(["PARTNER", partner], FIELD_SEPERATOR));
    // Tell the game this key as well.
    llMessageLinked(llGetLinkNumber(), PARTNER_KEY, "", partner);    
    
    // Report the partner choice.
    string PartnerName = llKey2Name(partner);
    if (PartnerName == "")
        PartnerName = "Nobody";
        
    llSay(0, PartnerName + " is now " + llKey2Name(gPlayer) + "'s MahJong partner.");
}

default {
    state_entry() { 
    }
    
    listen(integer channel, string name, key id, string mesg) {
        // Look up the key in the name list.
        integer Index = llListFindList(gNames, [mesg]);
        
        key Partner = llList2Key(gKeys, Index);
        SetPartner(Partner);
    }
    
    sensor(integer num_detected) {
        // Check our mode.
        if (gMode == FIND_PLAYER) {
            // Keep track of the player's position.
            gPlayerPos = llDetectedPos(0);
            // Now find all other agents.
            gMode = FIND_ALL;
            llSensor("", "", AGENT, 96.0, PI);
        }
        else { // gMode == FIND_ALL.
            // Create a list of all agents, with their distance from the player.
            list Agents;
            integer i;
            for (i = 0; i < num_detected; i++) {
                Agents += [ llVecDist(gPlayerPos, llDetectedPos(i)), llDetectedName(i), llDetectedKey(i) ];
            }
            
            // Sort by distance.
            Agents = llListSort(Agents, 3, TRUE);
                        
            // Remove the first agent, since that is the player.
            Agents = llDeleteSubList(Agents, 0, 2);
            
            // Create the name and key list.
            gNames = [];
            gKeys = [];
            
            for (i = 0; i < 3; i++) {
                // Split up this entry.
                float   Distance    = llList2Float (Agents, i * 3);
                string  Name        = llList2String(Agents, i * 3 + 1);
                key     ID          = llList2Key   (Agents, i * 3 + 2);
            
                
                // Make sure they are close enough (and that it is actually an entry)
                if (Distance <= MAX_DISTANCE && Name != "") {  
                    gNames += [Name];
                    gKeys  += [ID];
                }              
            }
            
            // Add the nobody entry at the end.
            gNames += ["Nobody"];
            gKeys  += [NULL_KEY];
            
            // Create random channel to listen on.
            gDialogChannel = llRound(llFrand(1.0) * 200000000) + 1;
            if (gCallback != -1)
                llListenRemove(gCallback);
                
            gCallback = llListen(gDialogChannel, "", "", "");
            
            // Give the dialog box.
            llDialog(gPlayer, "Please select a partner:", gNames, gDialogChannel);   
        }
    }
    
    no_sensor() {
        // Set the partner to nobody.
        SetPartner(NULL_KEY);
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == FIND_PARTNER) {
            // Keep track of the tile channel and player.
            gPlayer      = id;
            gTileChannel = (integer) data;
            
            // First find the player's position.
            gMode = FIND_PLAYER;
            llSensor("", gPlayer, AGENT, 96.0, PI);
        }
    }
}
