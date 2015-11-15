///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: Button Handler OnOff.lsl 4 2007-02-03 18:13:52Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

string onTexture = "on";
string offTexture = "off";

integer myState;

integer loadInProgress = FALSE;					// Are we currently loading a notecard
integer listenState = 0;						// What pop-up menu we're handling now
integer listenHandle;							// Listen handlers - only used for pop-up menu, then turned off
string notice = "";								// Text to display if no animations were configured or list animations
string curAnim = "";

// Listen channel for pop-up menu
integer listenChannel = -91234;

list listenStates = ["Load Notecard", "Set Sit", "Set Walk", "Set GroundSit"];

default
{
	state_entry()
	{
		llSetTexture(onTexture, 4);

		myState = TRUE;
		llMessageLinked(LINK_ROOT, 0, "On", NULL_KEY);
	}

	touch_start(integer total_number)
	{
		if (llDetectedKey(0) != llGetOwner()){return;}
		if(myState)
		{
			myState = FALSE;
			llMessageLinked(LINK_ROOT, 0, "Off", NULL_KEY);
		}
		else
		{
			myState = TRUE;
			llSetScriptState("ZHAOII Main Animation Overrider", TRUE);
			llSetScriptState("Cache", TRUE);
			llMessageLinked(LINK_ROOT, -1, "On", NULL_KEY);
		}
	}

	listen(integer channel, string name, key id, string message)
	{
		llListenRemove(listenHandle);
		listenHandle = 0;
		llMessageLinked(LINK_ROOT, -1, llList2String(listenStates, listenState - 1), (key)message);
	}

	link_message(integer sender, integer num, string message, key id)
	{
		if (message == "On"){llSetTexture(onTexture, 4);}
		else if (message == "Off"){llSetTexture(offTexture, 4);}
		else if(message == "Load")
		{
			// Can't load while we're in the middle of a load
			if(loadInProgress == TRUE){llOwnerSay( "Cannot load new notecard, still reading notecard." );return;}

			integer n = llGetInventoryNumber( INVENTORY_NOTECARD );
			// Can only have 12 buttons in a dialog box
			if(n > 12){llOwnerSay("You cannot have more than 12 animation notecards.");return;}

			integer i;
			list animSets = [];

			// Build a list of notecard names and present them in a dialog box
			for(i = 0; i < n; i++){animSets += [llGetInventoryName(INVENTORY_NOTECARD, i)];}

			if(listenHandle){llListenRemove(listenHandle);}
			listenHandle = llListen(listenChannel, "", llGetOwner(), "");
			llDialog(llGetOwner(), "Select the notecard to load:", animSets, listenChannel);
			listenState = 1;
		}
		else if(message == "Set Loading")
		{
			loadInProgress = num;
		}
		// Selecting new sit anim
		else if(message == "Dialog Sit")
		{
			if(listenHandle){llListenRemove(listenHandle);}
			listenHandle = llListen(listenChannel, "", llGetOwner(), "");

			// Dialog enhancement - Fennec Wind
			list dlgAnimNames = []; // List of found animation names
			list overrides = llCSV2List((string)id);
			integer tot = llGetListLength(overrides);
			integer i;
			string dlgAnimName;

			// Cycle through animations and retrive the ones we need
			for(i = 0; i < tot; i++)
			{
				dlgAnimName = llList2String(overrides, i);
				if(dlgAnimName != "")
				{
					if(llStringLength(dlgAnimName) > 24){dlgAnimName = llGetSubString(dlgAnimName, 0, 23);}
					dlgAnimNames = (dlgAnimNames = []) + dlgAnimNames + dlgAnimName;
				}
			}
			// If no animations were configured, say so and just display an "OK" button
			if(llGetListLength(dlgAnimNames) == 0)
			{
				notice = "No overrides have been configured.";
			}
			else
			{
				notice = "Animation List:\n"+llDumpList2String(dlgAnimNames, "\n");
			}
			if((curAnim = llList2String(overrides, num)) == ""){curAnim = "System Default";}
            llDialog(llGetOwner(), "Select the sit animation to use:\n\nCurrently: "+curAnim+"\n\n"+notice, dlgAnimNames, listenChannel);
			dlgAnimName = ""; dlgAnimNames = []; notice = "";
            listenState = 2;
        }
		// Selecting new walk anim
		else if(message == "Dialog Walk")
		{
			if(listenHandle){llListenRemove(listenHandle);}
			listenHandle = llListen(listenChannel, "", llGetOwner(), "");

			// Dialog enhancement - Fennec Wind
			list dlgAnimNames = []; // List of found animation names
			list overrides = llCSV2List((string)id);
			integer tot = llGetListLength(overrides);
			integer i;
			string dlgAnimName;

			// Cycle through animations and retrive the ones we need
			for(i = 0; i < tot; i++)
			{
				dlgAnimName = llList2String(overrides, i);
				if(dlgAnimName != "")
				{
					if(llStringLength(dlgAnimName) > 24){dlgAnimName = llGetSubString(dlgAnimName, 0, 23);}
					dlgAnimNames = (dlgAnimNames = []) + dlgAnimNames + dlgAnimName;
				}
			}
			// If no animations were configured, say so and just display an "OK" button
			if(llGetListLength(dlgAnimNames) == 0)
			{
				notice = "No overrides have been configured.";
			}
			else
			{
				notice = "Animation List:\n"+llDumpList2String(dlgAnimNames, "\n");
			}
			if((curAnim = llList2String(overrides, num)) == ""){curAnim = "System Default";}
            llDialog(llGetOwner(), "Select the walk animation to use:\n\nCurrently: "+curAnim+"\n\n"+notice, dlgAnimNames, listenChannel);
			dlgAnimName = ""; dlgAnimNames = []; notice = "";
            listenState = 3;
        }
		// Selecting new ground sit anim
		else if(message == "Dialog GroundSit")
		{
			if(listenHandle){llListenRemove(listenHandle);}
			listenHandle = llListen(listenChannel, "", llGetOwner(), "");

			// Dialog enhancement - Fennec Wind
			list dlgAnimNames = []; // List of found animation names
			list overrides = llCSV2List((string)id);
			integer tot = llGetListLength(overrides);
			integer i;
			string dlgAnimName;

			// Cycle through animations and retrive the ones we need
			for(i = 0; i < tot; i++)
			{
				dlgAnimName = llList2String(overrides, i);
				if(dlgAnimName != "")
				{
					if(llStringLength(dlgAnimName) > 24){dlgAnimName = llGetSubString(dlgAnimName, 0, 23);}
					dlgAnimNames = (dlgAnimNames = []) + dlgAnimNames + dlgAnimName;
				}
			}
			// If no animations were configured, say so and just display an "OK" button
			if(llGetListLength(dlgAnimNames) == 0)
			{
				notice = "No overrides have been configured.";
			}
			else
			{
				notice = "Animation List:\n"+llDumpList2String(dlgAnimNames, "\n");
			}
			if((curAnim = llList2String(overrides, num)) == ""){curAnim = "System Default";}
            llDialog(llGetOwner(), "Select the ground sit animation to use:\n\nCurrently: "+curAnim+"\n\n"+notice, dlgAnimNames, listenChannel);
			dlgAnimName = ""; dlgAnimNames = []; notice = "";
            listenState = 4;
        }
	}
}
