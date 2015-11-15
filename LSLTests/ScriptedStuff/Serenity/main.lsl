key YOURKEY = "098bcbe1-391c-4283-933f-3da0cc3f1468";//this is your key
integer SECRET_NUMBER = 280619750;//number used for rezzing objects
integer com_chan = -280619750;//channel used for talking between food and animals
integer API_CHAN = -854;//channel used for potions
integer com_lis;//pet listener
string reason;//reason for death
string name;//the name of the pet
string special;//the name of the special of the pet
string mother;//the pets mothers name
string father;//the pets fathers name
string breeder;//the name of the person this pet was owned by at birth
integer age;//the age of the pet
integer sex;//the sex of the pet 1=male 2=female
integer shine;//the shine of the pet
float glow;//the glow of the pet
integer seeds;//the number of seeds this pet has
integer generation;//the generation number of this pet
integer hunger;//the hunger level of this pet
string mname;//this is the name of the male that made the female pregnant
integer mshine;//this is that males shine
float mglow;//this is that males glow
string mspecial;//this is that males special
integer maxseed = 20;//max number of seeds allowed
integer maxage = 20;//max age allowed
integer maxhunger = 20;//max hunger allowed
integer version = 1;//version number
integer malecall = 15;//number of seconds between males calls for sex
integer maletick;//dynamic ticker
integer femalepreg = 30;//number of seconds between getting pregnant and having a baby
integer femalepregtick;//dynamic ticker
integer recoverytime = 30;//number of seconds between having a baby and becoming ready to have another
integer recoverytick;//dynamic ticker
integer eatcall = 28200;//number of seconds between increasing hunger
integer eattick;//dynamic ticker
integer agetime = 30;//number of seconds between aging
integer agetick;//dynamic ticker
integer movetime = 120;//number of seconds between moving
integer movetick;//dynamic ticker
integer breedingage = 7;//minimum age before allowing sex
string status = " ";//pregnancy status
configure()//configure the pet
{
    //this is where we will configure different things about our pet. shine glow in particular.
    //you could break this up so that only certain link numbers get glow or shine or whatever
    llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_GLOW,ALL_SIDES,glow,PRIM_BUMP_SHINY,ALL_SIDES,shine,PRIM_BUMP_NONE]);
    if(special == "Arctic")
    {//configure specials in this section as well
        llSetLinkTexture(11,"dd51147a-f6ef-2830-21bb-4d8b55556000",ALL_SIDES);
        llSetLinkTexture(6,"bb51f246-f21a-8d85-c1e2-ec86a8f73dd4",ALL_SIDES);
        llSetLinkTexture(7,"bb51f246-f21a-8d85-c1e2-ec86a8f73dd4",ALL_SIDES);
        llSetLinkTexture(5,"53c81b21-2f41-7649-c8ba-c42938fb1133",ALL_SIDES);
        llSetLinkTexture(4,"1150d787-2dca-193a-7acb-0b3d6c67cb17",ALL_SIDES);
        llSetLinkTexture(3,"844c4dfd-2a22-e413-b32c-f78a6584775d",ALL_SIDES);
        llSetLinkTexture(10,"1bb2839a-d38e-724d-7f78-885c8a4e90ca",ALL_SIDES);
        llSetLinkTexture(9,"1bb2839a-d38e-724d-7f78-885c8a4e90ca",ALL_SIDES);
        llSetLinkTexture(2,"3e952bc5-8eac-cf65-cc82-1a5aed626a39",ALL_SIDES);
        llSetLinkTexture(12,"9df63765-54e7-ae1b-f56c-28503666d6ae",ALL_SIDES);
        llSetLinkTexture(8,"9df63765-54e7-ae1b-f56c-28503666d6ae",ALL_SIDES);
    }
}
integer text = 0;//ticker used to show float text
integer floattext =0;//are we showing float text?
string sleep = "";
show_text()//display the float text
{
    string mysex = "NONE";
    if(sex == 1)mysex = "MALE";
    else if(sex == 2)mysex = "FEMALE";
    string myglow = (string)((integer)(glow * 100)) + "%";
    string myshine;
    if (shine == 0) {
        myshine = "None";
    } else
    if (shine == 1) {
        myshine = "Low";
    } else
    if (shine == 2) {
        myshine = "Medium";
    } else
    if (shine == 3) {
        myshine = "High";
    }
    sleeping();
    string out = "Name: "+name+"\n"+
                "Special: "+special+"\n"+
                "Mother: "+mother+" - Father: "+father+"\n"+
                "Breeder: "+breeder+"\n"+
                "Age: "+(string)age+"/"+(string)maxage+"\n"+
                "Generation: "+(string)generation+"\n"+
                "Gender: "+mysex+"\n"+
                "Shine: "+myshine+" - Glow: "+myglow+"\n"+
                "Seeds: "+(string)seeds+"/"+(string)maxseed+"\n"+
                "Hunger: "+(string)hunger+"/"+(string)maxhunger+"\n"+
                "Version: "+(string)version+"\n"+
                status+"\n"+sleep;
    llSetText(out,<1,1,1>,1);
}
integer maleready = 0;//is the male ready to have sex?
update()//update the pet stats
{
    configure();
    llSetObjectName(name);
    llMessageLinked(LINK_SET,age,"age","");
    string pack = llStringToBase64(name+"^"+special+"^"+mother+"^"+father+"^"+breeder+"^"+(string)age+"^"+(string)sex+"^"+(string)shine+"^"+(string)glow+"^"+(string)seeds+"^"+(string)generation+"^"+(string)hunger);
    llSetLinkPrimitiveParams(2,[PRIM_TEXT,pack,<1,1,1>,0]);
}
integer randomfnum;//random food number for talking to food objects
integer randomsnum;//random sex number for talking to mates
debug(string m)
{
    llSay(0,m);
}
call_food()//call for food
{
    randomfnum = llFloor(llFrand(DEBUG_CHANNEL));
    llSay(com_chan,"pet_search_food^"+(string)randomfnum);
}
call_sex()//call for sex
{
    llSay(com_chan,"pet_search_sex^"+(string)home_location);
}
integer menulis;//menu listener
integer menuchan;//menu channel. this actually gets randomized
vector home_location;//the home anchor location
list specials = ["Normal"];//list of specials
string ownername;
key gownername;
make_baby()//generate and rez a baby
{
    string babyname;
    integer babyshine;
    float babyglow;
    string babyspecial;
    integer babygen = generation + 1;
    string babymom = name;
    string babydad = mname;
    string babybreeder = ownername;
    integer babysex = llFloor(llFrand(2))+1;if(babysex>2)babysex=1;
    string out = "";
    integer f = llFloor(llFrand(llGetListLength(nameprefix)));
    out += llList2String(nameprefix,f);
    f = llFloor(llFrand(llGetListLength(namemiddle)));
    out += llList2String(namemiddle,f);
    if(babysex == 2)
    {
        f = llFloor(llFrand(llGetListLength(namefemalesuffix)));
        out += llList2String(namefemalesuffix,f);
    }else
    {
        f = llFloor(llFrand(llGetListLength(namemalesuffix)));
        out += llList2String(namemalesuffix,f);
    }
    babyname = out;
    babygen = generation + 1;
    if(babygen >= 6)
    {
        babyglow = ((glow+mglow)/2)+0.01;
        if(babyglow > 1.0)babyglow = 1.0;
        babyshine = llFloor((shine+mshine)/2);
        if(babyshine > 3)babyshine = 3;
        float coin = llFrand(1.0);
        if(special!="Normal"&&mspecial!="Normal")
        {
            if(coin<0.05)
            {
                babyspecial = llList2String(specials,llFloor(llFrand(llGetListLength(specials))));
            }
        }else
        {
            if(coin<0.02)
            {
                babyspecial = llList2String(specials,llFloor(llFrand(llGetListLength(specials))));
            }
        }
    }else
    {
        float coin = llFrand(1.0);
        if(coin<0.02)
        {
            babyglow=(glow+0.01);
            babyshine=(shine+1);
        }else
        {
            babyglow=0.0;
            babyshine=0;
        }
        babyspecial = "Normal";
    }
    babydata = babyname+"^"+babyspecial+"^"+babymom+"^"+babydad+"^"+babybreeder+"^"+(string)babysex+"^"+(string)babyshine+"^"+(string)babyglow+"^"+(string)babygen;
    llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),llGetPos(),ZERO_VECTOR,ZERO_ROTATION,SECRET_NUMBER);
}
string babydata;//the baby data
integer sleeping()//on off sleping function
{
    list descriptions = ["Dawn", "Morning", "Afternoon", "Night"];
    float timeOfDay = (integer)llGetTimeOfDay() % 14400;
    integer hour = llFloor(timeOfDay/3600);
    integer minute = llFloor(((integer)timeOfDay % 3600)/60);
    string zero = "";
    if(minute < 10)
    {
        zero = "0";
    }
    if(llList2String(descriptions, hour)=="Night")
    {
        sleep = "Asleep - Time: "+(string)hour+":"+zero+(string)minute;
        return 0;//change this to 1 to disable sleeping
    }else
    {
        sleep = "Awake - Time: "+(string)hour+":"+zero+(string)minute;
        return 1;
    }
}
float roam_distance = 5;//the pets range
float tolerance = 0.15;//the distance we allow before moving
float increment = 0.1;//distance to move during each iteration
move()//actually moves the prims
{
    if(sleeping() == 0)return;
    vector my_pos = llGetPos();
    vector destination;
    if (llVecDist(<destination.x, destination.y, 0>, <my_pos.x, my_pos.y, 0>) <= tolerance || destination == <0,0,0>) 
    {
        destination.x = (llFrand(roam_distance * 2) - roam_distance) + home_location.x;
        destination.y = (llFrand(roam_distance * 2) - roam_distance) + home_location.y;
        destination.z = my_pos.z;
    }
    vector lookat = destination;
    vector  fwd = llVecNorm(lookat-llGetPos());
    vector lft = llVecNorm(<0,0,1>%fwd);
    rotation rot = llAxes2Rot(fwd,lft,fwd%lft);
    llSetRot(rot);
    do
    {
        vector position = llGetPos();
        float dis_x = llFabs(destination.x - position.x);
        float dis_y = llFabs(destination.y - position.y);
        float angle = llAtan2(dis_y, dis_x);
        float inc_x = llCos(angle) * increment;
        float inc_y = llSin(angle) * increment;
        if (destination.x > position.x) 
        {
            position.x += inc_x;
        }else
        {
            position.x -= inc_x;
        }
        if (destination.y > position.y) 
        {
            position.y += inc_y;
        }else
        {
            position.y -= inc_y;
        }
        position.z = lookat.z;
        //good place for triggering a walking animation hehe
        llSetPos(position);
    }while(llVecDist(llGetPos(),lookat)>0.5);
}
key egg;//the key of the baby we rez
/*this section below is a bunch of lists. these lists help us create random and unique names for our pets*/
list nameprefix = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
list namemiddle = ["a","e","i","o","u","y","oo","ou","er","ar","ao","ai","erla","erlo","oar","el","an","ey","ul","in","al","ila","ilo","ed","os","et","erg","a","e","i","o","u","y","oo","ou","er","ar","ao","ai","erla","erlo","oar","el","an","ey","ul","in","al","ila","ilo","ed","os","et","erg"];
list namemalesuffix = ["","be","chu","de","der","th","is","o","eom","oh","elo","oo","rp","ler","er","mo","moe","mos","erd","up","urk","obo","in","it","e","od","red","rix","lem","ter","ore","ox","oid","io","nie","plo","plor","","be","chu","de","der","th","is","o","eom","oh","elo","oo","rp","ler","er","mo","moe","mos","erd","up","urk","obo","in","it","e","od","red","rix","lem","ter","ore","ox","oid","io","nie","plo","plor"];
list namefemalesuffix = ["","a","bai","chu","de","es","eo","ee","la","ela","lera","era","mo","moo","oba","ina","ita","ees","ey","ie","nie","plea","plera","zoo","zai","yai","ola","","a","bai","chu","de","es","eo","ee","la","ela","lera","era","mo","moo","oba","ina","ita","ees","ey","ie","nie","plea","plera","zoo","zai","yai","ola"];
usepotion(string potion)//function to use potions
{
    if(potion == "ager")
    {
        if(age < 7)
        {
            age = 7;
            llSay(com_chan,"used_ager");
            update();
        }
    }else if(potion == "sexchange")
    {
        if(sex == 1)sex = 2;
        else if(sex == 2)sex = 1;
        llSay(com_chan,"used_sexchanger");
        update();
        if(1==1)//this is a hack to force the compiler to allow global functions to change states. old ass hack
        {
            if(sex == 2)state female;
            else if(sex == 1)state male;
        }
    }else if(potion == "foodinject")
    {
        hunger = 0;
        llSay(com_chan,"used_foodinjector");
        update();
    }else if(potion == "shineboost1")
    {
        shine = 1;
        llSay(com_chan,"used_sb1");
        update();
    }else if(potion == "shineboost2")
    {
        shine = 2;
        llSay(com_chan,"used_sb2");
        update();
    }else if(potion == "shineboost3")
    {
        shine = 3;
        llSay(com_chan,"used_sb3");
        update();
    }else if(potion == "glowboost")
    {
        glow = glow + 0.01;
        if(glow > 1.0)glow = 1.0;
        llSay(com_chan,"used_gb1");
        update();
    }else if(potion == "seedboost")
    {
        seeds = maxseed;
        llSay(com_chan,"used_seedboost");
        update();
    }else if(potion == "deseed")
    {
        seeds = 0;
        llSay(com_chan,"used_deseeder");
        update();
    }else if(potion == "revive")
    {
        llSetText("",<1,1,1>,1);
        hunger = 0;
        update();
        llSay(com_chan,"used_revive");
        if(sex == 1)state male;
        else if(sex == 2)state female;
    }
}
relis()
{
    llListenRemove(com_lis);
    com_lis = llListen(com_chan,"","","");
}
process_link(integer r,string str,string extra)
{
    if(str == "sethome")home_location = llGetPos();
    else if(str == "update")
    {
        if(1==1)state updater;
    }else if(str == "reset")
    {
        llSetObjectDesc("Reset");
        llMessageLinked(LINK_SET,123,"update_mode","");
        llResetScript();
    }else if(str == "nameupdate")
    {
        name = extra;
        update();
    }else if(str == "rangeupdate")
    {
        roam_distance = (integer)extra;
    }
}
default
{//this state is where the scripts starts when it is first born. by generator or parent either way.
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
    dataserver(key id,string data)
    {
        if(id == gownername)
        {
            ownername = data;
        }
    }
    state_entry()
    {
        home_location = llGetPos();
        llSetText("",<1,1,1>,1);
        if(llGetObjectDesc() == "Reset")
        {
            list t = llGetLinkPrimitiveParams(2,[PRIM_TEXT]);
            t = llParseString2List(llBase64ToString(llList2String(t,0)),["^"],[]);
            name = llList2String(t,0);
            llSetObjectName(name);
            special = llList2String(t,1);
            mother = llList2String(t,2);
            father = llList2String(t,3);
            breeder = llList2String(t,4);
            age = (integer)llList2String(t,5);
            sex = (integer)llList2String(t,6);
            shine = (integer)llList2String(t,7);
            glow = (float)llList2String(t,8);
            seeds = (integer)llList2String(t,9);
            generation = (integer)llList2String(t,10);
            hunger = (integer)llList2String(t,11);
            update();
            llSetObjectDesc("Version: "+(string)version);
            state pet;
        }else
        {
            
        }
    }
    on_rez(integer sp)
    {
        if(sp!=SECRET_NUMBER)
        {
            if(llGetOwner()!=YOURKEY)
            {
                reason = "illegal rez by non creator";
                state dead;
            }
        }else
        {
            relis();
            llSay(0,"I am born.....");
            llAllowInventoryDrop(TRUE);
            llSetRemoteScriptAccessPin(-19842007);
            gownername = llRequestAgentData(llGetOwner(),DATA_NAME);
            llMessageLinked(LINK_SET,123,"scan_link","");
            llSay(com_chan,"child_ready");
        }
    }
    listen(integer c,string n,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m,["^"],[]);
        if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1) == "configure_pet")
            {
                llSay(0,"I am configured....");
                name = llList2String(t,2);
                special = llList2String(t,3);
                mother = llList2String(t,4);
                father = llList2String(t,5);
                breeder = llList2String(t,6);
                age = 0;
                sex = (integer)llList2String(t,7);
                shine = (integer)llList2String(t,8);
                glow = (float)llList2String(t,9);
                seeds = maxseed;
                generation = (integer)llList2String(t,10);
                hunger = 0;
                update();
                state pet;
            }
        }      
    }
}
state pet
{//this is a temp switch state that just pushes the script into its proper state. i could eliminate this but dont feel like it to be honest.
    state_entry()
    {
        if(sex == 1)state male;
        else if(sex == 2)state female;
    }
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
}
state male
{//this is the male state. if the pet is male everything it does is in this state.
    state_entry()
    {
        relis();
        status = " ";
        llSetTimerEvent(1.0);
    }
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
    touch_start(integer x)
    {
        floattext = 1;
        show_text();
    }
    listen(integer c,string name,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m, ["^"], []);
        if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1) == "female_ready")
            {
                if(age >= breedingage && seeds > 0)
                {
                    if(maleready == 1)
                    {
                        maleready = 0;
                        integer num = llList2Integer(t,2);
                        llSay(com_chan,(string)id+"^make_baby^"+(string)num+"^"+(string)shine+"^"+(string)glow+"^"+special);
                    }
                }                    
            }else if(llList2String(t,1) == "breed_success")
            {
                seeds--;
                if(seeds < 0)seeds = 0;
                update();
            }else if(llList2String(t,1) == "eat_food")
            {
                integer rnum = (integer)llList2String(t,2);
                if(rnum == randomfnum)
                {
                    hunger-=llList2Integer(t,3);
                    if(hunger < 0)hunger = 0;
                    update();
                }
            }else if(llList2String(t,1) == "potion")
            {
                usepotion(llList2String(t,2));
            }
        }
    }
    timer()
    {
        movetick++;
        if(movetick >= movetime)
        {
            movetick = 0;
            move();
        }
        agetick++;
        if(agetick >= agetime)
        {
            agetick = 0;
            age++;
            update();
        }
        if(seeds > 0)
        {
            eattick++;
            if(eattick >= eatcall)
            {
                eattick = 0;
                hunger++;
                debug("calling food");
                update();
                call_food();
            }
            
            if(age >= breedingage)
            {
                maletick++;
                if(maletick >= malecall)
                {
                    maletick = 0;
                    maleready = 1;
                    llSay(0,"Looking for a hot lady.");
                    call_sex();
                }
            }
        }
        if(floattext == 1)
        {
            text++;
            if(text >= 15)
            {
                text = 0;
                floattext = 0;
                llSetText("",<1,1,1>,1);
            }
        }
    }
}
state female
{//this is the female state. like the male state but for female pets.
    state_entry()
    {
        relis();
        status = " ";
        llSetTimerEvent(1.0);
    }
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
    touch_start(integer x)
    {
        floattext = 1;
        show_text();
    }
    listen(integer c,string name,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m, ["^"], []);
        if(llList2String(t,0)=="pet_search_sex")
        {
            if(age >= breedingage && seeds > 0)
            {
                randomsnum = llFloor(llFrand(DEBUG_CHANNEL));
                llSay(0,"Hot lady right here.");
                llSay(com_chan,(string)id+"^female_ready^"+(string)randomsnum);
            }
        }else if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1) == "make_baby")
            {
                if(age >= breedingage && seeds > 0)
                {
                    integer rnum = (integer)llList2String(t,2);
                    if(rnum == randomsnum)
                    {
                        mname = name;
                        mshine = (integer)llList2String(t,3);
                        mglow = (float)llList2String(t,4);
                        mspecial = llList2String(t,5);
                        seeds--;
                        if(seeds < 0)seeds = 0;
                        update();
                        llSay(com_chan,(string)id+"^breed_success");
                        llSay(0,"I'm pregnant.");
                        state pregnant;
                    }
                }
            }else if(llList2String(t,1) == "eat_food")
            {
                integer rnum = (integer)llList2String(t,2);
                if(rnum == randomfnum)
                {
                    hunger-=llList2Integer(t,3);
                    if(hunger < 0)hunger = 0;
                    update();
                }
            }else if(llList2String(t,1) == "potion")
            {
                usepotion(llList2String(t,2));
            }
        }
    }
    timer()
    {
        movetick++;
        if(movetick >= movetime)
        {
            movetick = 0;
            move();
        }
        agetick++;
        if(agetick >= agetime)
        {
            agetick = 0;
            age++;
            update();
        }
        if(seeds > 0)
        {
            eattick++;
            if(eattick >= eatcall)
            {
                eattick = 0;
                hunger++;
                debug("calling food");
                update();
                call_food();
            }
        }
        if(floattext == 1)
        {
            text++;
            if(text >= 15)
            {
                text = 0;
                floattext = 0;
                llSetText("",<1,1,1>,1);
            }
        }
    }
}
state pregnant
{//this is the pregnant state. if a female gets pregnant she will move into this state during the actual pregnancy
    state_entry()
    {
        relis();
        status = "Pregnant";
        llSetTimerEvent(1.0);
    }
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
    touch_start(integer x)
    {
        floattext = 1;
        show_text();
    }
    listen(integer c,string name,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m, ["^"], []);
        if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1) == "eat_food")
            {
                integer rnum = (integer)llList2String(t,2);
                if(rnum == randomfnum)
                {
                    hunger-=llList2Integer(t,3);
                    if(hunger < 0)hunger = 0;
                    update();
                }
            }
        }
    }
    timer()
    {
        movetick++;
        if(movetick >= movetime)
        {
            movetick = 0;
            move();
        }
        agetick++;
        if(agetick >= agetime)
        {
            agetick = 0;
            age++;
            update();
        }
        
        femalepregtick++;
        if(femalepregtick >= femalepreg)
        {
            femalepregtick = 0;
            state recovery;
        }
        
        if(seeds > 0)
        {
            eattick++;
            if(eattick >= eatcall)
            {
                eattick = 0;
                hunger++;
                debug("calling food");
                update();
                call_food();
            }
        }
        if(floattext == 1)
        {
            text++;
            if(text >= 15)
            {
                text = 0;
                floattext = 0;
                llSetText("",<1,1,1>,1);
            }
        }
    }
}
state recovery
{//this is the recovery state. when a female has waited her entire pregnancy she will come to this state to recover
    state_entry()
    {
        relis();
        status = "Recovering";
        make_baby();
        llSetTimerEvent(1.0);
    }
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
    object_rez(key id)
    {
        egg = id;
    }
    touch_start(integer x)
    {
        floattext = 1;
        show_text();
    }
    listen(integer c,string name,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m, ["^"], []);
        if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1) == "eat_food")
            {
                integer rnum = (integer)llList2String(t,2);
                if(rnum == randomfnum)
                {
                    hunger-=llList2Integer(t,3);
                    if(hunger < 0)hunger = 0;
                    update();
                }
            }
        }else if(id == egg)
        {
            llSay(0,"giving child a prim and its information");
            llGiveInventory(id,llGetInventoryName(INVENTORY_OBJECT,0));
            llSay(com_chan,(string)id+"^configure_pet^"+babydata);
            egg = NULL_KEY;
        }
    }
    timer()
    {
        movetick++;
        if(movetick >= movetime)
        {
            movetick = 0;
            move();
        }
        agetick++;
        if(agetick >= agetime)
        {
            agetick = 0;
            age++;
            update();
        }
        
        recoverytick++;
        if(recoverytick >= recoverytime)
        {
            state female;
        }
        
        if(seeds > 0)
        {
            eattick++;
            if(eattick >= eatcall)
            {
                eattick = 0;
                hunger++;
                debug("calling food");
                update();
                call_food();
            }
        }
        if(floattext == 1)
        {
            text++;
            if(text >= 15)
            {
                text = 0;
                floattext = 0;
                llSetText("",<1,1,1>,1);
            }
        }
    }
}
state dead
{//this is the death state. dead pets come here.
    state_entry()
    {
        relis();
        llSetText("Died due to ["+reason+"]",<1,0,0>,1);
    }
    link_message(integer s,integer r,string str,key id)
    {
        process_link(r,str,(string)id);
    }
    listen(integer c,string name,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m,["^"],[]);
        if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1)=="potion")
            {
                if(llList2String(t,2)=="revive")usepotion(llList2String(t,1));
            }
        }
    }
}
state updater
{
    state_entry()
    {
        relis();
        llSay(com_chan,"pet_ready_for_update");
    }
    listen(integer c,string n,key id,string m)
    {
        if(llGetOwnerKey(id)!=llGetOwner())return;
        list t = llParseString2List(m,["^"],[]);
        if(llList2String(t,0) == (string)llGetKey())
        {
            if(llList2String(t,1) == "update_pet")
            {
                llSetText("updating",<1,1,1>,1);
                llSetObjectDesc("Reset");
                llMessageLinked(LINK_SET,123,"update_mode","");
                llRemoveInventory(llGetInventoryName(INVENTORY_OBJECT,0));
                llRemoveInventory("menu");
                llRemoveInventory("scale");
                llSay(com_chan,"clean_ready");
                llRemoveInventory(llGetScriptName());
            }
        }
    }
}