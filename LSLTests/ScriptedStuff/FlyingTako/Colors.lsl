//Flying Tako Colors Script
//by Kanker Greenacre
//July 2005

//miscellaneous
string dataString;
key owner;//boat owner
key avatar;//person sitting at the helm
key kanker="7abbf31e-d601-4521-ae52-f7457d6e0012";
vector currentColor=<1,1,1>;

//script module flags
integer CONTROLS_MODULE=1;
integer SAIL_MODULE=2;
integer MOTOR_MODULE=3;
integer COLORIZER_MODULE=4;

//linked parts
integer BOW;
integer HULL;
integer STERN;
integer SAIL;
integer NUMBER1;
integer NUMBER2;

//select colors
list colorNames=["puke","red","baby blue","lemon","blah","hot hot pink","blue","gray",
                 "beige","schwarz","tangerine","orenji","eloise","white","trep","tan","green"];
list colorVectors=[<149,159,62>,<146,29,8>,<62,115,187>,<237,234,118>,<171,175,111>,<244,2,91>,<5,35,62>,<113,129,134>,
                   <226,182,138>,<0,0,0>,<232,92,23>,<237,115,17>,<204,0,204>,<255,255,255>,<63,95,127>,<128,64,0>,<84,126,2>];

//set hull color to one from the list
setColor(string color) {
    integer colorIndex=llListFindList(colorNames,[color]);
    vector rgb=llList2Vector(colorVectors,colorIndex)/256.;
    setColorVec(rgb);
}

//set hull color from input rgb vector
setColorVec(vector rgb) {
    currentColor=rgb;
    llSetLinkColor(BOW,rgb,ALL_SIDES);
    llSetLinkColor(HULL,rgb,ALL_SIDES);
    llSetLinkColor(STERN,rgb,ALL_SIDES);
    llSetLinkColor(NUMBER1,rgb,ALL_SIDES);
    llSetLinkColor(NUMBER2,rgb,ALL_SIDES);
}

//new random color for the hull
colorize() {
    vector color;
    color.x=(llFrand(256)/255.);
    color.y=llFrand(256)/255.;
    color.z=llFrand(256)/255.;
    setColorVec(color);
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
        if (str=="number1") NUMBER1=i;
        if (str=="number2") NUMBER2=i;
    }
}

default {
    
    state_entry() {
        getLinkNums();    
    }  

    on_rez(integer param) {
        llResetScript();
    }
    
    link_message(integer from,integer to,string msg,key id) {
        if (from==LINK_ROOT && to==COLORIZER_MODULE) {
            if (llGetSubString(msg,0,4)=="color") {
                if (llGetSubString(msg,6,-1)=="random") colorize();
                else if (llGetSubString(msg,6,6)=="<") setColorVec((vector)llGetSubString(msg,6,-1));
                else setColor(llGetSubString(msg,6,-1));
            }
            else if (llGetSubString(msg,0,4)=="alpha") {
                integer num=(integer)llGetSubString(msg,6,-1);
                num+=2000;
                llMessageLinked(SAIL,num,"",NULL_KEY);
            }
            else if (msg=="reset") llResetScript();
            else if (llGetSubString(msg,0,1)=="id") {
                if (llGetSubString(msg,3,-1)=="off") {
                    llMessageLinked(NUMBER1,1001,"",NULL_KEY);
                    llMessageLinked(NUMBER2,1001,"",NULL_KEY);
                }
                else {
                    string idStr=llGetSubString(msg,3,-1);
                    llMessageLinked(NUMBER1,1000,idStr,NULL_KEY);
                    llMessageLinked(NUMBER2,1000,idStr,NULL_KEY);
                    llSetLinkColor(NUMBER1,currentColor,ALL_SIDES);
                    llSetLinkColor(NUMBER2,currentColor,ALL_SIDES);
                }
            }
        }   
    }

}