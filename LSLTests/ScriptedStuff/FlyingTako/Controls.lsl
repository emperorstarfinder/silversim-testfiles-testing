//Flying Tako Controls Script
//by Kanker Greenacre
//July 2005

//version settings
integer raceVersion=TRUE; integer practiceVersion=FALSE; integer motorVersion=FALSE;
//integer practiceVersion=TRUE; integer raceVersion=FALSE; integer motorVersion=FALSE;
//integer motorVersion=TRUE; integer practiceVersion=FALSE; integer raceVersion=FALSE;
string boatName="Flying Tako ";
string versionNumber="2.1";

//miscellaneous
key owner;//boat owner
key avatar;//person sitting at the helm
key kanker="7abbf31e-d601-4521-ae52-f7457d6e0012";
integer ownerVersion=TRUE;
integer SAIL_UP=FALSE;
integer permSet=FALSE;
integer HUD_ON=TRUE;
string idStr;
integer racing=FALSE;
integer numTouches=0;
integer sailing=TRUE;
integer motoring=FALSE;
list dataList;
integer phantom=FALSE;

//script module flags
integer CONTROLS_MODULE=1;
integer SAIL_MODULE=2;
integer MOTOR_MODULE=3;
integer COLORIZER_MODULE=4;

//reused math variables
vector eulerRot;
vector currEuler;
rotation quatRot;
rotation currRot;
vector fwdVec;
vector upVec;
vector leftVec;

//linear motion variables
float currSpeed;
vector groundSpeed=ZERO_VECTOR;
float spdFactor=0.0;
float leeway;
float rotSpeed=0.7;
float rotDelta;
vector eulerTurnLeft;
vector eulerTurnRight;
rotation quatTurnLeft=ZERO_ROTATION;
rotation quatTurnRight=ZERO_ROTATION;
float rotTweak=0.8;         //scales boat turning rate (80% for now)
float maxSpeedMotor=10.0;

//heeling variables
float heelAngle;
float heelTorque;
float heelAdd;

//environment
float seaLevel;
float windDir;              //we can set this in the practice version
float windSpeed;            //we can set this in the practice version

//linked parts
integer BOW;
integer HULL;
integer STERN;
integer SAIL;
integer WINDVANE;
integer PORTBENCH;
integer STARBOARDBENCH;
integer RUDDER;
integer TILLER;
integer CENTERBOARD;
integer FLOOR;
integer MAST;
integer TRANSOM;
integer REARFLOOR;
integer HUD;
integer NUMBER1;
integer NUMBER2;
integer PROP;

//wind algorithm parameters
float rate=1;
float avgAng=45;
float avgSpd=3;
float halfArc=0.2;
float spdRng=1;

///////////////////////////////////////////////////////////////////////////////////
//not for public release:
integer codeKey=0;
integer pingChannel=0;
integer secretChannel;
integer todaysChannel() {
    return 0;
}
///////////////////////////////////////////////////////////////////////////////////

//set initial vehicle parameters
setVehicleParams() {
    llSetVehicleType         (VEHICLE_TYPE_BOAT);
    llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME,ZERO_ROTATION);
    llSetVehicleFlags        (VEHICLE_FLAG_NO_DEFLECTION_UP|VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT
                             |VEHICLE_FLAG_LIMIT_MOTOR_UP ); 
    //linear motion
    llSetVehicleVectorParam  (VEHICLE_LINEAR_FRICTION_TIMESCALE,<50.0,2.0,0.5>);;
    llSetVehicleVectorParam  (VEHICLE_LINEAR_MOTOR_DIRECTION,ZERO_VECTOR);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_MOTOR_TIMESCALE,10.0);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE,60);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_DEFLECTION_EFFICIENCY,0.85);
    llSetVehicleFloatParam   (VEHICLE_LINEAR_DEFLECTION_TIMESCALE,1.0);
    //angular motion
    llSetVehicleVectorParam  (VEHICLE_ANGULAR_FRICTION_TIMESCALE,<5,0.1,0.1>);
    llSetVehicleVectorParam  (VEHICLE_ANGULAR_MOTOR_DIRECTION,ZERO_VECTOR);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_MOTOR_TIMESCALE,0.1);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE,3);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY,1.0);
    llSetVehicleFloatParam   (VEHICLE_ANGULAR_DEFLECTION_TIMESCALE,1.0);
    //vertical attractor
    llSetVehicleFloatParam   (VEHICLE_VERTICAL_ATTRACTION_TIMESCALE,3.0);
    llSetVehicleFloatParam   (VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY,0.8);
    //banking
    llSetVehicleFloatParam   (VEHICLE_BANKING_EFFICIENCY,0.0);
    llSetVehicleFloatParam   (VEHICLE_BANKING_MIX,0.8);
    llSetVehicleFloatParam   (VEHICLE_BANKING_TIMESCALE,1);
    //vertical control
    llSetVehicleFloatParam   (VEHICLE_HOVER_HEIGHT,seaLevel);
    llSetVehicleFloatParam   (VEHICLE_HOVER_EFFICIENCY,2.0);
    llSetVehicleFloatParam   (VEHICLE_HOVER_TIMESCALE,1.0);
    llSetVehicleFloatParam   (VEHICLE_BUOYANCY,1.0);
}

setVehicleParamsMotor() {
    //vertical attractor
    llSetVehicleFloatParam   (VEHICLE_VERTICAL_ATTRACTION_TIMESCALE,1.0);
    llSetVehicleFloatParam   (VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY,0.8);
    //banking
    llSetVehicleFloatParam   (VEHICLE_BANKING_EFFICIENCY,1.0);
    llSetVehicleFloatParam   (VEHICLE_BANKING_MIX,1.0);
    llSetVehicleFloatParam   (VEHICLE_BANKING_TIMESCALE,1);    
}

//automatically detect link nums for each named part
getLinkNums() {
    integer i;
    integer linkcount=llGetNumberOfPrims();  
    for (i=1;i<=linkcount;++i) {
        string str=llGetLinkName(i);
        if (str=="bow") BOW=i;
        if (str=="hull") HULL=i;
        if (str=="stern") STERN=i;
        if (str=="sail") SAIL=i;
        if (str=="mast") MAST=i;
        if (str=="windindicator") WINDVANE=i;
        if (str=="floor") FLOOR=i;
        if (str=="transom") TRANSOM=i;
        if (str=="tiller") TILLER=i;
        if (str=="rudder") RUDDER=i;
        if (str=="centerboard") CENTERBOARD=i;
        if (str=="starboardbench") STARBOARDBENCH=i;
        if (str=="portbench") PORTBENCH=i;
        if (str=="rearfloor") REARFLOOR=i;
        if (str=="hud") HUD=i;
        if (str=="number1") NUMBER1=i;
        if (str=="number2") NUMBER2=i;
        if (str=="prop") PROP=i;          
    }
}

//set camera position for third person view
setCamera() {
    llSetCameraEyeOffset(<-11,0,11>);
    llSetCameraAtOffset(<3,0,3.5>);    
}

//figure out where to put boat when it is rezzed
setInitialPosition() {
    vector pos=llGetPos();
    float groundHeight=llGround(ZERO_VECTOR);
    float waterHeight = llWater(ZERO_VECTOR);
    seaLevel=llWater(ZERO_VECTOR);
    upright();
    if (llGetRegionName()=="Gray" && owner==kanker)
    //if (FALSE)
    {
        rotation initRot=llEuler2Rot(<0,0,225*DEG_TO_RAD>);
        //llSetRot(ZERO_ROTATION);
        vector initPos;
        if (raceVersion) initPos=<36.934,142.546,20.1>;//starting position at my dock
        if (practiceVersion) initPos=<40.046,139.434,20.1>;//starting position at my dock - practice version
        if (motorVersion) initPos=<33.728,145.8,20.1>;
        //initPos=<21,150,20.1>;//test position out in the water
        if (llVecDist(llGetPos(),initPos)<2.0) {
            llSetRot(initRot);
            while (llVecDist(llGetPos(),initPos)>.001) llSetPos(initPos);
        }
        else {
            //if over water, set boat height to sealevel + 0.12m
            if (groundHeight<=waterHeight) {
                pos.z=waterHeight+0.12;
                while (llVecDist(llGetPos(),pos)>.001) llSetPos(pos);
            }            
        }
    }
    else { 
        //if over water, set boat height to sealevel + 0.12m;
        if (groundHeight <= waterHeight) {
            pos.z = waterHeight + 0.12;
            while (llVecDist(llGetPos(),pos)>.001) llSetPos(pos);
        }
    }
}

//set sit target for helmsperson
setSitTarget() {
    llSetSitText("Sit");
    rotation avRot=llEuler2Rot(<0,0,PI_BY_TWO>);
    llSitTarget(<-1.4,-0.45,0.7>,avRot);
    llSetText("",ZERO_VECTOR,1.0);
}

//force boat upright
upright() {
    currRot=llGetRot();
    currEuler=llRot2Euler(currRot);
    leftVec=llRot2Left(currRot);
    heelAngle=llAsin(leftVec.z);
    eulerRot=<-heelAngle,0,0>;
    quatRot=llEuler2Rot(eulerRot);
    llRotLookAt(quatRot*currRot,0.2,0.2);
}

//not sure if i can use this yet
moor() {
    llMessageLinked(LINK_THIS,SAIL_MODULE,"moor",NULL_KEY);
    llMessageLinked(LINK_THIS,MOTOR_MODULE,"off",NULL_KEY);
    llOwnerSay("Mooring.");
    if (permSet) llStopAnimation("helm");
    upright();
    llReleaseControls();
    llSetStatus(STATUS_PHYSICS,FALSE);
    llSetTimerEvent(0);
    currSpeed=0;
    //llResetScript();
}

//reset stuff
startup() {
    owner=llGetOwner();
    llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Z | STATUS_ROTATE_Y,TRUE);
    llSetStatus(STATUS_PHYSICS,FALSE);
    llSetStatus(STATUS_PHANTOM,FALSE);
    llSetStatus(STATUS_BLOCK_GRAB,TRUE);
    llSetTimerEvent(0);
    setInitialPosition();
    setVehicleParams();
    setSitTarget();
    getLinkNums();                               
    llMessageLinked(HUD,1000,"",NULL_KEY);      //reset HUD
    llMessageLinked(SAIL,1000,"",NULL_KEY);     //reset sail
    llMessageLinked(WINDVANE,1000,"",NULL_KEY); //turn off windindicator
    setCamera();
    currSpeed=0;
    if (practiceVersion) {
        windDir=45*DEG_TO_RAD;
        windSpeed=3;
        llSetLinkColor(MAST,<0.3,0.3,0.3>,ALL_SIDES);
        string tmp=boatName+versionNumber+" Touring";
        llSetObjectName(tmp);
        if (owner==kanker) llMessageLinked(LINK_THIS,COLORIZER_MODULE,"color lemon",NULL_KEY);
    }
    if (raceVersion) {
        idStr=llGetObjectDesc();
        string tmp=boatName+versionNumber+" Racing";
        if (idStr!="(No Description)" & idStr!="") {
            tmp+=" #"+idStr;
            llSetObjectName(tmp);
        }
        else llSetObjectName(tmp);
        llSetLinkColor(MAST,<0.9,0.9,0.9>,ALL_SIDES);
        if (owner==kanker) llMessageLinked(LINK_THIS,COLORIZER_MODULE,"color <0.2,0.6,0.7>",NULL_KEY);
    }
    if (motorVersion) {
        string tmp="Motor Tako "+versionNumber;
        llSetObjectName(tmp);
        llSetLinkColor(MAST,<1.0,1.0,1.0>,ALL_SIDES);
        if (owner==kanker) llMessageLinked(LINK_THIS,COLORIZER_MODULE,"color green",NULL_KEY);
        //llSetLinkColor(MAST,<0.35,0.5,0.6>,ALL_SIDES);
    }
    llMessageLinked(LINK_THIS,SAIL_MODULE,"reset",NULL_KEY);
    llMessageLinked(LINK_THIS,MOTOR_MODULE,"reset",NULL_KEY);
    llMessageLinked(LINK_THIS,COLORIZER_MODULE,"reset",NULL_KEY);
    llListen(0,"",owner,"");
    if (raceVersion) llListen(pingChannel,"",NULL_KEY,"");
    llOwnerSay("Ready.");
    //llOwnerSay("free memory: "+(string)llGetFreeMemory());
}



//////////////////////////////////////////////////////////////////////////////////////////////
//state default///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

default {
    
    state_entry() {
        startup();
        llSetStatus(STATUS_BLOCK_GRAB,TRUE);
    }
    
    on_rez(integer param) {
        //reset();
        llResetScript();
    }

    changed(integer change) {
        avatar=llAvatarOnSitTarget();
        if (change & CHANGED_LINK) {
            if (avatar==NULL_KEY) {
                if (!(llGetAgentInfo(owner) & AGENT_ON_OBJECT)) {
                    llMessageLinked(WINDVANE,1000,"",NULL_KEY);//turn off windindicator
                    if (SAIL_UP) {
                        llOwnerSay("Mainsail lowered.");
                        llMessageLinked(LINK_THIS,SAIL_MODULE,"changed",NULL_KEY);
                    }
                    if (permSet) llStopAnimation("helm");
                    if (permSet) llReleaseControls();
                    permSet=FALSE;
                    llResetScript();
                }
           }
           else {
                if (ownerVersion && avatar!=owner) llWhisper(0,"Only the owner can operate this boat.");
                else if ((llGetAgentInfo(owner) & AGENT_ON_OBJECT)) {
                    //llMessageLinked(WINDVANE,4,"",NULL_KEY);//turn on windindicator
                    llWhisper(0,"Say 'notecard' for instructions or 'raise' to start sailing.");
                    if (llAvatarOnSitTarget()==owner) llRequestPermissions(owner,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);          
                }              
            }
        }
    }    
            
    listen(integer channel, string name, key id, string msg) {
        if (channel==0) {
            if (owner==id & llAvatarOnSitTarget()==owner) {
                if (llGetAgentInfo(owner) & AGENT_ON_OBJECT) {
                    if (llGetSubString(msg,0,4)=="sheet") {
                        llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                    }
                    else if (msg=="raise") {
                        sailing=TRUE;
                        motoring=FALSE;
                        if (!permSet) llRequestPermissions(owner,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                        permSet=TRUE;
                        llStartAnimation("helm");
                        llSetStatus(STATUS_PHYSICS,TRUE);
                        llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                        llMessageLinked(LINK_THIS,MOTOR_MODULE,"off",NULL_KEY);
                        //if (practiceVersion) llMessageLinked(WINDVANE,2000+llRound(windDir),"",NULL_KEY);
                        //else llMessageLinked(WINDVANE,4,"",NULL_KEY);
                        
                    }
                    else if (msg=="lower") llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                    else if (llGetSubString(msg,0,4)=="color") llMessageLinked(LINK_THIS,COLORIZER_MODULE,msg,NULL_KEY);
                    else if (msg=="moor") {
                        moor();
                        llResetScript();
                    }
                    else if (llGetSubString(msg,0,3)=="vane") {
                        if (llGetSubString(msg,5,-1)=="off") llMessageLinked(WINDVANE,1000,"",NULL_KEY);
                        else if (llGetSubString(msg,5,-1)=="on") {
                            if (practiceVersion) llMessageLinked(WINDVANE,2000+llRound(windDir),"",NULL_KEY);
                            else llMessageLinked(WINDVANE,4,"",NULL_KEY);
                        }
                    }
                    else if (llGetSubString(msg,0,3)=="anim") {
                        if (llGetSubString(msg,5,-1)=="off") {
                            if (permSet) llStopAnimation("helm");
                        }
                        else if (llGetSubString(msg,5,-1)=="on") {
                            if (permSet) llStartAnimation("helm");
                        }
                    } 
                    else if (llGetSubString(msg,0,7)=="wind dir") {
                        if (!raceVersion) {
                            windDir=(float)llGetSubString(msg,8,-1);
                            string str="windparams "+(string)windDir+" "+(string)windSpeed+" "+(string)halfArc+" "+(string)spdRng+" "+(string)rate;
                            llMessageLinked(LINK_THIS,SAIL_MODULE,str,NULL_KEY);
                        }
                    }
                    else if (llGetSubString(msg,0,7)=="wind spd") {
                        if (!raceVersion) {
                            windSpeed=(float)llGetSubString(msg,8,-1);
                            string str="windparams "+(string)windDir+" "+(string)windSpeed+" "+(string)halfArc+" "+(string)spdRng+" "+(string)rate;
                            llMessageLinked(LINK_THIS,SAIL_MODULE,str,NULL_KEY);
                        }
                    }
                    else if (llGetSubString(msg,0,4)=="dir+-") {
                        if (!raceVersion) {
                            halfArc=(integer)llGetSubString(msg,5,-1);
                            string str="windparams "+(string)windDir+" "+(string)windSpeed+" "+(string)halfArc+" "+(string)spdRng+" "+(string)rate;
                            llMessageLinked(LINK_THIS,SAIL_MODULE,str,NULL_KEY);
                        }
                    }
                    else if (llGetSubString(msg,0,4)=="spd+-") {
                        if (!raceVersion) {
                            spdRng=(float)llGetSubString(msg,5,-1);
                            string str="windparams "+(string)windDir+" "+(string)windSpeed+" "+(string)halfArc+" "+(string)spdRng+" "+(string)rate;
                            llMessageLinked(LINK_THIS,SAIL_MODULE,str,NULL_KEY);
                        }
                    }
                    else if (llGetSubString(msg,0,3)=="rate") {
                        if (!raceVersion) {
                            rate=(float)llGetSubString(msg,4,-1);
                            string str="windparams "+(string)windDir+" "+(string)windSpeed+" "+(string)halfArc+" "+(string)spdRng+" "+(string)rate;
                            llMessageLinked(LINK_THIS,SAIL_MODULE,str,NULL_KEY);
                        }
                    }
                    else if (llGetSubString(msg,0,1)=="id") {
                        if (raceVersion) {
                            llMessageLinked(LINK_THIS,COLORIZER_MODULE,msg,NULL_KEY);
                            if (llGetSubString(msg,3,-1)!="off") {
                                idStr=llGetSubString(msg,3,-1);
                                string tmp=boatName+" #"+idStr;
                                llSetObjectName(tmp);
                                llSetObjectDesc(idStr);
                            }
                        }
                    }
                    else if (msg=="hud") {
                        if (sailing) llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                        else llMessageLinked(LINK_THIS,MOTOR_MODULE,msg,NULL_KEY);
                    }
                    else if (llGetSubString(msg,0,4)=="alpha") llMessageLinked(LINK_THIS,COLORIZER_MODULE,msg,NULL_KEY);
                    else if (msg=="motor") {
                        if (motorVersion) {
                            if (!permSet) llRequestPermissions(owner,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);  
                            permSet=TRUE;
                            llStartAnimation("helm");
                            llSetStatus(STATUS_PHYSICS,TRUE);
                            llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                            llMessageLinked(LINK_THIS,MOTOR_MODULE,msg,NULL_KEY);
                            motoring=TRUE;
                            sailing=FALSE;
                            llMessageLinked(WINDVANE,1000,"",NULL_KEY); //turn off wind indicator
                            setVehicleParamsMotor();
                            llOwnerSay("Motoring");
                        }
                        else llOwnerSay("No motor!");
                    }
                    else if (msg=="off") {
                        if (motorVersion) {
                            sailing=TRUE;
                            motoring=FALSE;
                            setVehicleParams();
                            if (practiceVersion) llMessageLinked(WINDVANE,2000+llRound(windDir),"",NULL_KEY);
                            else llMessageLinked(WINDVANE,4,"",NULL_KEY);
                            llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                            llMessageLinked(LINK_THIS,MOTOR_MODULE,msg,NULL_KEY);                   
                        }
                    }
                    else if (msg=="knots") {
                        llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                        llMessageLinked(LINK_THIS,MOTOR_MODULE,msg,NULL_KEY);
                    }
                    if (msg=="register") {
                        if (raceVersion) {
                            integer chan=todaysChannel();
                            llShout(pingChannel,"ping");
                            llSleep(2.0);
                            string regPacket=idStr+","+(string)llGetOwner();
                            llShout(chan,regPacket);
                        }
                        else {
                            llSay(0,"Your boat is not race legal and cannot be registered.");
                        }
                    }
                    else if (msg=="pp") {
                        if (!raceVersion) {
                            if (!phantom) {
                                llOwnerSay("phantom ON");
                                llSetStatus(STATUS_PHANTOM,TRUE);
                                phantom=TRUE;
                            }
                            else {
                                llOwnerSay("phantom OFF");
                                llSetStatus(STATUS_PHANTOM,FALSE);
                                phantom=FALSE;
                            }
                        }
                    }
                    else if (msg=="practice") {
                        if (!raceVersion) llMessageLinked(LINK_THIS,SAIL_MODULE,msg,NULL_KEY);
                    }             
                }
            }
            if (msg=="notecard") {
                llGiveInventory(id,"Sailing the Tako");
                llGiveInventory(id,"Instructions");
            } 
        }
        else if (channel==pingChannel) {
            secretChannel=todaysChannel();
            llListen(secretChannel,"",NULL_KEY,"");
        }
        else if (channel==secretChannel) {
            string str="windparams "+msg;
            llMessageLinked(LINK_THIS,SAIL_MODULE,str,NULL_KEY);            
        }
    }    
    
    run_time_permissions(integer perms) {
        if (perms & (PERMISSION_TAKE_CONTROLS)) {
            llTakeControls(CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT |
            CONTROL_ROT_LEFT | CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP,TRUE,FALSE);
            permSet=TRUE;
        }
    }
    
    control(key id, integer held, integer change) {
        //turning controls
        if ( (change & held & CONTROL_LEFT) || (held & CONTROL_LEFT) || (change & held & CONTROL_ROT_LEFT) || (held & CONTROL_ROT_LEFT) ) {
            if (sailing) llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<rotSpeed/2.0,0.0,rotSpeed>);
            else llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<-rotSpeed,0.0,rotSpeed/1.5>);
        }
        else if ( (change & held & CONTROL_RIGHT) || (held & CONTROL_RIGHT) || (change & held & CONTROL_ROT_RIGHT) || (held & CONTROL_ROT_RIGHT) ) {
            if (sailing) llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<-rotSpeed/2.0,0.0,-rotSpeed>);
            else llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<rotSpeed,0.0,-rotSpeed/1.5>);
        }
        else if ( (change & ~held & CONTROL_LEFT) || (change & ~held & CONTROL_ROT_LEFT) ) {
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<0.0,0.0,0.0>);
        }
        else if ( (change & ~held & CONTROL_RIGHT) || (change & ~held & CONTROL_ROT_RIGHT) ) {
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<0.0,0.0,0.0>);
        }
        //sail/throttle controls
        if ( (held & CONTROL_FWD) && (held & CONTROL_UP) ) {
            if (sailing) llMessageLinked(LINK_THIS,SAIL_MODULE,"fwd_big",NULL_KEY);
            else {
                currSpeed+=0.3;
                if (currSpeed>maxSpeedMotor) currSpeed=maxSpeedMotor;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,0,0>);
                llMessageLinked(LINK_THIS,MOTOR_MODULE,"fwd",NULL_KEY);                
            }
        }
        else if ( (held & CONTROL_FWD) || (change & held & CONTROL_FWD) ) {
            if (sailing) llMessageLinked(LINK_THIS,SAIL_MODULE,"fwd_small",NULL_KEY);
            else {
                currSpeed+=0.3;
                if (currSpeed>maxSpeedMotor) currSpeed=maxSpeedMotor;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,0,0>);
                llMessageLinked(LINK_THIS,MOTOR_MODULE,"fwd",NULL_KEY);                
            }
        }
        else if ( (held & CONTROL_BACK) && (held & CONTROL_UP) ) {
            if (sailing) llMessageLinked(LINK_THIS,SAIL_MODULE,"back_big",NULL_KEY);
            else {
                currSpeed-=0.3;
                if (currSpeed<-2) currSpeed=-2;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,0,0>);
                llMessageLinked(LINK_THIS,MOTOR_MODULE,"back",NULL_KEY);                  
            }
        }
        else if ( (held & CONTROL_BACK) || (change & held & CONTROL_BACK) ) {
            if (sailing) llMessageLinked(LINK_THIS,SAIL_MODULE,"back_small",NULL_KEY);
            else {
                currSpeed-=0.3;
                if (currSpeed<-2) currSpeed=-2;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,0,0>);
                llMessageLinked(LINK_THIS,MOTOR_MODULE,"back",NULL_KEY);                  
            }
        }
        //motor to idle
        if ( (change & held & CONTROL_DOWN ) ) {
            if (motoring) {
                currSpeed=0.0;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<0,0,0>);
                llMessageLinked(LINK_THIS,MOTOR_MODULE,"idle",NULL_KEY);                
            }
        }
    }    
    
    link_message(integer from,integer to,string str,key id) {
        if (to==CONTROLS_MODULE) {
            dataList=llCSV2List(str);
            currSpeed=llList2Float(dataList,0);
            leeway=llList2Float(dataList,1);
            rotSpeed=rotTweak*llList2Float(dataList,2);
            heelTorque=5*llList2Float(dataList,3);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION,<currSpeed,leeway,0>);
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION,<heelTorque,0.0,0.0>);
        }
    }

}