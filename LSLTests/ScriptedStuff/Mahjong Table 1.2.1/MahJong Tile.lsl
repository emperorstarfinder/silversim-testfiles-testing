///////////////////////////////////////////////////////////////////////////////////////////
// MahJong Tile Script
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
// Colors to use for active/deactive.
vector  CLICKED_COLOR   = <0, 0.5, 0.5>;
vector  ACTIVE_COLOR    = <1, 0.25, 0>;
vector  SENSING_COLOR   = <0.5, 0.5, 1.0>;
//vector  SELECTABLE_COLOR= <0.769, 1.0, 0.824>;
vector  SELECTABLE_COLOR= <1, 1, 0.5>;
vector  HINT_COLOR      = <0.25, 0.25, 1.0>;
vector  INACTIVE_COLOR  = <1, 1,   1>;

// How long to wait after doing a sensor sweep before
// changing our name.
float   POST_SENSOR_DELAY   = 5.0;

// How long to show a hint.
float   HINT_DELAY          = 3.0;

// Timer types.
integer HINT_TIMER          = 0;
integer NAME_TIMER          = 1;

// Tile information.
integer TILES_PER_ROW   = 5;
integer TILE_FACE       = 2;
string  TILE_LOOKUP = "hcbwdfs";
list    TILE_INFO   = [  // Texture, Row
        // Characters
        "81acd112-a07a-e9bb-ccd1-7be682e85585", 0,
        // Circles
        "c40cb9b4-e00e-abf1-289d-83239d1d3568", 0,
        // Bamboo
        "d516f820-5242-597f-42aa-ccf569936334", 0,
        // Wind
        "bd1a9c06-296c-95fb-ea7b-85f22ea9615c", 0,
        // Dragons
        "bd1a9c06-296c-95fb-ea7b-85f22ea9615c", 1,
        // Flowers
        "27d586ea-48b3-18ee-5533-e87101ec973c", 1,
        // Seasons
        "27d586ea-48b3-18ee-5533-e87101ec973c", 0 ];
       
list    SUIT_NAMES  = [
         "Character",
         "Dot",
         "Bamboo",
         "Wind",
         "Dragon",
         "Flower",
         "Season" ];

// Misc constant.
integer NONE = -1;

// Error or margin for sensors.
float   ERROR_MARGIN    = 0.005;

// Seperate to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// This is the channel the board listens on.
integer gBoardChannel;
// This is the channel all tiles listen on.
integer gTileChannel;
// Which tile on the board we are.
integer gTileNumber;
// Our position in the game.
vector  gGamePos;
// Our tile type (suit & value)
string  gTileType;
// How many tiles there are total.
integer gTotalTiles;

// Whether or now to highlight selectable.
integer gShowSelectable = FALSE;

// Our size, for quick lookup.
vector  gScale;

// Our neighbor's channels.
list    gNeighbors  = [
            NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE,
            NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE,
            NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE
        ];

// Channel specific to this tile.
integer gSelfChannel;

// Key of the player and partner.
key     gPlayer;
key     gPartner    = NULL_KEY;

// Activation flag.
integer gIsActive;
vector  gInactiveColor = <1, 1, 1>;

// Whether or not we should show the tile face.
integer gShowFace;
// Whether or not this tile is selectable.
integer gSelectable = FALSE;

// The original tile name.
string  gTileName;

// Our timer type.
integer gTimer;
/////////// END GLOBAL VARIABLES ////////////

MoveTo(vector target) { 
    // Used to make sure we actually moved.   
    vector LastPosition;
    
    do {
        // Update the last position, in case we are trying
        // to move to an illegal position, such as below ground.
        LastPosition = llGetPos();
        // Try to move in the correct direction.
        llSetPos(target);
    } while (llVecDist(llGetPos(), target) > 0.001 &&
             llVecDist(llGetPos(), LastPosition) > 0.001);
}

Die() {
    // Move below the board, in case we ghost.
    vector Down = -llRot2Fwd(llGetRot());
    vector Graveyard = llGetPos() + Down * gScale.x * (gGamePos.z + 1.5);
    MoveTo(Graveyard);
    
    llSleep(2.0);
    
    // Now die.
    llDie();
}

DisplayTile() {
    if (gShowFace == FALSE || gTileType == "")
        return;
        
    // Extract the suite and value.
    string Suite  =            llGetSubString(gTileType, 0, 0);
    integer Value = ((integer) llGetSubString(gTileType, 1, 1)) - 1;
    
    // Get the suite index.
    integer SuiteIndex = llSubStringIndex(TILE_LOOKUP, Suite) * 2;
    
    // Use the index to look up information about the suite.
    llSetTexture( llList2Key(TILE_INFO, SuiteIndex), TILE_FACE );
    
    // Calculate the position in the grid this tile is.
    integer RowStart = llList2Integer(TILE_INFO, SuiteIndex + 1);
    
    integer yPos = Value / TILES_PER_ROW + RowStart;
    integer xPos = Value % TILES_PER_ROW;
    
    //llSay(0, llList2CSV([gTileType, Suite, Value, RowStart, yPos, xPos, SuiteIndex]));
    
    llOffsetTexture( -0.4 + xPos * 0.2, 0.25 - 0.5 * yPos, TILE_FACE);
}


UpdateName() {
    // If they can't see the face, don't set the suit name yet.
    if (!gShowFace) {
        llSetObjectName("Unknown (x?)");
        return;
    }
    
    // Change our name to include the tile name, and value.
    string Suit = llGetSubString(gTileType, 0, 0);
    
    // Look up the index for this suit.
    integer SuitIndex = llSubStringIndex(TILE_LOOKUP, Suit);
    // Look up the suit name.
    string SuitName = llList2String(SUIT_NAMES, SuitIndex);
    
    // Change the tile name.
    llSetObjectName(SuitName + " (x" + (string) (SuitIndex + 1) +")");
}

ShowFace() {
    gShowFace = TRUE;
    DisplayTile();
    UpdateName();
}

CheckNeighbors() {
    // Assume this tile is selectable.
    gSelectable = TRUE;
    
    // First of all, check if there is anything *directly* above us.
    if (llList2Integer(gNeighbors, 22) != NONE) {
        // This tile is not selectable or viewable.
        gSelectable = FALSE;
        return;
    }
    
    // These are flags for previously checked tiles.
    integer PieceA;
    integer PieceB;
    integer PieceC;
    integer PieceD;
    
    // Now check if two tiles above us are blocking view.
    PieceA = FALSE;
    if (llList2Integer(gNeighbors, 21) != NONE) {
        gSelectable = FALSE;
        PieceA = TRUE;
    }
    if (llList2Integer(gNeighbors, 23) != NONE) {
        gSelectable = FALSE;
        PieceB = TRUE;
    }
    
    if (PieceA && PieceB) {
        // This tile cannot be seen.
        return;
    }    
    
    // Check the other two possible tiles above us which could block view.
    PieceA = FALSE;
    if (llList2Integer(gNeighbors, 19) != NONE) {
        gSelectable = FALSE;
        PieceA = TRUE;
    }
    if (llList2Integer(gNeighbors, 25) != NONE) {
        gSelectable = FALSE;
        PieceB = TRUE;
    }
    
    if (PieceA && PieceB) {
        // This tile cannot be seen.
        return;
    }
    
    
    // Check for the case 4 corner pieces are above us blocking view.
    PieceA = FALSE;
    if (llList2Integer(gNeighbors, 18) != NONE) {
        gSelectable = FALSE;
        PieceA = TRUE;
    }
    if (llList2Integer(gNeighbors, 20) != NONE) {
        gSelectable = FALSE;
        PieceB = TRUE;
    }
    PieceC = FALSE;
    if (llList2Integer(gNeighbors, 24) != NONE) {
        gSelectable = FALSE;
        PieceC = TRUE;
    }
    if (llList2Integer(gNeighbors, 26) != NONE) {
        gSelectable = FALSE;
        PieceD = TRUE;
    }
    
    if (PieceA && PieceB && PieceC && PieceD) {
        // This tile cannot be seen.
        return;
    }
           
    // At this point the tile is viewable.
    ShowFace();
    
    // If this tile was already found to not be selectable, just exit here.
    if (!gSelectable)
        return;
    
    // Now check if there is something on *both* sides of us, on this layer.
    integer OnLeft  = FALSE;
    integer OnRight = FALSE;
    // Check the left side.
    integer i;
    for (i = 0; i < 3; i++) {
        if (llList2Integer(gNeighbors, 9 + i * 3) != NONE) {
            // Something on the left.
            OnLeft = TRUE;
        }
    }
    // Check the right side.
    for (i = 0; i < 3; i++) {
        if (llList2Integer(gNeighbors, 11 + i * 3) != NONE) {
            // Something on the right.
            OnRight = TRUE;
        }
    }
    
    // If something is on both sides, we are not selectable.
    if (OnLeft && OnRight)
        gSelectable = FALSE;
    else {
        gSelectable = TRUE;
        
        if (gShowSelectable) {
            gInactiveColor = SELECTABLE_COLOR;
        }
    }
}

CheckSelectable() {
    // See if we are now selectable.
    if (gSelectable)
        // Report ourselves to the board, so it can find matches.                    
        llShout(gBoardChannel, llDumpList2String(
                    ["SELECTABLE", gTileType, gSelfChannel], FIELD_SEPERATOR));   
}

default {    
    touch_start(integer num_detected) {     
        key Toucher = llDetectedKey(0);
        // Either the player or the partner can touch.   
        if ( gSelectable && (Toucher == gPlayer || Toucher == gPartner) ) {
            // Toggle being active.
            gIsActive = !gIsActive;
            if (gIsActive) {
                llSetColor(ACTIVE_COLOR, TILE_FACE);
                
                // Tell the board about the click.
                llShout(gBoardChannel, llDumpList2String([
                    "ACTIVE", gGamePos, gTileType, gSelfChannel], FIELD_SEPERATOR));
            }
            else { // Not active.
                llSetColor(gInactiveColor, TILE_FACE);
                
                // Tell the board about the click.
                llShout(gBoardChannel, llDumpList2String([
                    "INACTIVE", gGamePos, gTileType, gSelfChannel], FIELD_SEPERATOR));
            }
        }
    }
    
    on_rez(integer param) {
        if (param == 0)
            return;
            
        // Split up the parameter.
        gTileChannel = param / 256;
        gTileNumber  = param % 256;
               
        // Listen for tile channel traffic.         
        llListen(gTileChannel, "", "", "");
        // This is the channel to talk to the board on.
        gBoardChannel = gTileChannel - 1;
        // This is our self only channel we listen on.
        gSelfChannel = gTileChannel + gTileNumber + 1;
        llListen(gSelfChannel, "", "", "");
        
        // Save our current name as the tile name.
        gTileName = llGetObjectName();
                
        // Clear flags.
        gIsActive = FALSE;
        gShowFace = FALSE;
        gTileType = "";
        
        llListen(0, "", llGetOwner(), "dump");
    }
    
    sensor(integer num_detected) { 
        // Read the name of the sensed objects to extract information.       
        integer TileNumber;
        vector  DeltaGamePos;
        float   AbsDeltaZ;
        integer NeighborIndex;
        integer i;
        for (i = 0; i < num_detected; i++) {
            // First check to make sure this is a tile.
            list Parsed = llParseString2List(llDetectedName(i), [FIELD_SEPERATOR], []);
            // This must have three entries, and the first entry must
            // match our original tile name in order for it to be recognized.
            if (llGetListLength(Parsed) == 3 &&
                llList2String(Parsed, 0) == gTileName) {
                // This is a tile.  Extract its tile number and game position from its name.
                TileNumber   = (integer) llList2String(Parsed, 1);
                DeltaGamePos = (vector)  llList2String(Parsed, 2) - gGamePos;
                AbsDeltaZ    = llFabs(DeltaGamePos.z);
                
                // Do a quick check to see if this tile is in a layer of interest.
                if (AbsDeltaZ < 1.05 ) {
                    // Treat a DeltaZ of +/- 1 differently than a DeltaZ of 0.
                    if (AbsDeltaZ < 0.25) {
                        // DeltaZ ~= 0.  This tile is a neighbor.    
                        // Offset the delta game position a bit.
                        DeltaGamePos.y *= 2.0;
                        DeltaGamePos += <1, 1, 1>;
                        
                        // Calculate the index value into the neighbor's list.
                        NeighborIndex = llRound(9 + DeltaGamePos.y * 3 + DeltaGamePos.x);
                        
                        // Add this tile's "self" channel to the neighbor list.
                        gNeighbors = llDeleteSubList(gNeighbors, NeighborIndex, NeighborIndex);
                        gNeighbors = llListInsertList(gNeighbors, [gTileChannel + TileNumber + 1], NeighborIndex);                        
                    }
                    else if (llFabs(DeltaGamePos.x) < 0.75) {    
                        // DeltaZ ~= +/- 1.  This tile is a neighbor.      
                        // Offset the delta game position a bit.
                        DeltaGamePos.x *= 2.0;
                        DeltaGamePos.y *= 2.0;
                        DeltaGamePos += <1, 1, 1>;
                                  
                        //llWhisper(0, "/me TileNumber: " + (string) TileNumber + 
                        //      "; DeltaGamePos: " + (string) DeltaGamePos);
                      
                        // Calculate the index value into the neighbor's list.
                        NeighborIndex = llRound(DeltaGamePos.z * 9 + DeltaGamePos.y * 3 + DeltaGamePos.x);
                        
                        // Add this tile's "self" channel to the neighbor list.
                        gNeighbors = llDeleteSubList(gNeighbors, NeighborIndex, NeighborIndex);
                        gNeighbors = llListInsertList(gNeighbors, [gTileChannel + TileNumber + 1], NeighborIndex);   
                    }
                }
            }
        }
        
        // Now that we know who our neighbors are, check to see if this tile
        // should show its face, and if it is selectable.
        CheckNeighbors();
        // Done doing a sensor run, switch back color.
        llSetColor(gInactiveColor, TILE_FACE);
        
        // Set up a timer to re-name the tile.
        gTimer = NAME_TIMER;
        llSetTimerEvent(POST_SENSOR_DELAY);
    }
    
    no_sensor() {
        // Nothing there, no neighbors.
        CheckNeighbors();
        
        // Done doing a sensor run, switch back color.
        llSetColor(gInactiveColor, TILE_FACE);
        
        // Set up a timer to re-name the tile.
        gTimer = NAME_TIMER;
        llSetTimerEvent(POST_SENSOR_DELAY);
    }
    
    timer() {
        // Remove the timeout.
        llSetTimerEvent(0.0);
        
        // Which timer was this?
        if (gTimer == HINT_TIMER) {
            // Change our color back.
            llSetColor(gInactiveColor, TILE_FACE);
        }
        else { // gTimer == NAME_TIMER
            // Update the name, to show suit and multiplier.
            UpdateName();        
        }
    }
    
    listen(integer channel, string name, key id, string mesg) {  
        if (channel == 0) {
            string OldName = llGetObjectName();
            
            list Neighbors;
            integer i;
            integer Neighbor;
            for(i = 0; i < llGetListLength(gNeighbors); i++) {
                Neighbor = llList2Integer(gNeighbors, i);
                if (Neighbor != NONE)
                    Neighbor = Neighbor - gTileChannel - 1;
                Neighbors += [Neighbor];
            }
                            
            string Dump = llList2CSV([gGamePos] + Neighbors); 
            llSetObjectName((string) gTileNumber + ",");
            llWhisper(0, "/me " + Dump);
            llSetObjectName(OldName);
            return;
        }      
        // Parse the command.
        list Parsed = llParseString2List(mesg, [FIELD_SEPERATOR], []);
        string Command = llList2String(Parsed, 0);
        
        // Check the command.
        if (Command == "ALLOC") {
            // Does this allocation include us?
            integer BaseTile = (integer) llList2String(Parsed, 1);
            integer NumTiles = (integer) llList2String(Parsed, 2);
            
            if (gTileNumber < BaseTile ||
                gTileNumber >= BaseTile + NumTiles) {
                // Disregard this message, its not for us.
                return;
            }
            
            // This regards us.  Split up the rest of the data.
            gGamePos        = (vector)  llList2String(Parsed, 3);
            vector BoardPos = (vector)  llList2String(Parsed, 4);
            vector Increment= (vector)  llList2String(Parsed, 5);
            gTotalTiles     = (integer) llList2String(Parsed, 6);
            
            // Which tile are we in this allocation?
            integer ThisTile = gTileNumber - BaseTile;
            
            // Move to our position on the board.
            MoveTo( BoardPos + Increment * ThisTile );
            
            // Tell the board we are in position, if this is the last tile.
            if (gTileNumber == 143)
                llShout(gBoardChannel, "READY");
            
            // Keep track of our game position.
            gGamePos += <ThisTile, 0, 0>;
            
            // Put this game position into our name (along with tile number), 
            // so that sensors can easily pick it up.
            llSetObjectName( llDumpList2String([gTileName, gTileNumber, gGamePos], FIELD_SEPERATOR ));
                            
            return;
        }
        if (Command == "SHUFFLE") {
            // Does this shuffle include us?
            integer BaseTile = (integer) llList2String(Parsed, 1);
            integer NumTiles = (integer) llList2String(Parsed, 2);
            
            if (gTileNumber < BaseTile ||
                gTileNumber >= BaseTile + NumTiles) {
                // Disregard this message, its not for us.
                return;
            }
            
            // This regards us.  Split up the tile list.
            list Tiles = llCSV2List( llList2String(Parsed, 3) );

            // Extract our tile type.
            gTileType = llList2String(Tiles, gTileNumber - BaseTile);
            
            // Show the tile.
            DisplayTile();
            
            return;
        }
        if (Command == "RESHUFFLE") {
            // Does this reshuffle include us?
            integer LowerBound = (integer) llList2String(Parsed, 1);
            integer UpperBound = (integer) llList2String(Parsed, 2);
            
            if (gTileNumber < LowerBound ||
                gTileNumber > UpperBound) {
                // Disregard this message, its not for us.
                return;
            }
            
            // This regards us.  Split up the tile lists.
            list TileNumbers = llCSV2List( llList2String(Parsed, 3) );
            list TileTypes   = llCSV2List( llList2String(Parsed, 4) );
            
            // Find the index of this tile in the list.
            integer TileIndex = llListFindList(TileNumbers, [(string) gTileNumber]);
            
            // Sanity check.
            if (TileIndex == NONE) {
                llSay(0, "Reshuffle error.");
                gTileType = "";
            }
            else {
                // Extract our tile type.
                gTileType = llList2String(TileTypes, TileIndex);
            }
            
            // Show the tile.
            DisplayTile();
            // Update the tile's name.
            UpdateName();
            return;
        }
        if (Command == "UPDATE NEIGHBORS") {
            // This is a neighbor telling us of their demise.
            integer NeighborChannel = (integer) llList2String(Parsed, 1);
            // Look for the index of this neighbor.
            integer NeighborIndex = llListFindList(gNeighbors, [NeighborChannel]);
            // If a neighbor was found, remove it.
            if (NeighborIndex != NONE) {
                gNeighbors = llDeleteSubList(gNeighbors, NeighborIndex, NeighborIndex);
                gNeighbors = llListInsertList(gNeighbors, [NONE], NeighborIndex);
                
                // If already selectable, just return.
                if (gSelectable)
                    return;
                
                // Recheck neighbors, with new settings.
                CheckNeighbors();
                CheckSelectable();
                llSetColor(gInactiveColor, TILE_FACE);             
            }
            return;
        }
        if (Command == "ACTIVATE") {
            llSetColor(ACTIVE_COLOR, TILE_FACE);
            gIsActive = TRUE;
            return;
        }
        if (Command == "DEACTIVATE") {
            llSetColor(gInactiveColor, TILE_FACE);
            gIsActive = FALSE;
            return;
        }
        if (Command == "SCALE") {
            // Scale ourselves to match.
            gScale = (vector) llList2String(Parsed, 1);
            llSetScale(gScale);
            return;
        }
        if (Command == "PLAYER") {
            // Set the player's key.
            gPlayer = (key) llList2String(Parsed, 1);
            return;
        }
        if (Command == "REMOVE PAIR") {
            // We are part of a match.
            // First tell all our neighbors that we are dying.
            integer i;
            integer NeighborChannel;
            // Pre-build this to cut execution time.
            string DeathMessage = llDumpList2String(
                            ["UPDATE NEIGHBORS", gSelfChannel], FIELD_SEPERATOR);
            for (i = 0; i < 26; i++) {
                NeighborChannel = llList2Integer(gNeighbors, i);
                if (NeighborChannel != NONE) 
                    // Tell this neighbor we are going away.
                    llShout(NeighborChannel, DeathMessage);
            }
            Die();
            return;
        }
        if (Command == "DIE") {
            // Just die, they probably gave up.
            Die();
            return;
        }
        if (Command == "RUN SENSOR") {
            // Run a sensor to check for tiles around us.            
            llSensor("", "", ACTIVE | SCRIPTED, gScale.z * 1.25, PI);
            // Change color to show we are doing a sensor sweep.
            llSetColor(SENSING_COLOR, TILE_FACE);            
            return;
        }
        if (Command == "SHOW HINT") {
            // This tile is being shown as a hint, change our inactive color.
            llSetColor(HINT_COLOR, TILE_FACE);
            // Set the timeout, to remove this coloring.
            gTimer = HINT_TIMER;
            llSetTimerEvent(HINT_DELAY);
            return;
        }
        if (Command == "CHECK SELECTABLE") {
            CheckSelectable();
            return;
        }
        if (Command == "PARTNER") {
            // Extract the partner's key.
            gPartner = (key) llList2String(Parsed, 1);
            return;
        }
        if (Command == "SET SHOW SELECTABLE") {
            // Set the show selectable flag to this.
            gShowSelectable = (integer) llList2String(Parsed, 1);
            
            // Update our color.
            if (gShowSelectable && gSelectable) {
                gInactiveColor = SELECTABLE_COLOR;
            }
            else
                gInactiveColor = INACTIVE_COLOR;
                
            // Update ourselves if not selected.
            if (!gIsActive)
                llSetColor(gInactiveColor, TILE_FACE);
        }
    }
}
