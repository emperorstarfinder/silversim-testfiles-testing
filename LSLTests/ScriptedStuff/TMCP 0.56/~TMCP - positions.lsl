//basically, we need a large datastore for our command set

integer MSG_DATA_MENU=310;
integer MSG_DATA_TYPE=320;
integer MSG_DATA_POSE=330;
integer MSG_DATA_POSITION=331;
integer MSG_DATA_PROPS=332;
integer MSG_DATA_LM=335;

integer MSG_DO_POSE=350;
integer MSG_DO_LM=351;
integer MSG_DO_SPECIAL=352;

integer MSG_SET_RUNNING=340;
integer MSG_STORAGE_RESET=341;

integer MSG_DATA_READY=309;

integer MSG_RUN_ANIMS=379;

integer MSG_AGENT_PLAY_ANIM=395;

integer MSG_SET_SITTARGET=375;

integer MSG_DUMP_POSITIONS=389;
integer MSG_UPDATE_POS=363;

integer MSG_DO_DEFAULT_POSE = 358;
integer MSG_SET_DEFAULT_POSE = 359;

integer MSG_MLP_SETTING = 1;

integer MSG_ADJUST_POSROT=520;
integer MSG_TEMPORARY_POSROT=521;

list poseNames;
list poseData;

list positionNames;
list positionData;

list props;
string currentProp;
integer propChannel;

string currentPose="default";
list currentAnims;
list currentPositions;

list agentPoseIdx;

list agentAdjust;


string defaultPose="default";

runAnims() {
    list data=agentPoseIdx;
    integer i;
    list idpos;
    for (i=0; i<llGetListLength(data); i+=2) {
        key id=(key)llList2String(data, i);
        integer idx=-1+(integer)llList2String(data, i+1);
        if (id) if (idx>=0) {
            if (idx>=llGetListLength(currentAnims))
                llWhisper (0, "No animation available for "+llKey2Name(id));
            else {
                llMessageLinked (LINK_THIS, MSG_AGENT_PLAY_ANIM, llList2String(currentAnims, idx), id);
                //llOwnerSay ("Playing anim "+llList2String(currentAnims, idx)+" on id "+(string)id);
            }
                
            if (idx/2>=llGetListLength(currentPositions))
                llSay (0, "No position data for "+llKey2Name(id));   
            else {
                //set agents position
                idpos+=[id, (vector)llList2String(currentPositions, idx*2),(vector)llList2String(currentPositions, idx*2+1)];
            }
        } else {
            //llOwnerSay ("Corrupt agent anim position request");   
        }
    }    
    //apply positions
    for (i=0; i<=llGetNumberOfPrims(); i++) {
        integer j=llListFindList(idpos, [llGetLinkKey(i)]);
        if (-1<j) {
            vector pos = llList2Vector(idpos, j+1)+(<0,0,0.42+0.01*(integer)llGetObjectDesc()>/llGetRot());
            vector rot = llList2Vector(idpos, j+2) * DEG_TO_RAD;
            integer l=llListFindList (agentAdjust, [llGetLinkKey(i)]);
            if (-1<l) {
                pos+=llList2Vector (agentAdjust, l+1);
                rot=llRot2Euler(llEuler2Rot(llList2Vector (agentAdjust, l+2)) * llEuler2Rot(rot));                   
            }
            llSetLinkPrimitiveParamsFast(i, [PRIM_POS_LOCAL, pos,PRIM_ROT_LOCAL, llEuler2Rot(rot)]);
            //llOwnerSay ("Setting position for "+llKey2Name(llGetLinkKey(i))+" position: "+(string)pos+" rotation: "+ (string)rot );
        }        
    }
}

setSitTarget(integer poseidx) {
    poseidx--;
    vector v=(vector)llList2String(currentPositions, poseidx*2);
    vector r=(vector)llList2String(currentPositions, poseidx*2+1);
    llSitTarget (v+(<0,0,0.42+0.01*(integer)llGetObjectDesc()>/llGetRot()) , llEuler2Rot(r*DEG_TO_RAD));
    //llOwnerSay ("Sit target #"+(string)poseidx+" "+(string)(v+(<0,0,0.42>/llGetRot()))+" "+(string)(r));
}

string shortString (float n) {
    string s=(string)n;
    while (llStringLength(s)>1) {
        integer hasdot=-1!=llSubStringIndex(s, ".");
        string d=llGetSubString(s,-1,-1);
        if ((hasdot && (d=="0")) || (d=="."))
            s=llDeleteSubString(s,-1,-1);
        else
            jump ok;   
    }
    @ok;
    return s;
}

string shortVec (vector v) {
    return "<"+shortString(v.x)+","+shortString(v.y)+","+shortString(v.z)+">";
}

dumpPos() {
    llOwnerSay ("TMCP Position Dump");
    integer i;
    for (i=0; i<llGetListLength(positionNames); i++) {
        //llOwnerSay ("{"+llList2String(positionNames, i)+"} "+llList2String(positionData, i));    
        list v=llParseString2List(llList2String(positionData, i), ["&"], []);
        string s="{"+llList2String(positionNames, i)+"}";
        integer j;
        for (j=0; j<llGetListLength(v); j++)
            //notice that function shortvec takes string as param
            s+=" "+shortVec((vector)llList2String(v, j));        
        llOwnerSay (s);
    }   
}

checkProps(string pose) {
    integer i=llListFindList(props, ["^^^"+llToLower(pose)]);
    string prop;
    if (~i)
        prop=(string)llList2List(props, i+1, i+3); //prop name + position must be identical.
    
    if (currentProp!=prop) {
        if (currentProp) { //delete it
            llSay (propChannel, "DIE");
        }
        if (prop) {
            //rez prop at given position and rotation
            vector proppos=(vector)llList2String(props, i+2);
            rotation proprot=llEuler2Rot(DEG_TO_RAD*(vector)llList2String(props, i+3));
            //llRezAtRoot or llRezObject?
            llRezObject (llList2String(props, i+1), llGetPos()+proppos*llGetRootRotation(), ZERO_VECTOR, (llGetRootRotation()/ZERO_ROTATION) * proprot, propChannel);
            llSetTimerEvent (30.0);
        } else
            llSetTimerEvent(0.0);
        currentProp=prop;            
    }    
}

doPose (string m) {
    checkProps(m);
    if (m!=currentPose)
        agentAdjust=[];
        
            currentPose=m;
            currentAnims=[];
            currentPositions=[];
            integer i=llListFindList(positionNames, [m]);
            integer j=llListFindList(poseNames, [m]);
            currentAnims=llParseString2List (llList2String(poseData, j), ["|"], []);
            currentPositions=llParseString2List (llList2String(positionData, i), ["&"], []);
            
            //fill missing data with defaults
            i = llListFindList(positionNames, ["default"]);
            j = llListFindList(poseNames, ["default"]);
            list animdef=llParseString2List (llList2String(poseData, j), ["|"], []);
            list posdef=llParseString2List (llList2String(positionData, i), ["&"], []);
            currentAnims+=llList2List (animdef, llGetListLength(currentAnims), -1);
            currentPositions+=llList2List(posdef, llGetListLength(currentPositions), -1);            
            
            //this should be obsolete now:
            if (/*(i>=0) && */(j>=0)) {
                //list l=llParseString2List(llList2String(lmAction, i), [","],[]);
                //parse pose data. todo.
                if (i<0) {
                    //need to fetch default data... just try it.
                    i=llListFindList(positionNames, ["default"]);
                }
                //llOwnerSay ("Do pose "+m+" anims "+llList2String(poseData,j)+" data "+llList2String(positionData, i));
            } else {                                
                //llOwnerSay ("No animations defined for "+m);
            }
            
            runAnims();  
}

setAgentPosRot (key id, string data) {
    //set temporary agent adjustment.
    list l=llParseString2List(data, ["&"], []);
    vector p=(vector)llList2String(l,0);
    vector r=DEG_TO_RAD * (vector)llList2String(l,1);
    integer i=llListFindList (agentAdjust, [id]);
    if (-1<i) {
        p+=llList2Vector(agentAdjust, i+1);
        r=llRot2Euler(llEuler2Rot(llList2Vector(agentAdjust, i+2))*llEuler2Rot(r));        
        agentAdjust = llDeleteSubList(agentAdjust, i, i+2);
    }
    if (llVecMag(p)>1)
        p=llVecNorm(p);
    agentAdjust+=[id,p,r];       
    runAnims();
}

adjustPosition (string name, integer index, vector p, vector r) {
                              //positionNames
    integer i=llListFindList (positionNames, [name]); 
    if (-1<i) {
        string data=llList2String(positionData, i);
        list pos=llParseString2List(data, ["&"], []);
        if (index>0) {
            //alter only index   
            integer j=(index-1)*2;
            if (j<llGetListLength(positionData)) {
                vector v=(vector)llList2String(pos, j);   
                v+=p;
                vector R0=(vector)llList2String(pos, j+1);   
                rotation R1=llEuler2Rot(DEG_TO_RAD *R0);
                rotation Rd=llEuler2Rot(DEG_TO_RAD * r);
                R1 = Rd * R1;
                R0=RAD_TO_DEG * llRot2Euler(R1);                
                pos=llListReplaceList(pos, [shortVec(v),shortVec(R0)], j, j+1);                             
            }
            
        } else {
            //alter all
            integer j;
            for (j=0; j<llGetListLength(pos); j+=2) {
                vector v=(vector)llList2String(pos, j);   
                v+=p;
                vector R0=(vector)llList2String(pos, j+1);   
                rotation R1=llEuler2Rot(DEG_TO_RAD *R0);
                rotation Rd=llEuler2Rot(DEG_TO_RAD * r);
                R1 = Rd * R1;
                R0=RAD_TO_DEG * llRot2Euler(R1);                
                pos=llListReplaceList(pos, [shortVec(v),shortVec(R0)], j, j+1);                
            }               
        }
        data=llDumpList2String(pos, "&");
        //llOwnerSay ("new pos data for "+name+" : "+data);
        positionData=llListReplaceList (positionData, [data], i, i);
           
    }
}

adjustAllPositions (vector p, vector r) {
    //loop all pose, adjust them
    integer i;
    for (i=0; i<llGetListLength(positionNames); i++) {
        adjustPosition (llList2String(positionNames, i),-1, p,r);
    }   
}

parseSetting (string m, key id) {
    //seperated by =
    //might contain ROT or POS adjustments
    list l=llParseString2List(m, [" = ", " =", "=", "= ","="],[]);
    string cmd=llList2String(l, 0);
    string cmd2=llList2String(l,1);
    if (cmd=="REORIENT") {
        vector v=(vector)llList2String(l,2);
        /*
        list lv=llParseString2List(llList2String(l,2), ["<",",",">"], []); //rotations come as vector too
        llOwnerSay ("P: "+llList2String(l,2)+" : "+llDumpList2String(lv, "*"));
        v.x=(float)llList2String(lv,0);
        v.y=(float)llList2String(lv,1);
        v.z=(float)llList2String(lv,2);
        */
        
        llOwnerSay ("adjust "+cmd2+" "+(string)v);
        if (cmd2=="OFF") {
            adjustAllPositions (0.01*v, ZERO_VECTOR);    
        } else
        if (cmd2=="ROT") {
            adjustAllPositions (ZERO_VECTOR,v);    
        }
        
        doPose(currentPose);
        //runAnims();
    }    
}

adjustPosRot (key id, string data) {
    list l=llParseString2List(data, ["&"], []);
    integer i=llListFindList (agentPoseIdx, [(string)id]);
    //llOwnerSay ("posrot "+(string)i+" "+(string)id+" "+data);
    if ((-1<i)&&(llGetListLength(l)==2)) {
        integer lidx=llList2Integer (agentPoseIdx, i+1);
        adjustPosition (currentPose, lidx, (vector)llList2String(l,0), (vector)llList2String(l,1));
        doPose(currentPose);        
    }
}


default 
{
    state_entry()
    {
        
    }

    link_message (integer sn, integer n, string m, key id) {
        if (n==MSG_DATA_POSE) {
            //add posedata    
            poseNames+=m;
            poseData+=(string)id;
        } else
        if (n==MSG_DATA_POSITION) {
            positionNames+=m;
            positionData+=(string)id;            
        } else
        if (n==MSG_DATA_PROPS) {
            props+=["^^^"+llToLower(m)]+llParseString2List((string)id,["&"],[]);
        }
        if (n==MSG_SET_DEFAULT_POSE) {
                defaultPose=m;
        }
        else
        if (n==MSG_SET_RUNNING)
            state running;
    }
}

state running {
    state_entry()
    {
        propChannel=-1000-(integer)llFrand(2000000000);
        llOwnerSay ("Position free memory: "+(string)llGetFreeMemory());
        doPose(defaultPose);
    }
    
    timer() {
        if (currentProp)
            llSay (propChannel, "LIVE");
    }
    link_message (integer sn, integer n, string m, key id) {
        if (n==MSG_DO_POSE) {
            doPose(m);
        } else
        if (n==MSG_STORAGE_RESET)
            llResetScript();
        else
        if (n==MSG_RUN_ANIMS) {
            agentPoseIdx=llCSV2List(m);
            runAnims();    
        }
        else
        if (n==MSG_SET_SITTARGET) {
            setSitTarget((integer)m);    
        }
        else
        if (n==MSG_DUMP_POSITIONS) {
            dumpPos();
        }
        else
        if (n==MSG_UPDATE_POS) {
            runAnims();       
        }
        else
        if (n==MSG_SET_DEFAULT_POSE)
            defaultPose=m;
        else
        if (n==MSG_DO_DEFAULT_POSE)
            doPose(defaultPose);
        else
        if (n==MSG_MLP_SETTING) {
            parseSetting (m, id);   
        }
        else
        if (n==MSG_ADJUST_POSROT) {
            adjustPosRot(id, m);      
        }
        if (n==MSG_TEMPORARY_POSROT) {
            setAgentPosRot(id, m);      
        }

    }
    
}