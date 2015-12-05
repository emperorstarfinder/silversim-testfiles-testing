// PARAMOUR LINE-DANCE CONTROLLER v1.0
// by Mata Hari / Aine Caoimhe November 2014
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// *** THIS SCRIPT REQUIRES (AND WILL ONLY WORK) IN REGIONS WHERE THE SCRIPT OWNER HAS OSSL FUNCTION PERMISSIONS ***
// See Read Me notecard for instructions
//
// IMPORTANT! The set of country line dances that are included with this ARE NOT looped so you will need to set the dance timer to 28 seconds when
// using them (which is already set by default). If you replace these with looped dance animations instead you can change the default timer value
// in the script and/or the owner can change the timer at any time during use by touching the floor and picking a new time from the menu
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// SIMPLE USER SETTINGS - stuff that any user should feel comfortable setting
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
integer showFloatyText=TRUE;                    // TRUE = show floaty text, FALSE = hide it
string floatyTextName="Line Dance Floor";       // name to appear in floaty text above the line dance object
vector floatyTextColour=<1.000, 0.847, 0.200>;  // colour to use for the floaty text
string npcDancerFirstName="Line";               // first name to use for all NPC line dancers
string npcDancerLastName="Dancer";              // last name to use for all NPC line dancers
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// ADVANCED USER SETTINGS - a more advanced user might want to adjust these
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
list ignoreNotecards=["*** READ ME ***"];       // list of any notecards in inventory that are not NPC notecards
integer maxLineLength=5;                        // maximum number of dancers allowed in a single line
float spacingX=1.5;                             // distance between each dancer in the line (side to side)
float spacingY=-1.5;                            // when more than 1 line is needed, how far apart to space lines
vector p1Pos=<0.0, 0.0, -2.0>;                  // sit target position for 1st dancer - all other dancers positioned relative to this position (and centered on it)
rotation p1Rot=ZERO_ROTATION;                   // sit target rotation for 1st dancer - making this non-zero could produce unusual results!
integer randomOrder=FALSE;                      // TRUE = play dances in random order, FALSE = play in alphabetical order
float danceTimer=28.0;                          // how long (in seconds) to play each line dance by default before moving on to the next one (owner can also change this via dialog)
//
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING!!!!!
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
string baseAnim="*****base_DO NOT DELETE ME!";
list anims;
integer indexAn;
string currentAn;
list dancers;
string myState="OFF";
integer myChannel;
integer handle;
integer closeHandle;
list npcList;
integer npcToRez;

showMenu()
{
    myChannel=0x80000000 | (integer)("0x"+(string)llGetKey());
    string txtDia="What would you like to do?\n\nADD adds NPCs (give them time to rez before doing more!)\nKILL removes NPCs\nThe other set the autotimer value (28 seconds is for the non-looped country line dance set)\n\nPLEASE CLICK DONE WHEN FINISHED!";
    list butDia=["DONE","28 SEC","60 SEC","90 SEC","120 SEC","300 SEC","ADD 1","ADD 5","ADD 10","KILL 1","KILL 5","KILL ALL"];
    handle=llListen(myChannel,"",llGetOwner(),"");
    llDialog(llGetOwner(),txtDia,butDia,myChannel);
    closeHandle=TRUE;
}
positionDancers()
{
    dancers=[];
    integer link=llGetNumberOfPrims();
    while (link>0)
    {
        if (llGetAgentSize(llGetLinkKey(link))!=ZERO_VECTOR) dancers=[]+[llGetLinkKey(link),link]+dancers;
        link--;
    }
    integer i;
    integer l=llGetListLength(dancers);
    integer row;
    integer pos;
    integer thisLineCount;
    while (i<l)
    {
        vector thisPos=p1Pos;
        rotation thisRot=p1Rot;
        thisPos.y+=(pos*spacingX);
        thisPos.x+=(row*spacingY);
        llSetLinkPrimitiveParamsFast(llList2Integer(dancers,i+1),[PRIM_POS_LOCAL,thisPos,PRIM_ROT_LOCAL,thisRot]);
        thisLineCount++;
        if(thisLineCount>=maxLineLength)
        {
            thisLineCount=0;
            pos=0;
            if (row==0) row++;
            else if (row>0) row=row*-1;
            else row=(row*-1)+1;
        }
        else
        {
            if (pos==0) pos++;
            else if (pos>0) pos=pos*-1;
            else pos=(pos*-1)+1;
        }
        i+=2;
    }
}
startDancing(key who)
{
    key doNotStop=llGetInventoryKey(baseAnim);
    osAvatarPlayAnimation(who,baseAnim);
    list anToStop=llGetAnimationList(who);
    integer l=llGetListLength(anToStop);
    while (--l>=0) { if (llList2Key(anToStop,l)!=doNotStop) osAvatarStopAnimation(who,llList2Key(anToStop,l)); }
    osAvatarPlayAnimation(who,currentAn);
}
nextDance()
{
    indexAn++;
    if (indexAn>=llGetListLength(anims))
    {
        if (randomOrder) anims=[]+llListRandomize(anims,1);
        indexAn=0;
    }
    string nextDance=llList2String(anims,indexAn);
    // llOwnerSay("Starting "+nextDance+"\nStopping: "+currentAn);
    integer d=llGetListLength(dancers);
    integer i;
    while (i<d)
    {
        key who=llList2Key(dancers,i);
        osAvatarPlayAnimation(who,nextDance);
        osAvatarStopAnimation(who,currentAn);
        i+=2;
    }
    currentAn=nextDance;
    setText();
    positionDancers();
    llSetTimerEvent(danceTimer);
}
setText()
{
    string txt=floatyTextName;
    vector col=floatyTextColour;
    if (showFloatyText)
    {
        if (myState=="ERROR")
        {
            txt+="\nERROR - owner needs to fix and reset";
            col=<1.0,0,0>;
        }
        else if (myState=="READY") txt+="\n \nSit on the floor to start dancing";
        else txt+="\n \nSit on the floor to join the line dance\nNow playing dance "+(string)(indexAn+1)+" of "+(string)llGetListLength(anims);
    }
    else txt="";
    llSetText(txt,col,1.0);
}
buildAnimList()
{
    anims=[];
    integer l=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--l>=0) { if (llGetInventoryName(INVENTORY_ANIMATION,l)!=baseAnim) anims=[]+[llGetInventoryName(INVENTORY_ANIMATION,l)]+anims; }
    if (llGetListLength(anims)==0)
    {
        llOwnerSay("ERROR! No dance animations in inventory!");
        myState="ERROR";
    }
    else if (llGetListLength(anims)>1)
    {
        if (randomOrder) anims=[]+llListRandomize(anims,1);
        else anims=[]+llListSort(anims,1,TRUE);
    }
    indexAn=-1;
}
rezNpc()
{
    if (npcToRez>0)
    {
        string npcCard;
        integer found;
        while (!found)
        {
            npcCard=llGetInventoryName(INVENTORY_NOTECARD,llFloor(llFrand(llGetInventoryNumber(INVENTORY_NOTECARD))));
            if (llListFindList(ignoreNotecards,[npcCard])==-1) found=TRUE;
        }
        key npc=osNpcCreate(npcDancerFirstName,npcDancerLastName,llGetPos(),npcCard);
        osNpcSit(npc,llGetKey(),OS_NPC_SIT_NOW);
        npcList=[]+npcList+[npc];
        npcToRez--;
    }
    else
    {
        llSensorRemove();
        showMenu();
    }
}
default
{
    state_entry()
    {
        llSetSitText("DANCE");
        llSitTarget(<0.0,0.0,0.0001>,ZERO_ROTATION);
        if (llGetInventoryType(baseAnim)!=INVENTORY_ANIMATION)
        {
            llOwnerSay("ERROR! Unable to locate the base animation which MUST be in the ball.");
            myState="ERROR";
        }
        buildAnimList();
        if (myState!="ERROR")
        {
            myState="READY";
            dancers=[];
            indexAn=0;
            currentAn=llList2String(anims,indexAn);
        }
        setText();
    }
    timer()
    {
        if(closeHandle)
        {
            closeHandle++;
            if (closeHandle>2)
            {
                closeHandle=0;
                llOwnerSay("Dialog has timed out...touch me again to re-active the dialog menu");
                llListenRemove(handle);
            }
        }
        if (myState=="ON") nextDance();
        else llSetTimerEvent(0.0);
    }
    on_rez (integer foo)
    {
        llResetScript();
    }
    sensor(integer num)
    {
        llOwnerSay("Seriously? The sensor returned true?!");
        llSensorRemove();
        showMenu();
    }
    no_sensor()
    {
        rezNpc();
    }
    changed (integer change)
    {
        if (change & CHANGED_REGION_START) llResetScript();
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_LINK)
        {
            list newDancers;
            integer link=llGetNumberOfPrims();
            while (link>0)
            {
                if (llGetAgentSize(llGetLinkKey(link))!=ZERO_VECTOR) newDancers=[]+newDancers+[llGetLinkKey(link),link];
                link--;
            }
            integer l=llGetListLength(dancers);
            integer i;
            while (i<l)
            {
                key who=llList2Key(dancers,i);
                integer ind=llListFindList(newDancers,[who]);
                if (ind>=0)
                {
                    dancers=[]+llListReplaceList(dancers,[llList2Integer(newDancers,ind+1)],i+1,i+1);
                    newDancers=[]+llDeleteSubList(newDancers,ind,ind+1);
                }
                else
                {
                    osAvatarPlayAnimation(who,"stand");
                    osAvatarStopAnimation(who,currentAn);
                    osAvatarStopAnimation(who,baseAnim);
                    dancers=[]+llDeleteSubList(dancers,i,i+1);
                }
                i+=2;
            }
            l=llGetListLength(newDancers);
            i=0;
            while (i<l)
            {
                startDancing(llList2Key(newDancers,i));
                i+=2;
            }
            dancers=[]+dancers+newDancers;
            if (llGetListLength(dancers)==0)
            {
                myState="READY";
                llSetTimerEvent(0.0);
                setText();
            }
            else
            {
                if (myState=="READY") myState="ON";
                nextDance();    // have to advance dance to keep them all synched and to trigger positioning
            }
        }
    }
    touch_start(integer num)
    {
        if (llDetectedKey(0)==llGetOwner()) showMenu();
    }
    listen(integer channel, string name, key who, string message)
    {
        llListenRemove(handle);
        closeHandle=FALSE;
        if (message=="DONE") return;
        else if (llSubStringIndex(message," SEC")>=0)
        {
            danceTimer=(float)(llGetSubString(message,0,llSubStringIndex(message," MIN")-1));
            llOwnerSay("Dance timer now set to "+message);
            if (myState=="ON")
            {
                llSetTimerEvent(danceTimer);
                nextDance();
            }
            showMenu();
        }
        else if (llSubStringIndex(message,"ADD")>=0)
        {
            if (llGetInventoryNumber(INVENTORY_NOTECARD)<1)
            {
                llOwnerSay("I can't find any NPC notecards to use!");
                showMenu();
            }
            else
            {
                npcToRez=(integer)(llGetSubString(message,4,-1));
                llSensorRepeat("THIS_SENSOR_SHOULD_NEVER_RETURN_TRUE","",0,2.0,PI,2.0);
                rezNpc();
            }
        }
        else
        {
            integer npcToKill;
            if (message=="KILL ALL") npcToKill=llGetListLength(npcList);
            else npcToKill=(integer)(llGetSubString(message,-1,-1));
            integer killed;
            while((killed<npcToKill) && (llGetListLength(npcList)>0))
            {
                osNpcRemove(llList2Key(npcList,-1));
                npcList=[]+llDeleteSubList(npcList,-1,-1);
                killed++;
            }
            showMenu();
        }
    }
}