// LSL script generated: BuildHUD.lslp Sun Jan 24 18:17:24 Mitteleuropäische Zeit 2016



integer frontSide = 4;
integer topSide = 0;



// Need to put these into another module and include it so that we can just draw the textures
// into the new cubes once we've created it all :-) No sense in doing this here AND in the
// hud - as changing themes is going to be part of it all...

float changedZ = 1.44e-2;
float doubleHeight = 2.88e-2;
float fullWidth = 0.308;
vector gPrimSize = <1.44e-2,fullWidth,changedZ>;
vector gPrimMenus = <1.44e-2,fullWidth,doubleHeight>;

 
integer gPrimNumber = 0;
float gVerticalIndex = 0;
integer gWorking = FALSE;
vector black = <0.0,0.0,0.0>;
vector white = <1.0,1.0,1.0>;

// ## indicates a little prim (not sent to it's prim name) - every prim has a name
list primNames = ["Top","Mode","Half","Numbers","Menu prim","MenuItem:1","MenuItem:2,MenuName","MenuItem:3,MenuText:1","MenuItem:4,MenuText:2","MenuItem:5,MenuText:3","MenuItem:6,MenuText:4","MenuItem:7,MenuText:5","MenuItem:8,MenuText:6","MenuItem:9,MenuText:7","MenuItem:10,MenuText:8","MenuItem:11,MenuText:9","MenuItem:12,MenuText:10","MenuItem:13,MenuText:11","MenuItem:14,MenuText:12","MenuItem:15,MenuText:13","MenuItem:16,MenuText:14","MenuItem:17,MenuText:15","MenuItem:18,MenuText:16","MenuItem:19,MenuText:17","MenuItem:20,MenuText:18","MenuItem:21,MenuText:19","MenuItem:22,MenuText:20","MenuItem:23,MenuText:21","MenuItem:24,MenuText:22","MenuItem:25,MenuText:23","MenuItem:26,MenuText:24","MenuItem:27,MenuText:25","MenuItem:28,MenuText:26","MenuItem:29,MenuText:27","MenuItem:30,MenuText:28","MenuText:29,HScroll","MenuText:30,Scroll","None,HScroll"];

	// list of kinds of names - these are used to calculate the next prim position
	// Note - the above primNames have to all be on this list so that we know how to vertically adjust and the
	//        adjustment will be in the verticalIncNumbers
list nameIndex = ["Top","Mode","Numbers","Menu prim","MenuItem","MenuText","Scroll","None","Half"];
	
	// list of increment for vertical/horozontal so we can calculate where the prim should go
list verticalIncNumbers = [1.0,1.0,1.5,1.0,1.0,1.0,1.0,1.0,1.5];
	// List of adjustments for horozontal of a prim - mostly only the mode, menu#'s and admin as they are not full width...


	// List of the things we expect to find inside the building cube :-)
	// One we need to leave inside, the other to cleanup when we are done
list inventoryItems = ["~FS Theme Basic"];
list cleanupInventoryItems = ["Cube"];
integer cubeIndex = 0;


string texture = "~FS Theme Basic";
	// Name of the basic black and white themed texture


default {

    state_entry() {
        llSetText("Click me to build the DanceHUD prims...",white,1.0);
    }

 
    touch_start(integer num) {
        integer i;
        if (gWorking) return;
        if ((llDetectedKey(0) != llGetOwner())) return;
        for ((i = 0); (i < llGetListLength(inventoryItems)); (++i)) {
            if ((INVENTORY_NONE == llGetInventoryType(llList2String(inventoryItems,i)))) {
                llOwnerSay((("Error: I should contain an item called:" + llList2String(inventoryItems,i)) + " - add it and try again..."));
                return;
            }
        }
        for ((i = 0); (i < llGetListLength(cleanupInventoryItems)); (++i)) {
            if ((INVENTORY_NONE == llGetInventoryType(llList2String(cleanupInventoryItems,i)))) {
                llOwnerSay((("Error: I should contain an item called:" + llList2String(cleanupInventoryItems,i)) + " - add it and try again..."));
                return;
            }
        }
        llRequestPermissions(llGetOwner(),PERMISSION_CHANGE_LINKS);
    }

 
    run_time_permissions(integer perm) {
        if (gWorking) return;
        if ((perm & PERMISSION_CHANGE_LINKS)) {
            (gWorking = TRUE);
            llSetText("",white,1.0);
            llOwnerSay("Working on putting together the DanceHUD prims...");
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROTATION,ZERO_ROTATION,PRIM_SIZE,gPrimSize,PRIM_FULLBRIGHT,ALL_SIDES,FALSE,PRIM_COLOR,ALL_SIDES,black,0.0,PRIM_COLOR,frontSide,white,1.0,PRIM_TEXTURE,frontSide,texture,<1.0,2.5e-2,0.0>,<0.0,(-0.454),0.0>,0,PRIM_COLOR,topSide,white,1.0,PRIM_TEXTURE,topSide,texture,<1.0,2.5e-2,0.0>,<0.0,(-0.454),0.0>,(-PI_BY_TWO)]);
            llSetObjectName("Fleursoft DanceHUD OpenSource");
            llSetObjectDesc("");
            (gPrimNumber++);
            (gVerticalIndex = llList2Float(verticalIncNumbers,0));
            llRezObject(llList2String(cleanupInventoryItems,cubeIndex),llGetPos(),ZERO_VECTOR,ZERO_ROTATION,0);
        }
    }

 
    object_rez(key id) {
        string primName = llList2String(primNames,gPrimNumber);
        list names = llParseString2List(primName,[":",","],[]);
        integer i;
        vector adjustPos = <0.0,0.0,0.0>;
        integer index = llListFindList(nameIndex,[llList2String(names,0)]);
        if ((index == (-1))) {
            llOwnerSay((((("Programming error - the first prim name of prim " + ((string)gPrimNumber)) + " isn't on my list - sigh - add it. I found:'") + primName) + "'"));
        }
        (adjustPos.z = (((-1.0) * gVerticalIndex) * gPrimSize.z));
        float zChange = llList2Float(verticalIncNumbers,index);
        (gVerticalIndex += zChange);
        llCreateLink(id,LINK_ROOT);
        llSetLinkPrimitiveParamsFast(2,[PRIM_POSITION,adjustPos,PRIM_ROTATION,ZERO_ROTATION,PRIM_SIZE,gPrimSize,PRIM_FULLBRIGHT,ALL_SIDES,FALSE,PRIM_COLOR,ALL_SIDES,black,0.0,PRIM_COLOR,frontSide,black,1.0]);
        if (((-1) != llListFindList(names,["Scroll"]))) {
            llSetLinkPrimitiveParamsFast(2,[PRIM_TEXTURE,frontSide,texture,<1.0,2.5e-2,0.0>,<0.0,(-0.422),0.0>,0,PRIM_COLOR,frontSide,white,1.0]);
        }
        if (((-1) != llListFindList(names,["Numbers"]))) {
            llSetLinkPrimitiveParamsFast(2,[PRIM_TEXTURE,frontSide,texture,<1.0,5.0e-2,0.0>,<0.0,0.47,0.0>,0,PRIM_COLOR,frontSide,white,1.0,PRIM_SIZE,gPrimMenus]);
        }
        if (((-1) != llListFindList(names,["Mode"]))) {
            llSetLinkPrimitiveParamsFast(2,[PRIM_TEXTURE,frontSide,texture,<1.0,2.5e-2,0>,<0.0,(-0.328),0>,0,PRIM_COLOR,frontSide,white,1.0]);
        }
        llMessageLinked(2,123,primName,"");
        (gPrimNumber++);
        if ((gPrimNumber < llGetListLength(primNames))) {
            llRezObject(llList2String(cleanupInventoryItems,cubeIndex),llGetPos(),ZERO_VECTOR,ZERO_ROTATION,0);
        }
        else  {
            llOwnerSay("Cleaning up inventory...");
            for ((i = 0); (i < llGetListLength(cleanupInventoryItems)); (++i)) llRemoveInventory(llList2String(cleanupInventoryItems,i));
            llRemoveInventory(llGetScriptName());
            llOwnerSay("Created DanceHUD prims - ready to have scripts added :-)");
        }
    }
}
