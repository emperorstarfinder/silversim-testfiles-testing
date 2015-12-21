// PARAMOUR CLUBMASTER DANCE CONTROLLER (OSSL) V1.2
// by Mata Hari / Aine Caoimhe Sept 2014 / Oct 2014
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// *** THIS SCRIPT REQUIRES (AND WILL ONLY WORK) IN REGIONS WHERE THE SCRIPT OWNER HAS OSSL FUNCTION PERMISSIONS ***
// See Read Me notecard for instructions
//
// ******************************************************************************
// *                        BASIC USER VARIABLES                                *
// ******************************************************************************
// this section contains settings that you may wish to change for your use and requires little or no scripting knowledge
integer showFloatyText=TRUE;                            // TRUE allows text to be displayed or FALSE to hide all floaty text during operation
string floatyText="Paramour Clubmaster Dance Machine\nsingles - couples - NPC couples";  // text above the main dance controller (\n is a new line)
vector floatyTextColour=<0.941, 0.847, 0.459>;          // colour of the text above the main controller <R,G,B> where <0,0,0> is black, <1,1,1> is white
integer randomizeSinglesOrder=TRUE;                     // when initializing, randomize the order of the dances within each singles dance style (style order is always displayed alphabetical) TRUE= yes, FALSE = no
float autoTimer=120.0;                                  // for singles dances and couples in auto mode, how often (in seconds) to advance to the next animation
float zStep=0.01;                                       // when couples zAdjust is enabled, vertical adjustment (in m) to make for the avatar with each press of the page up/page down keys
float rpm=4.0;                                          // how rapidly to rotate the controller on its axis (in revolutions per minute) 0.0 disables rotation completely
//
// ******************************************************************************
// *                       ADVANCED USER VARIABLES                              *
// ******************************************************************************
// this section contains settings for slightly more advanced users but doesn't require much expertise
string singlesNotecard="~Singles Data";                 // name of the notecard containing all of the singles dances data
string animNotecard="~Couples Data";                    // name of the notecard containing all of the couples dances data
list anDefault=["DEFAULT_STAND_WAITING","Waiting to Dance","Stand_f",<-0.3,-0.3,0>,<0,0,90>,"Stand_m",<0.3,0.3,0>,<0,0,-90>]; // default stand animation and positions when waiting for a partner or inital couples dance selection
integer ballTimeout=30;                                 // seconds until a couples ball should self-destruct (pass to ball as on-rez) -- must be INTEGER type since it is compared to a UNIX timestamp
string poseballName="~club poseball";                   // name of the poseball to rez from inventory for couples - update if you rename the poseball for any reason
list partnerM=[                                         // list of appearance notecards to randomly select from if the empty poseball is the blue "male" one (if only one supplied it will always be used)
                "~~~CE male1","~~~CE male2","~~~CE male3","~~~CE male4","~~~CE male5"
                ];                                      
list firstNameM=[                                       // list of first names to randomly choose from for the male NPC (if only one name is supplied it will always be used)
                "Hedonism"
                ];
list lastNameM=[                                        // list of last names to randomly choose from for the male NPC  (if only one name is supplied it will always be used)
                "Dancer"
                ];
list partnerF=[                                         // list of appearance notecards to randomly select from if the empty poseball is the pink "female" one (if only one supplied it will always be used)
                "~~~CE female1","~~~CE female2","~~~CE female3","~~~CE female4","~~~CE female5","~~~CE female6","~~~CE female7","~~~CE female8"
                ];
list firstNameF=[                                       // list of first names to randomly choose from for the female NPC (if only one name is supplied it will always be used)
                "Hedonism"
                ];
list lastNameF=[                                        // list of last names to randomly choose from for the female NPC  (if only one name is supplied it will always be used)
                "Dancer"
                ];
integer enableParticles=TRUE;                           // enable particle effects for the main controller and poseballs - FALSE if you move scripts to different controller object and/or use different poseballs that shouldn't use them
vector sparkleStartColour=<1.0,0.2,0.2>;                // for main controller particle effect - start colour of sparkles
vector sparkleEndColour=<0.941, 0.847, 0.459>;          // for main controller particle effect - end colour of sparkles
float sparkleBurstSpeed=6.25;                           // for main controller particle effect - this affects how far out from center the sparkles go
integer sparkleBurstCount=7;                            // for main controller particle effect - number of particles per burst
// ******************************************************************************
// * DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING! *
// ******************************************************************************
integer debug=FALSE;
list anData=[]; list styles=[]; integer anStride=8;
list dancers=[];
integer dancerStride=15; integer B1USER=0; integer B1ID=1; integer B1AN=2; integer B1POS=3; integer B1ROT=4; integer B2USER=5; integer B2ID=6; integer B2AN=7; integer B2POS=8; integer B2ROT=9; integer BASEPOS=10; integer SWAPFLAG=11; integer STYLE=12; integer ANNAME=13; integer AUTO=14;
integer nextBallID; list ballRezFor;
list singlesDances;
list currentDances;
list singlesUsers;
list singlesStyles; string singlesStyleCount; string singlesDanceCount; string couplesDanceCount;
integer handle; integer myChannel; string txtDia; list butDia;
string myState;
integer tickCouples=TRUE;
showSinglesMenu(key who)
{
    txtDia="Pick a singles dance style to use\nQUIT to stop dancing";
    string curStyle=llList2String(singlesUsers,llListFindList(singlesUsers,[who])+1);
    if (curStyle!="NO_STYLE_SELECTED") txtDia+="\n\nYour current style is: "+curStyle;
    butDia=[]+singlesStyles+["QUIT"];
    llDialog(who,txtDia,butDia,myChannel);
}
startSingles(key who, string currentSinglesStyle)
{
        list anToStop=llGetAnimationList(who);
        osAvatarPlayAnimation(who,llList2String(currentDances,llListFindList(currentDances,llList2String(singlesUsers,llListFindList(singlesUsers,[who])+1))+1));
        integer a=llGetListLength(anToStop);
        while(--a>=0)
        {
            osAvatarStopAnimation(who,llList2String(anToStop,a));
        }
        updateText();
}
nextSingles(key who, string currentSinglesStyle)
{
    string curD=llList2String(currentDances,llListFindList(currentDances,[currentSinglesStyle])+1);
    string nextD=llList2String(currentDances,llListFindList(currentDances,[currentSinglesStyle])+2);
    if(curD!=nextD)
    {
        osAvatarPlayAnimation(who,nextD);
        osAvatarStopAnimation(who,curD);
    }
}
stopSingles(key who, string currentSinglesStyle)
{
    osAvatarPlayAnimation(who,"Stand");
    osAvatarStopAnimation(who,llList2String(currentDances,llListFindList(currentDances,[currentSinglesStyle])+1));
}
persistCurrent(integer anToUpdate)
{
    list ball1Params=osGetPrimitiveParams(llList2Key(dancers,B1ID),[PRIM_POSITION,PRIM_ROTATION]);
    list ball2Params=osGetPrimitiveParams(llList2Key(dancers,B2ID),[PRIM_POSITION,PRIM_ROTATION]);
    list newBall1AnData=llParseString2List(regToRel(llList2Vector(dancers,BASEPOS),ZERO_ROTATION,llList2Vector(ball1Params,0),llList2Rot(ball1Params,1)),["|"],[]);
    list newBall2AnData=llParseString2List(regToRel(llList2Vector(dancers,BASEPOS),ZERO_ROTATION,llList2Vector(ball2Params,0),llList2Rot(ball2Params,1)),["|"],[]);
    list newAnEntry=llList2List(anData,anToUpdate,anToUpdate+2)+newBall1AnData+[llList2String(anData,anToUpdate+5)]+newBall2AnData;
    anData=[]+llListReplaceList(anData,newAnEntry,anToUpdate,anToUpdate+anStride-1);
}
saveNotecard()
{
    integer l=llGetListLength(anData);
    if (l<anStride)
    {
        llOwnerSay("ERROR! Save notecard called with no animation data in memory. Aborting save.");
        return;
    }
    llRemoveInventory(animNotecard);
    llSleep(0.2);
    integer i;
    string data="";
    while (i<l)
    {
        data+=llDumpList2String(llList2List(anData,i,i+anStride-1),"|")+"\n";
        i+=anStride;
    }
    osMakeNotecard(animNotecard,data);
    llOwnerSay("The new data has been stored to your notecard");
}
doSynch(key who)
{
    integer i=getPairIndex(who);
    osAvatarStopAnimation(llList2Key(dancers,i+B1USER),llList2String(dancers,i+B1AN));
    osAvatarPlayAnimation(llList2Key(dancers,i+B1USER),llList2String(dancers,i+B1AN));
    osAvatarStopAnimation(llList2Key(dancers,i+B2USER),llList2String(dancers,i+B2AN));
    osAvatarPlayAnimation(llList2Key(dancers,i+B2USER),llList2String(dancers,i+B2AN));
}
showMain(key who)
{
    txtDia="Please select a dance style\nor SYNCH to resynch current dance";
    if (llList2Integer(dancers,getPairIndex(who)+AUTO))
    {
        butDia=[]+["MANUAL","SYNCH","QUIT"]+llList2List(styles,6,8)+llList2List(styles,3,5)+llList2List(styles,0,2);
        txtDia+="\nor MANUAL to return to manual dance selection mode";
    }
    else
    {
        butDia=[]+["AUTO","SYNCH","QUIT"]+llList2List(styles,6,8)+llList2List(styles,3,5)+llList2List(styles,0,2);
        txtDia+="\nor AUTO to enter auto dance mode";
    }
    llDialog(who,txtDia,butDia,myChannel);
}
showPickAn(key who, string styleName)
{
    txtDia="Pick an animation to play or...\nSTYLES to select a different style\nSYNCH to resynch animation\nOPTIONS to access options menu";
    list ans=[];
    integer i=llListFindList(anData,[styleName]);
    while(llList2String(anData,i)==styleName)
    {
        ans=[]+ans+[llList2String(anData,i+1)];
        i+=anStride;
    }
    while (llGetListLength(ans)<9)
    {
        ans=[]+ans+["~"];
    }
    butDia=[]+["STYLES","SYNCH","OPTIONS"]+llList2List(ans,6,8)+llList2List(ans,3,5)+llList2List(ans,0,2);
    llDialog(who,txtDia,butDia,myChannel);
}
showOptions(key who)
{
    if (myState=="READY")
    {
        txtDia="Please select an action:\n\nBACK to return to previous menu\nSWAP positions with partner\nAUTO to change dances automatically\nMANUAL to go back to manual\n"
                +"Z ADJUST to turn on height adjust\nZ STOP ADJ to turn it off\nZ RESET to revert to default position\nNEW M and NEW F will randomly select another male or female NPC dance partner";
        butDia=[]+["BACK","SWAP"];
        if (llList2Integer(dancers,getPairIndex(who)+AUTO)) butDia=[]+butDia+["MANUAL","Z ADJUST","Z STOP ADJ","Z RESET","NEW M","NEW F"];
        else butDia=[]+butDia+["AUTO","Z ADJUST","Z STOP ADJ","Z RESET","NEW M","NEW F"];
        if (who==llGetOwner())
        {
            if((llGetListLength(dancers)>dancerStride)||(llGetListLength(singlesUsers)>0)) txtDia+="\nCannot enter edit mode when there are other couples or singles dancers using the machine";
            else
            {
                txtDia+="\nEDIT ON enters edit mode (only works when owner and partner are the only users";
                butDia=[]+butDia+["EDIT ON"];
            }
        }
        else butDia=[]+butDia+["-"];
    }
    else if (myState=="EDIT")
    {
        txtDia="EDIT MODE\nEDIT OFF exit edit mode (does not save to card)\nSAVE changes to notecard\nREVERT this animation to stored value\n"
                +"SYNCH to resynch animation\nNEXT/PREV to change to next/previous animation (stores changes locally but not to notecard)";
        butDia=[]+["EDIT OFF","SAVE","REVERT","< PREV","SYNCH","NEXT >"];
    }
    else
    {
        llOwnerSay("ERROR! Attempting to show options menu but state was "+myState);
        return;
    }
    llDialog(who,txtDia,butDia,myChannel);
}
playAnimation(integer pairIndex, integer nextAnIndex)
{
    list thisCouple=llList2List(dancers,pairIndex,pairIndex+dancerStride-1);
    list nextAnData=llList2List(anData,nextAnIndex,nextAnIndex+anStride-1);
    list nextCouple=llList2List(thisCouple,B1USER,B1ID);
    if (llList2Integer(thisCouple,SWAPFLAG)==1) nextCouple+=llList2List(nextAnData,5,7)+llList2List(thisCouple,B2USER,B2ID)+llList2List(nextAnData,2,4)
                                                            +llList2List(thisCouple,BASEPOS,SWAPFLAG)+llList2List(nextAnData,0,1)+llList2List(thisCouple,AUTO,AUTO);
    else                                        nextCouple+=llList2List(nextAnData,2,4)+llList2List(thisCouple,B2USER,B2ID)+llList2List(nextAnData,5,7)
                                                            +llList2List(thisCouple,BASEPOS,SWAPFLAG)+llList2List(nextAnData,0,1)+llList2List(thisCouple,AUTO,AUTO);
    dancers=[]+llListReplaceList(dancers,nextCouple,pairIndex,pairIndex+dancerStride-1);
    if (osIsUUID(llList2Key(nextCouple,B1USER))&& osIsUUID(llList2Key(nextCouple,B2USER))&& osIsUUID(llList2Key(nextCouple,B1ID))&& osIsUUID(llList2Key(nextCouple,B2ID)))
    {
        osMessageObject(llList2Key(nextCouple,B1ID),"MOVE_BALL|"+relToReg(llList2Vector(nextCouple,BASEPOS),ZERO_ROTATION,llList2Vector(nextCouple,B1POS),llList2Vector(nextCouple,B1ROT)));
        osMessageObject(llList2Key(nextCouple,B2ID),"MOVE_BALL|"+relToReg(llList2Vector(nextCouple,BASEPOS),ZERO_ROTATION,llList2Vector(nextCouple,B2POS),llList2Vector(nextCouple,B2ROT)));
        osAvatarStopAnimation(llList2Key(thisCouple,B1USER),llList2String(thisCouple,B1AN));
        osAvatarStopAnimation(llList2Key(thisCouple,B2USER),llList2String(thisCouple,B2AN));
        osAvatarPlayAnimation(llList2Key(nextCouple,B1USER),llList2String(nextCouple,B1AN));
        osAvatarPlayAnimation(llList2Key(nextCouple,B2USER),llList2String(nextCouple,B2AN));
    }
    else
    {
        key keyToMessage=llList2Key(nextCouple,B1USER);
        if (!osIsUUID(keyToMessage)) keyToMessage=llList2Key(nextCouple,B2USER);
        if (osIsUUID(keyToMessage)) llRegionSayTo(keyToMessage,0,"Your animation selection won't begin to play until you have a seated partner but it has been stored.");
    }
}
integer getPairIndex(string find)
{
    return dancerStride*llFloor((float)llListFindList(dancers,[find])/(float)dancerStride);
}
string regToRel(vector basePos, rotation baseRot, vector regionPos,rotation regionRot)
{
    vector refPos=(regionPos - basePos) / baseRot;
    vector refRot=llRot2Euler((rotation)regionRot/ baseRot)*RAD_TO_DEG;
    string strToReturn="<"+trimF(refPos.x)+","+trimF(refPos.y)+","+trimF(refPos.z)+">"
                    +"|<"+trimF(refRot.x)+","+trimF(refRot.y)+","+trimF(refRot.z)+">";
    return strToReturn;
}
string relToReg(vector basePos, rotation baseRot, vector refPos,vector refRot)
{
    vector regionPos=refPos*baseRot+basePos;
    rotation regionRot=llEuler2Rot(refRot*DEG_TO_RAD)*baseRot;
    return ((string)regionPos+"|"+(string)regionRot);
}
string trimF(float value)
{
    integer newVal=llRound(value*10000);
    integer negFlag=FALSE;
    if (newVal<0)
    {
        negFlag=TRUE;
        newVal*=-1;
    }
    integer strLength;
    string retStr;
    if (newVal==0) retStr="0";
    else if (newVal<10) retStr="0.000"+(string)newVal;
    else if (newVal<100) retStr="0.00"+(string)newVal;
    else if (newVal<1000) retStr="0.0"+(string)newVal;
    else if (newVal<10000) retStr="0."+(string)newVal;
    else
    {
        retStr=(string)newVal;
        strLength=llStringLength(retStr);
        retStr=llGetSubString(retStr,0,strLength-5)+"."+llGetSubString(retStr,strLength-4,strLength-1);
    }
    while (llGetSubString(retStr,strLength,strLength)=="0")
    {
        retStr=llGetSubString(retStr,0,strLength-1);
        strLength-=1;
    }
    if (negFlag) retStr="-"+retStr;
    return retStr;
}
showFirst(key who)
{
    txtDia="How would you like to dance?\n\nSINGLES - singles (group)\nCOUPLES - dance with a friend\nNPC COUPLES - dance with an NPC\nOOPS I don't want to dance";
    butDia=["SINGLES","COUPLES","NPC COUPLES","OOPS"];
    llDialog(who,txtDia,butDia,myChannel);
}
doInitialize()
{
    if(llGetInventoryType(poseballName)!=INVENTORY_OBJECT)
    {
        llOwnerSay("ERROR! Unable to find the poseball "+poseballName+" in inventory");
        myState="ERROR";
    }
    if (llGetInventoryType(animNotecard)!=INVENTORY_NOTECARD)
    {
        llOwnerSay("ERROR! Unable to find the animation data notecard");
        myState="ERROR";
        return;
    }
    string cardData=osGetNotecard(animNotecard);
    anData=[]+llParseString2List(cardData,["|","\n"],[]);
    if (llGetInventoryType(singlesNotecard)!=INVENTORY_NOTECARD)
    {
        llOwnerSay("ERROR! Unable to find the single data data notecard");
        myState="ERROR";
        return;
    }
    cardData=""+osGetNotecard(singlesNotecard);
    singlesDances=[]+llParseString2List(cardData,["|","\n"],[]);
    integer i;
    integer l=llGetListLength(singlesDances);
    singlesStyles=[];
    while(i<l)
    {
        singlesDances=[]+llListReplaceList(singlesDances,[llStringTrim(llList2String(singlesDances,i),STRING_TRIM)],i,i);
        singlesDances=[]+llListReplaceList(singlesDances,[llStringTrim(llList2String(singlesDances,i+1),STRING_TRIM)],i+1,i+1);
        if (llListFindList(singlesStyles,[llList2String(singlesDances,i)])<0) singlesStyles=[]+singlesStyles+llList2String(singlesDances,i);
        i+=2;
    }
    if (randomizeSinglesOrder) singlesDances=[]+llListRandomize(singlesDances,2);
    singlesDances=[]+llListSort(singlesDances,2,TRUE);
    singlesStyleCount=(string)llGetListLength(singlesStyles);
    singlesDanceCount=(string)(llGetListLength(singlesDances)/2);
    i=0;
    l=llGetListLength(singlesStyles);
    currentDances=[];
    while (i<l)
    {
        if(llListFindList(currentDances,[llList2String(singlesStyles,i)])<0)
        {
            integer f=llListFindList(singlesDances,[llList2String(singlesStyles,i)]);
            currentDances=[]+currentDances+llList2List(singlesDances,f,f+1);
            if (llList2String(singlesDances,f+2)==llList2String(singlesDances,f)) currentDances=[]+currentDances+[llList2String(singlesDances,f+3)];
            else currentDances=[]+currentDances+[llList2String(singlesDances,f+1)];
        }
        i++;
    }
    while (llGetListLength(singlesStyles)<11)
    {
        singlesStyles=[]+singlesStyles+["*"];
    }
    if (llGetListLength(singlesStyles)>11)  llOwnerSay("WARNING! Found "+(string)(llGetListLength(singlesStyles))+" different singles dance styles but only the first 11 can be shown. Please correct this (but this is a non-fatal error so the dance machine will still work)");
    while (llListFindList(singlesStyles,["*","*","*"])>=0)
    {
        singlesStyles=[]+llDeleteSubList(singlesStyles,llListFindList(singlesStyles,["*","*","*"]),llListFindList(singlesStyles,["*","*","*"])+2);
    }
    i=0;
    l=llGetListLength(singlesDances);
    while(i<l)
    {
        if (llListFindList(singlesStyles,[llList2String(singlesDances,i+1)])>=0)
        {
            llOwnerSay("ERROR! A singles dance animation name is in conflict with one of the singles styles names. Style names must be unique! Please correct this and restart.");
            myState="ERROR";
            return;
        }
        if (llGetInventoryType(llList2String(singlesDances,i+1))!=INVENTORY_ANIMATION)
        {
            llOwnerSay("ERROR! Unable to locate the singles dance animation \""+llList2String(singlesDances,i+1)+"\" in inventory. Please correct this and reset");
            myState="ERROR";
            return;
        }
        i+=2;
    }    
    l=llGetListLength(anData);
    while(--l>=0)
    {
        anData=[]+llListReplaceList(anData,[llStringTrim(llList2String(anData,l),STRING_TRIM)],l,l);
    }
    styles=[];
    l=llGetListLength(anData);
    i=0;
    while (i<l)
    {
        if (llListFindList(singlesStyles,[llList2String(anData,i)])>=0)
        {
            llOwnerSay("ERROR! A doubles dance style name is in conflict with one of the singles styles names. Style names must be unique! Please correct this and restart.");
            myState="ERROR";
            return;
        }
        if (llListFindList(styles,[llList2String(anData,i)])<0) styles=[]+styles+[llList2String(anData,i)];
        i+=anStride;
    }
    while(llGetListLength(styles)<9)
    {
        styles=[]+styles+["-"];
    }
    if (llGetListLength(styles)>9) llOwnerSay("WARNING! Found "+(string)(llGetListLength(styles))+" different couples dance styles but only the first 9 can be shown. Please correct this (but this is a non-fatal error so the dance machine will still work)");
    while (llListFindList(styles,["-","-","-"])>=0)
    {
        styles=[]+llDeleteSubList(styles,llListFindList(styles,["-","-","-"]),llListFindList(styles,["-","-","-"])+2);
    }
    i=0;
    l=llGetListLength(anData);
    integer anCount;
    string styleName;
    integer warned=FALSE;
    while (i<l)
    {
        if (llList2String(anData,i)!=styleName)
        {
            styleName=llList2String(anData,i);
            anCount=1;
            warned=FALSE;
        }
        else
        {
            anCount++;
            if ((anCount>9) && !warned)
            {
                warned=TRUE;
                llOwnerSay("WARNING! Found more than 9 animations assigned to style "+styleName+" but only the first 9 can be shown. Please correct this (but this is a non-fatal error so the dance machine will still work)");
            }
        }
        string name=llList2String(anData,i+1);
        if (llListFindList(anData,[name])<i)
        {
            llOwnerSay("ERROR! The name "+name+" is being used to identify an pair of animations but is in conflict with another name -- a style name, other pair name, or individual animation name that isn't part of that pair. Please resolve this error and reset the controller (see instructions for more details about name restrictions).");
            myState="ERROR";
        }
        name= llList2String(anData,i+2);
        if (llGetInventoryType(name)!=INVENTORY_ANIMATION) {myState="ERROR"; llOwnerSay("ERROR! Unable to locate the animation "+name+" in inventory. Please either supply it or update the animation data notecard.");}
        name= llList2String(anData,i+5);
        if (llGetInventoryType(name)!=INVENTORY_ANIMATION) {myState="ERROR"; llOwnerSay("ERROR! Unable to locate the animation "+name+" in inventory. Please either supply it or update the animation data notecard.");}
        i+=anStride;
    }
    couplesDanceCount=(string)(llGetListLength(anData)/anStride);
    i=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--i>=0)
    {
        string anName=llGetInventoryName(INVENTORY_ANIMATION,i);
        if ((llListFindList(anData,[anName])<0) && (llListFindList(anDefault,[anName])<0) && (llListFindList(singlesDances,[anName])<0)) llOwnerSay("NOTE: found the animation "+anName+" in inventory but it is not used for either the singles or couples dances.");
    }
    if (llGetListLength(partnerM)==0) {myState="ERROR"; llOwnerSay("ERROR! No male NPC appeance notecard names were supplied");}
    if (llGetListLength(firstNameM)==0) {myState="ERROR"; llOwnerSay("ERROR! No male NPC first names were supplied");}
    if (llGetListLength(lastNameM)==0) {myState="ERROR"; llOwnerSay("ERROR! No male NPC last names were supplied");}
    if (llGetListLength(partnerF)==0) {myState="ERROR"; llOwnerSay("ERROR! No female NPC appeance notecard names were supplied");}
    if (llGetListLength(firstNameF)==0) {myState="ERROR"; llOwnerSay("ERROR! No female NPC first names were supplied");}
    if (llGetListLength(lastNameF)==0) {myState="ERROR"; llOwnerSay("ERROR! No female NPC last names were supplied");}
    list appearances=partnerM+partnerF;
    i=llGetListLength(appearances);
    while (--i>=0)
    {
        if (llGetInventoryType(llList2String(appearances,i))!=INVENTORY_NOTECARD) {myState="ERROR"; llOwnerSay("ERROR! Unable to locate the NPC appearance notecard "+llList2String(appearances,i));}
    }
}
setPart(integer on)
{
    if(on && enableParticles) llParticleSystem([PSYS_PART_MAX_AGE,0.7,PSYS_PART_FLAGS,0|PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_FOLLOW_SRC_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_TARGET_POS_MASK,PSYS_PART_START_COLOR,sparkleStartColour,PSYS_PART_END_COLOR,sparkleEndColour,PSYS_PART_START_SCALE,<0.05,0.05,0>,PSYS_PART_END_SCALE,<0.1,0.1,0>,PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,PSYS_SRC_BURST_RATE,0.1,PSYS_SRC_BURST_PART_COUNT,sparkleBurstCount,PSYS_SRC_BURST_RADIUS,2,PSYS_SRC_BURST_SPEED_MIN,sparkleBurstSpeed,PSYS_SRC_BURST_SPEED_MAX,sparkleBurstSpeed,PSYS_SRC_TARGET_KEY,llGetKey(),PSYS_SRC_ANGLE_BEGIN,1.55,PSYS_SRC_ANGLE_END,1.54,PSYS_PART_START_ALPHA,0.75,PSYS_PART_END_ALPHA,0.5]);
    else llParticleSystem([]);
}
setRot(integer on)
{
    if(on) llTargetOmega(<0.0,0.0,-rpm/60>,TWO_PI,1.0);
    else llTargetOmega(<0.0,0.0,0.0>,TWO_PI,1.0);
}
updateText()
{
    if (myState=="READY")
    {
        setPart(TRUE);
        setRot(TRUE);
        string txt=floatyText+"\nTouch me to dance\n";
        if ((llGetListLength(singlesUsers)>0) || (llGetListLength(dancers)>0)) txt+=" \nSingles dancers: "+(string)(llGetListLength(singlesUsers)/2)+"\nCouples: "+(string)(llGetListLength(dancers)/dancerStride)+"\n";
        txt+=" \nDances Loaded\n"+singlesStyleCount+" singles styles, "+singlesDanceCount+" dances\nand "+couplesDanceCount+" couples dances";
        if (showFloatyText) llSetText(txt,floatyTextColour,1.0);
        else llSetText("",ZERO_VECTOR,0.0);
        return;
    }
    setPart(FALSE);
    setRot(FALSE);
    if (myState=="INITIALIZING") llSetText(floatyText+"\nInitializing...\nplease wait",<0,1,0>,1.0);
    else if (myState=="ERROR") llSetText(floatyText+"\nERROR...sorry\ntemporarily out of order",<1,0,0>,1.0);
    else if (myState=="EDIT") llSetText(floatyText+"\nEDIT MODE...\nplease wait",<1,1,0>,1.0);
}
default
{
    state_entry()
    {
        myState="INITIALIZING";
        llSetText(floatyText+"\nInitializing...\nplease wait",<0,1,0>,1.0);
        setPart(FALSE);
        setRot(FALSE);
        myChannel= 0x80000000 | (integer)("0x"+(string)llGetKey());
        handle=llListen(myChannel,"",NULL_KEY,"");
        autoTimer/=2;
        doInitialize();
        dancers=[];
        singlesUsers=[];
        ballRezFor=[];
        if (myState=="INITIALIZING")
        {
            myState="READY";
            updateText();
            llSetTimerEvent(autoTimer);
            llSay(0,"System reset and ready");
        }
        else if (myState=="ERROR")
        {
            llInstantMessage(llGetOwner(),"ERROR encountered during initialization!");
            updateText();
        }
        else llOwnerSay("Reached end of state_entry with unexpected state: "+myState);
    }
    timer()
    {
        if (myState!="READY")
        {
            if (myState!="EDIT") llSetTimerEvent(0.0);
            return;
        }
        tickCouples=!tickCouples;
        integer i;
        integer t;
        if (tickCouples)
        {
            integer l=llGetListLength(dancers);
            while (i<l)
            {
                if (llList2Integer(dancers,i+AUTO))
                {
                    string style=llList2String(dancers,i+STYLE);
                    string curAn=llList2String(dancers, i+ANNAME);
                    integer curInd=llListFindList(anData,[style,curAn]);
                    integer nextInd;
                    if (llListFindList(styles,[style])<0) nextInd=0;
                    else if ((curInd>-1) && (llList2String(anData,curInd+anStride)==style)) nextInd=curInd+anStride;
                    else nextInd=llListFindList(anData,[style]);
                    playAnimation(i,nextInd);
                }
                i+=dancerStride;
            }
        }
        else
        {
            integer l=llGetListLength(singlesUsers);
            while(i<l)
            {
                if (llGetAgentSize(llList2Key(singlesUsers,i))==ZERO_VECTOR)
                {
                    singlesUsers=[]+llDeleteSubList(singlesUsers,i,i+1);
                    l-=2;
                }
                else
                {
                    nextSingles(llList2Key(singlesUsers,i),llList2String(singlesUsers,i+1));
                    i+=2;
                }
            }
            i=0;
            l=llGetListLength(currentDances);
            while(i<l)
            {
                string thisStyle=llList2String(currentDances,i);
                string moveToCurrent=llList2String(currentDances,i+2);
                string newNextDance;
                integer indexNewCurrent=llListFindList(singlesDances,[thisStyle,moveToCurrent]);
                if(llList2String(singlesDances,indexNewCurrent+2)==thisStyle) newNextDance=llList2String(singlesDances,indexNewCurrent+3);
                else newNextDance=llList2String(singlesDances,llListFindList(singlesDances,[thisStyle])+1);
                currentDances=[]+llListReplaceList(currentDances,[thisStyle,moveToCurrent,newNextDance],i,i+2);
                i+=3;
            }
        }
        updateText();
    }
    on_rez(integer foo)
    {
        llResetScript();
    }
    changed (integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION_START) llResetScript();
    }
    touch_start(integer num)
    {
        key toucher=llDetectedKey(0);
        if (myState=="INITIALIZING")
        {
            llRegionSayTo(toucher,0,"Sorry, currently initializing the dance machine. Please wait until it is ready, then touch again");
            return;
        }
        if (myState=="ERROR")
        {
            if (toucher!=llGetOwner()) llRegionSayTo(toucher,0,"Sorry, the controller has encountered an error and needs to be reset before it can resume working. Please inform the owner");
            else
            {
                llOwnerSay("Attempting script reset");
                llResetScript();
            }
            return;
        }
        else if (myState=="EDIT")
        {
            if (toucher!=llGetOwner())
            {
                llRegionSayTo(toucher,0,"Sorry, the owner is currently editing positions...please wait until this is finished and the machine is reset");
                return;
            }
            else showOptions(llGetOwner());
        }
        else if (myState=="READY")
        {
            if (llListFindList(singlesUsers,[toucher])>=0)
            {
                if ((llGetListLength(singlesStyles)==2) && (llList2String(singlesStyles,1) =="*"))
                {
                    integer indWho=llListFindList(singlesUsers,[toucher]);
                    stopSingles(toucher,llList2String(singlesUsers,indWho+1));
                    singlesUsers=[]+llDeleteSubList(singlesUsers,indWho,indWho+1);
                }
                else showSinglesMenu(toucher);
            }
            else if (llListFindList(dancers,[toucher])>=0) showMain(toucher);
            else showFirst(toucher);
        }
    }
    dataserver (key ball, string data)
    {
        list message=llParseString2List(data,["|"],[]);
        string command=llList2String(message,0);
        if (command=="BALL_REZZED")
        {
            integer ballIndex=llListFindList(dancers,[("AWAITING_BALL_REZ_"+llList2String(message,1))]);
            if (ballIndex<0)
            {
                llOwnerSay("ERROR! A ball said "+data+" but when parsed I was unable to find an index for it using AWAITING_BALL_REZ_"+llList2String(message,1));
                return;
            }
            dancers=[]+llListReplaceList(dancers,[ball],ballIndex,ballIndex);
            integer thisPair=getPairIndex(ball);
            if (thisPair<0)
            {
                llOwnerSay("ERROR! Unable to find an index when searching dancer list for the newly inserted ball UUID");
                return;
            }
            vector basePos=llList2Vector(dancers,thisPair+BASEPOS);
            if (basePos==ZERO_VECTOR)
            {
                llOwnerSay("ERROR! When attempting to retrieve the couple's base position to send a new ball the result returned ZERO_VECTOR.\n"
                        +"The lookup for the couple index returned: "+(string)thisPair
                        +"\nThe contents of the position field for that record is: "+llList2String(dancers,thisPair+BASEPOS));
                return;
            }
            if ((llList2String(dancers,ballIndex-1)=="pending_f") || (llList2String(dancers,ballIndex-1)=="pending_npcf")) osMessageObject(ball,"MOVE_AND_SHOW_BALL|"+(string)(basePos+<-0.3, -0.3, 0.25>)+"|<0,0,0>|"+ (string)(ballTimeout*-1)+"|"+(string)debug+"|"+(string)enableParticles);
            else if ((llList2String(dancers,ballIndex-1)=="pending_m") || (llList2String(dancers,ballIndex-1)=="pending_npcm")) osMessageObject(ball,"MOVE_AND_SHOW_BALL|"+(string)(basePos+<0.3, 0.3, 0.25>)+"|<0,0,0>|"+ (string)ballTimeout+"|"+(string)debug+"|"+(string)enableParticles);
            else llOwnerSay("ERROR...BALL_REZZED dataserver error unable to locate record with that rez ID");
        }
        else if (command=="KILL_BALL_CALLED")
        {
            string reason=llList2String(message,1);
            if ((reason=="NO_USER_SAT") || (reason=="USER_STOOD_TIMEOUT") )
            {
                integer i=getPairIndex(ball);
                if (i<0) return;
                key userToMessage=NULL_KEY;
                key ballToKill=NULL_KEY;
                string anToStop;
                if (ball==llList2Key(dancers,i+B1ID))
                {
                    userToMessage=llList2Key(dancers,i+B2USER);
                    ballToKill=llList2Key(dancers,i+B2ID);
                    anToStop=llList2String(dancers,i+B2AN);
                }
                else if (ball==llList2Key(dancers,i+B2ID))
                {
                    userToMessage=llList2Key(dancers,i+B1USER);
                    ballToKill=llList2Key(dancers,i+B1ID);
                    anToStop=llList2String(dancers,i+B1AN);
                }
                else llOwnerSay("ERROR! When handling kill ball on "+reason+" unable to find the relevant ball which should be impossible");
                if(osIsUUID(userToMessage) && (userToMessage!=NULL_KEY)) llRegionSayTo(userToMessage,0,"Sorry, your partner's danceball has timed out and has been removed. Yours must be removed as well. Please start again when you're both ready to dance.");
                if(osIsUUID(ballToKill) && (ballToKill!=NULL_KEY))  osMessageObject(ballToKill,"KILL_BALL");
                if(osIsUUID(userToMessage) && (userToMessage!=NULL_KEY)) osAvatarStopAnimation(userToMessage,anToStop);
                integer p=llListFindList(dancers,ball)-1;
                if (osIsUUID(llList2Key(dancers,p))) osAvatarStopAnimation(llList2Key(dancers,p),llList2String(dancers,p+2));
                dancers=[]+llDeleteSubList(dancers,i,i+dancerStride-1);
                updateText();
            }
            else
            {
                myState="ERROR";
                llSetTimerEvent(0.0);
                updateText();
                llShout(0,"ERROR! Sorry, the controller experienced an error and will attempt to reset. You can attempt to use it again once the system is ready. We are sorry for the inconvenience");
                llInstantMessage(llGetOwner(),"Encountered error due to poseball self-destruct with the following error condition:\n"+reason);
                integer l=llGetListLength(dancers);
                integer i;
                while (i<l)
                {
                    if (osIsUUID(llList2Key(dancers,i+B1ID))) osMessageObject(llList2Key(dancers,i+B1ID),"KILL_BALL");
                    if (osIsUUID(llList2Key(dancers,i+B1USER)))
                    {
                        if (osIsNpc(llList2Key(dancers,i+B1USER))) osNpcRemove(llList2Key(dancers,i+B1USER));
                        else osAvatarStopAnimation(llList2Key(dancers,i+B1USER),llList2String(dancers,i+B1AN));
                    }
                    if (osIsUUID(llList2Key(dancers,i+B2ID))) osMessageObject(llList2Key(dancers,i+B2ID),"KILL_BALL");
                    if (osIsUUID(llList2Key(dancers,i+B2USER)))
                    {
                        if (osIsNpc(llList2Key(dancers,i+B2USER))) osNpcRemove(llList2Key(dancers,i+B2USER));
                        else osAvatarStopAnimation(llList2Key(dancers,i+B2USER),llList2String(dancers,i+B2AN));
                    }
                    i+=dancerStride;
                }
                i=0;
                l=llGetListLength(singlesUsers);
                while (i<l)
                {
                    stopSingles(llList2Key(singlesUsers,i),llList2String(singlesUsers,i+1));
                    i+=2;
                }
                llResetScript();
            }
        }
        else if (command=="USER_SAT")
        {
            key uID=llList2Key(message,1);
            if (llListFindList(singlesUsers,[uID]))
            {
                singlesUsers=[]+llDeleteSubList(singlesUsers,llListFindList(singlesUsers,uID),llListFindList(singlesUsers,uID)+1);
                updateText();
            }
            if (llListFindList(ballRezFor,[uID])) ballRezFor=[]+llDeleteSubList(ballRezFor,llListFindList(ballRezFor,[uID]),llListFindList(ballRezFor,[uID])+1);
            integer i=llListFindList(dancers,[ball])-1;
            dancers=[]+llListReplaceList(dancers,[uID],i,i);
            osAvatarPlayAnimation(uID,llList2String(dancers,i+2));
            osMessageObject(llList2Key(dancers,i+1),"MOVE_BALL|"+relToReg(llList2Vector(dancers,getPairIndex(uID)+BASEPOS),ZERO_ROTATION,llList2Vector(dancers,i+3),llList2Vector(dancers,i+4)));
            if (osIsNpc(uID)) return;
            else showMain(uID);
            integer thisPair=getPairIndex(uID);
            if (thisPair<0) return;
            if (llList2String(dancers,thisPair+B1USER)=="pending_npcf")
            {
                key npc=osNpcCreate(llList2String(firstNameF,llFloor(llFrand(llGetListLength(firstNameF)))),llList2String(lastNameF,llFloor(llFrand(llGetListLength(lastNameF)))),(llList2Vector(dancers,thisPair+BASEPOS)+<0,0,2>),llList2String(partnerF,llFloor(llFrand(llGetListLength(partnerF)))),OS_NPC_SENSE_AS_AGENT);
                osNpcSit(npc,llList2Key(dancers,thisPair+B1ID),OS_NPC_SIT_NOW);
            }
            else if (llList2String(dancers,getPairIndex(uID)+B2USER)=="pending_npcm")
            {
                key npc=osNpcCreate(llList2String(firstNameM,llFloor(llFrand(llGetListLength(firstNameM)))),llList2String(lastNameM,llFloor(llFrand(llGetListLength(lastNameM)))),(llList2Vector(dancers,thisPair+BASEPOS)+<0,0,2>),llList2String(partnerM,llFloor(llFrand(llGetListLength(partnerM)))),OS_NPC_SENSE_AS_AGENT);
                osNpcSit(npc,llList2Key(dancers,thisPair+B2ID),OS_NPC_SIT_NOW);
            }
        }
        else if (command=="USER_STOOD")
        {
            key aviThatStood=llList2Key(message,1);
            integer indexAviThatStood=llListFindList(dancers,[aviThatStood]);
            osAvatarStopAnimation(aviThatStood,llList2String(dancers,indexAviThatStood+2));
            integer indexPair=getPairIndex(aviThatStood);
            integer indexPartner;
            string anToStartPartner;
            vector posPartner;
            vector rotPartner;
            if (indexPair==indexAviThatStood)
            {
                indexPartner=indexPair+B2USER;
                anToStartPartner=llList2String(anDefault,5);
                posPartner=llList2Vector(anDefault,6);
                rotPartner=llList2Vector(anDefault,7);
            }
            else
            {
                indexPartner=indexPair;
                anToStartPartner=llList2String(anDefault,2);
                posPartner=llList2Vector(anDefault,3);
                rotPartner=llList2Vector(anDefault,4);
            }
            key keyPartner=llList2Key(dancers,indexPartner);
            if (osIsUUID(keyPartner) && (keyPartner!=NULL_KEY))
            {
                dancers=[]+llListReplaceList(dancers,["avatar stood"],indexAviThatStood,indexAviThatStood);
                dancers=[]+llListReplaceList(dancers,[0],indexPair+AUTO,indexPair+AUTO);
                if (myState=="EDIT")
                {
                    myState="READY";
                    if (osIsUUID(llList2Key(dancers,indexPartner+1))) osMessageObject(llList2Key(dancers,indexPartner+1),"HIDE_BALL");
                    llOwnerSay("WARNING!!! Either you or your partner stood (or crashed?) while in edit mode. Machine will immediately exit edit mode.\n"
                            +"Changes to the current animation ARE NOT stored. Any changes you've made to other animations ARE stored. "
                            +"These will now be saved automatically to notecard to prevent their loss.\n"
                            +"Your dialog (if any) is now invalid so press any button to get a valid one");
                    saveNotecard();
                }
                if (osIsNpc(keyPartner))
                {
                    osNpcRemove(keyPartner);
                    return;
                }
                if (osIsUUID(llList2Key(dancers,indexPartner+1))) osMessageObject(llList2Key(dancers,indexPartner+1),"MOVE_BALL|"+relToReg(llList2Vector(dancers,indexPair+BASEPOS),ZERO_ROTATION,posPartner,rotPartner));
                osAvatarStopAnimation(keyPartner,llList2String(dancers,indexPartner+2));
                osAvatarPlayAnimation(keyPartner,anToStartPartner);
                llRegionSayTo(keyPartner,0,"Your partner is no longer dancing. If the ball is not re-occupied in the next "+(string)ballTimeout+" seconds both balls will be removed");
            }
            else
            {
                osMessageObject(llList2Key(dancers,indexPartner+1),"KILL_BALL");
                osMessageObject(ball,"KILL_BALL");
                dancers=[]+llDeleteSubList(dancers,indexPair,indexPair+dancerStride-1);
                updateText();
            }
        }
    }
    listen (integer channel, string name, key who, string message)
    {
        if (myState=="ERROR")
        {
            if (who!=llGetOwner()) llRegionSayTo(who,0,"Sorry, the controller has encountered an error and needs to be reset before it can resume working. Please inform the owner");
            else
            {
                llOwnerSay("Attempting script reset");
                llResetScript();
            }
        }
        else if (myState=="INITIALIZING") llRegionSayTo(who,0,"Sorry, the controller is re-initializing. You will need to start dancing again once it has finished doing so");
        else if (myState=="EDIT")
        {
            if (who!=llGetOwner())
            {
                llRegionSayTo(who,0,"Sorry, the controller has been switched into edit mode will be reset once the owner has finished making changes. Then you'll be able to dance");
                return;
            }
            if (message=="SYNCH") doSynch(who);
            else if (message=="< PREV")
            {
                integer indexAn=llListFindList(anData,llList2List(dancers,STYLE,ANNAME));
                persistCurrent(indexAn);
                indexAn-=anStride;
                if (indexAn<0) indexAn=llGetListLength(anData)-anStride;
                playAnimation(0,indexAn);
                llOwnerSay("Changes (if any) stored locally. Now editing\n    Style: "+llList2String(anData,indexAn)+"\n    Anim Name: "+llList2String(anData,indexAn+1));
            }
            else if (message=="NEXT >")
            {
                integer indexAn=llListFindList(anData,llList2List(dancers,STYLE,ANNAME));
                persistCurrent(indexAn);
                indexAn+=anStride;
                if (indexAn>llGetListLength(anData)) indexAn=0;
                playAnimation(0,indexAn);
                llOwnerSay("Changes (if any) stored locally. Now editing\n    Style: "+llList2String(anData,indexAn)+"\n    Anim Name: "+llList2String(anData,indexAn+1));
            }
            else if (message=="REVERT")
            {
                integer indexAn=llListFindList(anData,llList2List(dancers,STYLE,ANNAME));
                playAnimation(0,indexAn);
                llOwnerSay("Reverted to original position. Now editing\n    Style: "+llList2String(anData,indexAn)+"\n    Anim Name: "+llList2String(anData,indexAn+1));
            }
            else if (message=="SAVE")
            {
                integer indexAn=llListFindList(anData,llList2List(dancers,STYLE,ANNAME));
                persistCurrent(indexAn);
                saveNotecard();
            }
            else if (message=="EDIT OFF")
            {
                integer indexAn=llListFindList(anData,llList2List(dancers,STYLE,ANNAME));
                persistCurrent(indexAn);
                myState="READY";
                updateText();
                osMessageObject(llList2Key(dancers,B1ID),"HIDE_BALL");
                osMessageObject(llList2Key(dancers,B2ID),"HIDE_BALL");
            }
            showOptions(who);
        }
        else if (myState=="READY")
        {
            if (message=="OOPS") return;
            else if (message=="SINGLES")
            {
                if ((llGetListLength(singlesStyles)==2) && (llList2String(singlesStyles,1) =="*"))
                {
                    singlesUsers=[]+singlesUsers+[who,llList2String(singlesStyles,0)];
                    startSingles(who,llList2String(singlesStyles,0));
                    llRegionSayTo(who,0,"You will start to dance momentarily...please touch me again to stop");
                }
                else
                {
                    singlesUsers=[]+singlesUsers+[who,"NO_STYLE_SELECTED"];
                    showSinglesMenu(who);
                }
                return;
            }
            else if ((message=="COUPLES") || (message=="NPC COUPLES"))
            {
                if (llListFindList(singlesUsers,who)>=0)
                {
                    llRegionSayTo(who,0,"Sorry, I seem to have you in my list of singles dancers. Please quit dancing first, then request a new couples dance");
                    showSinglesMenu(who);
                    return;
                }
                if (llListFindList(dancers,[who])>=0)
                {
                    llRegionSayTo(who,0,"Sorry, I already seem to have you in my list of couples dancers so I can't rez a new pair of danceballs for you. Please QUIT and inform the owner if this error continues to occur");
                    showMain(who);
                    return;
                }
                vector toucherPos=llList2Vector(llGetObjectDetails(who,[OBJECT_POS]),0);
                if (toucherPos==ZERO_VECTOR)
                {
                    llOwnerSay("ERROR! Toucher detected with ZERO_VECTOR as their location!");
                    llRegionSayTo(who,0,"Sorry, there appears to have been an error detecting your current location so I cannot rez any poseballs for you");
                    return;
                }
                if (llListFindList(ballRezFor,[who])>-1)
                {
                    integer indexBRF=llListFindList(ballRezFor,[who]);
                    if (llGetUnixTime()-llList2Integer(ballRezFor,indexBRF+1)<10)
                    {
                        llRegionSayTo(who,0,"I think I have already rezzed a pair of balls for you within the last 10 seconds. If they failed to rez for some reason or you are unable to see them please wait a few more moments and try again (perhaps I detected a double-click in error)");
                        return;
                    }
                    else ballRezFor=[]+llDeleteSubList(ballRezFor,indexBRF,indexBRF+1);
                }
                if (message=="COUPLES")
                {
                    dancers=[] + dancers + ["pending_f",("AWAITING_BALL_REZ_"+(string)(nextBallID+1))] + llList2List(anDefault,2,4) + ["pending_m",("AWAITING_BALL_REZ_"+(string)(nextBallID+2))] + llList2List(anDefault,5,7) + [toucherPos, 0] + llList2List(anDefault,0,1) + [0];
                    llRegionSayTo(who,0,"Rezzing a pair of dance balls near you for you and your partner to sit on.");
                }
                else
                {
                    dancers=[] + dancers + ["pending_npcf",("AWAITING_BALL_REZ_"+(string)(nextBallID+1))] + llList2List(anDefault,2,4) + ["pending_npcm",("AWAITING_BALL_REZ_"+(string)(nextBallID+2))] + llList2List(anDefault,5,7) + [toucherPos, 0] + llList2List(anDefault,0,1) + [0];
                    llRegionSayTo(who,0,"Rezzing a pair of dance balls. Your NPC partner will join you once you select one.");
                }
                llRezObject(poseballName,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,(nextBallID+1));
                llRezObject(poseballName,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,(nextBallID+2));
                nextBallID+=2;
                ballRezFor=[]+ballRezFor + [who,llGetUnixTime()];
                updateText();
            }
            else if ((llListFindList(dancers,[who])<0) && (llListFindList(singlesUsers,[who])<0)) llRegionSayTo(who,0,"Sorry, you don't appear to be in my list of current dancers any more.");
            else if (message=="-") showMain(who);
            else if (message=="*") showSinglesMenu(who);
            else if (message=="~")
            {
                integer thisPair=getPairIndex(who);
                if (llList2Integer(dancers,thisPair+AUTO)) showMain(who);
                else
                {
                    string backToStyle=llList2String(dancers,thisPair+STYLE);
                    if (llListFindList(styles,backToStyle)<0) showMain(who);
                    else showPickAn(who,backToStyle);
                }
            }
            else if (message=="EDIT ON")
            {
                if ((llGetListLength(dancers)>dancerStride) || (llGetListLength(singlesUsers)>0))
                {
                    llOwnerSay("Sorry, it appears that someone else is using the controller now so you cannot enter edit mode until they quit.");
                    showOptions(who);
                }
                else
                {
                    myState="EDIT";
                    updateText();
                    osMessageObject(llList2Key(dancers,B1ID),"EDIT_BALL");
                    osMessageObject(llList2Key(dancers,B2ID),"EDIT_BALL");
                    integer indexAn=llListFindList(anData,llList2List(dancers,STYLE,ANNAME));
                    dancers=[]+llListReplaceList(dancers,[0],SWAPFLAG,SWAPFLAG);
                    playAnimation(0,indexAn);
                    llOwnerSay("Entering edit mode.\nVERY IMPORTANT!!!! Any changes are only stored in live memory. To remember them for future you must click SAVE before the next time the system is reset to save them to notecard."
                        +"\n\nNow editing\n    Style: "+llList2String(anData,indexAn)+"\n    Anim Name: "+llList2String(anData,indexAn+1));
                    showOptions(who);
                }
            }
            else if (message=="BACK")
            {
                string backToStyle=llList2String(dancers,getPairIndex(who)+STYLE);
                if (llListFindList(styles,backToStyle)<0) showMain(who);
                else showPickAn(who,backToStyle);
            }
            else if (message=="SWAP")
            {
                integer thisPair=getPairIndex(who);
                integer nextAnIndex=llListFindList(anData,llList2List(dancers,thisPair+STYLE,thisPair+ANNAME));
                if (nextAnIndex<0) llRegionSayTo(who,0,"Sorry, I am unable to swap positions for the current animation");
                else
                {
                    if (llList2Integer(dancers,thisPair+SWAPFLAG)==0) dancers=[]+llListReplaceList(dancers,[1],thisPair+SWAPFLAG,thisPair+SWAPFLAG);
                    else dancers=[]+llListReplaceList(dancers,[0],thisPair+SWAPFLAG,thisPair+SWAPFLAG);
                    playAnimation(thisPair,nextAnIndex);
                }
                showOptions(who);
            }
            else if (message=="AUTO")
            {
                integer thisPair=getPairIndex(who);
                dancers=[]+llListReplaceList(dancers,[1],thisPair+AUTO,thisPair+AUTO);
                string txtToSay="Your couple is now in Auto dance mode.\nHappy dancing!";
                llRegionSayTo(llList2Key(dancers,thisPair+B1USER),0,txtToSay);
                llRegionSayTo(llList2Key(dancers,thisPair+B2USER),0,txtToSay);
                if (llListFindList(anData,[llList2String(dancers,thisPair+STYLE)])<0) playAnimation(thisPair,0);
                showMain(who);
            }
            else if (message=="MANUAL")
            {
                integer thisPair=getPairIndex(who);
                dancers=[]+llListReplaceList(dancers,[0],thisPair+AUTO,thisPair+AUTO);
                string txtToSay="Your couple is now in Manual dance mode.";
                llRegionSayTo(llList2Key(dancers,thisPair+B1USER),0,txtToSay);
                llRegionSayTo(llList2Key(dancers,thisPair+B2USER),0,txtToSay);
                showMain(who);
            }
            else if (message=="Z ADJUST")
            {
                osMessageObject(llList2Key(dancers,llListFindList(dancers,[who])+1),"ENABLE_Z|"+(string)zStep);
                llRegionSayTo(who,0,"Z-Adjust enabled. Use your keyboard's PAGE UP and PAGE DOWN keys to adjust your height off the floor (this only changes your position, your partner may need to make a similar adjustment)\n"
                                    +"The adjustments you make will apply to all future dances you select. Use \"Z STOP ADJ\" to turn off the adjustment controls and keep your current setting, or \"Z RESET\" to return to the default position.");
                showOptions(who);
            }
            else if (message=="Z STOP ADJ")
            {
                osMessageObject(llList2Key(dancers,llListFindList(dancers,[who])+1),"DISABLE_Z");
                llRegionSayTo(who,0,"Z-Adjust disabled but your current adjustment will apply to any other dances you select. Press \"Z RESET\" at any time if you want to clear it");
                showOptions(who);
            }
            else if (message=="Z RESET")
            {
                osMessageObject(llList2Key(dancers,llListFindList(dancers,[who])+1),"UNSET_Z");
                llRegionSayTo(who,0,"Your current z-adjustment has been reset to zero");
                showOptions(who);
            }
            else if ((message=="NEW M") || (message=="NEW F"))
            {
                integer thisPair=getPairIndex(who);
                key keyToChange=llList2Key(dancers,thisPair+B1USER);
                if (keyToChange==who) keyToChange=llList2Key(dancers,thisPair+B2USER);
                if (osIsNpc(keyToChange))
                {
                    if (message=="NEW M") osNpcLoadAppearance(keyToChange,llList2String(partnerM,llFloor(llFrand(llGetListLength(partnerM)))));
                    else osNpcLoadAppearance(keyToChange,llList2String(partnerF,llFloor(llFrand(llGetListLength(partnerF)))));
                }
                else llRegionSayTo(who,0,"Can't change your partner's appearance...they aren't a NPC.");
                showOptions(who);
            }
            else if (message=="STYLES") showMain(who);
            else if (message=="SYNCH")
            {
                doSynch(who);
                integer thisPair=getPairIndex(who);
                if (llList2Integer(dancers,thisPair+AUTO)) showMain(who);
                else
                {
                    string backToStyle=llList2String(dancers,thisPair+STYLE);
                    if (llListFindList(styles,backToStyle)<0) showMain(who);
                    else showPickAn(who,backToStyle);
                }
            }
            else if (message=="OPTIONS") showOptions(who);
            else if (message=="QUIT")
            {
                if (llListFindList(singlesUsers,[who])>=0)
                {
                    integer indWho=llListFindList(singlesUsers,[who]);
                    stopSingles(who,llList2String(singlesUsers,indWho+1));
                    singlesUsers=[]+llDeleteSubList(singlesUsers,indWho,indWho+1);
                }
                else
                {
                    integer thisPair=getPairIndex(who);
                    string txtToSay="One of the couple has chosen to quit dancing";
                    if (osIsUUID(llList2Key(dancers,thisPair+B1ID))) osMessageObject(llList2Key(dancers,thisPair+B1ID),"KILL_BALL");
                    if (osIsNpc(llList2Key(dancers,thisPair+B1USER))) osNpcRemove(llList2Key(dancers,thisPair+B1USER));
                    else if (osIsUUID(llList2Key(dancers,thisPair+B1USER)))
                    {
                        osAvatarStopAnimation(llList2Key(dancers,thisPair+B1USER),llList2String(dancers,thisPair+B1AN));
                        llRegionSayTo(llList2Key(dancers,thisPair+B1USER),0,txtToSay);
                    }
                    if (osIsUUID(llList2Key(dancers,thisPair+B2ID))) osMessageObject(llList2Key(dancers,thisPair+B2ID),"KILL_BALL");
                    if (osIsNpc(llList2Key(dancers,thisPair+B2USER))) osNpcRemove(llList2Key(dancers,thisPair+B2USER));
                    else if (osIsUUID(llList2Key(dancers,thisPair+B2USER)))
                    {
                        osAvatarStopAnimation(llList2Key(dancers,thisPair+B2USER),llList2String(dancers,thisPair+B2AN));
                        llRegionSayTo(llList2Key(dancers,thisPair+B2USER),0,txtToSay);
                    }
                    dancers=[]+llDeleteSubList(dancers,thisPair,thisPair+dancerStride-1);
                }
                updateText();
            }
            else if ((message=="< PREV") || (message=="NEXT >") || (message=="SAVE") || (message=="REVET") || (message=="EDIT OFF")) showMain(who);
            else if (llListFindList(singlesUsers,[who])>=0)
            {
                integer uInd=llListFindList(singlesUsers,[who]);
                if (message!=llList2String(singlesUsers,uInd+1))
                {
                    singlesUsers=[]+llListReplaceList(singlesUsers,[message],uInd+1,uInd+1);
                    startSingles(who,message);
                }
                showSinglesMenu(who);
            }
            else if (llListFindList(styles,[message])>-1)
            {
                integer thisPair=getPairIndex(who);
                if (llList2Integer(dancers,thisPair+AUTO))
                {
                    string txtToSay="New auto dance style selected by your couple: "+message;
                    if (osIsUUID(llList2Key(dancers,thisPair+B1USER))) llRegionSayTo(llList2Key(dancers,thisPair+B1USER),0,txtToSay);
                    if (osIsUUID(llList2Key(dancers,thisPair+B2USER))) llRegionSayTo(llList2Key(dancers,thisPair+B2USER),0,txtToSay);
                    dancers=[]+llListReplaceList(dancers,[message],thisPair+STYLE,thisPair+STYLE);
                    playAnimation(thisPair,llListFindList(anData,[message]));
                    showMain(who);
                }
                else showPickAn(who,message);
            }
            else if (llListFindList(anData,[message])>-1)
            {
                integer thisPair=getPairIndex(who);
                if (llList2Integer(dancers,thisPair+AUTO))
                {
                    string txtToSay="A dance was manually selected...switching your couple to manual dance mode";
                    if (osIsUUID(llList2Key(dancers,thisPair+B1USER))) llRegionSayTo(llList2Key(dancers,thisPair+B1USER),0,txtToSay);
                    if (osIsUUID(llList2Key(dancers,thisPair+B2USER))) llRegionSayTo(llList2Key(dancers,thisPair+B2USER),0,txtToSay);
                    dancers=[]+llListReplaceList(dancers,[0],thisPair+AUTO,thisPair+AUTO);
                }
                integer selectedDanceIndex=llListFindList(anData,[message])-1;
                playAnimation(thisPair,selectedDanceIndex);
                showPickAn(who,llList2String(anData,selectedDanceIndex));
            }
            else llOwnerSay("ERROR! Received a dialog response in READY state but it failed to match a button name and was neither a style nor animation name. This shouldn't be possible!");
        }
    }
}