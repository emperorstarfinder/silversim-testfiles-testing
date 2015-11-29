/*

Version: 0.01 created 2014-08-23 by Jesa (0815C Resident)

SYNOPSIS:

You can use this plugin to enhance a currently playing animation started by an
npose SET notecard to do a certain action, e.g. to apply one spank or the like
when somebody pushes a button.

Additionally, a sound can be played with a certain volume.

USAGE:

LINKMSG|1444|seatNum~list~of~words

list~of~words is a ~ sepearated list of the following 3 arguments:
1. name of an animation (don't use a looped animation)
2. name or asset UUID of a sound
3. volume of the sound to play, 1.0 is maximum, 0.0 is minimum, 0.5 is default

EXAMPLES:

Create a button notecard, e.g.: BTN:Spanking:SpankOnce and add one (yes, only one)
from the following example lines:

LINKMSG|1444|seat2~spankOnce~spankSound~1.0

LINKMSG|1444|seat2~spankOnce

// the following commands wouldn't require a seat, but to avoid an error
// message, just give it an existing seat, e.g. seat1

LINKMSG|1444|seat1~~spankSound

LINKMSG|1444|seat1~~spankSound~0.8

For the sound, you can also give the the sound's AssetUUID.



 
ANIMATIONS:

Make sure that the "overlay animation from the button" only controls the limbs
that it should move, and has the same or a higher priority than the running
animation from the SET notecard.

LICENSE:

This script and the nPose scripts are licensed under the GPLv2
(http://www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject
to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you
      must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in
Second Life and/or other virtual world platforms derived from Second Life (such
as OpenSim).  If the platform should allow more fine-grained permissions, then
"full perms" will mean the most permissive possible set of permissions allowed
by the platform.

*/

string AnimationName;
string SoundName;
float  SoundVolume;

list   SeatAvatarAnimations = []; // stride [ seatName, animName, avatarKey ]


// linkMsg 35353 is seatupdate:
// 'Cane-LieBack^<0,0,1.5>^<0,0,0.7,0.7>^^ece16261-c476-4dc5-bc6e-a050369c4acf'
// + '^§2732|R1~collar~R2~rlcuff~R3~llcuff~R4~rcuff~R5~lcuff~R6~rbbelt~R7~lbbelt'
// + '^§2733|R1~R2~R3~R4~R5~R6~R7^seat1'
// + '^Cane-Top-Start^<0.1,0,0.8>^<0,0,0.6,0.7>^^'
// + 'a3484dd9-ddbd-4dbc-a61d-f302185503ed^§1655|jeCane|%AVKEY%^§1657|jeCane|%AVKEY%^seat2'

// str contains strided list with stride of 8 and ^ as separator:
// 0: animation name
// 1: position offset
// 2: rotation offset
// 3: facial animation
// 4: avatarKey
// 5: commands SATMSG
// 6: commands NOTSATMSG
// 7: setname: seat1, seat2, ...
store_seater_animations( string str )
{
    // llOwnerSay( "StoreAnims: " + str );
    list words = llParseStringKeepNulls( str, [ "^" ], [] );
    
    SeatAvatarAnimations = [];
    integer length = llGetListLength( words );
    integer i;
    for( i=0; i < length; i+=8 ) {
        string animName  = llList2String( words, i     );
        key    avatarKey = llList2Key(    words, i + 4 );
        string seatName  = llList2String( words, i + 7 );
        SeatAvatarAnimations += [ seatName, animName, avatarKey ];
    }
}

default
{

    link_message( integer sender, integer num, string str, key id )
    {
        if( num == 1444 ) 
        {
            // split up by ~: seatname, animation name, sound name, sound volume
            list words        = llParseStringKeepNulls( str, [ "~" ], [] );
            AnimationName = llList2String( words, 1 );
            SoundName     = llList2String( words, 2 );
            SoundVolume   = llList2Float(  words, 3 );

            string seatName   = llList2String( words, 0 );
            integer seatIndex = llListFindList( SeatAvatarAnimations, [ seatName ] );
            if( seatIndex == -1 )
            {
                llOwnerSay( "Error: no seat given in NC: " + str );
                return;
            }
            key avatarKey = llList2Key( SeatAvatarAnimations, seatIndex + 2 );
            if( avatarKey == NULL_KEY )           avatarKey = id;
            if( SoundVolume == 0 )                SoundVolume = 0.5;    

            // llSay( 0, "Starting animation " + AnimationName + " for avatar " + (string)id
            //    + " and sound " + SoundName );
            llRequestPermissions( avatarKey, PERMISSION_TRIGGER_ANIMATION ); // => run_time_permissions
        }
        
        else if( num == 35353  )
        {
            // llOwnerSay( "LM (cmd=" + (string)num
            //    + ")\nMSG: '" + str
            //    + "'\nKey: " + llKey2Name( id ) );     
            store_seater_animations( str );
            // llOwnerSay( "SeatUpdate: " + llDumpList2String( SeatAvatarAnimations, "'\t'" ) );
        }
        
        
        
    } // link_message
    
    run_time_permissions( integer perm )
    {
        if( perm & PERMISSION_TRIGGER_ANIMATION )
        {
            if( AnimationName ) llStartAnimation( AnimationName );
            if( SoundName )     llPlaySound( SoundName, SoundVolume );
        }
    } // run_time_permissions
    
} // default