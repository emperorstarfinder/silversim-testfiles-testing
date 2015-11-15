///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: ZHAOII Main Animation Overrider.lsl 4 2007-02-03 18:13:52Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

// 1.0.11.3 by Fennec Wind January 18th, 2007
//          Changed Walk/Sit/Ground Sit dialogs to show animation name (or partial name if too long) and only show buttons for non-blank entries.
//          Fixed minor bug in the state_entry, ground sits were not being initialized.

// 1.0.11.2 Fixed forward walk override (same as previous backward walk fix). 09/06 by Dzonatas Sol

// Ziggy's HUD Animation Overrider - 05/06

// Based on Francis Chung's Franimation Overrider v1.8

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.

// CONSTANTS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// List of all the animation states
list animState = ["Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
                  "Soft Landing", "Standing Up", "Falling Down", "Hovering Down", "Hovering Up",
                  "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
                  "Turning Right", "Turning Left", "Walking", "Landing", "Standing" ];

// Animations in which we automatically disable animation overriding
// Try to keep this list short, the longer it is the worse it affects our runtime
// (Note: This is *almost* constant. We have to type-convert this to keys instead of strings
// on initialization - blargh)
list autoDisableList = [
    "3147d815-6338-b932-f011-16b56d9ac18b", // aim_R_handgun
    "ea633413-8006-180a-c3ba-96dd1d756720", // aim_R_rifle
    "b5b4a67d-0aee-30d2-72cd-77b333e932ef", // aim_R_bazooka
    "46bb4359-de38-4ed8-6a22-f1f52fe8f506", // aim_l_bow
    "9a728b41-4ba0-4729-4db7-14bc3d3df741", // Launa's hug
    "f3300ad9-3462-1d07-2044-0fef80062da0", // punch_L
    "c8e42d32-7310-6906-c903-cab5d4a34656", // punch_r
    "85428680-6bf9-3e64-b489-6f81087c24bd", // sword_strike_R
    "eefc79be-daae-a239-8c04-890f5d23654a"  // punch_onetwo
];

// Index of interesting animations
integer noAnimIndex     = -1;
integer standIndex      = 20;
integer sittingIndex    = 1;
integer sitgroundIndex  = 0;
integer hoverIndex      = 12;
integer flyingIndex     = 11;
integer flyingslowIndex = 10;
integer hoverupIndex    = 9;
integer hoverdownIndex  = 8;
integer waterTreadIndex = 25;
integer swimmingIndex   = 26;
integer swimupIndex     = 27;
integer swimdownIndex   = 28;
integer standingupIndex = 6;
integer walkingIndex    = 18;

// list of animations that have a different value when underwater
list underwaterAnim = [ hoverIndex, flyingIndex, flyingslowIndex, hoverupIndex, hoverdownIndex ];

// corresponding list of animations that we override the overrider with when underwater
list underwaterOverride = [ waterTreadIndex, swimmingIndex, swimmingIndex, swimupIndex, swimdownIndex];

list lineNums = [ 45, // 0  Sitting on Ground
                  33, // 1  Sitting
                   1, // 2  Striding
                  17, // 3  Crouching
                   5, // 4  CrouchWalking
                  39, // 5  Soft Landing
                  41, // 6  Standing Up
                  37, // 7  Falling Down
                  19, // 8  Hovering Down
                  15, // 9  Hovering Up
                  43, // 10 FlyingSlow
                   7, // 11 Flying
                  31, // 12 Hovering
                  13, // 13 Jumping
                  35, // 14 PreJumping
                   3, // 15 Running
                  11, // 16 Turning Right
                   9, // 17 Turning Left
                   1, // 18 Walking
                  39, // 19 Landing
                  21, // 20 Standing 1

                  // Extra...

                  23, // 21 Standing 2
                  25, // 22 Standing 3
                  27, // 23 Standing 4
                  29, // 24 Standing 5
                  47, // 25 Treading Water
                  49, // 26 Swimming
                  51, // 27 Swim up
                  53, // 28 Swim Down
                  55, // 29 Walking 2
                  57, // 30 Walking 3
                  59, // 31 Walking 4
                  61, // 32 Walking 5
                  63, // 33 Sitting 2
                  65, // 34 Sitting 3
                  67, // 35 Sitting 4
                  69, // 36 Sitting 5
                  71, // 37 Ground Sitting 2
                  73, // 38 Ground Sitting 3
                  75, // 39 Ground Sitting 4
                  77 // 40 Ground Sitting 5
                ];

// This is an ugly hack, because the standing up animation doesn't work quite right
// (SL is borked, this has been bug reported)
// If you play a pose overtop the standing up animation, your avatar tends to get
// stuck in place.
// This is a list of anims that we'll stop automatically
list autoStop = [ 5, 6, 19 ];
// Amount of time we'll wait before autostopping the animation (set to 0 to turn off autostopping )
float autoStopTime = 1.5;

// List of stands
list standIndexes = [ 20, 21, 22, 23, 24 ];

// How long before flipping stand animations
float standTimeDefault = 40.0;

// List of sits
list sitIndexes = [ 1, 33, 34, 35, 36 ];

// List of walks
list walkIndexes = [ 18, 29, 30, 31, 32 ];

// List of ground sits
list gsitIndexes = [ 0, 37, 38, 39, 40 ];

// How fast we should poll for changed anims (as fast as possible)
// In practice, you will not poll more than 8 times a second.
float timerEventLength = 0.1;

// List of states where llGetAnimation() might give us something goofy back
list hackGetAnimList = ["CrouchWalking"];

// GLOBALS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

integer curStandIndex = 0;                     // Current stand we're on (indexed [0, numStands])
string curStandAnim = "";                      // Current Stand animation
integer numStands = 5;                             // # of stand anims we use (constant: ListLength(stands))
integer curStandAnimIndex = 0;                 // Current stand we're on (indexed [0, numOverrides] )

integer curSitIndex = 0;                       // Current sit we're on (indexed [0, numSits])
string curSitAnim = "";                        // Current sit animation
integer numSits = 5;                               // # of sit anims we use (constant: ListLength(sits))
integer curSitAnimIndex = 0;                   // Current sit we're on (indexed [0, numOverrides] )

integer curWalkIndex = 0;                      // Current walk we're on (indexed [0, numWalks])
string curWalkAnim = "";                       // Current walk animation
integer numWalks = 5;                              // # of walk anims we use (constant: ListLength(walks))
integer curWalkAnimIndex = 0;                  // Current walk we're on (indexed [0, numOverrides] )

integer curGsitIndex = 0;                     // Current ground sit we're on (indexed [0, numGsits])
string curGsitAnim = "";                      // Current ground sit animation
integer numGsits = 5;                             // # of ground sit anims we use (constant: ListLength(gsits))
integer curGsitAnimIndex = 0;                 // Current ground sit we're on (indexed [0, numOverrides] )

string curAnim = "";							// Current animation for dialogs

list overrides = [];                           // List of animations we override
key notecardLineKey;                           // notecard reading keys
integer notecardLinesRead;                     // number of notecard lines read
integer notecardIndex;                         // current line beingr ead from notecard
integer numOverrides;                          // # of overrides (a constant - llGetListLength(lineNums))

string  lastAnim = "";                         // last Animation we ever played
string  lastAnimSet = "";                      // last set of animations we ever played
integer lastAnimIndex = 0;                     // index of the last animation we ever played
string  lastAnimState = "";                    // last thing llGetAnimation() returned

float standTime = standTimeDefault;            // How long before flipping stand animations

integer animOverrideOn = TRUE;                 // Is the animation override on?
integer gotPermission  = FALSE;                // Do we have animation permissions?

integer haveWalkingAnim = FALSE;               // Hack to get it so we face the right way when we walk backwards

integer sitOverride = TRUE;                    // Whether we're overriding sit or not

integer listenState = 0;                       // What pop-up menu we're handling now

string notecardName = "";                      // The notecard we're currently reading

list overrideStorage = ["","","","","","","","","","","",""];

string dlgAnimName; // Current animation name
list dlgAnimNames = []; // List of found animation names
integer i;

// CODE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Find if two lists/sets share any elements in common
integer hasIntersection( list _list1, list _list2 ) {
    list bigList;
    list smallList;
    integer smallListLength;
    integer i;

    if (  llGetListLength( _list1 ) <= llGetListLength( _list2 ) ) {
        smallList = _list1;
        bigList = _list2;
    }
    else {
        bigList = _list1;
        smallList = _list2;
    }
    smallListLength = llGetListLength( smallList );

    for ( i=0; i<smallListLength; i++ ) {
        if ( llListFindList( bigList, llList2List(smallList,i,i) ) != -1 ) {
            return TRUE;
        }
    }

    return FALSE;
}

startAnimationList( string _csvAnims ) {
    list anims = llCSV2List( _csvAnims );
    integer numAnims = llGetListLength( anims );
    integer i;
    for( i=0; i<numAnims; i++ )
        llStartAnimation( llList2String(anims,i) );
}

stopAnimationList( string _csvAnims ) {
    list anims = llCSV2List( _csvAnims );
    integer numAnims = llGetListLength( anims );
    integer i;
    for( i=0; i<numAnims; i++ )
        llStopAnimation( llList2String(anims,i) );
}

startNewAnimation( string _anim, integer _animIndex, string _state ) {
   if ( _anim != lastAnimSet ) {
      string newAnim;
      if ( lastAnim != "" )
         stopAnimationList( lastAnim );
      if ( _anim != "" ) {   // Time to play a new animation
         list newAnimSet = llParseStringKeepNulls( _anim, ["|"], [] );
         newAnim = llList2String( newAnimSet, (integer)llFloor(llFrand(llGetListLength(newAnimSet))) );

         startAnimationList( newAnim );

         if ( llListFindList( autoStop, [_animIndex] ) != -1 ) {
            // This is an ugly hack, because the standing up animation doesn't work quite right
            // (SL is borked, this has been bug reported)
            // If you play a pose overtop the standing up animation, your avatar tends to get
            // stuck in place.
            if ( lastAnim != "" ) {
               stopAnimationList( lastAnim );
               lastAnim = "";
            }
            llSleep( autoStopTime );
            stopAnimationList( _anim );
         }
      }
      lastAnim = newAnim;
      lastAnimSet = _anim;
   }
   lastAnimIndex = _animIndex;
   lastAnimState = _state;
}

// Load all the animation names from a notecard
loadNoteCard() {

    if ( llGetInventoryKey(notecardName) == NULL_KEY ) {
        llOwnerSay( "Notecard '" + notecardName + "' does not exist, or does not have full permissions." );
		llMessageLinked(LINK_ROOT, FALSE, "Set Loading", NULL_KEY);
        notecardName = "";
        return;
    }

	// See if notecard has been cached
	integer storageIndex = llListFindList(overrideStorage, [notecardName]);
	if(storageIndex != -1)
	{
		llMessageLinked(LINK_ROOT, storageIndex, "Get Override", NULL_KEY);
		return;
	}

    llOwnerSay( "Loading notecard '" + notecardName + "'..." );

    // Faster events while processing our notecard
    llMinEventDelay( 0 );

    // Start reading the data
    notecardLinesRead = 0;
    notecardIndex = 0;
    notecardLineKey = llGetNotecardLine( notecardName, llList2Integer(lineNums, notecardIndex) );
}

// Figure out what animation we should be playing right now
animOverride() {
    string  curAnimState = llGetAnimation(llGetOwner());
    integer curAnimIndex;
    integer underwaterAnimIndex;
    vector  curPos;

    // Check if we need to work around any bugs in llGetAnimation
    if ( llListFindList(hackGetAnimList, [curAnimState]) != -1 ) {

       // Hack, because, SL really likes to switch between crouch and crouchwalking for no reason
       if ( curAnimState == "CrouchWalking" ) {
          if ( llVecMag(llGetVel()) < .5 )
             curAnimState = "Crouching";
       }
    }

    if ( curAnimState == lastAnimState ) {
        // This conditional not absolutely necessary (In fact it's better if it's not here)
        // But it's good for increasing performance.
        // One of the drawbacks of this performance hack is the underwater animations
        // If you fly up, it will keep playing the "swim up" animation even after you've
        // left the water.
        return;
    }

    curAnimIndex        = llListFindList( animState, [curAnimState] );
    underwaterAnimIndex = llListFindList( underwaterAnim, [curAnimIndex] );
    curPos              = llGetPos();

    if ( curAnimIndex == standIndex ) {
        startNewAnimation( curStandAnim, curStandAnimIndex, curAnimState );
    }
    else if ( curAnimIndex == sittingIndex ) {
        // Check if sit override is turned off
        if (( sitOverride == FALSE ) && ( curAnimState == "Sitting" )) {
            startNewAnimation( "", noAnimIndex, curAnimState );
        }
        else {
            startNewAnimation( curSitAnim, curSitAnimIndex, curAnimState );
        }
    }
    else if ( curAnimIndex == walkingIndex ) {
        startNewAnimation( curWalkAnim, curWalkAnimIndex, curAnimState );
    }
    else if ( curAnimIndex == sitgroundIndex ) {
        startNewAnimation( curGsitAnim, curGsitAnimIndex, curAnimState );
    }
    else {
        if ( underwaterAnimIndex != -1 && llWater(ZERO_VECTOR) > curPos.z )
            curAnimIndex = llList2Integer( underwaterOverride, underwaterAnimIndex );
        startNewAnimation( llList2String( overrides, curAnimIndex ), curAnimIndex, curAnimState );
    }
}

// Switch to the next stand anim
doNextStand()
{
	curStandIndex = (curStandIndex+1) % numStands;
	curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);
	curStandAnim = llList2String(overrides, curStandAnimIndex);
	if(lastAnimState == "Standing")
    {
		startNewAnimation( curStandAnim, curStandAnimIndex, lastAnimState );
	}
	llResetTime();
}

// Returns true if we should override the current animation
integer shouldOverride() {
    if ( animOverrideOn && gotPermission ) {
        // Check if we should explicitly NOT override a playing animation
        if ( hasIntersection( autoDisableList, llGetAnimationList(llGetOwner()) ) ) {
            startNewAnimation( "", noAnimIndex, "" );
            return FALSE;
        }
        return TRUE;
    }
    return FALSE;
}

// Initialize listeners, and reset some status variables
initialize() {
    if ( animOverrideOn )
        llSetTimerEvent( timerEventLength );
    else
        llSetTimerEvent( 0 );

    lastAnim = "";
    lastAnimIndex = noAnimIndex;
    lastAnimState = "";
    gotPermission = FALSE;

	stopAnimationList(llList2CSV(llGetAnimationList(llGetOwner())));

	// Check sit override status
	if(sitOverride)
	{
		llMessageLinked(LINK_SET, 0, "Sit On", NULL_KEY);
	}
	else
	{
		llMessageLinked(LINK_SET, 0, "Sit Off", NULL_KEY);
	}

	llOwnerSay("Override activated. ("+(string)llCeil(100 * llGetFreeMemory() / (float)(16*1024))+"% free)");
}

// STATE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

default {
    state_entry() {
        integer i;

        if ( llGetAttached() )
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);

        // Initialize!
        curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);

        curSitAnimIndex = llList2Integer(sitIndexes,curSitIndex);

        curWalkAnimIndex = llList2Integer(walkIndexes,curWalkIndex);

		// Added ground sit initializing - Fennec Wind
        curGsitAnimIndex = llList2Integer(gsitIndexes,curGsitIndex);

        numOverrides = 41;

        // Type convert strings to keys :P
        for ( i=0; i<llGetListLength(autoDisableList); i++ ) {
            key k = llList2Key( autoDisableList, i );
            autoDisableList = llListReplaceList ( autoDisableList, [ k ], i, i );
        }

        // populate override list with blanks
        for ( i=0; i<numOverrides; i++ ) {
            overrides += [ "" ];
        }
        initialize();

		llMessageLinked(LINK_ROOT, -1, "Load", NULL_KEY);

        // turn off the auto-stop anim hack
        if ( autoStopTime == 0 )
            autoStop = [];

        llResetTime();
    }

   run_time_permissions(integer _parm) {
      if( _parm != (PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS) )
         gotPermission = FALSE;
      else {
         llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE);
         gotPermission = TRUE;
      }
   }

    attach( key _k ) {
        if ( _k != NULL_KEY )
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
    }

    link_message( integer _sender, integer _channel, string _message, key _id ) {

        if ( _message == "On" ) {
            llSetTimerEvent( timerEventLength );
            animOverrideOn = TRUE;
            if ( gotPermission )
                animOverride();
        }
        else if ( _message == "Off" ) {
            llSetTimerEvent( 0 );
            animOverrideOn = FALSE;
            startNewAnimation( "", noAnimIndex, lastAnimState );
			llSleep(2); // Brief delay just to make sure things are caught up.
			llSetScriptState("Cache", FALSE);
			llSetScriptState("ZHAOII Main Animation Overrider", FALSE);
        }
		else if ( _message == "NextStand")
		{
			if ( animOverrideOn && gotPermission )
			{
				doNextStand();
			}
		}
		else if(_message == "Load Notecard")
		{
			llMessageLinked(LINK_ROOT, TRUE, "Set Loading", NULL_KEY);
			notecardName = (string)_id;
			loadNoteCard();
		}
        else if ( _message == "Sit On" ) {
            // Turning on sit override
            sitOverride = TRUE;
            if ( lastAnimState == "Sitting" )
                startNewAnimation( curSitAnim, curSitAnimIndex, lastAnimState );
        }
        else if ( _message == "Sit Off" ) {
            // Turning off sit override
            sitOverride = FALSE;
            if ( lastAnimState == "Sitting" )
                startNewAnimation( "", noAnimIndex, lastAnimState );
        }
		else if(_message == "Sit")
		{
			dlgAnimNames = []; // List of found animation names
			for(i = 0; i < numSits; i++)
			{
				dlgAnimName = llList2String(overrides, llList2Integer(sitIndexes, i));
				if(dlgAnimName != ""){dlgAnimNames = (dlgAnimNames = []) + dlgAnimNames + dlgAnimName;}
			}
			llMessageLinked(LINK_ROOT, llListFindList(sitIndexes, [curSitAnimIndex]), "Dialog Sit", (key)llList2CSV(dlgAnimNames));
			dlgAnimName = ""; dlgAnimNames = [];
		}
		else if(_message == "Set Sit")
		{
			integer p = llListFindList(overrides, [(string)_id]); // Find the index for the selected animation
			if(p == -1)
			{
				if(llStringLength((string)_id) == 24)
				{
					for(i = 0; i < 24; i++)
					{
						if(llGetSubString(llList2String(overrides, i), 0, 23) == (string)_id)
						{
							p = i;
							_id = (key)llList2String(overrides, p);
							i = 24; // break
						}
					}
				}
			}
			if(p != -1)
			{
				curSitAnimIndex = p;
				curSitAnim = (string)_id;
				if(lastAnimState == "Sitting"){startNewAnimation(curSitAnim, curSitAnimIndex, lastAnimState);}
				llOwnerSay("New sitting animation: "+curSitAnim);
			}
		}
		else if(_message == "Walk")
		{
			dlgAnimNames = []; // List of found animation names
			for(i = 0; i < numWalks; i++)
			{
				dlgAnimName = llList2String(overrides, llList2Integer(walkIndexes, i));
				if(dlgAnimName != ""){dlgAnimNames = (dlgAnimNames = []) + dlgAnimNames + dlgAnimName;}
			}
			llMessageLinked(LINK_ROOT, llListFindList(walkIndexes, [curWalkAnimIndex]), "Dialog Walk", (key)llList2CSV(dlgAnimNames));
			dlgAnimName = ""; dlgAnimNames = [];
		}
		else if(_message == "Set Walk")
		{
			integer p = llListFindList(overrides, [(string)_id]); // Find the index for the selected animation
			if(p == -1)
			{
				if(llStringLength((string)_id) == 24)
				{
					for(i = 0; i < 24; i++)
					{
						if(llGetSubString(llList2String(overrides, i), 0, 23) == (string)_id)
						{
							p = i;
							_id = (key)llList2String(overrides, p);
							i = 24; // break
						}
					}
				}
			}
			if(p != -1)
			{
				curWalkAnimIndex = p;
				curWalkAnim = (string)_id;
				if(lastAnimState == "Walking"){startNewAnimation(curWalkAnim, curWalkAnimIndex, lastAnimState );}
				llOwnerSay("New walking animation: "+curWalkAnim);
			}
		}
		else if(_message == "GroundSit")
		{
			dlgAnimNames = []; // List of found animation names
			for(i = 0; i < numSits; i++)
			{
				dlgAnimName = llList2String(overrides, llList2Integer(sitIndexes, i));
				if(dlgAnimName != ""){dlgAnimNames = (dlgAnimNames = []) + dlgAnimNames + dlgAnimName;}
			}
			llMessageLinked(LINK_ROOT, llListFindList(gsitIndexes, [curGsitAnimIndex]), "Dialog GroundSit", (key)llList2CSV(dlgAnimNames));
			dlgAnimName = ""; dlgAnimNames = [];
		}
		else if(_message == "Set GroundSit")
		{
			integer p = llListFindList(overrides, [(string)_id]); // Find the index for the selected animation
			if(p == -1)
			{
				if(llStringLength((string)_id) == 24)
				{
					for(i = 0; i < 24; i++)
					{
						if(llGetSubString(llList2String(overrides, i), 0, 23) == (string)_id)
						{
							p = i;
							_id = (key)llList2String(overrides, p);
							i = 24; // break
						}
					}
				}
			}
			if(p != -1)
			{
				curGsitAnimIndex = p;
				curGsitAnim = (string)_id;
				if(lastAnimState == "Sitting on Ground"){startNewAnimation(curGsitAnim, curGsitAnimIndex, lastAnimState);}
				llOwnerSay("New sitting on ground animation: "+curGsitAnim);
			}
		}
		else if(_message == "Recive Override")
		{
			overrides = llCSV2List((string)_id);
			curStandAnim = llList2String(overrides, 20);
			curSitAnim = llList2String(overrides, 1);
			curWalkAnim = llList2String(overrides, 18);
			curGsitAnim = llList2String(overrides, 0);
			// Do we have a walking animation?
			haveWalkingAnim = !( curWalkAnim == "" );

			llOwnerSay("Finished loading cached notecard "+notecardName+". ("+(string)llCeil(100 * llGetFreeMemory() / (float)(16*1024))+"% free)");
			llMessageLinked(LINK_ROOT, FALSE, "Set Loading", NULL_KEY);
			notecardName = "";
		}
    }

    dataserver( key _query_id, string _data ) {

        if ( _query_id != notecardLineKey ) {
            llOwnerSay( "Error in reading notecard. Please try again." );
			llMessageLinked(LINK_ROOT, FALSE, "Set Loading", NULL_KEY);
            notecardName = "";
            return;
        }

        if ( _data != EOF ) {    // not random crap

            if ( notecardIndex == curStandAnimIndex )   // Pull in the current stand animation
                curStandAnim = _data;

            if ( notecardIndex == curSitAnimIndex )   // Pull in the current sit animation
                curSitAnim = _data;

            if ( notecardIndex == curWalkAnimIndex )   // Pull in the current walk animation
                curWalkAnim = _data;

            if ( notecardIndex == curGsitAnimIndex )   // Pull in the current ground sit animation
                curGsitAnim = _data;

            // Whoops, we're replacing the currently playing anim
            if ( animOverrideOn && gotPermission && notecardIndex == lastAnimIndex )  {

                // Better play the new one :)
                startNewAnimation( _data, lastAnimIndex, lastAnimState );
            }

             // Do we have a walking animation?
             if ( notecardIndex == walkingIndex )
                 haveWalkingAnim = !( _data == "" );

            // Store the name of the new animation
            overrides = llListReplaceList( overrides, [_data], notecardIndex, notecardIndex );

            notecardLinesRead ++;

            // See if we're done loading the notecard. Users like status messages.
            if ( notecardLinesRead < numOverrides ) {
                notecardIndex ++;
                notecardLineKey = llGetNotecardLine( notecardName, llList2Integer(lineNums, notecardIndex) );
            }
            else {
				llOwnerSay("Finished reading notecard "+notecardName+". ("+(string)llCeil(100 * llGetFreeMemory() / (float)(16*1024))+"% free)");

				// Store the overrides in the storage script for quick changing.
				integer storageIndex = llListFindList(overrideStorage, [notecardName]);
				if(storageIndex == -1)
				{
					storageIndex = llListFindList(overrideStorage, [""]);
				}
				overrideStorage = llListReplaceList(overrideStorage, [notecardName], storageIndex, storageIndex);
				llMessageLinked(LINK_ROOT, storageIndex, "Store Override", llList2CSV(overrides));

				llMessageLinked(LINK_ROOT, FALSE, "Set Loading", NULL_KEY);
                notecardName = "";

                // Restore the minimum event delay
                llMinEventDelay( 0.1 );
            }
        }
        else {
            // We hit EOF, so it's a short notecard - probably an original

			llOwnerSay("Finished reading notecard "+notecardName+". ("+(string)llCeil(100 * llGetFreeMemory() / (float)(16*1024))+"% free)");

			// Store the overrides in the storage script for quick changing.
			integer storageIndex = llListFindList(overrideStorage, [notecardName]);
			if(storageIndex == -1)
			{
				storageIndex = llListFindList(overrideStorage, [""]);
			}
			overrideStorage = llListReplaceList(overrideStorage, [notecardName], storageIndex, storageIndex);
			llMessageLinked(LINK_ROOT, storageIndex, "Store Override", llList2CSV(overrides));

			llMessageLinked(LINK_ROOT, FALSE, "Set Loading", NULL_KEY);
            notecardName = "";

            // Restore the minimum event delay
            llMinEventDelay( 0.1 );
        }
    }

    on_rez( integer _code ) {
        initialize();
    }

   collision_start( integer _num ) {
      if ( shouldOverride() )
         animOverride();
   }

   collision( integer _num ) {
      if ( shouldOverride() )
         animOverride();
   }

   collision_end( integer _num ) {
      if ( shouldOverride() )
         animOverride();
   }

   control( key _id, integer _level, integer _edge ) {
      if ( _edge ) {
         // SL tends to mix animations together on forward or backward walk. It could be because
         // of anim priorities. This helps stop the default walking anims, so it won't mix with
         // the desired anim. This also lets the avi turn around on a backwards walk for a more natural
         // look.
         if ( _level & _edge & ( CONTROL_BACK | CONTROL_FWD ) ) {
            if ( llGetAnimation(llGetPermissionsKey()) == "Walking" ) {
                if ( haveWalkingAnim ) {
                    llStopAnimation("walk");
                    llStopAnimation("female_walk");
                }
            }
         }

         if ( shouldOverride() )
            animOverride();
      }
   }

    timer() {
        if ( shouldOverride() ) {
            animOverride();

            // Is it time to switch stand animations?
            if ( llGetTime() > standTime ) {
                // Don't interrupt the typing animation with a stand change
				if(!(llGetAgentInfo(llGetOwner()) & AGENT_TYPING)){doNextStand();}
            }
        }
    }

	changed(integer change)
	{
		if(change & CHANGED_INVENTORY)
		{
			// We might have a changed notecard, go ahead and clear the cache index just to be safe.
			overrideStorage = ["","","","","","","","","","","",""];
		}
	}
}
