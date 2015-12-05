// PARAMOUR PRIVATE DANCER
// by Mata Hari/Aine Caoimhe May 2014
//
// *** LICENCE ***
// This script is supplied under the terms of the GPU General Public License 3.0
// You are free to modify, copy,and/or redistribute this work provided you:
// 1. Supply it free of charge
// 2. Attribute it as the modified work of the original creator (Mata Hari/Aine Caolmhe)
// 3. Also make your modified version freely available to copy, modify, and redistribute under the same GPU3.0 terms that this script was given.
// Full text of the GPU General Public License are available at http://www.gnu.org/licenses/gpl.html
//
// The animations contained in this object *ARE NOT* my creation, however I obtained them with full perms under GPU3.0 as well so you may
// freely copy and redistribute them under the same terms.
//
// *** OVERVIEW ***
// The Paramour Private Dancer stage is designed to be used either as a free-standing object to rez on the ground *or* worn as an attachment.
// This lets you use it anywhere you want! In regions where scripts are active, the owner can switch things on or off on the fly by touching
// the platform (even when rezzed on the ground and someone else is using it). Only the owner can do this though.
//
// In regions where scripts are disabled you can still use this in a very basic way as an attachment; however you will need to copy
// all of the animations into your own inventory and either play them one by one, manually, or set up them up as an "AO" in viewers that support
// this feature (most V3 viewers now have some method of doing this, allowing you to use an AO in regions where scripts are disabled). The platform
// will be "stuck" at whatever the last light and particle effect values were applied to the prims at the time the script was last active.
//
// In regions where facelights are disabled, the point light part of the lighting system will not be visible when using the platform as an attachment
// (but will work perfectly when rezzed on the ground). The colours will still change though.
//
// *** INSTRUCTIONS ***
// The Paramour Private Dancer Stage comes with a set of default values that should let you use it right away as either a ground-rezzed stage or an attachment.
//
// If you're rezzing it to the ground to use as a conventional stage (either for yourself or others to use) all you need to do is sit on it.
// If it's going to be your own personal stage you may want to tweak the supplied default generic sit position to give a better "fit" for your
// avatar. I suggest using the Magic Sit Kit to determine the optimum position and rotation.
//
// To use it as an attachment you need to be in camera view (NOT MOUSELOOK!) and you will need to stand motionless on a spot (don't move or turn your avi...only
// move or pan your camera control). If you move, the stage will move with you which will look very, very weird. :P You'll also want to disable your
// AO if you're using one. Then simply attach the stage to your "Avatar Center" attachment point (it must be this one!). If the region has scripts enabled
// you should begin to dance immediately (it will take a few moments to get each of the animations from the server if your viewer cache doesn't already have
// them stored). When you're finished dancing, just detach it again.
//
// The first time you use the stage as an attachment you'll need to position it correctly on the Avatar Center attachment point and you may also want to create a
// duplicate of your avatar shape to wear while using it. Edit the duplicate shape by adjusting your "hover" height to be somewhat above normal ground level. I have
// found a hover value in the 53-55 range works well for me. That makes sure there's enough "clearance" to have the some of the platform portion of the dance pole be
// clearly visible above the floor without your feet disappearing into it...play with the hover value and attachment position until it looks right. The base is
// supplied 'extra-large" so it will sink deeply into the ground - you can edit this to be much smaller if you want (the enitre stage is full perm so you can
// tweak sizing and textures however you want them...just don't change the prim names and make sure the object containing this script remains the root prim.
// The x- and y-axis positioin for attachment should be 0 since that's how the animations seem to have been created. That said, the animations aren't perfect
// so don't waste too much time trying to get it "right" for one since the odds are it won't be perfect for all of them. One day maybe someone will make a better
// set of animations - hint hint. If you find some, I'd love to get a copy from you please.
//
// All supplied animations use the same root position (which is roughly avatar center at the ground) so if you want to add any new ones they'll
// also need to have this same root position -- this requirement was selected becasuse when worn as an attachment the stage *can't* move you so it
// needs to be based on a ground-standing avatar.
//
// In regions where scripts are enabled, the owner can touch the stage at any time to access a dialog menu that allow you to switch the lights and particle effects
// on or off or change the timers on the fly. These will only persist until the next time the dance pole script is reset.
//
// *** ADDITIONAL NOTES ***
// Normally I am meticulous about closing listeners (used for dialogs) by setting a timer when showing the dialog and then closing the listener if a response hasn't been
// received in a reasonable period of time. Unfortunately this script needs the two convenient timer methods for other things so I can't do this, so if you initiate a
// dialog the listener will be active until you respond to it (or the script resets) and will remain active even if you ignore or close the dialog without responding. To
// minimize (very small) region resource usage of the listener, if you accidentally do this just touch the pole again to initiate a dialog and then "cancel" to close it out properly.
//
// While this script is one of the few I've written recently that doesn't use OSSL, it should still be compatible with an NPC that is scripted
// to sit on it or wear it however for the animation part to work the NPC MUST BE CREATED WITH THE SENSE_AS_AGENT flag set to true If the NPC was created 
// by a script owned by someone other than the owner of this script, they must also have the OS_NPC_NOT_OWNED flag set. If NPC animations are being
// handled by another script and the stage is set to only handling lighting and particle effects, it should function regardless of how the NPC
// was created (I haven't tested this though). If an NPC is wearing the stage, it technically "belongs" to the NPC so the dialog won't be available to you.
//
// This script was adapted from my portable dancepole  model so many of the variable names may include "pole" as part of the name...it was easiest just to leave it that way
// even though from a naming standpoint it's odd. I updated to the text to reflect the stage but it's possible I missed a few places.
//
// *** USER SETTINGS ***
// The default values supplied below should be fine for most users but you can change them to any of the allowed values to suit your personal preferences. You'll need to
// be in a region that allows scripts to be editted and if the stage is being worn as an attachment you'll probably need to unwear and rewear it again before it will
// behave properly. Be sure to use the correct exact spelling of any names (including using all-caps for them).
//
// 1. Settings to use when stage is used as a free-standing floor model
// These settings only apply to the stage when it is rezzed on the ground
integer ownerOnly=FALSE;                        // TRUE = anyone can the dance pole. FALSE = only the owner can dance on it
vector sitPos=<0.0, 0.0, 0.65>;                 // sit target position (I suggest using the Magic Sit Kit to determine this)
rotation sitRot=ZERO_ROTATION;                  // sit target rotation (ditto)
string emptyBehaviour="CONTINUE";               // What to do when nobody is dancing:
                                                // - "CONTINUE" = keep doing any lighting and/or particle effects just like when someone is dancing. This setting
                                                //                will continue to use region simulator resources whereas most other options will allow the script
                                                //                to sleep, using minimal region resources.
                                                // - "SET_DEFAULT" = the script will reset and then use whatever the default values are
                                                // - "SET_OFF" = disable everything...lights will go "black" and any particle effects will be stopped. When someone sits
                                                //               on the pole again it will activate beginning with the default values. Until then, script will sleep
                                                // - "FREEZE" = lights and particle effects values will be frozen at whatever they're currently set to and stay that way
                                                //              until someone sits down again, at which point they'll resume. The script will sleep during that time.

// 2. Settings to use when dance pole is used as an attachment
// These settings only apply to the stage when it is being worn -- it needs to be attached to the "Avatar Center" attachment point
string detachBehaviour="FREEZE";                // When using the stage as an attachment do you want to reset it or attempt to store existing state
                                                // FREEZE = the script will try to remember all current values at the time it is detached (not 100% reliable since the
                                                //          detach event in LSL scripting is a little wonky and the results are somewhat unpredictable)
                                                // SET_DEFAULT = when you next attach the dance pole the script will reset, returning to the default values you've set
//
// 3. Global settings
// All other settings apply to the pole regardless of whether it's attached or free-standing.
//
integer noDialogChatResponses=FALSE;            // When using the dialog menu, after many actions the stage confirms the change in general chat (but it uses llOwnerSay so only you can see it)
                                                // Once you've been using it for a while you may find these messages unnecessary (or even annoying).
                                                // TRUE = don't say any confirmation messages....FALSE = confirm changes
// 3.1 Animations -- settings that affect animation system
integer animateFromPole=TRUE;                   // TRUE = this script will use the animations it finds in its inventory and play then as per the settings here.
                                                // FALSE = this script will disable its animation system and only handle the lighting and particle effects. The user will need to have
                                                //          the animations in his/her own inventory and either use a built-in viewer AO or manually selecting and play them from inventory.
                                                //          I strongly recommend setting it to TRUE and then only use an AO version if you attach it in a region that doesn't allow scripts
float animTimer=60.0;                           // how long (in seconds) to play the current animation before advancing to the next. Cannot be 0.
integer animRandomOrder=FALSE;                  // TRUE = randomly select the next animation - the same animation won't be picked again until all have been played
                                                //        at which point the list will be re-shuffled and played again (so it's *possible* but unlikely that an
                                                //        animation might be last on the list and then end up first on the newly shuffled list and end up playing twice in a row
                                                // FALSE = animations are played in the order that they appear in the stage's inventory
//
// 3.2 Lighting effects
// The lighting system is all run by a single timer which is the shortest time between any lighting changes. The shorter the timer the more rapidly lights will change, but also
// the more load it will place on the region simulator (and since you want lights to enhance the pole-dancing, I'd suggest not using very short values anyway since the lights will
// then be more of a distraction than anything).
string lightColourModeSpots="UNIFORM";          // the lighting mode to use for the four spotlights....they will change the light shining on the dancer
                                                // UNIFORM = all 4 spotlights will be the same colour
                                                // SIDE_SPLIT = spotlight #1 and #2 (which are adjacent) will use one colour and the other two will use the assigned "opposite 
                                                //              colour" (see colour settings section below)
                                                // CROSS_SPLIT = spotlight #1 and #3 (which are opposite one another) will use one colour and the other two will use the
                                                //               assigned "opposite colour".
                                                // QUAD_RANDOM = all four spotlights will be given random colours from the list and no two spotlights will be the same
                                                // SPOTS_OFF = spotlights will be turned off completely and hidden (by setting their alpha to zero). Potlights will treat this
                                                //             as having the spots set in UNIFORM mode and "pretend" that spotlight #1 is changing.
string lightColourModePots="MATCH_SAME";        // the lighting mode to use for the eight small lights in the base...these don't have any effect on the lighting on the dancer and depend on the spotlight mode
                                                // MATCH_SAME  = if spotlight mode is UNIFORM, SIDE_SPLIT or CROSS_SPLIT the potlights will each use the colour of the spotlight closest above it (so
                                                //               they will be in pairs). If spotlight mode is random, all 8 potlights will be given random colours.
                                                // MATCH_OPPOSITE = if spotlight mode is UNIFORM, SIDE_SPLIT or CROSS_SPLIT the potlights will use the assigned opposite colour of the spotlight closest above it
                                                //                  They will be give random colours if spotlight mode is QUAD_RANDOM.
                                                // UNIFORM_RANDOM = all 8 potlights will use the same colour, randomly selected from the list
                                                // UNIFORM_MATCH = all 8 potlights will use the same colour as spotlight #1 regardless of spotlight mode
                                                // UNIFORM_OPPOSITE = all 8 potlights will use the assigned colour opposite of spotlight #1 regardless of spotlight mode
                                                // CROSS_MATCH = potlights #1, 3, 5, and 7 will use the same colour as spotlight #1 and the other four will use the assigned opposite colour regardless of spotlight mode
                                                // CROSS_RANDOM = potlights #1, 3, 5 and 7 will use one randomly selected colour and the other 4 will use their assigned opposite colour regardless of spotlight mode
                                                // PURE_RANDOM = potlights will use randomly selected colours (all different) regardless of spotlight mode
                                                // POTS_OFF = potlights will be hidden by setting their alpha to zero.
float lightTimer=5.0;                           // time (in seconds) between changes in spotlight colour. If you set this to zero no lights will change AND IT WILL ALSO DISABLE ANY PARTICLE EFFECT CHANGES
                                                // so you would need to use the dialog to turn those on or off
integer lightCycleRandom=TRUE;                  // TRUE = the order that colours will "play" is random but each colour will be "played" once before being repeated. Once all have played, the
                                                //       colour list order is re-shuffled (so it's possible but very unlikely that the same colour selection could "play" twice in a row).
                                                // FALSE = the order that colours will "play" is the same as their order in the list of available colours and cycles continually through
                                                //         the list.
integer cycleLightMode=TRUE;                    // TRUE = if lightColourModeSpots is not SPOTS_OFF after the spots have changed colour a certain number of times the mode will advance to the next one in the list
                                                //        and the potlights mode does not change
                                                //        if lightColourModeSpots = SPOTS_OFF and lightColourModePots is not also POTS_OFF, potlights mode will change after a certain number of colour changes
                                                // FALSE = neither slotlights nor potlights will change from their preset modes unless changed via dialog
integer cycleLightChange=13;                    // if cycleSpotMode=TRUE, how many times to change colours before advancing the mode to the next one. Ignored if cycleSpotMode=FALSE
//
// 3.3 Colour definitions
// This section defines the list of available colours that will be used for the spotlights and potlights. During use, if you switch the light cycling from random to squential or reset the script, the colour list
// will be re-sorted by colour name which may not be the same as it appears in the list of colours, so if that's important then make sure you have a list that will sort correctly (usually be prefixing names with a 1, 2, 3, etc.)
// The list can be as long as you want, but each colour in the list must be supplied with the following 4 details:
// - colour name -- must be a unique name
// - colour vector -- the standard LSL vector value of the colour where <0.0, 0.0, 0.0> is black and <1.0,1.0,1.0> is white
// - colour intensity value to use when a spotlight has this colour. 0.0 is none, 1.0 is maximum but avoid using very high values since there are 4 spotlights and this will tend to wash out the viewer.
// - colour opposite is the name of the colour to use as the "opposite" of this colour...the name must be in the list and be exactly identical (including caps, spaces, etc). If you want, you can name a colour
//   as its own opposite and you don't have to have it be a reciprocal relationship (so you could set it up with red has blue as its opposite, but blue has yellow, and yellow has red...as long as all three are in the list)
// YOU MUST DEFINE A MINIMUM OF 8 COLOURS but setting up 12 or more is best. There used to be (and maybe still is?) a bug where there was a limit to the length of a list that can be read when it is first defined like this
// as a global so I'd suggest no more than about 24 (and with even that many the differences between colours would be pretty minimal)
list colourList=[
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
float radius=3.0;                               // radius value to use in the pointlight setting for all spotlights...this is how far their light can project and should usually be close to the default value.
float falloff=0.75;                             // falloff value to use in the pointlight setting for all spotlights...this is how rapidly their light level falls off as it approaches the maximum radius and should be around 0.75
float lightGlow=0.15;                           // value to set for PRIM_GLOW on both spotlights and potlights when on... somewhere in the 0.1 to 0.2 range looks best on my viewer
// 
// 3.4 Particle Effects
// The stage has two optional particle effects with the following default appearance:
// - a gentle fog cloud that floats around the large base platform piece that and drifts outwards a bit into the room -- set by the particleBaseSet variable values
// - a narrow column of fairly dense fog rising from each of the 8 potlights (even if they are invisible) -- set by the particlePotsSet variable values
// NOTE: all cyclic particle effects are based on the value of the lightTimer so if you set it to 0.0 the particle effects won't change
// 3.4.1 Base platform particle effect settings
list particleBaseSet=[
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
integer particleBaseOn=TRUE;                         // TRUE=particle defaults to be active wnen reset...FALSE=particle is off by default
integer particleBaseCyclic=FALSE;                    // TRUE=particle turns on and off on a periodic basis...FALSE=particle state doesn't change
integer cyclesBaseOff=1;                             // if particle is cyclic, how many light timer cycles to spend in off state before becoming active...ignored if cyclic is FALSE
integer cyclesBaseOn=10000000;                       // if particle if cyclic, how many light timer cycles to spend in the off state before disabling...ignored if cyclic is FALSE
// NOTE: even if you set the cyclic to FALSE you should still supply off and on values in case you force a change using the dialog system
// 3.4.2 Potlights particle effect settings (applied to all 8)
list particlePotsSet=[
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
integer particlePotsOn=FALSE;
integer particlePotsCyclic=TRUE;
integer cyclesPotsOff=23;
integer cyclesPotsOn=1;
//
// # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
// # #    MAIN SCRIPT STARTS HERE - DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING!    # #
// # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
// globals
// prims
list linksSpots;
list linksPots;
list linksGantry;
integer linksPlatform;
// dialog
integer handle;
integer channel;
string menuLevel="MAIN_MENU";
string storedSpotMode;
string storedPotMode;
// animation
key userID;
list animList;
integer animInd;
// color tracking
float currentTimer;
integer colourInd;
integer cycleCount;
// particle tracking
integer cycleBase;
integer cyclePots;
integer storedCyclicBase;
integer storedCyclicPots;

showMainMenu()
{
    string txtDia="Please select an option.\n"
                 +"'Freeze' stops the lighting/particle effect timer until you 'Unfreeze' it\n"
                 +"Chat On/Off sets whether you want to see confirmation messages when you make changes"
                 +"In the first row of buttons, 'All On' or 'All Off' only affects the lights";
    list butR1;
    if (lightColourModeSpots=="SPOTS_OFF") butR1+=["Spots On"];
    else butR1+=["Spots Off"];
    if (lightColourModePots=="POTS_OFF") butR1+=["Pots On"];
    else butR1+=["Pots Off"];
    if ((lightColourModeSpots=="SPOTS_OFF") || (lightColourModePots=="POTS_OFF")) butR1+=["All On"];
    else butR1+=["All Off"];
    list butR2;
    if (particleBaseOn) butR2+=["Part1 Off"];
    else butR2+=["Part1 On"];
    if (particlePotsOn) butR2+=["Part2 Off"];
    else butR2+=["Part2 On"];
    butR2 +=["-"];
    list butR3;
    if (currentTimer==0.0) butR3+=["Unfreeze"];
    else butR3+=["Freeze"];
    butR3+=["Timer Anim","Timer Lights"];
    list butR4=["DONE"];
    if (noDialogChatResponses) butR4+=["Chat On"];
    else butR4+=["Chat Off"];
    butR4+=["RESET"];
    menuLevel="MAIN_MENU";
    handle=llListen(channel,"",llGetOwner(),"");
    llDialog(llGetOwner(),txtDia,(butR4+butR3+butR2+butR1),channel);
}
showAnimMenu()
{
    string txtDia="How often (in seconds) would you like the current dancer to advance to the next animation?\n\nNote: this DOES NOT change the scripted value so next time stage is used it will revert to the default. Selecting any value other than 'never' also advances the dancer to the next animation (to keep it in synch with the timer)";
    menuLevel="ANIM_MENU";
    handle=llListen(channel,"",llGetOwner(),"");
    llDialog(llGetOwner(),txtDia,(["never","-","CANCEL","120","300", "600","15", "30", "60"]),channel);
}
showLightsMenu()
{
    string txtDia="What time (in seconds) would you like to set the lighting effect timer to?\n\nNote: This also effects the frequency of particle effects and choosing 'never' will disable them!)";
    menuLevel="LIGHTS_MENU";
    handle=llListen(channel,"",llGetOwner(),"");
    llDialog(llGetOwner(),txtDia,["never","default","CANCEL","10","15","30","4","5","7","1","2","3"],channel);
}
updateParticles()
{
    if (particleBaseOn) llLinkParticleSystem(linksPlatform,particleBaseSet);
    else llLinkParticleSystem(linksPlatform,[]);
    list rulesForPots=[];
    if (particlePotsOn) rulesForPots=particlePotsSet;
    {
        integer i;
        while (i<8)
        {
            llLinkParticleSystem(llList2Integer(linksPots,i),rulesForPots);
            i++;
        }
    }
}
setStartParticles()
{
    // called when script is reset - can occur when attached
    cycleBase=0;
    cyclePots=0;
    updateParticles();
}
setLights()
{
    list spotInd;   // list of the 4 colour indexes to use for the spotlights this time
    list potInd;    // list of the 8 colour indexes to use for the potlights this time
    integer oppositeIndex=(integer)(llListFindList(colourList,[llList2String(colourList,(colourInd*4)+3)])/4); // this is the defined opposite colour of the current colour index
    // first determine what to set the spotlights to
    if ((lightColourModeSpots=="UNIFORM") || (lightColourModeSpots=="SPOTS_OFF")) spotInd=[colourInd,colourInd,colourInd,colourInd];
    else if (lightColourModeSpots=="SIDE_SPLIT") spotInd=[colourInd,colourInd,oppositeIndex,oppositeIndex];
    else if (lightColourModeSpots=="CROSS_SPLIT") spotInd=[colourInd,oppositeIndex,colourInd,oppositeIndex];
    else if (lightColourModeSpots=="QUAD_RANDOM")
    {
        spotInd+=[colourInd];
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
    else 
    {
        llOwnerSay("ERROR! Unable to understand the current lightColourModeSpots variable setting of "+(string)lightColourModeSpots+" in section 3.2 of User Settings");
        return;
    }
    // now handle pots
    if (lightColourModePots=="MATCH_SAME") potInd=[llList2Integer(spotInd,0),llList2Integer(spotInd,0),llList2Integer(spotInd,1),llList2Integer(spotInd,1),llList2Integer(spotInd,2),llList2Integer(spotInd,2),llList2Integer(spotInd,3),llList2Integer(spotInd,3)];
    else if (lightColourModePots=="MATCH_OPPOSITE") // despite what is said in intructions we don't actually look up colour opposites unless spots are random
    {
        if ((lightColourModeSpots=="UNIFORM") || (lightColourModeSpots=="SPOTS_OFF")) potInd=[oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex];
        else if (lightColourModeSpots=="SIDE_SPLIT") potInd=[oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,colourInd,colourInd,colourInd,colourInd];
        else if (lightColourModeSpots=="CROSS_SPLIT") potInd=[oppositeIndex,oppositeIndex,colourInd,colourInd,oppositeIndex,oppositeIndex,colourInd,colourInd];
        else
        {
            potInd=[oppositeIndex,oppositeIndex];
            potInd+=[(integer)(llListFindList(colourList,[(llList2String(colourList,(llList2Integer(spotInd,1)*4)+3))])/4),(integer)(llListFindList(colourList,[(llList2String(colourList,(llList2Integer(spotInd,1)*4)+3))])/4)];
            potInd+=[(integer)(llListFindList(colourList,[(llList2String(colourList,(llList2Integer(spotInd,2)*4)+3))])/4),(integer)(llListFindList(colourList,[(llList2String(colourList,(llList2Integer(spotInd,2)*4)+3))])/4)];
            potInd+=[(integer)(llListFindList(colourList,[(llList2String(colourList,(llList2Integer(spotInd,3)*4)+3))])/4),(integer)(llListFindList(colourList,[(llList2String(colourList,(llList2Integer(spotInd,3)*4)+3))])/4)];
        }
    }
    else if (lightColourModePots=="UNIFORM_RANDOM")
    {
        integer randPotCol=(integer)(llFrand(llGetListLength(colourList)/4));
        potInd=[randPotCol,randPotCol,randPotCol,randPotCol,randPotCol,randPotCol,randPotCol,randPotCol];
    }
    else if (lightColourModePots=="UNIFORM_MATCH") potInd=[colourInd,colourInd,colourInd,colourInd,colourInd,colourInd,colourInd,colourInd];
    else if (lightColourModePots=="UNIFORM_OPPOSITE") potInd=[oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex,oppositeIndex];
    else if (lightColourModePots=="CROSS_MATCH") potInd=[colourInd,oppositeIndex,colourInd,oppositeIndex,colourInd,oppositeIndex,colourInd,oppositeIndex];
    else if (lightColourModePots=="CROSS_RANDOM")
    {
        integer randPot=(integer)(llFrand(llGetListLength(colourList)/4));
        integer oppPot=(integer)(llListFindList(colourList,[(llList2String(colourList,(randPot*4)+3))])/4);
        potInd=[randPot,oppPot,randPot,oppPot,randPot,oppPot,randPot,oppPot];
    }
    else if (lightColourModePots=="PURE_RANDOM")
    {
        potInd+=[colourInd];
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
    else if (lightColourModePots!="POTS_OFF")
    {
        llOwnerSay("ERROR! Unable to understand the current lightColourModePots variable setting of "+(string)lightColourModePots+" in section 3.2 of User Settings");
        return;
    }
    // at this point spotInd and potInd contain the list of colour index values for their lights so set them
    if (lightColourModeSpots!="SPOTS_OFF")
    {
        integer s;
        while(s<4)
        {
            llSetLinkPrimitiveParamsFast(llList2Integer(linksSpots,s),[
                    PRIM_COLOR, ALL_SIDES, llList2Vector(colourList,(llList2Integer(spotInd,s)*4) + 1),1.0,
                    PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                    PRIM_GLOW, ALL_SIDES, lightGlow,
                    PRIM_POINT_LIGHT, TRUE, llList2Vector(colourList,(llList2Integer(spotInd,s)*4) + 1), llList2Float(colourList,(llList2Integer(spotInd,s)*4) + 2), radius, falloff
                ]);
            s++;
        }
    }
    if (lightColourModePots!="POTS_OFF")
    {
        integer p;
        while(p<8)
        {
            llSetLinkPrimitiveParamsFast(llList2Integer(linksPots,p),[
                    PRIM_COLOR, ALL_SIDES, llList2Vector(colourList,(llList2Integer(potInd,p)*4) + 1),1.0,
                    PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
                    PRIM_GLOW, ALL_SIDES, lightGlow
                ]);
            p++;
        }
    }
}
setStartLighting()
{
    // called when script is reset - can occur when attached
    colourInd=0;
    if (lightCycleRandom) colourList=llListRandomize(colourList,4);
    if (lightColourModeSpots=="SPOTS_OFF") showGantry(FALSE);
    else showGantry(TRUE);
    if (lightColourModePots=="POTS_OFF") showPots(FALSE);
    else showPots(TRUE);
    if ((llGetAttached()==0) && (emptyBehaviour=="SET_OFF"))
    {
        spotsOff();
        potsOff();
    }
    else setLights();
}
spotsOff()
{
    float alpha=1.0;
    if (lightColourModeSpots=="SPOTS_OFF") alpha=0.0;
    integer i=llGetListLength(linksSpots);
    while(--i>-1)
    {
        llSetLinkPrimitiveParamsFast(llList2Integer(linksSpots,i),[
                PRIM_COLOR, ALL_SIDES, <0.05, 0.05, 0.05>,alpha,
                PRIM_FULLBRIGHT, ALL_SIDES, FALSE,
                PRIM_GLOW, ALL_SIDES, 0.0,
                PRIM_POINT_LIGHT, FALSE, <0.0,0.0,0.0>, 0.0, 0.0, 0.0
            ]);
    }
}
potsOff()
{
    float alpha=1.0;
    if (lightColourModePots=="POTS_OFF") alpha=0.0;
    integer i=llGetListLength(linksPots);
    while(--i>-1)
    {
        llSetLinkPrimitiveParamsFast(llList2Integer(linksPots,i),[
                PRIM_COLOR, 0, <0.05, 0.05, 0.05>,alpha,
                PRIM_FULLBRIGHT, 0, FALSE,
                PRIM_GLOW, 0, 0.0
            ]);
    }
}
showGantry(integer on)
{
    integer i=llGetListLength(linksGantry);
    while(--i>-1)
    {
        llSetLinkAlpha(llList2Integer(linksGantry,i),(float)on,ALL_SIDES);
    }
}
showPots(integer on)
{
    integer i=llGetListLength(linksPots);
    while(--i>-1)
    {
        llSetLinkAlpha(llList2Integer(linksPots,i),(float)on,ALL_SIDES);
    }
}
handleStartUsage()
{
    // called either when first attached or when first sat upon
    llSetClickAction(CLICK_ACTION_TOUCH);
    if (animateFromPole) startAnimations();
    // don't do a light or particle change until one cycle has elapsed
    llSetTimerEvent(currentTimer);
}
handleResetOnGround()
{
    setStartLighting();
    setStartParticles();
    if (emptyBehaviour="CONTINUE") llSetTimerEvent(currentTimer);
}
handleIdleGround()
{
    // handle anything that needs to happen when the pole has been rezzed on the ground and someone stops using it
    llSetClickAction(CLICK_ACTION_SIT);
    if (emptyBehaviour=="CONTINUE") return;
    else if (emptyBehaviour=="SET_DEFAULT") llResetScript();
    else if (emptyBehaviour=="SET_OFF") llResetScript();
    else if (emptyBehaviour=="FREEZE") llSetTimerEvent(0.0);
    else llOwnerSay("ERROR! The current setting of the emptyBehaviour variable in section 1 of the User Settings is invalid. Please check your script. Current value is "+(string)emptyBehaviour);
}
// handleSit()  not required...handled from changed event trigger instead
handleAttach()
{
    // just attached - make sure it's where it is supposed to be
    if (llGetAttached()!=40) //     ATTACH_AVATAR_CENTER = 40....not currently defined in Opensim
    {
        llRegionSayTo(llGetOwner(),0,"The stage must be attached to the Avatar Center attachment point to work");
        llDetachFromAvatar();
        return;
    }
    // store userID and then request perms which should be auto-granted
    userID=llGetOwner();
    llRequestPermissions(userID,PERMISSION_TRIGGER_ANIMATION);
}
handleDetach()
{
    // handle anything that needs to happen when the pole was being worn as an attachment and is detached
    if (animateFromPole) stopAnimations();      // release animations
    // script should go to sleep automatically shortly after detach but just to be sure stop the timer
    llSetTimerEvent(0.0);
    // inbound event handles the setting to reset on attach
}
startAnimations()
{
    // called when first beginning to animate and pole is handling animations
    // make sure we have some animations to play
    if (llGetListLength(animList)==0)
    {
        llRegionSayTo(userID,0,"ERROR! Stage is set to play animations from inventory but couldn't find any! Please add some and reset script");
        return;
    }
    // start playing first animation and then stop all other animations that the avi was playing
    list animToStop=llGetAnimationList(userID);
    integer an=llGetListLength(animToStop);
    llStartAnimation(llList2String(animList,animInd));
    while(--an>-1)
    {
        llStopAnimation(llList2Key(animToStop,an));
    }
    // since we need 2 timers (one for animation and one for everything else) we use sensor repeat to handle the animation side of things
    if (animTimer==0.0)
    {
        animTimer=30.0; // fallback time in case user set to 0 for some silly reason
        llOwnerSay("WARNING! the animTimer setting in the animation section is set to zero but must be a positive time if the stage is handling animations. Defaulting to 30 seconds");
    }
    llSensorRepeat("THIS_SENSOR_TEST_SHOULD_NEVER_RETURN_A_RESULT", NULL_KEY, 0, 1.0, 0.01, animTimer); // this should never trigger a successful sensor event
}
stopAnimations()
{
    // called when detached or unsit
    // we need to release anims
    llStartAnimation("stand");
    llStopAnimation(llList2String(animList,animInd));
    userID=NULL_KEY;
    // and release sensor
    llSensorRemove();
}
playNextAnim()
{
    // called by sensor event - play the next animation
    string anToStop=llList2String(animList,animInd);
    animInd++;
    if (animInd>=llGetListLength(animList))
    {
        // use this opportunity to check if animations in inventory have changed...list is rebuilt and index set to 0
        buildAnimsList();
        // make sure we don't start with the same animation we just played (and security check to make sure it can't get into infinite loop)
        while ((llList2String(animList,0)==anToStop) && (llGetListLength(animList)>1))
        {
            animList=llListRandomize(animList,1);
        }
    }
    llStartAnimation(llList2String(animList,animInd));
    llStopAnimation(anToStop);
}
buildAnimsList()
{
    animList=[];
    integer i=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--i>-1)
    {
        animList+=llGetInventoryName(INVENTORY_ANIMATION,i);
    }
    if (animRandomOrder) animList=llListRandomize(animList,1);
    else animList=llListSort(animList,1,TRUE);
    animInd=0;
}
buildLinkList()
{
    linksSpots=[];
    linksPots=[];
    linksGantry=[];
    list spotlights;
    list potlights;
    integer link=llGetNumberOfPrims();
    while (link)
    {
        string primName=llGetLinkName(link);
        if (link == llGetLinkNumber()) linksPlatform=link;
        else if (primName=="reflector dish") linksGantry+=[link];
        else if (primName=="light body") linksGantry+=[link];
        else if (primName=="gantry bar") linksGantry+=[link];
        else if (llSubStringIndex(primName,"pot light")==0) potlights+=[primName,link];
        else if (llSubStringIndex(primName,"spotlight")==0)
        {
            spotlights+=[primName,link];
            linksGantry+=[link];
        }
        link--;
    }
    potlights=llListSort(potlights,2,TRUE);
    integer l=llGetListLength(potlights);
    integer i;
    while(i<l)
    {
        linksPots+=[llList2Integer(potlights,i+1)];
        i+=2;
    }
    spotlights=llListSort(spotlights,2,TRUE);
    l=llGetListLength(spotlights);
    i=0;
    while(i<l)
    {
        linksSpots+=[llList2Integer(spotlights,i+1)];
        i+=2;
    }
    if (llGetListLength(linksSpots)!=4) llOwnerSay("ERROR! Unable to find the 4 expected spotlight prims");
    if (llGetListLength(linksPots)!=8) llOwnerSay("ERROR! Unable to find the 8 expected potlight prims");
    if (!linksPlatform)  llOwnerSay("ERROR! Unable to find the expected base platform prim");
    if (llGetListLength(linksGantry)!=12) llOwnerSay("WARNING! Expected to find 12 items to treat as the spot system but found "+(string)llGetListLength(linksGantry)+"instead");
}

default
{
    state_entry()
    {
        userID=NULL_KEY;
        cycleCount=0;
        channel=0x80000000|(integer)("0x"+(string)llGetKey());
        currentTimer=lightTimer;
        buildLinkList();
        buildAnimsList();
        if (sitPos==ZERO_VECTOR) sitPos=<0,0,0.000001>;
        llSitTarget(sitPos,sitRot);
        // need to handle initial behaviour
        if (llGetAttached()==0) handleResetOnGround();  // rezzed to ground
        else
        {
            setStartLighting();
            setStartParticles();
            handleAttach();
        }
    }
    on_rez(integer start_param)
    {
        llSetClickAction(CLICK_ACTION_SIT);
        llResetScript();
    }
    attach(key id)
    {
        if (id==NULL_KEY)
        {
            // detached
            handleDetach();
            return;
        }
        else
        {
            if (detachBehaviour=="SET_DEFAULT")
            {
                llRegionSayTo(id,0,"One moment while your stage's script is being reset");
                llResetScript();
            }
            else handleAttach();
        }
    }
    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_REGION_START) llResetScript();
        if (change & CHANGED_LINK)
        {
            if(llGetAttached()) return;     // attach event will handle
            key sitter=NULL_KEY;
            integer link=llGetNumberOfPrims();
            while(link)
            {
                if (llGetAgentSize(llGetLinkKey(link))!=ZERO_VECTOR) sitter=llGetLinkKey(link);
                link--;
            }
            if (sitter==NULL_KEY)
            {
                // nobody seated stop any animations we were doing or else ensure userID is cleared
                if ((userID!=NULL_KEY) && (animateFromPole) && (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)) stopAnimations();
                else userID=NULL_KEY;
                // and set to idle ground
                handleIdleGround();
                return;
            }
            else
            {
                // someone is seated
                if (userID==NULL_KEY)
                {
                    // see if new user is allowed to sit her
                    if (ownerOnly && (sitter!=llGetOwner()))
                    {
                        llRegionSayTo(sitter,0,"Sorry, only the owner has permission to use this");
                        llUnSit(sitter);
                        return;
                    }
                    // new user request perms - should auto-grant
                    userID=sitter;
                    llRequestPermissions(userID,PERMISSION_TRIGGER_ANIMATION);
                }
                else
                {
                    // already had a key stored...see if it somehow changed unexpectedly
                    if (sitter!=userID)
                    {
                        llRegionSayTo(sitter,0,"ERROR! I already had a key stored for a user but found a different key for sitter! Sorry");
                        llUnSit(sitter);
                        return;
                    }
                    else
                    {
                        // somehow this got triggered during use so handle it like a new sit/attach
                        llRequestPermissions(userID,PERMISSION_TRIGGER_ANIMATION);
                    }
                }
            }
            return;
        }
    }
    run_time_permissions(integer perm)
    {
        // triggered either by a call from somoene sitting on it when it's rezzed on ground, or when initially attached by an avi
        handleStartUsage();
    }
    no_sensor()
    {
        // this is the expected result of the sensor we're using...make sure animation timer should still be going
        if (llGetAgentSize(userID)==ZERO_VECTOR)
        {
            llSensorRemove();
            userID=NULL_KEY;
            if (llGetAttached()) llOwnerSay("ERROR...something strange is happening...sensor event fired and agent size returned was zero which should not be possible!");
            else handleIdleGround();
        }
        else playNextAnim();
    }
    sensor(integer num)
    {
        llSay(0,"Seriously?! That sensor repeat function actually found something?!?!?!?!?!");
        llSensorRemove();
    }
    timer()
    {
        // controls lighting changes
        colourInd++;
        if (colourInd>=(llGetListLength(colourList)/4)-1)
        {
            colourInd=0;
            if (lightCycleRandom) colourList=llListRandomize(colourList,4);
        }
        if (cycleLightMode) // if using cycling see it it's time to change modes
        {
            cycleCount++;
            if (cycleCount==cycleLightChange)
            {
                cycleCount=0;
                if (lightColourModeSpots=="UNIFORM") lightColourModeSpots="SIDE_SPLIT";
                else if (lightColourModeSpots=="SIDE_SPLIT") lightColourModeSpots="CROSS_SPLIT";
                else if (lightColourModeSpots=="CROSS_SPLIT") lightColourModeSpots="QUAD_RANDOM";
                else if (lightColourModeSpots=="QUAD_RANDOM") lightColourModeSpots="UNIFORM";
                else // spots are off so pot mode changes instead
                {
                    if (lightColourModePots=="MATCH_SAME") lightColourModePots="MATCH_OPPOSITE";
                    else if (lightColourModePots=="MATCH_OPPOSITE") lightColourModePots="UNIFORM_RANDOM";
                    else if (lightColourModePots=="UNIFORM_RANDOM") lightColourModePots="UNIFORM_MATCH";
                    else if (lightColourModePots=="UNIFORM_MATCH") lightColourModePots="UNIFORM_OPPOSITE";
                    else if (lightColourModePots=="UNIFORM_OPPOSITE") lightColourModePots="CROSS_MATCH";
                    else if (lightColourModePots=="CROSS_MATCH") lightColourModePots="CROSS_RANDOM";
                    else if (lightColourModePots=="CROSS_RANDOM") lightColourModePots="PURE_RANDOM";
                    else if (lightColourModePots=="PURE_RANDOM") lightColourModePots="MATCH_SAME";
                }
            }
        }
        // set new lights
        setLights();
        // particle updates
        integer particleChange=FALSE;
        if (particleBaseCyclic) cycleBase++;
        if ((particleBaseOn && (cycleBase>=cyclesBaseOn)) || (!particleBaseOn && (cycleBase>=cyclesBaseOff)))
        {
            particleChange=TRUE;
            particleBaseOn=!particleBaseOn;
            cycleBase=0;
        }
        if (particlePotsCyclic) cyclePots++;
        if ((particlePotsOn && (cyclePots>=cyclesPotsOn)) || (!particlePotsOn && (cyclePots>=cyclesPotsOff)))
        {
            particleChange=TRUE;
            particlePotsOn=!particlePotsOn;
            cyclePots=0;
        }
        if (particleChange) updateParticles();
    }
    touch_start(integer num)
    {
        if (llDetectedKey(0)!=llGetOwner())
        {
            llRegionSayTo(llDetectedKey(0),0,"Sorry, only the owner can change the stage's settings using the dialog menu");
            return;
        }
        showMainMenu();
    }
    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(handle);
        if (menuLevel=="MAIN_MENU")
        {
            if (message=="DONE") return;
            if (message=="-")
            {
                showMainMenu();
                return;
            }
            if (message=="RESET")
            {
                if(!noDialogChatResponses) llOwnerSay("Resetting script");
                llResetScript();
                return;
            }
            if ((message=="Chat On")||(message=="Chat Off"))
            {
                noDialogChatResponses=!noDialogChatResponses;
                if (noDialogChatResponses) llOwnerSay("No more confirmation messages will be sent");
                else llOwnerSay("Confirmation messages will now be sent after each dialog selection");
                showMainMenu();
                return;
            }
            if (message=="Timer Anim")
            {
                showAnimMenu();
                return;
            }
            if (message=="Timer Lights")
            {
                showLightsMenu();
                return;
            }
            if (message=="Freeze")
            {
                currentTimer=0;
                llSetTimerEvent(currentTimer);
                if (!noDialogChatResponses) llOwnerSay("Timer has been disabled. Lights and particle effects will remain like this until you unfreeze them");
                showMainMenu();
                return;
            }
            if (message=="Unfreeze")
            {
                currentTimer=lightTimer;
                llSetTimerEvent(currentTimer);
                if (!noDialogChatResponses) llOwnerSay("Timer has been enabled. Lights and particle effects will now resume");
                showMainMenu();
                return;
            }
            if (message=="Spots Off")
            {
                storedSpotMode=lightColourModeSpots;
                lightColourModeSpots="SPOTS_OFF";
                showGantry(FALSE);
                spotsOff();
                if (!noDialogChatResponses) llOwnerSay("Spotlights now off and hidden");
                showMainMenu();
                return;
            }
            if (message=="Spots On")
            {
                lightColourModeSpots=storedSpotMode;
                showGantry(TRUE);
                setLights();
                if (!noDialogChatResponses) llOwnerSay("Spotlights now on and unhidden");
                showMainMenu();
                return;
            }
            if (message=="Pots Off")
            {
                storedPotMode=lightColourModePots;
                lightColourModePots="POTS_OFF";
                showPots(FALSE);
                potsOff();
                if (!noDialogChatResponses) llOwnerSay("Potlights now off and hidden");
                showMainMenu();
                return;
            }
            if (message=="Pots On")
            {
                lightColourModePots=storedPotMode;
                showPots(TRUE);
                setLights();
                if (!noDialogChatResponses) llOwnerSay("Potlights now on and unhidden");
                showMainMenu();
                return;
            }
            if (message=="All Off")
            {
                storedSpotMode=lightColourModeSpots;
                lightColourModeSpots="SPOTS_OFF";
                showGantry(FALSE);
                storedPotMode=lightColourModePots;
                lightColourModePots="POTS_OFF";
                showPots(FALSE);
                spotsOff();
                potsOff();
                if (!noDialogChatResponses) llOwnerSay("Spotlights and potlights now off and hidden");
                showMainMenu();
                return;
            }
            if (message=="All On")
            {
                lightColourModeSpots=storedSpotMode;
                showGantry(TRUE);
                lightColourModePots=storedPotMode;
                showPots(TRUE);
                if (!noDialogChatResponses) llOwnerSay("Spotlights and potlights now on and unhidden");
                setLights();
                showMainMenu();
                return;
            }
            if (message=="Part1 Off")
            {
                particleBaseOn=FALSE;
                storedCyclicBase=particleBaseCyclic;
                particleBaseCyclic=FALSE;
                updateParticles();
                if (!noDialogChatResponses) llOwnerSay("The base platform's particle effects have been disabled until you turn them on again");
                showMainMenu();
                return;
            }
            if (message=="Part1 On")
            {
                particleBaseOn=TRUE;
                particleBaseCyclic=storedCyclicBase;
                cycleBase=0;
                updateParticles();
                if (!noDialogChatResponses) llOwnerSay("The base platform's particle effects have been enabled. If they aren't set to cyclic you will need to manually turn them off again.");
                showMainMenu();
                return;
            }
            if (message=="Part2 Off")
            {
                particlePotsOn=FALSE;
                storedCyclicPots=particlePotsCyclic;
                particlePotsCyclic=FALSE;
                updateParticles();
                if (!noDialogChatResponses) llOwnerSay("The potlights' particle effects have been disabled until you turn them on again");
                showMainMenu();
                return;
            }
            if (message=="Part2 On")
            {
                particlePotsOn=TRUE;
                particlePotsCyclic=storedCyclicPots;
                cycleBase=0;
                updateParticles();
                if (!noDialogChatResponses) llOwnerSay("The potlights' particle effects have been enabled. If they aren't set to cyclic you will need to manually turn them off again.");
                showMainMenu();
                return;
            }
        }
        if (menuLevel=="ANIM_MENU")
        {
            if (message=="-")
            {
                showAnimMenu();
                return;
            }
            if (message=="CANCEL")
            {
                showMainMenu();
                return;
            }
            if (message=="never")
            {
                llSensorRemove();
                if (!noDialogChatResponses) llOwnerSay("The current dancer will keep playing this animation until you start the timer again or a new dancer uses the pole");
                showMainMenu();
                return;
            }
            else
            {
                llSensorRepeat("THIS_SENSOR_TEST_SHOULD_NEVER_RETURN_A_RESULT", NULL_KEY, 0, 1.0, 0.01, (float)message);
                if (!noDialogChatResponses) llOwnerSay("The current dancer will now change animations every "+message+" seconds until you change it or a new dancer uses the stage");
                playNextAnim();
                showMainMenu();
                return;
            }
        }
        if (menuLevel=="LIGHTS_MENU")
        {
            if (message=="CANCEL")
            {
                showMainMenu();
                return;
            }
            else
            {
                if (message=="never") currentTimer=0.0;
                else if (message=="default") currentTimer=lightTimer;
                else currentTimer=(float)message;
                llSetTimerEvent(currentTimer);
                if (!noDialogChatResponses) llOwnerSay("Lighting timer updated. This value will be used until you change it or the script resets");
                showMainMenu();
            }
        }
    }
}