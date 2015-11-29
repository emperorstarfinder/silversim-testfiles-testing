//Changes by Tano Toll for seamless TMCP (pose-ball free) compatability, and to dodge 'double locking':

//*sit and unsit events do not trigger an RLV command (master script already does this)
//*identifier is changed to object name, url encoded.
//*delayed but automatic notecard read on inventory change

// ----------------------------------------------------------------------------------
// MLPV2 Plugin for RLV Script V1.02
//
// Use with a notecard named .RLV with the format:
// Pose|Ball no.: 0,1...*|@RLV-Command
// e.g.
// Missionary|1|@unsit=n
// stand|*|!release
// ----------------------------------------------------------------------------------
// Copyright (c) 2010, Jenni Eales. All rights reserved.
// ----------------------------------------------------------------------------------
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice,
//      this list of conditions and the following disclaimer in the documentation
//      and/or other materials provided with the distribution.
//    * The names of its contributors may not be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
// OF SUCH DAMAGE.
//
// Changes:
// ----------------------------------------------------------------------------------
// Version 1.02
// - use | as seperator
// - support multiple lines for one pose
// - additional link message for direct call from ball menu
//
// Version 1.01
// - use ; instead of | as seperator
//
// Version 1.0
// - first version released
// ----------------------------------------------------------------------------------
//
// constants
string NOTECARD         = ".RLV"; // name of config notecard
integer DEBUG           = FALSE;  // switch debug on/off
integer RELAY_CHANNEL   = -1812221819; // channel for RLV relay
float TIMER_SEC         = 1800.0; // 30 min.
string CMD_RELEASE      = "!release";  // release command
integer LM_NUMBER       = -1819;  // number for link message
 
// internal use
key kQuery;
integer iLine;
 
string pose = "stand"; // pose set by the Ball Menu
list poses    = [];    // configured poses
list balls    = [];    // configured balls
list commands = [];    // configured commands
list avatars  = [];    // avatars sitting on balls

integer wants_init;
 
// log a message
log(string message)
{
    if(DEBUG) llOwnerSay(message);
}
 
// only for testing purposes
log_data()
{
    log("List:");
    integer total_number = llGetListLength(commands);
    integer i;
    for(i=0; i<total_number; i++)
    {
        log("- " + llList2String(poses, i) + ": (" + llList2String(balls, i) + ") "+ llList2String(commands, i));
    }
}
 
// write a message to the RLV Relay
relay(key avatar, string message)
{
    list tokens = llParseString2List(message, ["|"], [""]);
    integer total_number = llGetListLength(tokens);
    integer i;
    for(i=0; i<total_number; i++)
    {
        string token = llList2String(tokens, i);
        log("RLV: MLPV2," + (string) avatar + "," + token);
        llSay(RELAY_CHANNEL, llEscapeURL(llGetObjectName())+"," + (string) avatar + "," + token);
    }
}
 
// find commands for pose and play it for avatars on ball
rlv(string pose)
{
    log("command for: " + pose);
    llSetTimerEvent(TIMER_SEC);
 
    integer total_number = llGetListLength(poses);
    integer i;
    for(i=0; i<total_number; i++)
    {
        if (pose == llList2String(poses, i))
        {
            string ball = llList2String(balls, i);
            log("command for pose: " + pose + " (" + ball + ")");
            if (ball == "*")
            {
                integer b;
                for (b=0; b<6; b++)
                {
                    // get avatar for ball index
                    key avatar = llList2Key(avatars, b);
                    if(avatar != NULL_KEY) relay(avatar, llList2String(commands, i));
                }
            }
            else
            {
                key avatar = llList2Key(avatars, (integer) ball);
                if(avatar != NULL_KEY) relay(avatar, llList2String(commands, i));
            }
        }
    }
}
 
// new find: pose and ball needs to match
integer find_pose(string pose, string ball)
{
    integer total_number = llGetListLength(poses);
    integer i;
    for(i=0; i<total_number; i++)
    {
        if (pose == llList2String(poses, i) && ball == llList2String(balls, i))
        {
            return i;
        }
    }
    return -1;
}
 
// add a pose/ball/command entry
add_pose(string pose, string ball, string command)
{
    // look for existing entry for pose
    integer found = find_pose(pose, ball);
    if (found == -1)
    {
        // add a new pose
        poses += [pose];
        balls += [ball];
        commands += [command];
 
        log("Added from " + NOTECARD + ": " + pose + " | " + ball + " | " + command);
    }
    else
    {
        // append to existing pose
        string c = llList2String(commands, found) + "|" + command;
        commands = llListReplaceList(commands, [c], found, found);
 
        log("Added " + command + " to pose " + pose);
    }
}
 
// parse and store a line
process_line(string line)
{
    list tokens = llParseString2List(line, ["  |  ","  | "," |  "," | "," |","| ","|"],[""]);
    if(llGetListLength(tokens) < 3) return;
 
    string pose = llList2String(tokens, 0);
    string ball = llList2String(tokens, 1);
 
    integer total_number = llGetListLength(tokens);
    integer i;
    for(i=2; i<total_number; i++)
    {
        add_pose(pose, ball, llList2String(tokens, i));
    }
}
 
// check if object is in the inventory
integer exists_notecard(string notecard) {
    return llGetInventoryType(notecard) == INVENTORY_NOTECARD;
}
 
// initialize me
initialize()
{
    log("Initializing...");
    poses = [];
    balls = [];
    commands = [];
    avatars = [NULL_KEY, NULL_KEY, NULL_KEY, NULL_KEY, NULL_KEY, NULL_KEY];
 
    if (exists_notecard(NOTECARD))
    {
        log("Reading " + NOTECARD + "...");
        iLine = 0;
        kQuery = llGetNotecardLine(NOTECARD, iLine);
    }
    else
    {
        llOwnerSay("Not found: " + NOTECARD );
    }
}
 
 
default
{
    // on state entry initialize me
    state_entry()
    {

        initialize();
    }
 
    // reset on Inventory change
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY) {
            wants_init=TRUE;
            llSetTimerEvent (15.0);
        }
    }
 
    // read a line from notecard
    dataserver(key _query_id, string _data) {
        // were we called to work on notecard?
        if (_query_id == kQuery) {
            // this is a line of our notecard
            if (_data == EOF) {
                if (DEBUG) log_data();
                log(NOTECARD + " read.");
            } else {
                    // increment line count
                    // data has the current line from this notecard
                    if(_data != "") {
                        process_line(_data);
                    }
 
                // request next line
                // read another line when you can
                iLine++;
                kQuery = llGetNotecardLine(NOTECARD, iLine);
            }
        }
    }
 
    timer()
    {
        if (wants_init) {
            wants_init = FALSE;
              initialize();        
            llSetTimerEvent (0.0);
            return;    
        }
        
        integer b;
        for (b=0; b<6; b++)
        {
            // get avatar for ball index
            key avatar = llList2Key(avatars, b);
 
            // if not null send command
            if(avatar != NULL_KEY) relay(avatar, CMD_RELEASE);
        }
        llSetTimerEvent(0.0);
    }
 
    // link message from MLPV2
    link_message(integer sender_number, integer number, string message, key id)
    {
        /*
        // pose from ball menu selected
        if (number == 0 && message == "POSEB") {
            pose = (string)id;
            rlv(pose);
            return;
        }
        */
 
        // direct call from ball menu
        // configure in .MENUITEMS with
        // LINKMSG Resctriction | 0,-1,-1819,Restriction
        if (number == LM_NUMBER) {
            //llOwnerSay ("RLV: -- "+message);
            pose = message;
            rlv(pose);
            return;
        }
 
        // unsit avatar
        if (number == -11001)
        {
            integer ball = (integer) message;
            log("Avatar unsit from ball " + (string) ball +": " + (string) llList2Key(avatars, ball));
            //relay(llList2Key(avatars, ball), CMD_RELEASE);
            avatars = llListReplaceList(avatars, [NULL_KEY], ball, ball);
        }
 
        // sit avatar
        if (number == -11000)
        {
            list tokens = llParseString2List(message, ["|"], [" "]);
            integer ball = llList2Integer(tokens, 0);
            log("Avatar sit on ball " + (string) ball +": " + (string) id);
            avatars = llListReplaceList(avatars, [id], ball, ball);
            //rlv(pose);
        }
    }
}