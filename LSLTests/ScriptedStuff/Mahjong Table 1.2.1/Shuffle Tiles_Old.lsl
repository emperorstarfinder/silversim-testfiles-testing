///////////////////////////////////////////////////////////////////////////////////////////
// Shuffle Tiles Script
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
// Tile shuffler.
integer SHUFFLE_TILES   = 700100;
integer SHUFFLE_DONE    = 700101;
integer RESHUFFLE_TILES = 700102;
integer RESHUFFLE_DONE  = 700103;
integer PAIR_REMOVED    = 700104;
integer SHUFFLE_ALLOC   = 700105;
integer SHUFFLE_ALLOC_DONE = 700106;

// "Character" tile suit.
list WAN    = ["h1", "h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9"];
// "Bamboo" tile suit.
list TIAU   = ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9"];
// "Circle" tile suit.
list TUNG   = ["c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9"];
// "Dragon" tile suit.
list DRAGON = ["d1", "d2", "d3"];
// "Wind" tile suit.
list WIND   = ["w1", "w2", "w3", "w4"];
// "Season" tile suit.
list SEASON = ["s1", "s2", "s3", "s4"];
// "Flower tile suit.
list FLOWER = ["f1", "f2", "f3", "f4"];

// Seperate to use instead of comma.
string  FIELD_SEPERATOR = "~!~";

// Misc constant.
integer NONE = -1;
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
// These lists store info about tiles on the board.
list    gTileTypes;
list    gTileNumbers;
// Channel to communicate with the tiles.
integer gTileChannel;
/////////// END GLOBAL VARIABLES ////////////

Randomize() {
    // Shuffle the tile types 7 times.
    integer i;
    for (i = 0; i < 7; i++)
        gTileTypes = llListRandomize(gTileTypes, 0);
}

Shuffle(string data) {  
    // Lets assume 144 tiles.
    gTileChannel = (integer) data;
    
    // Create a list of all possible tiles.
    gTileTypes   =   WAN  + WAN  + WAN  + WAN  +
                     TIAU + TIAU + TIAU + TIAU +
                     TUNG + TUNG + TUNG + TUNG +
                     WIND + WIND + WIND + WIND +
                     DRAGON + DRAGON + DRAGON + DRAGON +
                     SEASON + FLOWER;
                    
    gTileNumbers  = [ 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,
                     10,  11,  12,  13,  14,  15,  16,  17,  18,  19,
                     20,  21,  22,  23,  24,  25,  26,  27,  28,  29,
                     30,  31,  32,  33,  34,  35,  36,  37,  38,  39,
                     40,  41,  42,  43,  44,  45,  46,  47,  48,  49 ];
    gTileNumbers += [50,  51,  52,  53,  54,  55,  56,  57,  58,  59,
                     60,  61,  62,  63,  64,  65,  66,  67,  68,  69,
                     70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
                     80,  81,  82,  83,  84,  85,  86,  87,  88,  89,
                     90,  91,  92,  93,  94,  95,  96,  97,  98,  99 ];
    gTileNumbers +=[100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
                    110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
                    120, 121, 122, 123, 124, 125, 126, 127, 128, 129,
                    130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
                    140, 141, 142, 143, 144 ];
                                    
    // And randomize the types.
    Randomize();
    
    // Spit out this tile list in pieces.
    integer ChunkSize = 48;
    integer i;
    for (i = 0; i < 3; i++) {
        list Chunk = llList2List(gTileTypes, i * ChunkSize, (i+1) * ChunkSize - 1);
        llShout(gTileChannel, llDumpList2String(
            ["SHUFFLE", i * ChunkSize, ChunkSize, llList2CSV(Chunk)], FIELD_SEPERATOR));
    }
}

Reshuffle(string data) {
    // Randomize the types.
    Randomize();
    
    // Split out the tile info, in pieces.
    integer ChunkSize = 20;
    integer NumTiles = llGetListLength(gTileNumbers);
    integer i;
    for (i = 0; i < NumTiles; i += ChunkSize) {
        // Get the bounds for this chunk.        
        integer UpperIndex = i + ChunkSize - 1;
        // Check for the case that the upper bound is past the end of the list.
        if (UpperIndex >= NumTiles)
            UpperIndex = NumTiles - 1;
                    
        integer LowerBound = llList2Integer(gTileNumbers, i);
        integer UpperBound = llList2Integer(gTileNumbers, UpperIndex);
        
        // Extract the chunks to send.
        list TypeChunk   = llList2List(gTileTypes,   i, UpperIndex);
        list NumberChunk = llList2List(gTileNumbers, i, UpperIndex);
        
        // Send these chunks to the tiles.
        llShout(gTileChannel, llDumpList2String(
            ["RESHUFFLE", LowerBound, UpperBound, 
                llList2CSV(NumberChunk), llList2CSV(TypeChunk)], FIELD_SEPERATOR));
    }
    
}

RemoveTile(integer tile) {
    // Get the index number of this tile.
    integer Index = llListFindList(gTileNumbers, [tile]);
    
    if (Index != NONE) {        
        // Remove this tile from both lists.
        gTileTypes  = llDeleteSubList(gTileTypes,   Index, Index);
        gTileNumbers= llDeleteSubList(gTileNumbers, Index, Index);
    }
}

default {     
    link_message(integer sender, integer channel, string data, key id) {
        if (channel == SHUFFLE_TILES) {
            Shuffle(data);
            llMessageLinked(sender, SHUFFLE_DONE, "", "");
            return;
        }
        if (channel == RESHUFFLE_TILES) {
            Reshuffle(data);
            llMessageLinked(sender, RESHUFFLE_DONE, "", "");            
            return;            
        }
        if (channel == PAIR_REMOVED) {
            // Remove the tiles from the board lists.
            list Parsed = llCSV2List(data);
            integer Tile1 = (integer) llList2String(Parsed, 0);
            integer Tile2 = (integer) llList2String(Parsed, 1);
            
            Tile1 = Tile1 - gTileChannel - 1;
            Tile2 = Tile2 - gTileChannel - 1;
            
            RemoveTile(Tile1);
            RemoveTile(Tile2);
            return;  
        }
    }
}
