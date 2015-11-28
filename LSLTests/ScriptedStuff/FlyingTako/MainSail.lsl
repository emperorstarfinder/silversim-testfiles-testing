rotation childRot;
rotation quatRot;
rotation initRot;
vector eulerRot;

integer i;
key defaultFurledKey="f859c1a2-8fa4-5a6d-aa8b-15b81ef303a4";
key defaultRaisedRightKey="4922b72e-6c1c-3808-930e-3531b7af07c4";
key defaultRaisedLeftKey="4922b72e-6c1c-3808-930e-3531b7af07c4";
key furledKey;
key raisedRightKey;
key raisedLeftKey;

integer foundFurled;
integer foundRaisedRight;
integer foundRaisedLeft;

lower() {
    llSetLocalRot(initRot);
    llSetTexture(furledKey,1);//left side
    llSetTexture(furledKey,3);//right side    
}

raise () {
    llSetTexture(raisedLeftKey,1);
    llSetTexture(raisedRightKey,3);    
}

reset() {
    llSetLocalRot(initRot);    
    llSetAlpha(1.0,ALL_SIDES);
}

default {
    
    state_entry() {
        furledKey=defaultFurledKey;
        raisedRightKey=defaultRaisedRightKey;
        raisedLeftKey=defaultRaisedLeftKey;
        llSetObjectName("sail");
        initRot=llEuler2Rot(<0,0,PI_BY_TWO>);
        llSetLocalRot(initRot);
        llSetTexture("transparent",ALL_SIDES);
        llSetTexture(furledKey,1);//left side
        llSetTexture(furledKey,3);//right side
        llSetAlpha(1.0,ALL_SIDES);
        llSetStatus(STATUS_PHANTOM,FALSE);       
    }
    
    on_rez(integer param) {
        llAllowInventoryDrop(TRUE);
    }
    
    link_message(integer sender,integer num,string str,key id) {
        if (num==1000) {//reset
            lower();
            reset();
        }
        else if (num==1001) {//lower without reset
            lower();
        }
        else if (num==1002) {//raise sail
            raise();
        }
        else if (num>1999) {//change alpha setting
            float alpha=(float)num;
            alpha-=2000;
            alpha/=100.;
            llSetAlpha(alpha,1);
            llSetAlpha(alpha,3);
        }   
        else {//rotate sail, CCW is positive
            childRot=llGetLocalRot();
            eulerRot=<0,0,num*DEG_TO_RAD>;
            quatRot=llEuler2Rot(eulerRot);
            llSetLocalRot(quatRot*childRot);
        }     
    }
    
    changed(integer change){
        if( (change & CHANGED_INVENTORY) | (change & CHANGED_ALLOWED_DROP) ) {
            integer numInvTex=llGetInventoryNumber(INVENTORY_TEXTURE);
            foundFurled=FALSE;
            foundRaisedRight=FALSE;
            foundRaisedLeft=FALSE;
            for (i=0;i<numInvTex;++i) {
                string name=llGetInventoryName(INVENTORY_TEXTURE,i);
                if (name=="sail_furled") {
                    furledKey=llGetInventoryKey(name);
                    foundFurled=TRUE;
                    llOwnerSay("New furled sail texture: "+(string)furledKey);
                    lower();
                }
                else if (name=="sail_raised_right") {
                    raisedRightKey=llGetInventoryKey(name);
                    foundRaisedRight=TRUE;
                    llOwnerSay("New raised sail texture: "+(string)raisedRightKey);
                    raise();
                }
                else if (name=="sail_raised_left") {
                    raisedLeftKey=llGetInventoryKey(name);
                    foundRaisedLeft=TRUE;
                    llOwnerSay("New raised sail texture: "+(string)raisedLeftKey);
                    raise();
                }
            }
            if (!foundFurled) furledKey=defaultFurledKey;
            if (!foundRaisedRight) raisedRightKey=defaultRaisedRightKey;
            if (!foundRaisedLeft) raisedLeftKey=defaultRaisedLeftKey;
        }
    }
    
}