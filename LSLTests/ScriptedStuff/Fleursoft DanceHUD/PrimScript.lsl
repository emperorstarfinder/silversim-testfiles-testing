// LSL script generated: PrimScript.lslp Sun Jan 24 18:17:24 Mitteleuropäische Zeit 2016

// Put this script inside the cube that will be rez'd by the parent
// So - create a cube - put this inside and then put this inside the 'creator cube'

// We use this to simply set the name of the object which we will link in

default {

	link_message(integer sender,integer number,string msg,key id) {
        llSetObjectName(msg);
        llRemoveInventory(llGetScriptName());
    }
}
