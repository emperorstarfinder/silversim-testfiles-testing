// ZHAO-II-core - Ziggy Puff, 07/07

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Main engine script - receives link messages from any interface script. Handles the core AO work
//
// Interface definition: The following link_message commands are handled by this script. All of 
// these are sent in the string field. All other fields are ignored
//
// ZHAO_RESET							Reset script
// ZHAO_LOAD|<notecardName>				Load specified notecard
// ZHAO_NEXTSTAND						Switch to next stand
// ZHAO_STANDTIME|<time>				Time between stands. Specified in seconds, expects an integer.
// 										0 turns it off
// ZHAO_AOON							AO On
// ZHAO_AOOFF							AO Off
// ZHAO_SITON							Sit On
// ZHAO_SITOFF							Sit Off
// ZHAO_RANDOMSTANDS					Stands cycle randomly
// ZHAO_SEQUENTIALSTANDS				Stands cycle sequentially
// ZHAO_SETTINGS						Prints status
// ZHAO_SITS							Select a sit
// ZHAO_GROUNDSITS						Select a ground sit
// ZHAO_WALKS							Select a walk
//
// ZHAO_SITANYWHERE_ON					Sit Anywhere mod On 
// ZHAO_SITANYWHERE_OFF					Sit Anywhere mod Off 
//
// ZHAO_TYPE_ON							Typing AO On 
// ZHAO_TYPE_OFF						Typing AO Off 
//
// ZHAO_TYPEKILL_ON                    Typing Killer On 
// ZHAO_TYPEKILL_OFF                   Typing Killer Off 
//
// So, to send a command to the ZHAO-II engine, send a linked message:
//
//   llMessageLinked(LINK_SET, 0, "ZHAO_AOON", NULL_KEY);
//
// This script uses a listener on channel -91234. If other scripts are added to the ZHAO, make sure 
// they don't use the same channel
/////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////
// New notecard format
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
// Lines starting with a / are treated as comments and ignored. Blank lines are ignored. Valid lines 
// look like this:
//
// [ Walking ]SexyWalk1|SexyWalk2|SexyWalk3
//
// The token (in this case, [ Walking ]) identifies the animation to be overridden. The rest is a 
// list of animations, separated by the '|' (pipe) character. You can specify multiple animations 
// for Stands, Walks, Sits, and GroundSits. Multiple animations on any other line will be ignored. 
// You can have up to 12 animations each for Walks, Sits and GroundSits. There is no hard limit 
// on the number of stands, but adding too many stands will make the script run out of memory and 
// crash, so be careful. You can repeat tokens, so you can split the Stands up across multiple lines. 
// Use the [ Standing ] token in each line, and the script will add the animation lists together.
//
// Advanced: Each 'animation name' can be a comma-separated list of animations, which will be played 
// together. For example:
//
// [ Walking ]SexyWalk1UpperBody,SexyWalk1LowerBody|SexyWalk2|SexyWalk3
//
// Note the ',' between SexyWalk1UpperBody and SexyWalk1LowerBody - this tells ZHAO-II to treat these 
// as a single 'animation' and play them together. The '|' between this 'animation' and SexyWalk2 tells 
// ZHAO-II to treat SexyWalk2 and SexyWalk3 as separate walk animations. You can use this to layer 
// animations on top of each other.
//
// Do not add any spaces around animation names!!!
//
// The token can be one of the following:
//
// [ Standing ]
// [ Walking ]
// [ Sitting ]
// [ Sitting On Ground ]
// [ Crouching ]
// [ Crouch Walking ]
// [ Landing ]
// [ Standing Up ]
// [ Falling ]
// [ Flying Down ]
// [ Flying Up ]
// [ Flying ]
// [ Flying Slow ]
// [ Hovering ]
// [ Jumping ]
// [ Pre Jumping ]
// [ Running ]
// [ Taking Off ]
// [ Turning Right ]
// [ Turning Left ]
// [ Floating ]
// [ Swimming Forward ]
// [ Swimming Up ]
// [ Swimming Down ]
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Chloe1982 Constantine, 05/08/13 - Modified/Updated to use the new LSL Animation functions, timer is
//					now used only to detect swimming (timerEventLength)
//					incorporates fix to not kill a typing anim
//					incorporates seamless sit
//
// Ziggy, 07/16/07 - Warning instead of error on 'no animation in inventory', that way SL's built-in
//					anims can be used
//
// Ziggy, 07/14/07 - 2 bug fixes. Listens aren't being reset on owner change, and a typo in the 
//					ground sit animation code
//
// Ziggy, 06/07: - Reduce script count, since idle scripts take up scheduler time
//					Tokenize notecard reader, to simplify notecard setup
//					Remove scripted texture changes, to simplify customization by animation sellers

// Fennec Wind, January 18th, 2007: - Changed Walk/Sit/Ground Sit dialogs to show animation name (or partial name if too long) 
//					and only show buttons for non-blank entries.
//					Fixed minor bug in the state_entry, ground sits were not being initialized.
//

// Dzonatas Sol, 09/06: Fixed forward walk override (same as previous backward walk fix). 


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
// Default notecard we read on script_entry
string defaultNoteCard = "Default";

// List of all the animation states
list animState = [ "Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
				   "Soft Landing", "Standing Up", "Falling Down", "Hovering Down", "Hovering Up",
				   "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
				   "Turning Right", "Turning Left", "Walking", "Landing", "Standing", "Taking Off" ];

// Logic change - we now have a list of tokens. The 'overrides' list is the same length as this, 
// i.e. it has one entry per token, *not* one entry per animation. Multiple options for a token 
// are stored as | separated strings in a single list entry. This was done to save memory, and 
// allow a larger number of stands etc. All the xxxIndex variables now refer to the token index, 
// since that's how long 'overrides' is.

// List of internal tokens. This *must* be in the same sequence as the animState list. Note that
// we combine some tokens after the notecard is read (striding/walking, landing/soft landing), etc.
// The publicized tokens list only contains one entry for each pair, but we'll accept both, and
// combine them later
list tokens = [ "Sitting On Ground", "Sitting",     "Striding", "Crouching", "Crouch Walking",		// 0-4
				"Soft Landing", "Standing Up", "Falling", "Flying Down", "Flying Up",				// 5-9
				"Flying Slow", "Flying", "Hovering", "Jumping", "Pre Jumping",						// 10-14
				"Running", "Turning Right", "Turning Left", "Walking", "Landing",					// 15-19
				"Standing", "Taking Off", "Swimming Down", "Swimming Up", "Swimming Forward",		// 20-24
				"Floating", "Typing" ];																// 25-26

// The tokens for which we allow multiple animations
string multiAnimTokenIndexes = ",0,1,18,20,";    // Groundsit, Sitting, Walking, Standing

// Index of interesting animations
integer noAnimIndex		= -1;
integer sitgroundIndex	= 0;
integer sittingIndex	= 1;
integer walkingIndex	= 18;
integer standingIndex	= 20;
integer swimLowIndex	= 22;
integer swimHighIndex	= 25;
integer typingIndex		= 26;
/*
Not used any more but here to help with magic string
integer hoverdownIndex  = 8;
integer hoverupIndex    = 9;
integer flyingslowIndex = 10;
integer flyingIndex     = 11;
integer hoverIndex      = 12;
integer swimdownIndex   = 22;
integer swimupIndex     = 23;
integer swimmingIndex   = 24;
integer waterTreadIndex = 25;
*/

// magic string that replaces the following commented out lists
string magicPos = "12111009082524242322";
// number of swimming replacement anims
integer magicSwim = 5;

// list of animations that have a different value when underwater
//list underwaterAnim = [ hoverIndex, flyingIndex, flyingslowIndex, hoverupIndex, hoverdownIndex ];

// corresponding list of animations that we override the overrider with when underwater
//list underwaterOverride = [ waterTreadIndex, swimmingIndex, swimmingIndex, swimupIndex, swimdownIndex];

// How long before flipping stand animations
integer standTimeDefault = 30;

// How fast should we poll for whether or not we're under water?
// NOTE, you can change this to whatever value you like, it will just change the delay on how long it takes
// you to start/stop swimming
float timerEventLength = 3.0;
// Stupidly fast rate if we need to worry about typing
float typingRate = 0.25;

// Number of timer events that will have to pass to change an anim
integer maxTicks;
// Number of ticks that have passed
integer numTicks = 0;
// How fast are we clocking the timer?
float oldRate = 0.0;
// Are we underwater?
integer isUnder = FALSE;
integer hasSwim = FALSE;

// Listen channel for pop-up menu
integer listenChannel = -91234;

// GLOBALS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

integer typingStatus = FALSE;				// status of avatar typing

integer numTyping;							// Number of typing anims
integer numStands;							// Number of stands - needed for auto cycle
integer randomStands = FALSE;				// Whether stands cycle randomly
integer curStandIndex;						// Current stand - needed for cycling
string curStandAnim = "";					// Current Stand animation
string curSitAnim = "";						// Current sit animation
string curWalkAnim = "";					// Current walk animation
string curTypeAnim = "";					// Current type animation
string curGsitAnim = "";					// Current ground sit animation

list overrides = [];						// List of animations we override
key notecardLineKey;						// notecard reading keys
integer notecardIndex;						// current line being read from notecard
integer numOverrides;						// # of overrides

integer standTime = standTimeDefault;		// How long before flipping stand animations

integer animOverrideOn = TRUE;				// Is the animation override on?
integer gotPermission  = FALSE;				// Do we have animation permissions?
integer	gotTyping = FALSE;					// Not really about typing, but that's all we use it for

integer listenHandle;						// Listen handlers - only used for pop-up menu, then turned off

integer haveWalkingAnim = FALSE;			// Hack to get it so we face the right way when we walk backwards

integer sitOverride = TRUE;					// Whether we're overriding sit or not
integer standOverride = TRUE;				// Whether we're overriding stand or not
integer typingOverrideOn = FALSE;			// Whether we're overriding typing or not
integer typingKill = FALSE;                 // Whether we're killing the typing completely
/// Sit Anywhere mod by Marcus Gray
/// just one var to overrider stands... let's see how this works out 0o
integer sitAnywhereOn = FALSE;

integer listenState = 0;					// What pop-up menu we're handling now

integer loadInProgress = FALSE;				// Are we currently loading a notecard
string notecardName = "";					// The notecard we're currently reading

key Owner = NULL_KEY;

// String constants to save a few bytes
string EMPTY = "";
string SEPARATOR = "|";
string TRYAGAIN = "\nPlease correct the notecard and try again.";
string S_STAND = "Stand override: ";
string S_SIT = "Sit override: ";
string S_SIT_AW = "Sit anywhere: ";
string S_TYPING = "Typing override: ";
string S_TKILL = "Typing killer:";

// CODE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Enable or disable the AO

AO_Enable()
{
	setTimerEvent();
	numTicks = 0;
	if (gotPermission)
		sendOverrides();
}

AO_Disable()
{
	setTimerEvent();
	if (gotPermission)
		llResetAnimationOverride("ALL");            // Clear them all out
}

// Send new overrides to the server
sendOverrides()
{
	integer n = llGetListLength(animState);
	string anim = EMPTY;
	string st;
	while (n--)
	{
		st = llList2String(animState, n);
		if ((anim = llList2String(overrides, n)) == EMPTY)
			llResetAnimationOverride(st);
		else if (llSubStringIndex(multiAnimTokenIndexes, "," + (string)n + ",") == -1)
			doAnimSet(st, anim);
		else
		{
			if (n == 0)
				anim = curGsitAnim;
			else if (n == 1)
				anim = curSitAnim;
			else if (n == 18)
				anim = curWalkAnim;
			else
				anim = curStandAnim;
			doAnimSet(st, anim);
		}
	}
}

// Switch to the next stand anim
doNextStand(integer fromUI)
{
	if (sitAnywhereOn)
		return;
	if (numStands > 0)
	{
		if (randomStands)
			curStandIndex = llFloor(llFrand(numStands));
		else
			curStandIndex = (curStandIndex + 1) % numStands;

		doAnimSet("Standing", curStandAnim = findMultiAnim(20, curStandIndex));  //, 20

		if (fromUI)
			llOwnerSay("Switching to stand '" + curStandAnim + "'.");
	}
	else if (fromUI)
		llOwnerSay("No stand animations configured.");
}

// Actually set the animation (if we need to)
doAnimSet(string st, string anim)
{
	if (anim == EMPTY)
		return;
	if (animOverrideOn)
		llSetAnimationOverride(st, anim);
}

doType(string what, integer start)
{
	if (gotTyping)
	{
		if (start)
			llStartAnimation(what);
		else
			llStopAnimation(what);
	}
}

// Start or stop typing animation
typingOverride(integer isTyping) {
	if(isTyping) {  
		if( typingKill ) { // if we totally kill typing anims
			doType("type", FALSE);
			typingStatus = FALSE;
		}
		else
		{
			integer curTypingIndex = 0;
			if(numTyping > 1) {
				curTypingIndex = llFloor( llFrand(numTyping) );
			}
			curTypeAnim = findMultiAnim( typingIndex, curTypingIndex );
			doType(curTypeAnim, TRUE);
		}
	}
	else if( !typingKill )
	{
		doType(curTypeAnim, FALSE);
	}
}

// Displays menu of animation choices
doMultiAnimMenu( integer _animIndex, string _animType, string _currentAnim )
{
	// Dialog enhancement - Fennec Wind
	// Fix - a no-mod anim with a long name will break this

	list anims = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
	integer numAnims = llGetListLength( anims );
	if ( numAnims > 12 ) {
		llOwnerSay( "Too many animations, cannot generate menu. " + TRYAGAIN );
		return;
	}

	list buttons = [];
	integer i;
	string animNames = EMPTY;
	for ( i=0; i<numAnims; i++ ) {
		animNames += "\n" + (string)(i+1) + ". " + llList2String( anims, i );
		buttons += [(string)(i+1)];
	}
	// If no animations were configured, say so and just display an "OK" button
	if ( animNames == EMPTY ) {
		animNames = "\n\nNo overrides have been configured.";
	}
	llListenControl(listenHandle, TRUE);
	llDialog( Owner, "Select the " + _animType + " animation to use:\n\nCurrently: " + _currentAnim + animNames, 
			  buttons, listenChannel );
}

// Returns an animation from the multiAnims
string findMultiAnim( integer _animIndex, integer _multiAnimIndex )
{
	list animsList = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
	return llList2String( animsList, _multiAnimIndex );
}

// Checks for too many animations - can't do menus with > 12 animations
checkMultiAnim( integer _animIndex, string _animName )
{
	list animsList = llParseString2List( llList2String(overrides, _animIndex), [SEPARATOR], [] );
	if ( llGetListLength(animsList) > 12 )
		llOwnerSay( "You have more than 12 " + _animName + " animations. Please correct this." );
}

checkAnimInInventory( string _csvAnims )
{
	list anims = llCSV2List( _csvAnims );
	integer i;
	for( i=0; i<llGetListLength(anims); i++ ) {
		string animName = llList2String( anims, i );
		if ( llGetInventoryType( animName ) != INVENTORY_ANIMATION ) {
			// Only a warning, so built-in anims can be used
			llOwnerSay( "Warning: Couldn't find animation '" + animName + "' in inventory." );
		}
	}
}

doWater(integer drowning)
{
	if (isUnder == drowning)
		return;
	integer n = magicSwim;
	integer off = 0;
	if (isUnder = drowning)
		off = 2 * n;

	integer p;
	integer po;
	string anim;
	string st;
	while (n--)
	{
		po = p = (integer)llGetSubString(magicPos, n * 2, n * 2 + 1);
		if (isUnder)
			po = (integer)llGetSubString(magicPos, n * 2 + off, n * 2 + 1 + off);
		st = llList2String(animState, p);
		if ((anim = llList2String(overrides, po)) == EMPTY)
			llResetAnimationOverride(st);
		else
			doAnimSet(st, anim);
	}
}

// Load all the animation names from a notecard
loadNoteCard() {

	if ( llGetInventoryKey(notecardName) == NULL_KEY ) {
		llOwnerSay( "Notecard '" + notecardName + "' does not exist, or does not have full permissions." );
		loadInProgress = FALSE;
		notecardName = EMPTY;
		return;
	}

	llOwnerSay( "Loading notecard '" + notecardName + "'..." );

	// Clear out saved override information, since we now allow sparse notecards
	overrides = [];
	integer i;
	for ( i=0; i<numOverrides; i++ )
		overrides += [EMPTY];

	// Clear out multi-anim info as well, since we may end up with fewer options
	// that the last time
	curStandIndex = 0;
	curStandAnim = EMPTY;
	curSitAnim = EMPTY;
	curWalkAnim = EMPTY;
	curGsitAnim = EMPTY;
	
	hasSwim = FALSE;

	// Start reading the data
	notecardIndex = 0;
	notecardLineKey = llGetNotecardLine( notecardName, notecardIndex );
}

// Stop loading notecard
endNotecardLoad()
{
	loadInProgress = FALSE;
	notecardName = EMPTY;
	
	if (animOverrideOn)
		sendOverrides();
}

// If we're going to be able to handle typing then starting
// and stopping the timer is going to get tricky as there will
// be a lot of places where something has to be done to change
// the timer rate. Use the globals to figure out the rate

setTimerEvent()
{
	float rate = 0.0;
	if (animOverrideOn)
	{
		rate = standTime;
		if (hasSwim)
			rate = timerEventLength;
	}
	if (typingOverrideOn || typingKill)
		rate = typingRate;

	if (rate != 0.0)
	{
		numTicks = llFloor(numTicks*oldRate/rate);
		maxTicks = llRound(standTime / rate);
	}
	llSetTimerEvent(oldRate = rate);
}

sayOnOff(integer on, string what)
{
	string st = "Off";
	if (on)
		st = "On";
	llOwnerSay(what + st);
}

// Initialize listeners, and reset some status variables
initialize() {
	Owner = llGetOwner();

	setTimerEvent();
	numTicks = 0;

	gotPermission = FALSE;

	// Create new listener, and turn it off
	if ( listenHandle )
		llListenRemove( listenHandle );

	listenHandle = llListen( listenChannel, EMPTY, Owner, EMPTY );
	llListenControl( listenHandle, FALSE );

	llOwnerSay( (string)(llGetFreeMemory() * 100 / llGetMemoryLimit()) + "% memory free" );
}

// STATE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

default {
	state_entry() {
		integer i;

		Owner = llGetOwner();

		// Just a precaution, this shouldn't be on after a reset
		if ( listenHandle )
			llListenRemove( listenHandle );

		listenHandle = llListen( listenChannel, EMPTY, Owner, EMPTY );

		if (llGetAttached())
			llRequestPermissions(Owner, PERMISSION_OVERRIDE_ANIMATIONS | PERMISSION_TRIGGER_ANIMATION);

		numOverrides = llGetListLength(tokens);

		// populate override list with blanks
		overrides = [];
		for ( i=0; i<numOverrides; i++ ) {
			overrides += [ EMPTY ];
		}
		randomStands = FALSE;
		initialize();
		notecardName = defaultNoteCard;
		loadInProgress = TRUE;
		loadNoteCard();
	}

	on_rez( integer _code ) {
		initialize();
	}

	attach( key _k ) {
		if (_k != NULL_KEY)
			llRequestPermissions(Owner, PERMISSION_OVERRIDE_ANIMATIONS | PERMISSION_TRIGGER_ANIMATION);
		else if (gotPermission)
			llResetAnimationOverride("ALL");
		gotTyping = gotPermission = FALSE;
	}

	run_time_permissions( integer _perm ) {
		if (_perm & PERMISSION_OVERRIDE_ANIMATIONS)
		{
			if (animOverrideOn)
				sendOverrides();
			gotPermission = TRUE;
		}
		if (_perm & PERMISSION_TRIGGER_ANIMATION)
			gotTyping = TRUE;
	}

	link_message( integer _sender, integer _num, string _message, key _id) {
		
		// Coming from an interface script
		if ( _message == "ZHAO_RESET" ) {
			llOwnerSay( "Resetting..." );
			llResetScript();
		
		} else if ( _message == "ZHAO_AOON" ) {
			animOverrideOn = TRUE;
			llOwnerSay("AO Enabled.");
			AO_Enable();
		
		} else if ( _message == "ZHAO_AOOFF" ) {
			animOverrideOn = FALSE;
			llOwnerSay("AO Disabled.");
			AO_Disable();

		} else if ( _message == "ZHAO_STANDON" ) {
			// Turning on stand override
			sayOnOff(standOverride = TRUE, S_STAND);
			doAnimSet("Standing", curStandAnim);

		} else if ( _message == "ZHAO_STANDOFF" ) {
			// Turning off stand override
			sayOnOff(standOverride = FALSE,S_STAND);
            llResetAnimationOverride("Standing" );
        
		
		} else if ( _message == "ZHAO_SITON" ) {
			// Turning on sit override
			sayOnOff(sitOverride = TRUE, S_SIT);
			doAnimSet("Sitting", curSitAnim);
		
		} else if ( _message == "ZHAO_SITOFF" ) {
			// Turning off sit override
			sayOnOff(sitOverride = FALSE, S_SIT);
			llResetAnimationOverride("Sitting");

		} else if ( _message == "ZHAO_SITANYWHERE_ON" ) {
			if (curGsitAnim == EMPTY)
				llOwnerSay(S_SIT_AW + "Needs a ground sit animation");
			else
			{
				// Turning on sit anywhere mod
				sayOnOff(sitAnywhereOn = TRUE, S_SIT_AW);
				doAnimSet("Standing", curGsitAnim);
			}

		} else if ( _message == "ZHAO_SITANYWHERE_OFF" ) {
			// Turning off sit anywhere mod
			sayOnOff(sitAnywhereOn = FALSE, S_SIT_AW);
			doAnimSet("Standing", curStandAnim);

		} else if ( _message == "ZHAO_TYPEAO_ON" ) {
			if (numTyping)
			{
				// Turning on typing override
				sayOnOff(typingOverrideOn = TRUE, S_TYPING);
				setTimerEvent();
				typingStatus = FALSE;
			}
			else
				llOwnerSay(S_TYPING + "No animation");

		} else if ( _message == "ZHAO_TYPEAO_OFF" ) {
			// Turning off typing override
			sayOnOff(typingOverrideOn = FALSE, S_TYPING);
			setTimerEvent();
			if ( typingStatus && !typingKill ) {
				doType(curTypeAnim, FALSE);
				typingStatus = FALSE;
			}

		} else if ( _message == "ZHAO_TYPEKILL_ON" ) {
			// Turning on Typing killer
			sayOnOff(typingKill = TRUE, S_TKILL);
			typingStatus = FALSE;
			setTimerEvent();

		} else if ( _message == "ZHAO_TYPEKILL_OFF" ) {
			// Turning off Typing killer
			sayOnOff(typingStatus = typingKill = FALSE, S_TKILL);
			setTimerEvent();

		} else if ( _message == "ZHAO_RANDOMSTANDS" ) {
			// Cycling to next stand - sequential or random
			randomStands = TRUE;
			llOwnerSay( "Stand cycling: Random" );
		
		} else if ( _message == "ZHAO_SEQUENTIALSTANDS" ) {
			// Cycling to next stand - sequential or random
			randomStands = FALSE;
			llOwnerSay( "Stand cycling: Sequential" );
		
		} else if ( _message == "ZHAO_SETTINGS" ) {
			// Print settings
			sayOnOff(standOverride, S_STAND);
			sayOnOff(sitOverride, S_SIT);
			sayOnOff(sitAnywhereOn, S_SIT_AW);
			sayOnOff(typingOverrideOn, S_TYPING);
			sayOnOff(typingKill, S_TKILL);
			if ( randomStands == TRUE ) {
				llOwnerSay( "Stand cycling: Random" );
			} else {
				llOwnerSay( "Stand cycling: Sequential" );
			}
			llOwnerSay( "Stand cycle time: " + (string)standTime + " seconds" );

		} else if ( _message == "ZHAO_NEXTSTAND" ) {
			// Cycling to next stand - sequential or random. This is from UI, so we
			// want feedback
			doNextStand( TRUE );
		
		} else if ( llGetSubString(_message, 0, 14) == "ZHAO_STANDTIME|" ) {
			// Stand time change
			standTime = (integer)llGetSubString(_message, 15, -1);
			setTimerEvent();
			llOwnerSay( "Stand cycle time: " + (string)standTime + " seconds" );
		
		} else if ( llGetSubString(_message, 0, 9) == "ZHAO_LOAD|" ) {
			// Can't load while we're in the middle of a load
			if ( loadInProgress == TRUE ) {
				llOwnerSay( "Cannot load new notecard, still reading notecard '" + notecardName + "'" );
				return;
			}

			// Notecard menu
			loadInProgress = TRUE;
			notecardName = llGetSubString(_message, 10, -1);
			loadNoteCard();
		
		} else if ( _message == "ZHAO_SITS" ) {
			// Selecting new sit anim

			// Move these to a common function
			doMultiAnimMenu( sittingIndex, "Sitting", curSitAnim );

			listenState = 1;
		
		} else if ( _message == "ZHAO_WALKS" ) {
			// Same thing for the walk

			// Move these to a common function
			doMultiAnimMenu( walkingIndex, "Walking", curWalkAnim );

			listenState = 2;
		} else if ( _message == "ZHAO_GROUNDSITS" ) {
			// And the ground sit

			// Move these to a common function
			doMultiAnimMenu( sitgroundIndex, "Sitting On Ground", curGsitAnim );

			listenState = 3;
		}
	}

	listen( integer _channel, string _name, key _id, string _message) {
		// Turn listen off. We turn it on again if we need to present 
		// another menu
		llListenControl(listenHandle, FALSE);

		if ( listenState == 1 ) {
			doAnimSet("Sitting", curSitAnim = findMultiAnim(1, (integer)_message - 1));
			llOwnerSay("New sitting animation: " + curSitAnim);

		} else if ( listenState == 2 ) {
			doAnimSet("Walking", curWalkAnim = findMultiAnim(18, (integer)_message - 1));
			llOwnerSay("New walking animation: " + curWalkAnim);

		} else if ( listenState == 3 ) {
			doAnimSet("Sitting on Ground", curGsitAnim = findMultiAnim(0, (integer)_message - 1));
			if (sitAnywhereOn)
				doAnimSet("Standing", curGsitAnim);
			llOwnerSay("New groundsit animation: " + curGsitAnim);
		}
	}

	dataserver( key _query_id, string _data )
	{
		if ( _query_id != notecardLineKey )
			return;

		if ( _data == EOF )
		{
			// Now the read ends when we hit EOF

			// End-of-notecard handling...

			// See how many walks/sits/ground-sits we have
			checkMultiAnim(18, "walking");
			checkMultiAnim(1, "sitting");
			checkMultiAnim(0, "ground sitting");
			checkMultiAnim(20, "standing");

			// Reset stand, walk, sit and ground-sit anims to first entry
			curStandIndex = 0;
			numStands = llGetListLength(llParseString2List(llList2String(overrides, standingIndex), (list)SEPARATOR, [])); //FIX
			numTyping = llGetListLength(llParseString2List(llList2String(overrides, typingIndex), (list)SEPARATOR, []));

			curStandAnim = findMultiAnim(standingIndex, 0);
			curWalkAnim = findMultiAnim(walkingIndex, 0);
			curSitAnim = findMultiAnim(sittingIndex, 0);
			curGsitAnim = findMultiAnim(sitgroundIndex, 0);
			curTypeAnim = findMultiAnim(typingIndex, 0);

			endNotecardLoad();
			llOwnerSay("LSL Functions/AO loaded. Mem:" + (string)llGetFreeMemory());

			return;
		}

		// We ignore blank lines and lines which start with a #
		if (_data == EMPTY || llGetSubString(_data, 0, 0) == "#")
		{
			notecardLineKey = llGetNotecardLine(notecardName, ++notecardIndex);
			return;
		}
		
		// Let's get a token
		integer p = llSubStringIndex(_data, "[");
		string token = EMPTY;
		string anims = EMPTY;
		if (p != -1)
		{
			if ((p = llSubStringIndex(_data = llDeleteSubString(_data, 0, p), "]")) != -1)
			{
				token = llStringTrim(llGetSubString(_data, 0, p - 1), STRING_TRIM);
				anims = llStringTrim(llDeleteSubString(_data, 0, p), STRING_TRIM);
				if ((p = llListFindList(tokens, [token])) == -1)
				{
					llOwnerSay("AO:bad data on line " + (string)(notecardIndex+1) + " of " + notecardName + TRYAGAIN); // start from 1
					endNotecardLoad();
					return;
				}
			}
		}

		if (anims != EMPTY)
		{
			// See if this is a token for which we allow multiple animations
			if (llSubStringIndex(multiAnimTokenIndexes, "," + (string)p + ",") != -1)
			{  //FIX
				list anims2Add = llParseString2List(anims, (list)SEPARATOR, []); //FIX
				// Make sure the anims exist
				integer k = llGetListLength(anims2Add);
				while (k--)
					checkAnimInInventory(llList2String(anims2Add, k));

				// Join the string and list and put it back into overrides
				overrides = llListReplaceList(overrides, (list)(llList2String(overrides, p) + SEPARATOR + llDumpList2String(anims2Add, SEPARATOR)), p, p ); //FIX
			}
			else
			{
				// This is an animation for which we only allow one override
				if (llSubStringIndex(anims, SEPARATOR) != -1)
				{
					llOwnerSay("Multiple anims for " + token + " not allowed. " + TRYAGAIN);
					endNotecardLoad();
					return;
				}

				// Inventory check
				checkAnimInInventory(anims);

				// We're good
				overrides = llListReplaceList(overrides, (list)anims, p, p); //FIX
			}
			hasSwim = hasSwim || (p >= swimLowIndex && p <= swimHighIndex);
		}
		
		// Wow, after all that, we read one line of the notecard
		notecardLineKey = llGetNotecardLine(notecardName, ++notecardIndex);
	}

	timer() {
		vector cur = llGetPos();
		doWater(cur.z < llWater(ZERO_VECTOR));
		integer typingTemp = llGetAgentInfo(Owner) & AGENT_TYPING;
		if ((typingOverrideOn || typingKill) && typingTemp != typingStatus)
			typingOverride(typingStatus = typingTemp);
		if ( maxTicks ) {
			if (!(numTicks = (numTicks + 1) % maxTicks))
			{
				if (llGetAnimation(Owner) == "Standing")
				{
					if (typingTemp)
						numTicks--;
					else
						doNextStand(FALSE);
				}
			}
		}
	}
}