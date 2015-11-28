//Flying Tako Sail Script
//by Kanker Greenacre
//July 2005

//version settings
integer raceVersion=TRUE; integer practiceVersion=FALSE; integer motorVersion=FALSE; integer olympicVersion=FALSE;
//integer practiceVersion=TRUE; integer raceVersion=FALSE; integer motorVersion=FALSE; integer olympicVersion=FALSE;
//integer olympicVersion=TRUE; integer motorVersion=FALSE; integer practiceVersion=FALSE; integer raceVersion=FALSE;
string boatName="Flying Tako ";
string versionNumber="2.1";

//script module flags
integer CONTROLS_MODULE=1;
integer SAIL_MODULE=2;
integer MOTOR_MODULE=3;
integer COLORIZER_MODULE=4;

//environment
vector wind;
float windAngle;
float absWindAngle;
float depth;
float seaLevel;

//reused math variables
vector eulerRot;
vector currEuler;
rotation quatRot;
rotation currRot;

//boat variables
float zRotAngle;
vector fwdVec;
vector upVec;
vector leftVec;
float compass;

//heeling variables
float heelAngle;
float heelTorque;
float heelAdd;

//linear motion variables
float currSpeed;
vector groundSpeed=ZERO_VECTOR;
float spdFactor=0.0;
float leeway;

//angular motion variables
float rotSpeed;
float rotDelta;
vector eulerTurnLeft;
vector eulerTurnRight;
rotation quatTurnLeft=ZERO_ROTATION;
rotation quatTurnRight=ZERO_ROTATION;

//sail variables
integer boomAngle;
integer currBoomAngle=0;
integer delta;
integer incr;
float optBoomAngle;
float trimFactor;

//performance constants
float timerFreq=1.5;        //timer frequency, seconds
float maxSpeed=10.0;        //maximum allowed speed
integer sheetAngle=5;       //initial sheet angle setting
integer ironsAngle=35;      //this is as close as the boat can sail to the wind
float slowingFactor=0.7;    //speed drops by this factor every timerFreq seconds if sailing into the wind
float leewayTweak=0.5;      //scales leeway (0=no leeway)
float speedTweak=1.0;       //scales speed
float rotTweak=5.0;         //scales boat turning rate
float heelTweak=0.5;        //scales amount of heeling
float maxWindSpeed=14.0;    //used for heeling calculation
float windDir;              //we can set this in the practice version
float windSpeed;            //we can set this in the practice version

//motor settings
integer fromMotoring=FALSE;
float maxSpeedMotor=10.0;
float throttle=0;

//miscellaneous
string dataString;
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
float mpsToKts=1.944;
float convert=1;
string units=" m/s";
integer showKnots=FALSE;
float time;
float offset;
float theta;
integer practice=FALSE;

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
float angRate=10;
float avgAng=0;
float avgSpd=5;
float halfArc=0.2;
float spdRng=3;
integer raceWindOn=FALSE;

//prevailing wind algorithm
calcWindDir() {
    time=llGetTimeOfDay();
    theta=time/14400*TWO_PI*angRate;
    offset=llSin(theta)*llSin(theta*2)*llSin(theta*9)*llCos(theta*4);
    windDir=avgAng+halfArc*offset;
    llMessageLinked(WINDVANE,2000+llRound(windDir*RAD_TO_DEG),"",NULL_KEY);
}

calcWindSpd() {
    offset=llSin(theta)*llSin(theta*4)+llSin(theta*13)/3;
    windSpeed=avgSpd+spdRng*offset;
    if (windSpeed<0) windSpeed=0;   
}

//calculate wind relative to boat
calcWindAngle() {
    if (raceWindOn) {
        calcWindDir();
        calcWindSpd();
    }
    else {
        wind=llWind(ZERO_VECTOR);
        windDir=llAtan2(-wind.y,-wind.x);//direction wind is blowing FROM
        windSpeed=llVecMag(wind);
    }
    currRot=llGetRot();
    currEuler=llRot2Euler(currRot);
    zRotAngle=currEuler.z;//boat heading
    leftVec=llRot2Left(currRot);
    windAngle=windDir-zRotAngle;
    while (windAngle>PI) windAngle-=TWO_PI;//bw -PI and PI
    while (windAngle<-PI) windAngle+=TWO_PI;//bw -PI and PI    
}

//calculate heel angle based on wind and sail settings
calcHeelAngle() {
    heelAngle=llAsin(leftVec.z);
    if (SAIL_UP)
        if (llFabs(windAngle+boomAngle)>3*DEG_TO_RAD)
            heelTorque=SAIL_UP*llSin(windAngle)*llCos(heelAngle)*PI_BY_TWO*(windSpeed/maxWindSpeed)*llCos(boomAngle*DEG_TO_RAD)*heelTweak;
        else heelTorque=0;
    else heelTorque=0;
    heelAdd=heelTorque-heelAngle;
    eulerRot=<heelAdd,0,0>;
    quatRot=llEuler2Rot(eulerRot);
}

//calculate angle of sail (or boom) based on sheet setting and the wind
calcBoomDelta() {
    boomAngle=sheetAngle;
    if (boomAngle>llFabs(windAngle*RAD_TO_DEG)) boomAngle=llRound(llFabs(windAngle*RAD_TO_DEG));
    if (windAngle<0) boomAngle*=-1;
    delta=boomAngle-currBoomAngle;
    currBoomAngle=boomAngle;
    llMessageLinked(SAIL,delta,"",NULL_KEY);//tell sail to rotate by delta
}

//calculate boat speed
calcSpeed() {
    groundSpeed=llGetVel();
    absWindAngle=llFabs(windAngle);
    if (llFabs(absWindAngle*RAD_TO_DEG-llFabs(boomAngle))<10) trimFactor=0;
    else {
        optBoomAngle=0.5*absWindAngle*RAD_TO_DEG;
        trimFactor=(90.-llFabs(optBoomAngle-llFabs(boomAngle)))/90.;
    }
    if (absWindAngle<ironsAngle*DEG_TO_RAD) currSpeed*=slowingFactor;
    else {
        if (SAIL_UP) {
            currSpeed=speedTweak*(llCos(windAngle/2.)+0.5)*windSpeed*trimFactor;
            if (currSpeed>maxSpeed) currSpeed=maxSpeed;
        }
        else currSpeed*=0.8;
    }
}

//calculate leeway (lateral drift) due to wind
calcLeeway() {
    leeway=SAIL_UP*-llSin(windAngle)*llSin(heelAngle)*windSpeed*leewayTweak;    
}

//calculate turning rate based on current speed
calcTurnRate() {
    spdFactor=llVecMag(groundSpeed)/(maxSpeed);
    //rotSpeed=0.4-(spdFactor)*0.4;
    rotSpeed=0.5+(spdFactor)/2.0;
}

//gets depth of water below boat
calcDepth() {
    depth=llWater(ZERO_VECTOR)-llGround(ZERO_VECTOR);
}

//update heads-up display (in 1st and 3rd person view)
updateHUD() {
    compass=PI_BY_TWO-zRotAngle;
    while (compass<0) compass+=TWO_PI;
    calcDepth();
    dataString ="Heading:          "     +(string)((integer)(compass*RAD_TO_DEG))+" deg\n";
    dataString+="Wind Angle:       "  +(string)((integer)(windAngle*RAD_TO_DEG))+" deg\n";
    dataString+="Wind Speed:   "  +llGetSubString((string)(windSpeed*convert),0,3)+units+"\n";
    dataString+="Ground Speed: "+llGetSubString((string)(llVecMag(groundSpeed*convert)),0,3)+units+"\n";
    dataString+="Depth:             "       +llGetSubString((string)depth,0,3)+" m\n";
    dataString+="Sail Angle:         "  +(string)(-boomAngle)+" deg\n";
    dataString+="Sheet Angle:      " +(string)sheetAngle+" deg\n\n\n\n";
    llSetText(dataString,ZERO_VECTOR,1.0);
    llMessageLinked(HUD,1001,dataString,NULL_KEY);//sends data to HUD prim above and behind the boat
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

//raise sail: start timer
raiseSail() {
    SAIL_UP=TRUE;
    llOwnerSay("Raising mainsail.");
    llMessageLinked(SAIL,1002,"",NULL_KEY);
    llMessageLinked(WINDVANE,4,"",NULL_KEY);
    llSetTimerEvent(timerFreq);        
} 

//lower sail but leave physics on
lowerSail() {
    llOwnerSay("Lowering mainsail.");
    llMessageLinked(SAIL,1000,"",NULL_KEY);//lower sail w/ reset
    currBoomAngle=0;
    sheetAngle=5;
    SAIL_UP=FALSE; 
}


//////////////////////////////////////////////////////////////////////////////////////////////
//state default///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

default {
    
    state_entry() {
        getLinkNums();
        llSetText("",ZERO_VECTOR,1.0);
        llMessageLinked(HUD,1001,"",NULL_KEY);
        avgAng=300*DEG_TO_RAD;
        halfArc=18*DEG_TO_RAD;
    }
    
    on_rez(integer param) {
        raceWindOn=FALSE;
    }

    link_message(integer from,integer to,string msg,key id) {
        if (from==LINK_ROOT && to==SAIL_MODULE) {
            if (msg=="fwd_small") {
                sheetAngle+=2;
                if (sheetAngle>90) sheetAngle=90;     
            }
            else if (msg=="back_small") {
                sheetAngle-=2;
                if (sheetAngle<5) sheetAngle=5;       
            } 
            else if (msg=="fwd_big") {
                sheetAngle+=7;
                if (sheetAngle>90) sheetAngle=90;     
            }
            else if (msg=="back_big") {
                sheetAngle-=7;
                if (sheetAngle<5) sheetAngle=5;       
            }
            else if (llGetSubString(msg,0,4)=="sheet") {
                incr=(integer)llDeleteSubString(msg,0,4);
                sheetAngle+=incr;
                if (sheetAngle>90) sheetAngle=90;
            }
            else if (msg=="raise") raiseSail();
            else if (msg=="lower") lowerSail();
            else if (msg=="moor") {
                llSetTimerEvent(0);
                if (SAIL_UP) lowerSail();
            }
            else if (llGetSubString(msg,0,9)=="windparams") {
                if (!practiceVersion | practice) { 
                    list in=llParseString2List(msg,[" "],[""]);
                    avgAng=llList2Integer(in,1)*DEG_TO_RAD;
                    avgSpd=llList2Integer(in,2);
                    if (llGetListLength(in)==6) {
                        halfArc=llList2Integer(in,3)*DEG_TO_RAD;
                        spdRng=llList2Float(in,4);
                        angRate=llList2Integer(in,5)*10.0;
                    }
                    raceWindOn=TRUE;
                }
            }
            else if (msg=="hud") {
                if (HUD_ON) {
                    HUD_ON=FALSE;
                    llSetText("",ZERO_VECTOR,1.0);
                    llMessageLinked(HUD,1001,"",NULL_KEY);                        
                }
                else HUD_ON=TRUE;
            }
            else if (msg=="motor") {
                if (SAIL_UP) lowerSail();
                llSetTimerEvent(0);
                motoring=TRUE;
                sailing=FALSE;
            }
            else if (msg=="off") {
                llSetTimerEvent(timerFreq);
                motoring=FALSE;
                sailing=TRUE;
            }
            else if (msg=="reset") llResetScript();
            else if (msg=="knots") {
                if (showKnots==FALSE) {
                    convert=mpsToKts;
                    units=" kts";
                    showKnots=TRUE;
                }
                else {
                    convert=1;
                    units=" m/s";
                    showKnots=FALSE;
                }
            }
            else if (msg=="practice") {
                if (practice) {
                    llOwnerSay("practice wind OFF");
                    practice=FALSE;
                    raceWindOn=FALSE;
                }
                else {
                    llOwnerSay("practice wind ON");
                    practice=TRUE;
                    raceWindOn=TRUE;
                }
            }
        }        
    }
    
    timer() {
        calcWindAngle();
        if (SAIL_UP) calcBoomDelta();
        calcHeelAngle();
        calcSpeed();
        calcLeeway();
        calcTurnRate();
        if (HUD_ON) updateHUD();
        dataString=(string)currSpeed+","+(string)leeway+","+(string)rotSpeed+","+(string)heelTorque;
        llMessageLinked(LINK_THIS,CONTROLS_MODULE,dataString,NULL_KEY);
    }

}