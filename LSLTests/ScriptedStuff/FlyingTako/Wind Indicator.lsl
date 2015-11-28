vector windDir;
list particleVars=[PSYS_PART_FLAGS,
            PSYS_PART_FOLLOW_SRC_MASK,  
            PSYS_SRC_PATTERN,
            PSYS_SRC_PATTERN_DROP,
            PSYS_PART_MAX_AGE,3.0,
            PSYS_PART_START_COLOR,<1,1,1>,
            PSYS_PART_START_ALPHA,1.0,
            PSYS_PART_START_SCALE,<.3,.3,.3>,
            PSYS_SRC_BURST_RATE,0.1,
            PSYS_SRC_BURST_SPEED_MIN,0.5,
            PSYS_SRC_BURST_SPEED_MAX,0.5,
            PSYS_SRC_BURST_PART_COUNT,1];
list tmpVars;
integer fixed=FALSE;
            
setParticles() {
    windDir=llWind(<0,0,0>);
    windDir*=0.15;
    tmpVars=particleVars;
    tmpVars+=[PSYS_SRC_ACCEL,windDir];
    llParticleSystem(tmpVars);
}   

default {
    state_entry() {
        llSetObjectName("windindicator");
        llParticleSystem([]);
        llSetTimerEvent(4.0);
    }

    timer() {
        setParticles();
    }
    
    link_message(integer sender_num, integer num, string str, key id) {
        if (num==1000) {
            llParticleSystem([]);
            llSetTimerEvent(0);
        }
        else if (num>1000) {
            llSetTimerEvent(0);
            num-=2000;
            float windAng=num*DEG_TO_RAD;
            windAng+=PI;
            windDir=<llCos(windAng),llSin(windAng),0>;
            windDir*=0.5;
            tmpVars=particleVars;
            tmpVars+=[PSYS_SRC_ACCEL,windDir];
            llParticleSystem(tmpVars);
            fixed=TRUE;
        }   
        else {
            llSetTimerEvent((float)num);
            fixed=FALSE;
        }
    }
}