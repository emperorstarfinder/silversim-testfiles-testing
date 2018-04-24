///////////////////////////////////////////////////////////////////////////////////////////
// Pattern Builder Script
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
// Channels for comms with the game.
integer BUILD_PATTERN       = 1341120230;
integer BUILD_PATTERN_DONE  = 1341120231;

// Channels for comms with the shuffler.
integer SHUFFLE_ALLOC   = 700105;
integer SHUFFLE_ALLOC_DONE = 700106;

// This sets the status bar text.
integer STATUS_BAR  = 502000;

// External burst reader script.
integer BURST_READ  = 8000;

// Table info channels
integer REQUEST_TABLE_INFO  = 3001000;
integer RETURN_TABLE_INFO   = 3001001;

// Parallel Rezzer Comm Channels. (Public)
integer PARALLEL_REZ    = 600100;
integer DONE_REZZING    = 600101;

// General tile object info.
float   TILE_RATIO      = 1.357142857;
rotation TILE_ROT       = <0, -0.70710678, 0, 0.70710678>;

// Seperator to use instead of comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// These are set by the game script.
string  gPattern;
string  gTileObject;

// Table information.
vector  gLocalTablePos;
rotation gLocalTableRot;
rotation gTableRot;
vector  gTableScale;
vector  gTableTopLeft;
vector  gTileSizeX;
vector  gTileSizeY;
vector  gTileSizeZ;
integer gNumLayers;

// Grid info.
integer gMinX;
integer gMinY;
integer gMaxX;
integer gMaxY;

// Last line to read.
integer gLastLine;
// How many lines we have read.
integer gNumLinesRead;
// How many lines have been requested.
integer gNumLinesRequested;
// Which tile we are going to allocate next.
integer gNextTile;

// Current notecard read query.
key gQueryID;

// How many tiles are on the board.
integer gNumTiles;

// Tile channel.
integer gTileChannel;
// Board channel.
integer gBoardChannel;
integer gBoardCallback;
/////////// END GLOBAL VARIABLES ////////////

Status(string  mesg) {
    // This sets the status bar message.
    llMessageLinked(LINK_SET, STATUS_BAR, mesg, "");
}

rotation GetRootRot() {
    // If this object is not linked, or if it is the
    // root object, just return llGetRot
    integer LinkNum = llGetLinkNumber();
    
    if (LinkNum == 0 || LinkNum == 1)
        return llGetRot();
        
    // Otherwise take local rotation into account.
    
    // This is the rotation of this object with the
    // root object's rotation as the reference frame.
    rotation LocalRot = llGetLocalRot();
    // This uses the global coord system as the 
    // reference frame.
    rotation GlobalRot = llGetRot();
    
    // Reverse the local rotation, so we can undo it.
    LocalRot.s = -LocalRot.s;
    
    // Convert from local rotation to just root rotation.
    rotation RootRot = LocalRot * GlobalRot;
    
    // Make the sign match (mathematically, this isn't necessary, 
    // but it makes the rotations look the same when printed out).
    RootRot = -RootRot;
    
    return RootRot;
}

vector GetLocalPos() {
    // If this object is not linked, or if it is the
    // root object, just return ZERO_VECTOR.
    integer LinkNum = llGetLinkNumber();
    
    if (LinkNum == 0 || LinkNum == 1)
        return ZERO_VECTOR;
        
    // Otherwise return the local position.
    return llGetLocalPos();
}

vector GetRootPos() {
    // If this object is not linked, or if it is the
    // root object, just return llGetPos
    integer LinkNum = llGetLinkNumber();
    
    if (LinkNum == 0 || LinkNum == 1)
        return llGetPos();
        
    // Otherwise take local position into account.
    return llGetPos() - GetLocalPos() * GetRootRot();
}

key GetRootKey() {
    // First try link #0 (since we might not be linked).
    key RootKey = llGetLinkKey(0);
    
    if (RootKey == NULL_KEY)
        // Linked object, use link #1.
        RootKey = llGetLinkKey(1);
    
    return RootKey;
}

rotation GetLocalRot() {
    // If this object is not linked, or if it is the
    // root object, just return ZERO_ROTATION.
    integer LinkNum = llGetLinkNumber();
    
    if (LinkNum == 0 || LinkNum == 1)
        return ZERO_ROTATION;
        
    // Otherwise return the local rotation.
    return llGetLocalRot();
}

ParseTableInfo(string data) {
    // Keep track of this info, for later.
    list Parsed = llParseString2List(data, [FIELD_SEPERATOR], []);
    
    gLocalTablePos  = (vector)  llList2String(Parsed, 0);
    gLocalTableRot  = (rotation)llList2String(Parsed, 1);
    gTableScale     = (vector)  llList2String(Parsed, 2);
}

BurstRead() {
    // Check if there are any more lines to request.
    if (gNumLinesRequested < gLastLine) {
        // Read up to 32 lines.
        integer NumToRead = 32;
        if (gNumLinesRequested + NumToRead > gLastLine)
            NumToRead = gLastLine - gNumLinesRequested;
        
        //llSay(0, "Reading lines " + (string) (gNumLinesRequested + 1) + " to " +
        //        (string) (gNumLinesRequested + NumToRead) + ".");
        
        llMessageLinked(llGetLinkNumber(), BURST_READ, llDumpList2String(
                    [gPattern, gNumLinesRequested + 1, NumToRead], FIELD_SEPERATOR), "");
            
        gNumLinesRequested += NumToRead;
    }
}

default {
    state_entry() {
        // Ask the table how big the play-area is, where it is,
        // and how it is oriented.
        llMessageLinked(LINK_SET, REQUEST_TABLE_INFO, "", "");
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == RETURN_TABLE_INFO ) {
            ParseTableInfo(data);
            
            state WaitForBuildRequest;
            return;
        }
    }
}

state WaitForBuildRequest {    
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == BUILD_PATTERN) {
            // Parse the message.
            list Parsed = llParseString2List(data, [FIELD_SEPERATOR], []);
            // Extract the entries.
            gPattern    = llList2String(Parsed, 0);
            gTileObject = llList2String(Parsed, 1);
            
            // Start building the pattern.
            state RezTiles;
        }
        if (channel == RETURN_TABLE_INFO ) {
            ParseTableInfo(data);
            return;
        }
    }
}

state RezTiles {
    state_entry() {
        Status("Creating Tiles");
        // Create random tile and board channels.
        gTileChannel = llRound( llFrand(1.0) * 8388606 ) + 1;
        gBoardChannel= gTileChannel - 1;
                            
        gQueryID = llGetNotecardLine(gPattern, 0);
    }
    
    dataserver(key query_id, string data) {
        if (query_id != gQueryID)
            return;

        // Parse the first line.            
        list Parsed = llParseString2List(data, [" "], []);
        gNumTiles   = (integer) llList2String(Parsed, 2);
        gMinX       = (integer) llList2String(Parsed, 3);
        gMinY       = (integer) llList2String(Parsed, 4);
        gMaxX       = (integer) llList2String(Parsed, 5);
        gMaxY       = (integer) llList2String(Parsed, 6);      
        gLastLine   = (integer) llList2String(Parsed, 7);  
        gNumLayers  = (integer) llList2String(Parsed, 8);
                            
        // Rez the number of specified tiles, and wait until rezzing is complete.
        gTableRot  = gLocalTableRot * GetRootRot();
        llMessageLinked(LINK_SET, PARALLEL_REZ, llDumpList2String(
            [gTileObject, llGetPos(), ZERO_VECTOR, 
                TILE_ROT * gTableRot, gTileChannel * 256, gNumTiles], "~!~"), "");
                
                
        // Pre-calculate a couple bookkeeping variables.
        vector TableCenter = GetRootPos() + (gLocalTablePos +
                                 <0, 0, gTableScale.z / 2.0>) * gTableRot;
        
        float xGrid = (gMaxX - gMinX + 2) / 2.0;
        float yGrid = (gMaxY - gMinY + 2) / 2.0;
                
        //llSay(0, llList2CSV([gMinX, gMinY, gMaxX, gMaxY]));
        gTileSizeX = <-gTableScale.x / xGrid, 0, 0> * gTableRot;
        gTileSizeY = <0, gTableScale.y / yGrid, 0> * gTableRot;
        
        // Check to see if we need to clip the size of a side.
        float Ratio = llVecMag(gTileSizeY) / llVecMag(gTileSizeX);
        if (Ratio > TILE_RATIO) {
            // Clip Y.
            gTileSizeY = (llVecMag(gTileSizeX) * TILE_RATIO) * llVecNorm(gTileSizeY);
        }
        else if (Ratio < TILE_RATIO) {
            // Clip X.
            gTileSizeX = (llVecMag(gTileSizeY) / TILE_RATIO) * llVecNorm(gTileSizeX);
        }
        
        gTileSizeZ = ( (llVecMag(gTileSizeX) / 5 * 2) * <0, 0, 1> ) * gTableRot;


        gTableTopLeft = TableCenter
                            - gTileSizeX * (xGrid / 2 - 0.5)
                            + gTileSizeY * (yGrid / 2 - 0.5)
                            + gTileSizeZ / 2;
    }

    link_message(integer sender, integer channel, string data, key id) {
        if (channel == DONE_REZZING) {
            // Tell all the tiles what to scale to.
            llShout(gTileChannel, llDumpList2String(["SCALE",
                    <llVecMag(gTileSizeZ),
                     llVecMag(gTileSizeY),
                     llVecMag(gTileSizeX)>], FIELD_SEPERATOR));
                     
            state ReadPattern;
        }
    }
}

state ReadPattern {
    state_entry() {
        Status("Building Pattern");
        gNumLinesRequested = 0;
        gNumLinesRead = 0;
        gNextTile = 0;
                
        // Listen for a message from the last tile saying it is in place.
        llListen(gBoardChannel, "", "", "READY");
        
        // "Burst" read up to 32 lines.
        BurstRead();
    }
    
    dataserver(key query_id, string data) {
        // Parse the line.
        list Parsed = llParseString2List(data, [" "], []);
        
        vector GamePos;
        GamePos.x   = (float)   ((integer) llList2String(Parsed, 0) - gMinX) / 2.0;
        GamePos.y   = (float)   ((integer) llList2String(Parsed, 1) - gMinY) / 2.0;
        GamePos.z   = (float)   ((integer) llList2String(Parsed, 2));
        
        integer NumTiles = (integer) llList2String(Parsed, 3);
        
        vector RezPos =  gTableTopLeft + 
                            GamePos.x * gTileSizeX -
                            GamePos.y * gTileSizeY +
                            GamePos.z * gTileSizeZ;
        
        // Allocate the tiles.
        llShout(gTileChannel, llDumpList2String(
                ["ALLOC", gNextTile, NumTiles, GamePos, RezPos, gTileSizeX, gNumTiles],
                FIELD_SEPERATOR));
                
        // Tell the shuffle script about this allocation.
        llMessageLinked(llGetLinkNumber(), SHUFFLE_ALLOC, llDumpList2String(
                [gNextTile, NumTiles, GamePos], FIELD_SEPERATOR), "");
        
        // Change the pointer to the next tile to allocate.
        gNextTile += NumTiles;
                        
        
        // See if we are done, or need to do another burst read.
        gNumLinesRead++;
        
        // See if we are ready for another burst of data.
        if (gNumLinesRead == gNumLinesRequested)
            // We have reached the end of the previous burst.
            BurstRead();
    }
    
    listen(integer channel, string name, key id, string mesg) {
        // All tiles are in place, tell the game we are finished, and what channels to use.
        llMessageLinked(llGetLinkNumber(), BUILD_PATTERN_DONE, 
                        llList2CSV([gTileChannel, gBoardChannel]), "");
        
        // Wait for another request.
        state WaitForBuildRequest;
    }
}
