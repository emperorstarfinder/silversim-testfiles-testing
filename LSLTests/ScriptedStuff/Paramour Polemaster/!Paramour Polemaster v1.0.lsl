// PARAMOUR POLEMASTER v1.0 (OSSL)
// by Aine Caoimhe (c. LACM) February 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// *** REQUIRES REGION WITH OSSL FUNCTIONS ENABLED FOR SCRIPT OWNER
// This script requires the use of Opensim-specific OSSL functions and is not compatible with Second Life.
// This script expects each animation to have a description that identifies the sit target position (but not rotation) and time in the format <pos>time    example:  <0.00,0.00,-1.05>20.5
// Any animation not containing that information will be given default values of ZERO_VECTOR and 30.0 seconds
//
// USER SETTINGS
integer maxUsers=2;                     // how many simultaneous users are allowed (including NPCs) - more than 3 or 4 would become extremely crowded
vector globalOffset=<0.0, 0.0, -1.0>;   // position offset for the object used globally for all animations (in addition to their individual offsets)
integer animRandomOrder=FALSE;          // TRUE = randomly select the next animation FALSE = (recommended) animations are played sequentially in the order they appear in inventory
integer ownerOnlyMenu=FALSE;            // TRUE = only owner can access the menu, FALSE = any current user can
integer showCage=TRUE;      // by default, make the cage visible - if TRUE, showGantry must be false and will automatically be set that way on startup
integer showGantry=FALSE;   // by default, make the 4 gantry bars visible - if TRUE, showCage must be false; if obth showGrantry and showCage are FALSE showFixtures will be set to FALSE automatically
integer showFixtures=TRUE;  // by default, make the fixtures visible...you can hide fixtures which will also hide the spotlight faces but they will continue to shine light if spotlight lighting effects are enabled
float masterTimer=5.0;      // how often to change lights but this also affects the frequency of particle effects (avoid doing this too often since it will increase sim load)
integer spotsOn=TRUE;       // enable spotlights lighting effect (if FALSE fixtures and gantry will be hidden automatically but if TRUE the fixtures can still be left invisible)
integer fogOn=TRUE;         // by default, should the base platform's fog effect be enabled (this is a continuous effect)
integer potJetsOn=TRUE;     // by default, should the pot lights on the base shoot jets of fog up periodially
float potsTime=60.0;        // approximately how often (in seconds) to have the pots fog-jet effect trigger when it's active (should be a multiple of masterTimer)
float potsDuration=5.0;     // approximately how long to emit the jets (should be a multiple of masterTimer)
integer topFogOn=TRUE;      // by default, should the ball on the top of the pole emit a fog cloud periodically
float topTime=120.0;        // approximately how often (in seconds) to have the top ball drop the fog mist when it's active (should be a multiple of masterTimer)
float topDuration=10.0;     // approximately how long to emit fog from the top ball (should be a multiple of masterTimer)
//
// ADVANCED USERS
// If you're familiar with the variables involved with the associated functions, you may wish to change these as well
list colourList=[ // string name, vector colour, float spot intensity, string name of colour to use as it's "colour opposite"  -- minimum 8 suggest max 24
    "01. red", <1.00, 0.00, 0.00>, 0.25, "08. sky blue",
    "02. orange", <1.00, 0.50, 0.00>, 0.25, "09. blue",
    "03. yellow", <1.00, 1.00, 0.00>, 0.25, "10. violet",
    "04. yellow green", <0.50, 1.00, 0.00>, 0.275, "12. pink",
    "05. green", <0.00, 1.00, 0.00>, 0.30, "11. magenta",
    "06. sea green", <0.00, 1.00, 0.50>, 0.35, "13. white",
    "07. cyan", <0.00, 1.00, 1.00>, 0.40, "01. red",
    "08. sky blue", <0.00, 0.50, 1.00>, 0.55, "13. white",
    "09. blue", <0.00,0.00, 1.00>, 0.75, "01. red",
    "10. violet", <0.50, 0.00, 1.00>, 0.50, "02. orange",
    "11. magenta", <1.00, 0.00, 1.00>, 0.35, "06. sea green",
    "12. pink", <1.00, 0.00, 0.50>, 0.30, "10. violet",
    "13. white", <1.00, 1.00, 1.00>, 0.25,"10. violet"
    ];
integer randomOrder=TRUE;   // randomize the colour list
float radius=4.5;           // spot point light
float falloff=0.75;         // sopt point light
float lightGlow=0.15;       // sport point light
list particleBaseSet=[      // particle effect for platform - simple on/on effect not on timer
                PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
                PSYS_SRC_BURST_RADIUS,0.4,
                PSYS_SRC_ANGLE_BEGIN,0,
                PSYS_SRC_ANGLE_END,0,
                PSYS_SRC_TARGET_KEY,NULL_KEY,
                PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_START_ALPHA,0.04,
                PSYS_PART_END_ALPHA,1,
                PSYS_PART_START_GLOW,0,
                PSYS_PART_END_GLOW,0,
                PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                PSYS_PART_START_SCALE,<0.500000,0.500000,0.000000>,
                PSYS_PART_END_SCALE,<3.000000,3.000000,0.000000>,
                PSYS_SRC_TEXTURE,"",
                PSYS_SRC_MAX_AGE,0,
                PSYS_PART_MAX_AGE,15,
                PSYS_SRC_BURST_RATE,0.3,
                PSYS_SRC_BURST_PART_COUNT,4,
                PSYS_SRC_ACCEL,<0.000000,0.000000,-0.500000>,
                PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                PSYS_SRC_BURST_SPEED_MIN,0.1,
                PSYS_SRC_BURST_SPEED_MAX,0.21,
                PSYS_PART_FLAGS,
                    0 |
                    PSYS_PART_BOUNCE_MASK |
                    PSYS_PART_INTERP_SCALE_MASK
            ];
list particleTopSet=[   // particle effect for top ball
                PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
                PSYS_SRC_BURST_RADIUS,0,
                PSYS_SRC_ANGLE_BEGIN,0.4,
                PSYS_SRC_ANGLE_END,2.2,
                PSYS_SRC_TARGET_KEY,NULL_KEY,
                PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_START_ALPHA,0.125,
                PSYS_PART_END_ALPHA,1,
                PSYS_PART_START_GLOW,0,
                PSYS_PART_END_GLOW,0,
                PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                PSYS_PART_START_SCALE,<0.500000,0.500000,0.000000>,
                PSYS_PART_END_SCALE,<3.000000,3.000000,0.000000>,
                PSYS_SRC_TEXTURE,"",
                PSYS_SRC_MAX_AGE,0,
                PSYS_PART_MAX_AGE,15.1,
                PSYS_SRC_BURST_RATE,1,
                PSYS_SRC_BURST_PART_COUNT,5,
                PSYS_SRC_ACCEL,<0.000000,0.000000,-0.050000>,
                PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                PSYS_SRC_BURST_SPEED_MIN,0.025,
                PSYS_SRC_BURST_SPEED_MAX,0.1,
                PSYS_PART_FLAGS,
                    0 |
                    PSYS_PART_INTERP_SCALE_MASK
            ];
list particlePotsSet=[  // particle effect for pot lights
                PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
                PSYS_SRC_BURST_RADIUS,0.5,
                PSYS_SRC_ANGLE_BEGIN,0,
                PSYS_SRC_ANGLE_END,0.05,
                PSYS_SRC_TARGET_KEY,NULL_KEY,
                PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                PSYS_PART_START_ALPHA,0.1,
                PSYS_PART_END_ALPHA,1,
                PSYS_PART_START_GLOW,0,
                PSYS_PART_END_GLOW,0,
                PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                PSYS_PART_START_SCALE,<0.100000,0.100000,0.000000>,
                PSYS_PART_END_SCALE,<0.700000,0.700000,0.000000>,
                PSYS_SRC_TEXTURE,"",
                PSYS_SRC_MAX_AGE,0,
                PSYS_PART_MAX_AGE,5,
                PSYS_SRC_BURST_RATE,0.05,
                PSYS_SRC_BURST_PART_COUNT,4,
                PSYS_SRC_ACCEL,<0.000000,0.000000,-0.500000>,
                PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                PSYS_SRC_BURST_SPEED_MIN,1,
                PSYS_SRC_BURST_SPEED_MAX,2,
                PSYS_PART_FLAGS,
                    0 |
                    PSYS_PART_BOUNCE_MASK |
                    PSYS_PART_INTERP_SCALE_MASK
            ];

// # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
// # #    MAIN SCRIPT STARTS HERE - DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING!    # #
// # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
integer debug=FALSE;    // displays animation info during use
integer linkPlatform;
integer linkTopBall;
integer linkGantry;
integer linkFixtures;
integer linkCage;
list linkSpots=["main1","main2","main3","main4"];
list linkPots=["pot1","pot2","pot3","pot4","pot5","pot6","pot7","pot8"];
key diaUser=NULL_KEY;
integer handle;
integer myChannel;
float diaTimeout;
float animTimer;
vector sitOffset;
list userIDs;
list animList;
integer animInd;
float potChange;
integer potOn=FALSE;
float topChange;
integer topOn=FALSE;
list methods=["UNIFORM","SIDE","CROSS","RANDOM"];
integer indexMethod;
integer indexColour;
playNextAnim()
{
    string anToStop=llList2String(animList,animInd);
    animInd+=3;
    if (animInd>=llGetListLength(animList))
    {
        if (animRandomOrder)
        {
            animList=llListRandomize(animList,3);
            while ((llList2String(animList,0)==anToStop) && (llGetListLength(animList)>1)) { animList=llListRandomize(animList,3); }
        }
        animInd=0;
    }
    integer u=llGetListLength(userIDs);
    float curU=(float)u;
    string anToStart=llList2String(animList,animInd);
    sitOffset=llList2Vector(animList,animInd+1)+globalOffset;
    while(--u>=0)
    {
        key who=llList2Key(userIDs,u);
        osAvatarPlayAnimation(who,anToStart);
        osAvatarStopAnimation(who,anToStop);
        positionUpdate((360.0/curU)*u,who);
    }
    llSensorRepeat("NO_RESULT_POSSIBLE",NULL_KEY,AGENT,0.01,0.01,llList2Float(animList,animInd+2));
    if (debug)
    {
        string txt=llDumpList2String(llList2List(animList,animInd,animInd+2)," | ");
        llSetText(txt,<1.0,0.0,0.0>,1.0);
        llOwnerSay(txt);
    }
}
startAnimations()
{
    integer u=llGetListLength(userIDs);
    float curU=(float)u;
    string anToStart=llList2String(animList,animInd);
    sitOffset=llList2Vector(animList,animInd+1)+globalOffset;
    while (--u>-1)
    {
        key who=llList2Key(userIDs,u);
        positionUpdate((360.0/curU)*u,who);
        list animToStop=llGetAnimationList(who);
        integer an=llGetListLength(animToStop);
        osAvatarPlayAnimation(who,anToStart);
        while(--an>-1) { osAvatarStopAnimation(who,llList2Key(animToStop,an)); }
    }
    playNextAnim();
}
stopAnimations()
{
    list sitters;
    integer link=llGetNumberOfPrims();
    while(link)
    {
        if (llGetAgentSize(llGetLinkKey(link))!=ZERO_VECTOR) sitters+=[llGetLinkKey(link)];
        else link=1;
        link--;
    }
    integer u=llGetListLength(userIDs);
    while (--u>-1)
    {
        if (llListFindList(sitters,[llList2Key(userIDs,u)])==-1) // no longer using
        {
            osAvatarPlayAnimation(llList2Key(userIDs,u),"Stand");
            osAvatarStopAnimation(llList2Key(userIDs,u),llList2String(animList,animInd));
            userIDs=llDeleteSubList(userIDs,u,u);
        }
    }
    if (llGetListLength(userIDs)<1)
    {
        llSensorRemove();
        if (debug) llSetText("Ready",<1,0,0>,1.0);
    }
}
positionUpdate(float zRotation,key who)
{
    vector pos=sitOffset;
    vector size = llGetAgentSize(who);
    integer linkNum = llGetNumberOfPrims();
    do
    {
        if(who == llGetLinkKey( linkNum ))
        {
            rotation rot=llEuler2Rot(<0,0,zRotation>*DEG_TO_RAD);
            float fAdjust = ((((0.008906 * size.z) + -0.049831) * size.z) + 0.088967) * size.z;
            vector newPos=((pos + <0.0, 0.0, 0.4>) - (<0.0,0.0,1.0> * fAdjust))*rot;
            llSetLinkPrimitiveParamsFast(linkNum, [PRIM_POS_LOCAL,newPos,PRIM_ROT_LOCAL, rot]);
            jump end;
        }
    }while( --linkNum );
    @end;
}
doBuildAnimationList()
{
    animList=[];
    integer i=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--i>-1)
    {
        string name=llGetInventoryName(INVENTORY_ANIMATION,i);
        string desc=osGetInventoryDesc(name);
        integer ev=llSubStringIndex(desc,">");
        vector off=ZERO_VECTOR;
        float time=30.0;
        if (ev>=6)  // expected
        {
            off=(vector)llGetSubString(desc,0,ev);
            time=(float)llGetSubString(desc,ev+1,-1);
            if (time<=0) time=30.0;
        }
        animList=[]+animList+[name,off,time];
    }
    if (animRandomOrder) animList=llListRandomize(animList,3);
    else animList=llListSort(animList,3,TRUE);
    animInd=llGetListLength(animList);
    if (debug) llOwnerSay("Found "+(string)(animInd/3)+" animations");
    animInd-=3;
    if (llGetListLength(animList)<3) llOwnerSay("ERROR! Did not find any animations in inventory! Please add some and reset the script");
}
showMainMenu()
{
    list butDia;
    if (showCage) butDia=[]+["Hide Cage"];
    else butDia=[]+["Show Cage"];
    if (showGantry) butDia=[]+butDia+["Hide Gantry"];
    else butDia=[]+butDia+["Show Gantry"];
    if (showFixtures) butDia=[]+butDia+["Hide fixtures"];
    else if (showCage || showGantry) butDia=[]+butDia+["Show fixtures"];
    else butDia=[]+butDia+["-"];
    if (fogOn) butDia=[]+butDia+["Basefog off"];
    else butDia=[]+butDia+["Basefog on"];
    if (potJetsOn) butDia=[]+butDia+["Potsfog off"];
    else butDia=[]+butDia+["Potsfog on"];
    if (topFogOn) butDia=[]+butDia+["Topfog off"];
    else butDia=[]+butDia+["Topfog on"];
    if (spotsOn) butDia=[]+butDia+["Spots off"];
    else butDia=[]+butDia+["Spots on"];
    butDia=[]+butDia+["DONE","RESET"];
    handle=llListen(myChannel,"",diaUser,"");
    llDialog(diaUser,"Select an action",butDia,myChannel);
    diaTimeout=59.9;
}
doSetLights()
{
    list spotInd;   // list of the 4 colour indexes to use for the spotlights this time
    list potInd;    // list of the 8 colour indexes to use for the potlights this time
    integer oppositeIndex=(integer)(llListFindList(colourList,[llList2String(colourList,(indexColour*4)+3)])/4); // this is the defined opposite colour of the current colour index
    // first determine what to set the spotlights to
    string thisMethod=llList2String(methods,indexMethod);
    if (thisMethod=="UNIFORM") spotInd=[indexColour,indexColour,indexColour,indexColour];
    else if (thisMethod=="SIDE") spotInd=[indexColour,indexColour,oppositeIndex,oppositeIndex];
    else if (thisMethod=="CROSS") spotInd=[indexColour,oppositeIndex,indexColour,oppositeIndex];
    else if (thisMethod=="RANDOM")
    {
        spotInd=[indexColour];
        integer maxInd=(llGetListLength(colourList)/4)-1;
        integer newRand=(integer)(llFrand(maxInd+1)); // left the -1 in maxInd and +1 here just to remind myself that I'm doing it right
        while (llGetListLength(spotInd)<4)
        {
            while(llListFindList(spotInd,[newRand])>-1)
            {
                newRand=(integer)(llFrand(maxInd+1));
            }
            spotInd+=[newRand];
        }
    }
    // now pots
    if (thisMethod=="RANDOM")
    {
        potInd=[indexColour];
        integer maxPotInd=(llGetListLength(colourList)/4)-1;
        integer newPotRand=(integer)(llFrand(maxPotInd+1));
        while (llGetListLength(potInd)<8)
        {
            while(llListFindList(potInd,[newPotRand])>-1)
            {
                newPotRand=(integer)(llFrand(maxPotInd+1));
            }
            potInd+=[newPotRand];
        }
    }
    else potInd=[llList2Integer(spotInd,0),llList2Integer(spotInd,0),llList2Integer(spotInd,1),llList2Integer(spotInd,1),llList2Integer(spotInd,2),llList2Integer(spotInd,2),llList2Integer(spotInd,3),llList2Integer(spotInd,3)];
    // at this point spotInd and potInd contain the list of colour index values for their lights so set them
    if (spotsOn)
    {
        integer s;
        while(s<4)
        {
            llSetLinkPrimitiveParamsFast(llList2Integer(linkSpots,s),[
                    PRIM_COLOR, ALL_SIDES, llList2Vector(colourList,(llList2Integer(spotInd,s)*4) + 1),1.0*(float)showFixtures,
                    PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                    PRIM_GLOW, ALL_SIDES, lightGlow*(float)showFixtures,
                    PRIM_POINT_LIGHT, TRUE, llList2Vector(colourList,(llList2Integer(spotInd,s)*4) + 1), llList2Float(colourList,(llList2Integer(spotInd,s)*4) + 2), radius, falloff
                ]);
            s++;
        }
    }
    integer p;
    while(p<8)
    {
        llSetLinkPrimitiveParamsFast(llList2Integer(linkPots,p),[
                PRIM_COLOR, ALL_SIDES, llList2Vector(colourList,(llList2Integer(potInd,p)*4) + 1),1.0,
                PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                PRIM_GLOW, ALL_SIDES, lightGlow
            ]);
        p++;
    }
}
doSetParticles()
{
    if (fogOn) llLinkParticleSystem(linkPlatform,particleBaseSet);
    else llLinkParticleSystem(linkPlatform,[]);
    if (topOn) llLinkParticleSystem(linkTopBall,particleTopSet);
    else llLinkParticleSystem(linkTopBall,[]);
    list rulesForPots=[];
    if (potOn) rulesForPots=particlePotsSet;
    integer i=llGetListLength(linkPots);
    while (--i>=0) { llLinkParticleSystem(llList2Integer(linkPots,i),rulesForPots); }
}
doBuildLinkLists()
{
    integer i=llGetNumberOfPrims();
    {
        while (i)
        {
            string name=llGetLinkName(i);
            if (name=="platform") linkPlatform=i;
            else if (name=="poletop") linkTopBall=i;
            else if (name=="gantry") linkGantry=i;
            else if (name=="fixtures") linkFixtures=i;
            else if (name=="cage") linkCage=i;
            else if (llListFindList(linkPots,[name])>=0) linkPots=[]+llListReplaceList(linkPots,[i],llListFindList(linkPots,[name]),llListFindList(linkPots,[name]));
            else if (llListFindList(linkSpots,[name])>=0) linkSpots=[]+llListReplaceList(linkSpots,[i],llListFindList(linkSpots,[name]),llListFindList(linkSpots,[name]));
            i--;
        }
        doUpdateVisible();
    }
}
doUpdateVisible()
{
    llSetLinkAlpha(linkCage,(float)showCage,ALL_SIDES);
    llSetLinkAlpha(linkGantry,(float)showGantry,ALL_SIDES);
    llSetLinkAlpha(linkFixtures,(float)showFixtures,ALL_SIDES);
    integer i;
    while (i<llGetListLength(linkSpots))
    {
        llSetLinkAlpha(llList2Integer(linkSpots,i+1),(float)showFixtures,ALL_SIDES);
        i+=2;
    }
}
default
{
    state_entry()
    {
        if (maxUsers==0)
        {
            llOwnerSay("ERROR! Maximum users is set at 0 which doesn't allow anyone to use this. Setting it to 1 instead.");
            maxUsers=1;
        }
        userIDs=[];
        doBuildAnimationList();
        if (sitOffset==ZERO_VECTOR) sitOffset=<0,0,0.000001>;
        llSitTarget(sitOffset,ZERO_ROTATION);
        llSetClickAction(CLICK_ACTION_SIT);
        diaUser=NULL_KEY;
        myChannel=0x80000000|(integer)("0x"+(string)llGetKey());
        if (showCage) showGantry=FALSE;
        else if (!showGantry) showFixtures=FALSE;
        if (!spotsOn)
        {
            showGantry=FALSE;
            showFixtures=FALSE;
        }
        doBuildLinkLists();
        if (randomOrder) colourList=[]+llListRandomize(colourList,4);
        if (potJetsOn) potChange=llGetTime()+potsTime;
        if (topFogOn) topChange=llGetTime()+topTime;
        doSetParticles();
        doSetLights();
        llSetTimerEvent(masterTimer);
        if (debug) llSetText("Ready",<1.0,0.0,0.0>,1.0);
        else llSetText("",<0,0,0>,0.0);
    }
    sensor(integer num)
    {
        llOwnerSay("ERROR! Sensor returned a result which should be impossible! Animations disabled");
        llSensorRemove();
        llSetText("ERROR!!!",<1,0,0>,1.0);
    }
    no_sensor() // expected result
    {
        playNextAnim();
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
    timer()
    {
        // particle handling
        integer doChange=FALSE;
        float now=llGetTime();
        if (potJetsOn)
        {
            if (now>=potChange)
            {
                doChange=TRUE;
                potOn=!potOn;
                if (potOn) potChange=now+potsDuration;
                else potChange=now+potsTime;
            }
        }
        if (topFogOn)
        {
            if (now>=topChange)
            {
                doChange=TRUE;
                topOn=!topOn;
                if (topOn) topChange=now+topDuration;
                else topChange=now+topTime;
            }
        }
        if (doChange) doSetParticles();
        // lighting effects
        indexColour++;
        if (indexColour*4>=llGetListLength(colourList))
        {
            indexColour=0;
            indexMethod++;
            if (indexMethod>=llGetListLength(methods))
            {
                indexMethod=0;
                if (randomOrder) colourList=[]+llListRandomize(colourList,4);
            }
        }
        doSetLights();
        if (diaTimeout>0.0) diaTimeout-=masterTimer;
        if (diaTimeout<0.0)
        {
            diaTimeout=0.0;
            llRegionSayTo(diaUser,0,"Sorry, the dialog has timed out. Please touch me again to get the dialog back");
            diaUser=NULL_KEY;
            llListenRemove(handle);
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_REGION_START) llResetScript();
        if (change & CHANGED_LINK)
        {
            if(llGetAttached()) return;
            list sitters;
            integer link=llGetNumberOfPrims();
            while(link)
            {
                if (llGetAgentSize(llGetLinkKey(link))!=ZERO_VECTOR) sitters+=[llGetLinkKey(link)];
                else link=1;
                link--;
            }
            if (llGetListLength(sitters)==0) stopAnimations();
            else
            {
                if (llGetListLength(sitters)>maxUsers)
                {
                    integer s=llGetListLength(sitters);
                    while (--s>-1)
                    {
                        if (llListFindList(userIDs,[llList2Key(sitters,s)])==-1)
                        {
                            llRegionSayTo(llList2Key(sitters,s),0,"Sorry, the pole is already at its maximum allowed number of users");
                            llUnSit(llList2Key(sitters,s));
                            llDeleteSubList(sitters,s,s);
                        }
                    }
                }
                else
                {
                    stopAnimations();
                    userIDs=[]+sitters;
                    startAnimations();
                }
            }
        }
    }
    touch_start(integer num)
    {
        if (diaUser==NULL_KEY)
        {
            if (ownerOnlyMenu && (llDetectedKey(0)!=llGetOwner()))
            {
                llRegionSayTo(llDetectedKey(0),0,"Sorry, only the owner can access the settings");
                return;
            }
            diaUser=llDetectedKey(0);
            showMainMenu();
        }
        else
        {
            if (llDetectedKey(0)!=diaUser)
            {
                llRegionSayTo(llDetectedKey(0),0,"Sorry, someone else is already using the dialog");
                return;
            }
            else showMainMenu();
        }
    }
    listen(integer channel, string name, key who, string message)
    {
        diaTimeout=0.0;
        llListenRemove(handle);
        if (message=="DONE") return;
        else if (message=="-") return;
        else if (message=="RESET") llResetScript();
        else if (message=="Hide Cage")
        {
            showCage=FALSE;
            showFixtures=FALSE;
            doUpdateVisible();
            doSetLights();
        }
        else if (message=="Show Cage")
        {
            showCage=TRUE;
            showGantry=FALSE;
            doUpdateVisible();
            doSetLights();
        }
        else if (message=="Hide Gantry")
        {
            showGantry=FALSE;
            showFixtures=FALSE;
            doUpdateVisible();
            doSetLights();
        }
        else if (message=="Show Gantry")
        {
            showGantry=TRUE;
            showFixtures=TRUE;
            showCage=FALSE;
            doUpdateVisible();
            doSetLights();
        }
        else if (message=="Hide fixtures")
        {
            showFixtures=FALSE;
            showGantry=FALSE;
            doUpdateVisible();
            doSetLights();
        }
        else if (message=="Show fixtures")
        {
            showFixtures=TRUE;
            if (!showCage) showGantry=TRUE;
            doUpdateVisible();
            doSetLights();
        }
        else if (message=="Basefog off")
        {
            fogOn=FALSE;
            doSetParticles();
        }
        else if (message=="Basefog on")
        {
            fogOn=TRUE;
            doSetParticles();
        }
        else if (message=="Potsfog off")
        {
            potJetsOn=FALSE;
            potOn=FALSE;
            doSetParticles();
        }
        else if (message=="Potsfog on")
        {
            potJetsOn=TRUE;
            potOn=TRUE;
            potChange=llGetTime()+potsDuration;
            doSetParticles();
        }
        else if (message=="Topfog off")
        {
            topFogOn=FALSE;
            topOn=FALSE;
            doSetParticles();
        }
        else if (message=="Topfog on")
        {
            topFogOn=TRUE;
            topOn=TRUE;
            topChange=llGetTime()+topDuration;
            doSetParticles();
        }
        else if (message=="Spots off")
        {
            spotsOn=FALSE;
            showFixtures=FALSE;
            showGantry=FALSE;
            doUpdateVisible();
            integer s;
            while(s<4)
            {
                llSetLinkPrimitiveParamsFast(llList2Integer(linkSpots,s),[
                        PRIM_COLOR, ALL_SIDES, <1.0,1.0,1.0>,1.0*(float)showFixtures,
                        PRIM_FULLBRIGHT, ALL_SIDES, FALSE,
                        PRIM_GLOW, ALL_SIDES, 0.0,
                        PRIM_POINT_LIGHT, FALSE, <0.0,0.0,0.0>,0.0, radius, falloff
                    ]);
                s++;
            }
       }
        else if (message=="Spots on")
        {
            spotsOn=TRUE;
            doSetLights();
        }
        showMainMenu();
   }
}