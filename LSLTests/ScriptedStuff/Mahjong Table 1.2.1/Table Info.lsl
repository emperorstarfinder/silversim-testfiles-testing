///////////////////////////////////////////////////////////////////////////////////////////
// Table Info Script
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
// Table info channels
integer REQUEST_TABLE_INFO  = 3001000;
integer RETURN_TABLE_INFO   = 3001001;

// Seperator to use instead of a comma.
string  FIELD_SEPERATOR = "~!~";
///////////// END CONSTANTS ////////////////

///////////// GLOBAL VARIABLES ///////////////
/////////// END GLOBAL VARIABLES ////////////

vector GetLocalPos() {
    // If this object is not linked, or if it is the
    // root object, just return ZERO_VECTOR.
    integer LinkNum = llGetLinkNumber();
    
    if (LinkNum == 0 || LinkNum == 1)
        return ZERO_VECTOR;
        
    // Otherwise return the local position.
    return llGetLocalPos();
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

SendInfo(integer recipient) {
    vector Scale = llGetScale();
    
    llMessageLinked(recipient, RETURN_TABLE_INFO, llDumpList2String(
            [ZERO_VECTOR, GetLocalRot(), 
             <Scale.x * 0.75, Scale.y * 0.75, Scale.z>], FIELD_SEPERATOR), "");
}

default {    
    state_entry() {
        SendInfo(LINK_SET);
    }
    
    link_message(integer sender, integer channel, string data, key id) {
        // Just listen for table info requests, and respond.
        if (channel == REQUEST_TABLE_INFO) {
            SendInfo(sender);
            return;
        }
    }
    
    changed(integer change) {
        // If something important changed, update table info.
        if (change == CHANGED_SCALE || change == CHANGED_LINK) {
            SendInfo(LINK_SET);
        }
    }
}
