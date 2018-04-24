///////////////////////////////////////////////////////////////////////////////////////////
// Mahjong Game Script
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
// How much of a handicap to give people using the show selectable feature.
float   SHOW_SELECTABLE_HANDICAP    = 0.75;

// Particle color to use if handicapped.
//vector  HANDICAP_COLOR  = <0.769, 1.0, 0.824>;
vector  HANDICAP_COLOR  = <1, 1, 0.5>;
// Particle color to use if not handicap.
//vector  NORMAL_COLOR    = <0.000000, 0.250980, 0.501961>;
vector  NORMAL_COLOR    = <1, 1, 1>;
// Particle color to use for a bonus.
//vector  BONUS_COLOR     = <0, 0.5, 0.5>;
vector  BONUS_COLOR     = <1, 0, 0>;

// Tile shuffler.
integer SHUFFLE_TILES   = 700100;
integer SHUFFLE_DONE    = 700101;
integer RESHUFFLE_TILES = 700102;
integer RESHUFFLE_DONE  = 700103;
integer PAIR_REMOVED    = 700104;

// This is the channel we report scores on.
integer MAHJONG_SCORES      = 2104320391;

// Channels for communicating with the timeout manager.
integer TIMEOUT_MANAGER_START_CHECKING  = 1230934100;
integer TIMEOUT_MANAGER_STOP_CHECKING   = 1230934101;
integer TIMEOUT_MANAGER_PLAYER_GONE     = 1230934102;

// Channels for comms with the pattern builder.
integer BUILD_PATTERN       = 1341120230;
integer BUILD_PATTERN_DONE  = 1341120231;

// This sets the status bar text.
integer STATUS_BAR  = 502000;

// This sets which widgets are viewable.
integer SET_ENABLED = 1013349680;

// Viewable widget flags.
integer DISABLE_ALL             = 0;
integer SHUFFLE_BUTTON          = 1;
integer GET_HINT_BUTTON         = 2;
integer GIVE_UP_BUTTON          = 4;
integer PLAY_GAME_BUTTON        = 8;
integer SCORE_DISPLAY           = 16;
integer SHUFFLES_LEFT_DISPLAY   = 32;
integer ROUND_DISPLAY           = 64;
integer PARTNER_BUTTON          = 128;
integer SHOW_SELECTABLE         = 256;
integer HIDE_SELECTABLE         = 512;

// Button channels.
integer SHUFFLE         = 1014923100;
integer GET_HINT        = 1014923101;
integer TOGGLE_GAME     = 1014923102;
integer PARTNER         = 1014923103;
integer TOGGLE_SELECTABLE = 1014923104;

//integer GET_HINT_RESET  = 1014923101;

// Comm channel for partner script.
integer FIND_PARTNER    = 1023405620;
integer PARTNER_KEY     = 1023405621;

// Misc particle channel.
integer SCORE_PARTICLES     = 1494102390;

// Widget channels.
integer SET_SCORE           = 503400;
integer SET_ROUND           = 503401;
integer SET_SHUFFLES_LEFT   = 503402;

// Name of the tile object.
string  STANDARD_SET    = "Tile";
string  MAYAN_SET       = "Tile - Mayan";

// Misc constant.
integer NONE            = -1;

// Suit multipliers (for scoring).
string  SUIT_MULTIPLIERS = "hcbwdfs";

// Seperator to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// Tile channel.
integer gTileChannel;
// Board channel.
integer gBoardChannel;
integer gBoardCallback;

// How many tiles are on the board.
integer gNumTiles;

// Name of the tile set.
string  gTileObject     = STANDARD_SET;

// The player's key and name.
key     gPlayer;
string  gPlayerName;
key     gPartner;

// How many pairs are left on the board.
integer gPairsLeft;
// Current score.
integer gScore;
// Current round.
integer gRound;
// Current pattern number.
integer gPatternNum;
// Name of the pattern we are using.
string  gPattern;
// How many shuffles are left.
integer gShufflesLeft;

// Whether or not there was a hint since the last pair match.
integer gHadHint;
// The hint we had, if any.
integer gHint1;
integer gHint2;

// This is to check if they chose the same pair twice in a row.
string  gLastMatch;

// This is used to handicap people using the selectable tiles view.
float   gHandicap = 1.0;
integer gShowSelectable = FALSE;

// These lists are used to figure out a match.
list    gSelectableChannels;
list    gSelectableTypes;

// This is the currently active tile.
integer gActiveTile;
string  gActiveType;
vector  gActivePos;
/////////// END GLOBAL VARIABLES ////////////

NextPattern() {
    // Move to the next pattern in the inventory.
    gPatternNum++;
    integer NumPatterns = llGetInventoryNumber(INVENTORY_NOTECARD);
    
    // Start over if we run out of pattern.
    if (gPatternNum >= NumPatterns)
        gPatternNum = 0;
        
    // Use this pattern notecard for the next round.    
    gPattern = llGetInventoryName(INVENTORY_NOTECARD, gPatternNum);
}

integer SuitMultiplier(string type) {
    string Suit = llGetSubString(type, 0, 0);
    // Look up the multiplier value.
    return llSubStringIndex(SUIT_MULTIPLIERS, Suit) + 1;
    
}

integer IsMatch(string type1, string type2) {
    // Check to see if this is a match.
    
    // First, check for the simple match.
    if (type1 == type2)
        return TRUE;
    
    string Suit1 = llGetSubString(type1, 0, 0);
    string Suit2 = llGetSubString(type2, 0, 0);
    
    // Now check for a flower match.
    if (Suit1 == "f" && Suit2 == "f")
        return TRUE;
        
    // Finally, check for a season match.
    if (Suit1 == "s" && Suit2 == "s")
        return TRUE;
    
    // Otherwise it isn't a match.
    return FALSE;
}

Status(string  mesg) {
    // This sets the status bar message.
    llMessageLinked(LINK_SET, STATUS_BAR, mesg, "");
}

RemoveSelectable(integer tile_channel) {
    // Find the index of this tile in the list.
    integer Index = llListFindList(gSelectableChannels, [tile_channel]);
    
    // This shouldn't happen...
    if (Index == NONE) {
        llSay(0, "ASSERTION FAILED: RemoveSelectable::Index == NONE");
        return;
    }
    
    // Remove this tile from the list.
    gSelectableChannels = llDeleteSubList(gSelectableChannels, Index, Index);
    gSelectableTypes    = llDeleteSubList(gSelectableTypes,    Index, Index);
}

default {
    state_entry() {
        state WaitForGame;
    }
}

state WaitForGame {    
    state_entry() {
        Status("Waiting for Game");
        
        // Show the play game button.
        llMessageLinked(LINK_SET, SET_ENABLED, (string) PLAY_GAME_BUTTON, "");
        
        // Listen for pattern command.
        llListen(0, "", "", "");
        gPatternNum = 0;
        // Use the standard set as default.
        gTileObject = STANDARD_SET;
        
        // Reset selectable view.
        gShowSelectable = FALSE;
        gHandicap       = 1.0;
        
        // Set no partner to start.
        gPartner = NULL_KEY;
    }
    
    state_exit() {
        // Deactivate the play game, button.
        llMessageLinked(LINK_SET, SET_ENABLED, (string) DISABLE_ALL, "");
        
        // Convert the pattern number into a pattern name.
        gPattern = llGetInventoryName(INVENTORY_NOTECARD, gPatternNum);
    }
    
    listen(integer channel, string name, key id, string mesg) {
        if (llGetSubString(mesg, 0, 7) == "pattern ") {
            integer NewPattern = (integer) llGetSubString(mesg, 8, -1) - 1;
            string NewPatternName = llGetInventoryName(INVENTORY_NOTECARD, NewPattern);
            // Make sure it exists.
            if (llGetInventoryKey(NewPatternName) == NULL_KEY) {
                llSay(0, "Pattern '" + (string) (NewPattern + 1) + "' not found.");
                return;
            }
            
            // Otherwise use this pattern.
            gPatternNum = NewPattern;
            list Parsed = llParseString2List(NewPatternName, [","], []);
            string PatName = llList2String(Parsed, 1);
            llSay(0, "First pattern set to '" + PatName +"'.");
            return;
        }
        //if (mesg == "set mayan") {
        //    // Change tile sets.
        //    gTileObject = MAYAN_SET;
       //     llSay(0, "Tile Set: Mayan");
        //}
        else if (mesg == "set standard") {
            // Change tile sets.
            gTileObject = STANDARD_SET;
            llSay(0, "Tile Set: Standard");
        }
    }
        
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == TOGGLE_GAME) {
            // Keep track of the player that started this game.
            gPlayer     = id;
            gPlayerName = llKey2Name(gPlayer);
                        
            // Initialize game values.
            gScore   = 0;
            gRound   = 1;
            gShufflesLeft = 3;
            
            // Build the pattern.
            state BuildPattern;
        }
    }
}

state BuildPattern {
    state_entry() {          
        // Tell the pattern builder to start building.
        llMessageLinked(llGetLinkNumber(), BUILD_PATTERN, 
            llDumpList2String([gPattern, gTileObject], FIELD_SEPERATOR), "");
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        // Just wait for the pattern to finish building.
        if (channel == BUILD_PATTERN_DONE) {
            // Parse the message.
            list Parsed = llCSV2List(data);
            // Extract the entires.
            gTileChannel    = (integer) llList2String(Parsed, 0);
            gBoardChannel   = (integer) llList2String(Parsed, 1);
            // Move on.
            state ShuffleTiles;
        }
    }   
}

state ShuffleTiles {
    state_entry() {
        Status("Shuffling");
        // Tell the shuffle script to start, and wait for it to complete.
        llMessageLinked(llGetLinkNumber(), SHUFFLE_TILES, (string) gTileChannel, "");
    }
    
    state_exit() {
        // There are now 72 pairs on the board.
        gPairsLeft  = 72;
                
        // Enable the appropriate widgets.
        llMessageLinked(LINK_SET, SET_ENABLED, (string) 
                (SHUFFLE_BUTTON | GET_HINT_BUTTON | GIVE_UP_BUTTON | SCORE_DISPLAY |
                 SHUFFLES_LEFT_DISPLAY | ROUND_DISPLAY | SHOW_SELECTABLE | PARTNER_BUTTON), gPlayer);
                 
        // Show 3 shuffles left on the display.
        llMessageLinked(LINK_SET, SET_SHUFFLES_LEFT, (string) gShufflesLeft, "");
                 
        // Tell the tiles the key of the player, so they can
        // start accepting clicks.
        llShout(gTileChannel, llDumpList2String(
                    ["PLAYER", gPlayer], FIELD_SEPERATOR));
                 
        // Tell the tiles to check for tiles over each other (ie blocking
        // the view of the tile type).
        llShout(gTileChannel, llDumpList2String(
                    ["RUN SENSOR", 0], FIELD_SEPERATOR));
                    
        // Tell the tiles the partner's key, if one is set.
        if (gPartner != NULL_KEY)
            llShout(gTileChannel, llDumpList2String(["PARTNER", gPartner], FIELD_SEPERATOR));
    }
            
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == SHUFFLE_DONE) {
            // We are done shuffling, move on.
            state PlayGame;
        }
    }
}

state ReshuffleTiles {
    state_entry() {
        Status("Reshuffling");
        // Tell the shuffle script to re-shuffle the tiles already on the board.
        llMessageLinked(llGetLinkNumber(), RESHUFFLE_TILES, "", "");
    } 
    
    listen(integer channel, string name, key id, string mesg) {
        if (channel == gBoardChannel) {
            // Parse the message.
            list Parsed = llParseString2List(mesg, [FIELD_SEPERATOR], []);
            string Command = llList2String(Parsed, 0);
                            
            // Check the command.
            if (Command == "ACTIVE") {
                // We are busy re-shuffling.  Tell any tile
                // wishing to be active, too bad.
                integer ClickedTile = (integer) llList2String(Parsed, 3);
                llShout(ClickedTile, "DEACTIVATE");
            }
        }
    }
     
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == RESHUFFLE_DONE) {
            // Decrement the number of shuffles left.
            gShufflesLeft--;
            llMessageLinked(LINK_SET, SET_SHUFFLES_LEFT, (string) gShufflesLeft, "");
            
            state PlayGame;
        }
    }
}

state PlayGame {
    state_entry() {                
        // Show the pattern name.
        list Parsed = llCSV2List(gPattern);
        string PatternName = llList2String(Parsed, 1);
        Status(PatternName);
        // No tiles are active, to start.
        gActiveTile = NONE;
        gHadHint    = FALSE;
        // Clear the last match type.
        gLastMatch = "";
                
        // Start listening for board messages.
        if (gBoardCallback != NONE)
            llListenRemove(gBoardCallback);
        gBoardCallback = llListen(gBoardChannel, "", "", "");
        
        // Clear selectable lists.        
        gSelectableChannels = [];
        gSelectableTypes    = [];
        
        // Ask the board for all selectable tiles, so we can find matches.
        llShout(gTileChannel, "CHECK SELECTABLE");
        
        // Check the show selectable flag.
        if (gShowSelectable) {
            gHandicap = SHOW_SELECTABLE_HANDICAP;
            // Tell the tiles to show selectable.
            llShout(gTileChannel, llDumpList2String(["SET SHOW SELECTABLE", gShowSelectable], FIELD_SEPERATOR));
        }
        else
            gHandicap = 1.0;
        
        // Tell the time-out controller the channel that traffic is on,
        // and who to check for.
        llMessageLinked(llGetLinkNumber(), TIMEOUT_MANAGER_START_CHECKING, (string) gBoardChannel, gPlayer);
    }
    
    state_exit() {
        // Remove the listen.
        if (gBoardCallback != NONE)
            llListenRemove(gBoardCallback);
        
        // Stop checking for the player.
        llMessageLinked(llGetLinkNumber(), TIMEOUT_MANAGER_STOP_CHECKING, "", "");        
    }
        
    listen(integer channel, string name, key id, string mesg) {
        if (channel == gBoardChannel) {
            // Parse the message.
            list Parsed = llParseString2List(mesg, [FIELD_SEPERATOR], []);
            string Command = llList2String(Parsed, 0);
                            
            // Check the command.
            if (Command == "SELECTABLE") {
                // This is a tile reporting that it is now selectable.
                
                // Extract the type/channel of this tile.
                string  Type        =           llList2String(Parsed, 1);
                integer TileChannel = (integer) llList2String(Parsed, 2);
                
                // If this is a season or flower, just use the suit information.
                string Suit = llGetSubString(Type, 0, 0);
                if (Suit == "f" || Suit == "s")
                    Type = Suit;
                    
                // Double check that we don't already know about this tile.
                if (llListFindList(gSelectableChannels, [TileChannel]) == NONE) {
                    // Add this to the list of selectable tiles.
                    gSelectableTypes    += [Type];
                    gSelectableChannels += [TileChannel];                    
                }
                return;
            }
            if (Command == "ACTIVE") {
                // Extract the type and 'self' channel for this tile.
                string  ClickedType =           llList2String(Parsed, 2);
                integer ClickedTile = (integer) llList2String(Parsed, 3);
                
                // This tile wants to be active.  Is there anything already active?
                if (gActiveTile == NONE) {
                    // Nope, just let this tile be active.
                    gActiveTile = ClickedTile;
                    gActiveType = ClickedType;
                    return;
                }
                // Something was already active.  Do a quick sanity check
                // to be sure this isn't the same tile asking to be active.
                if (ClickedTile == gActiveTile)
                    return;
                    
                // Now, check to see if these types match.
                if (IsMatch(ClickedType, gActiveType)) {
                    // A match!  Remove the pair.                    
                    llShout(gActiveTile, "REMOVE PAIR");
                    llShout(ClickedTile, "REMOVE PAIR");
                    
                    // Remove these from the selectable lists.
                    RemoveSelectable(gActiveTile);
                    RemoveSelectable(ClickedTile);
                    
                    // Tell the shuffle script about this, so it can
                    // update its internal state.
                    llMessageLinked(llGetLinkNumber(), PAIR_REMOVED, 
                                llList2CSV([gActiveTile, ClickedTile]), "");
                                
                    integer PairScore = 0;
                    vector  ParticleColor = NORMAL_COLOR;
                    // If we are handicapped, use that color instead.
                    if (llFabs(gHandicap - SHOW_SELECTABLE_HANDICAP) < 0.01)
                        ParticleColor = HANDICAP_COLOR;
                                
                    // Check for flowers and seasons.
                    string Suit = llGetSubString(ClickedType, 0, 0);
                    if (Suit == "f" || Suit == "s")
                        ClickedType = Suit;
                            
                    // Check if they requested a hint.
                    if (gHadHint) {
                        // If they had a hint for this, they get no score.
                        // However, unset the flag now.
                        gHadHint = FALSE;
                    }
                    else {
                        // See if this is the 2nd match of this type.
                        float BonusMultiplier = 1.0;
                            
                        // See if this matches the last pair.
                        if (ClickedType == gLastMatch) {
                            BonusMultiplier = 2.0; 
                            ParticleColor = BONUS_COLOR;
                        }                           
                        
                        // Add the score for this pair.
                        PairScore = llRound(gPairsLeft * SuitMultiplier(gActiveType) * 
                                            BonusMultiplier * gHandicap);
                        gScore += PairScore;
                        // Update the score display.
                        llMessageLinked(LINK_SET, SET_SCORE, (string) gScore, "");
                    }
                    // Show the amount this pair gave, in particles.
                    llMessageLinked(LINK_SET, SCORE_PARTICLES, 
                                llDumpList2String([PairScore, ParticleColor], FIELD_SEPERATOR), "");
                    
                    // Update the handicap.
                    if (gShowSelectable)
                        gHandicap = SHOW_SELECTABLE_HANDICAP;
                    else // no handicap
                        gHandicap = 1.0;
                        
                    // Keep track of the match type, for later.
                    gLastMatch = ClickedType;
                    // Decrement the number of pairs left on the board.
                    gPairsLeft--;
                    // See if the board is cleared.
                    if (gPairsLeft == 0) {
                        // Move to the next round number.
                        gRound++;
                        llMessageLinked(LINK_SET, SET_ROUND, (string) gRound, "");
                        
                        // Switch to the next pattern.
                        NextPattern();
                        
                        // Reset the number of shuffles.
                        gShufflesLeft = 3;
                        if (gPatternNum > 10)
                            gShufflesLeft = 4;
                            
                        llMessageLinked(LINK_SET, SET_SHUFFLES_LEFT, (string) gShufflesLeft, "");
                        
                        // Only show score, number of shuffles and round number.
                        llMessageLinked(LINK_SET, SET_ENABLED, (string) 
                                (SCORE_DISPLAY | SHUFFLES_LEFT_DISPLAY | ROUND_DISPLAY), gPlayer);
                        // Load the level.
                        state BuildPattern;
                        return;
                    }
                    // Clear the active info.
                    gActiveTile = NONE;
                }
                else {
                    // Not a match.  Deactivate the previous tile, and select this one.
                    llShout(gActiveTile, "DEACTIVATE");
                    gActiveTile = ClickedTile;
                    gActiveType = ClickedType;                    
                }
                return;
            }
            if (Command == "INACTIVE") {
                // Extract the type and 'self' channel for this tile.
                string  ClickedType =           llList2String(Parsed, 2);
                integer ClickedTile = (integer) llList2String(Parsed, 3);
                
                // This tile wants to be inactive.  Is this actually the active tile?
                if (ClickedTile == gActiveTile) {
                    // Yes, clear the active tile info.
                    gActiveTile = NONE;
                    return;
                }
                return;
            }
        }
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == TOGGLE_GAME) {
            // End the game.
            state EndGame;
            return;
        }
        if (channel == TOGGLE_SELECTABLE) {
            // Are we already showing selectable?
            if (gShowSelectable) {
                // Switch modes.
                gShowSelectable = FALSE;
                // Update the widgets.
                llMessageLinked(LINK_SET, SET_ENABLED, (string) 
                        (SHUFFLE_BUTTON | GET_HINT_BUTTON | GIVE_UP_BUTTON | SCORE_DISPLAY |
                         SHUFFLES_LEFT_DISPLAY | ROUND_DISPLAY | SHOW_SELECTABLE | PARTNER_BUTTON), gPlayer);
            }
            else { // !gShowSelectable
                // Switch modes.
                gShowSelectable = TRUE;
                // Change the handicap.
                gHandicap = SHOW_SELECTABLE_HANDICAP;
                // Update the widgets.
                llMessageLinked(LINK_SET, SET_ENABLED, (string) 
                        (SHUFFLE_BUTTON | GET_HINT_BUTTON | GIVE_UP_BUTTON | SCORE_DISPLAY |
                         SHUFFLES_LEFT_DISPLAY | ROUND_DISPLAY | HIDE_SELECTABLE | PARTNER_BUTTON), gPlayer);
            }
            
            // Update this flag for the tiles.
            llShout(gTileChannel, llDumpList2String(["SET SHOW SELECTABLE", gShowSelectable], FIELD_SEPERATOR));
            return;
        }
        if (channel == PARTNER) {
            // Tell the partner script to find the player a partner.
            llMessageLinked(llGetLinkNumber(), FIND_PARTNER, (string) gTileChannel, gPlayer);
            return;
        }
        if (channel == PARTNER_KEY) {
            // Set the partner's key, for later rounds.
            gPartner = id;
            return;
        }
        if (channel == GET_HINT) {                       
            // Has a hint already been requested?
            if (gHadHint) {
                // Yes, use the last hint we showed.
                llShout(gHint1, "SHOW HINT");
                llShout(gHint2, "SHOW HINT");
                
                //llMessageLinked(sender, GET_HINT_RESET, "", "");
                return;
            }
                                     
            // Set the had hint flag, so that this is only done once per selection.
            gHadHint = TRUE;
            
            // Find a match in our selectable tiles.
            integer NumSelectable = llGetListLength(gSelectableChannels);
            string Type;
            
            integer i;
            integer LookupIndex;
            list    SubList;
            for (i = 0; i < NumSelectable - 1; i++) {
                // Extract the first tile in our pair to try.
                Type = llList2String(gSelectableTypes, i);
                // Only check tiles after this one, in the list.
                SubList = llList2List(gSelectableTypes, i + 1, -1);
                
                // See if there is a match for this tile in the rest of the list.
                integer LookupIndex = llListFindList(SubList, [Type]);
                
                // Was there a match?
                if (LookupIndex != NONE) {
                    // There was a match, extract the channel of the matching tile.
                    gHint1 = llList2Integer(gSelectableChannels, i);
                    gHint2 = llList2Integer(gSelectableChannels, i + LookupIndex + 1);
                    // Tell both of these tiles to highlight themselves as a hint.
                    llShout(gHint1, "SHOW HINT");
                    llShout(gHint2, "SHOW HINT");
                    
                    // Tell the button to 'unclick' itself.
                    //llMessageLinked(sender, GET_HINT_RESET, "", "");
                    // We are done.
                    return;
                }
            }
            
            // No moves were found!
            if (gShufflesLeft > 0)
                Status("No moves, shuffle!");
            else
                Status("No moves left!");
            
            // Tell the button to 'unclick' itself.
            //llMessageLinked(sender, GET_HINT_RESET, "", "");
            return;
        }
        if (channel == SHUFFLE) {
            // If they are out of shuffles, ignore this.
            if (gShufflesLeft == 0)
                return;
                
            // Get ready to switch to the reshuffing state.
            
            // Deselect any selected tile.
            if (gActiveTile != NONE) {
                llShout(gActiveTile, "DEACTIVATE");
                gActiveTile = NONE;
            }
            // If we were busy getting a hint, give up on that.
            if (gHadHint) {
                gHadHint = FALSE;
            }
            
            // Re-shuffle the board.
            state ReshuffleTiles;
        
            return;
        }
        if (channel == TIMEOUT_MANAGER_PLAYER_GONE) {
            // The player wandered off...
            state EndGame;
            return;
        }
    }    
}

state EndGame {
    state_entry() {
        // Clear tiles.
        llShout(gTileChannel, "DIE");
        
        // short-circuit scores for now
        //state WaitForGame;
        //return;
        
        // Create a random channel for the leader board to respond on.
        integer ResponseChannel = llRound(llFrand(1.0) * 2000000000) + 1;
        llListen(ResponseChannel, "", "", "");
        // Report the score.
        llShout(MAHJONG_SCORES, llList2CSV([gPlayerName, gScore, ResponseChannel]));
        
        // Only wait so long for a response...
        llSetTimerEvent(15.0);
    }
    
    listen(integer channel, string name, key id, string mesg) {
        integer Result = (integer) mesg;
        
        if (Result > 0) 
            llSay(0, "Congratulations, you ranked #" + mesg + " on the Leader Board!");
        else
            llSay(0, "Thanks for playing Mahjong!");
            
        state WaitForGame;
    }    
    
    timer() { 
        llSay(0, "Thanks for playing Mahjong!");       
        state WaitForGame;
    }
}


