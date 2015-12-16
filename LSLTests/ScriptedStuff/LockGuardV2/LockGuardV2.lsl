//============================================================================
//  LockGuard V2 Script
//      ..... by Lillani Lowell
//
//      Modified by Sonya Gausman (2007/07/31)
//
//      Special thanks (in alphabetical order) go to:
//
//          Tengu Tamabushi (testing/debugging/code support & rope texture)
//          Zi Ree (testing/debugging/code support & chain texture)
//
//              The chain and rope textures which LockGuard V2 uses are owned
//              by Tengu and Zi.
//
//      And thanks to all the people who are using LockGuard!
//
//==================================================
//
// LockGuard V2 is a simple, powerful, programmable, and highly versatile
// particle chain link library. LockGuard V2 is a plug and play, multiple
// purple chain/rope/hose generator which can be used for fences, streamers,
// decorations, spiderwebs, and b&d related items.
//
// LockGuard chains are called by matching an avatar key with a particle chain
// ID tag, and by using this method particle chains can be called
// individually, in groups, or even all at once.
//
// Now.....
//
// I'd like to say, the way this source is written may seem a little odd to
// some people, but there *is* a rhyme and reason to my apparant madness, even
// if it doesn't seem entirely obvious at first glance. :)
//
// And, of course, code improvements are always welcome!
//
// Feel free to use this code in any derivitive works, a source mention would be
// nice, but not necessary. :)
//
// LockGuard Features:
//      -- One way communication, no need to haggle.
//      -- Plug and play functionality.
//      -- Built-in particle chain generator, configurable "on the fly".
//      -- 100% backwards compatibility with all previous furniture and devices.
//      -- Simplistic, furniture side scripting, LockGuard is your wheel, you
//         don't have to reinvent it.
//      -- Call chains based on customizable ID tags, call multiple chains
//         which share one ID.
//      -- Determine whether or not an item exists through a ping.

// LockGuard V2 Features:
//      -- Open source!
//      -- Multi-command parsing, include all your LockGuard commands in
//         a single chatblock.
//      -- Multiple ID tags per item, call a chain individually, call it by
//         a group tag, or all at once!
//      -- Determine whether or not a chain is linked from the item.
//      -- Ability to change channels for private projects (requires
//         nPrivateProject=TRUE).
//      -- Ability to disable listen entirely, for "fire and forget" chains
//         (requires nPrivateProject=TRUE).

//
// Sonya: The original version of this script used llLockGuardFoo() functions
// however such naming could bring make someone think that those functions are
// built-in (where in fact they are user functions) since "ll" is said to mean
// "linden library".  I therefore changed all function names from
// llLockGuardFoo() to lgFoo().
//
// I've also did some optimisation in lgObey() and wrapped comments at
// 78th column to make code more readable (it made it more readable
// for me at least).
//

//==================================================
//  program variables
//==================================================

        //
        // Changing nPrivateProject to TRUE will allow LockGuard V2 devices to
        // change the LG channel or even disable llListen
        // entirely. nPrivateProject should *always* be false for items which
        // use non-static or linking with public items.
        //

    integer nPrivateProject = FALSE;


        //
        // Typical channel and handler.
        //

    integer         nChannel = -9119;
    integer         nHandle;

        //
        // Variables for sucking the data out of a notecard. See the default
        // state.
        //

    string          fnLNCFilename = "LockGuard V2 Config";
    string          fnLNCFileData;
    list            fnLNCFileDataList;
    integer         fnLNCLine;
    key             fnLNCQueryID;

        //
        // Command line storage + parser count.
        //

    list            lCommandLine;
    integer         nParserCount;

        // Chat lines are converted into lists because it is assumed the
        // internal compiled FindList functions will work faster than breaking
        // it down into substrings and then having a bunch of intepreted if
        // and thens running amok on a virtual machine comparing them.
        //
        // Known Issue
        //
        // The only potential issue with the new V2 Script is that it now
        // supports multiple LockGuard commands in a single command
        // block. This was included in the overhaul of the parser which old
        // LockGuard does not support. This will *not* affect LockGuard
        // devices or furniture which are already on the market, as they are
        // still compatible with the LockGuard protocol.  Backwards
        // compatibility has been thoroughly tested to make sure old LockGuard
        // furniture/devices operate as they should with the new LockGuard V2
        // Script.
        //
        // The only time this issue will present a problem is when new V2
        // furniture or devices use the new multi-command format and try to
        // communicate with the old LockGuard Item Script. The old LockGuard
        // Item Script will only recognize the first command, and ignore the
        // rest. This is easily solved by dropping in the LockGuard V2 Script
        // and LockGuard V2 Config notecard in place of the old LockGuard Item
        // Script and LockGuard Item Config notecard into your item, etc.
        //
        // Again, this *does not* affect the use of current /furniture/ or
        // /devices/.
        //
        // I had debated on adding the new multi-command parser because of
        // this potential issue, but at the last minute decided being able to
        // configure AND link a chain in one single call which significantly
        // reduces LockGuard channel use and increases overall performance
        // outweighed the minor inconvenience of taking a moment to change out
        // LockGuards scripts in items.
        //
        // Evolution is not without its little bumps in the road, but that
        // which does not evolve gets left behind.
        //

//==================================================
//  lockguard variables
//==================================================

        //
        // 0 - id
        // 1 - link
        // 2 - unlink
        // 3 - ping
        // 4 - free
        // 5 - texture
        // 6 - size
        // 7 - life
        // 8 - speed
        // 9 - gravity
        // 10 - color
        // 11 - unlisten    << only works when nPrivateProject = TRUE
        // 12 - channel     << only works when nPrivateProject = TRUE
        //
        // Do not modify or change the order of lLockGuardCommands unless you
        // KNOW what you're doing!
        //

    list            lLockGuardCommands = [ "id", "link", "unlink", "ping", "free", "texture", "size", "life", "speed", "gravity", "color", "unlisten", "channel" ];

        //
        // These textures were granted by Zi and Tengu (see credits at top)
        // for use in LockGuard V2.  Although they are being distributed with
        // V2, they are still owned by their respective creators.
        //

    key             kDefaultChain = "40809979-b6be-2b42-e915-254ccd8d9a08";
    key             kDefaultRope = "bc586d76-c5b9-de10-5b66-e8840f175e0d";

    list            lLockGuardID = [];

    key             kTarget;

    //
    // Default particle chain values, if they're not loaded from the
    // configuration notecard these are what they will be. Don't change the
    // defaults here, change them in the LockGuard V2 Config notecard instead.
    //

    key             kTextureDefault = "40809979-b6be-2b42-e915-254ccd8d9a08";
    float           fSizeXDefault = 0.07;
    float           fSizeYDefault = 0.07;
    float           fLifeDefault = 1;
    float           fGravityDefault = 0.3;
    float           fMinSpeedDefault = 0.005; // Not really used, life
                                              // generally determines speed.
    float           fMaxSpeedDefault = 0.005; // Not really used, life
                                              // generally determines speed.
    float           fRedDefault = 1;
    float           fGreenDefault = 1;
    float           fBlueDefault = 1;

    //
    // Particle chain values the program will actually use. Don't fill them
    // in, they'll only get written over later.
    //

    key             kTexture;
    float           fSizeX;
    float           fSizeY;
    float           fLife;
    float           fGravity;
    float           fMinSpeed;
    float           fMaxSpeed;
    float           fRed;
    float           fGreen;
    float           fBlue;

    integer         nLinked = FALSE;

//==================================================
//  filter
//==================================================

integer lgItemCheck()
{

    //
    // LockGuard will do the checks to ensure the command line meets the
    // following critera:
    //      1. It's meant for LockGuard.
    //      2. It's meant for the avatar who owns the item this script is in.
    //      3. It's meant for all items OR.....
    //      4. It's meant for a corresponding ID tag which has been given to
    //         this item.
    //
    // While ALL is still supported as a tag for backwards compatibility with
    // some old devices, it should *never* be used in new devices.
    //

    if( llList2String( lCommandLine, 0 ) != "lockguard" )
        return FALSE;
    if( llList2String( lCommandLine, 1 ) != (string)llGetOwner() )
        return FALSE;
    if( llList2String( lCommandLine, 2 ) == "all" )
        return TRUE;
    //if( llListFindList( lLockGuardID, llList2List( lCommandLine, 2, 2 ) ) == -1 )
    //    return FALSE;
    //return TRUE;
    return llListFindList( lLockGuardID, llList2List( lCommandLine, 2, 2 ) ) != -1;
}

//==================================================
//  particle chain
//==================================================

lgRestoreDefaults()
{

    //
    // Restore the chain defaults, LockGuard does this when the script first
    // starts (after loading from the notecard), when attached to an avatar,
    // or when an unlink command is issued.
    //

    kTexture = kTextureDefault;
    fSizeX = fSizeXDefault;
    fSizeY = fSizeYDefault;
    fLife = fLifeDefault;
    fGravity = fGravityDefault;
    fMinSpeed = fMinSpeedDefault;
    fMaxSpeed = fMaxSpeedDefault;
    fRed = fRedDefault;
    fGreen = fGreenDefault;
    fBlue = fBlueDefault;

}

lgLink( integer fn_nRelinking )
{

    //
    // The simple secret of a particle chain revealed! :)
    //

    integer nBitField = PSYS_PART_TARGET_POS_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK;

    llParticleSystem( [] );

    if( !fn_nRelinking )
        kTarget = llList2Key( lCommandLine, ++nParserCount );

    if( fGravity == 0 )
        nBitField = nBitField|PSYS_PART_TARGET_LINEAR_MASK;

    llParticleSystem( [ PSYS_PART_MAX_AGE, fLife, PSYS_PART_FLAGS, nBitField, PSYS_PART_START_COLOR, <fRed, fGreen, fBlue>, PSYS_PART_END_COLOR, <fRed, fGreen, fBlue>, PSYS_PART_START_SCALE, <fSizeX, fSizeY, 1.00000>, PSYS_PART_END_SCALE, <fSizeX, fSizeY, 1.00000>, PSYS_SRC_PATTERN, 1, PSYS_SRC_BURST_RATE, 0.000000, PSYS_SRC_ACCEL, <0.00000, 0.00000, (fGravity*-1)>, PSYS_SRC_BURST_PART_COUNT, 10, PSYS_SRC_BURST_RADIUS, 0.000000, PSYS_SRC_BURST_SPEED_MIN, fMinSpeed, PSYS_SRC_BURST_SPEED_MAX, fMaxSpeed, PSYS_SRC_INNERANGLE, 0.000000, PSYS_SRC_OUTERANGLE, 0.000000, PSYS_SRC_OMEGA, <0.00000, 0.00000, 0.00000>, PSYS_SRC_MAX_AGE, 0.000000, PSYS_PART_START_ALPHA, 1.000000, PSYS_PART_END_ALPHA, 1.000000, PSYS_SRC_TARGET_KEY, kTarget, PSYS_SRC_TEXTURE, kTexture ] );

    nLinked = TRUE;

}

lgUnlink()
{

    //
    // Unlink the particle chain, restore the item's defaults, and move along.
    //

    llParticleSystem( [] );

    lgRestoreDefaults();

    nLinked = FALSE;

    kTarget = NULL_KEY;

}

lgTexture()
{

    //
    // Change the texture.
    //

    kTexture = llList2Key( lCommandLine, ++nParserCount );

    if( kTexture == "chain" )
        kTexture = kDefaultChain;
    if( kTexture == "rope" )
        kTexture = kDefaultRope;

    if( nLinked )
        lgLink( TRUE );

}

lgSize()
{

    //
    // Change the size.
    //

    fSizeX = llList2Float( lCommandLine, ++nParserCount );
    fSizeY = llList2Float( lCommandLine, ++nParserCount );

    if( nLinked )
        lgLink( TRUE );

}

lgLife()
{

    //
    // Change the life.
    //

    fLife = llList2Float( lCommandLine, ++nParserCount );

    if( nLinked )
        lgLink( TRUE );

}

lgSpeed()
{

    //
    // Change the speed.
    //

    fMinSpeed = llList2Float( lCommandLine, ++nParserCount );
    fMaxSpeed = llList2Float( lCommandLine, ++nParserCount );

    if( nLinked )
        lgLink( TRUE );

}

lgGravity()
{

    //
    // Change the amount of gravity.
    //

    fGravity = llList2Float( lCommandLine, ++nParserCount );

    if( nLinked )
        lgLink( TRUE );

}

lgColor()
{

    //
    // Change the color/tint.
    //

    fRed = llList2Float( lCommandLine, ++nParserCount );
    fGreen = llList2Float( lCommandLine, ++nParserCount );
    fBlue = llList2Float( lCommandLine, ++nParserCount );

    if( nLinked )
        lgLink( TRUE );

}

//==================================================
//  channel
//==================================================

lgUnlisten()
{

    //
    // Kill the listener. This command will not work unless nPrivateProject ==
    // TRUE.
    //

    llListenRemove( nHandle );

}

lgChannelChange()
{

    //
    // Swap channels. This command will not work unless nPrivateProject ==
    // TRUE.
    //

    llListenRemove( nHandle );

    nChannel = llList2Integer( lCommandLine, ++nParserCount );
    nHandle = llListen( nChannel, "", NULL_KEY, "" );

}

//==================================================
//  obedience
//==================================================

lgSetID()
{

    //
    // Assign a new ID to the item, an item can have multiple IDs.
    //

    nParserCount++;
    lLockGuardID += llList2List( lCommandLine, nParserCount, nParserCount );

}

lgPing()
{

    //
    // Do we exist?
    //

    llWhisper( nChannel, "lockguard " + (string)llGetOwner() + " " +  llList2String( lLockGuardID, 0 ) + " okay" );

}

lgFree()
{

    //
    // Are we free?
    //

    if( nLinked )
        llWhisper( nChannel, "lockguard " + (string)llGetOwner() + " " +  llList2String( lLockGuardID, 0 ) + " no" );
    else
        llWhisper( nChannel, "lockguard " + (string)llGetOwner() + " " +  llList2String( lLockGuardID, 0 ) + " yes" );

}

lgObey( integer fn_nBase )
{

    //integer nCommands = llGetListLength( lCommandLine );
    integer nCommands = (lCommandLine!=[]);
    integer nReturn;

    //
    // Let's parse! The script will poll through the commandline and compare
    // it to any known commands provided in the command list defined under the
    // variables with lLockGuardCommands. If it finds a match it'll call the
    // command based on its number.
    //
    // In theory, searching commands this way using compiled/native functions
    // should be faster than using multiple functions to break the commandline
    // down into substrings, storing the substrings, and then comparing them
    // on a virtual machine. Maybe someone can confirm/deny this.
    //
    // When fn_nBase == 3, it is being called from the listen block.
    // When fn_nBase == 0, it is being called from the notecard reader.
    //

    nParserCount = fn_nBase;

    do
    {

        nReturn = llListFindList( lLockGuardCommands, llList2List( lCommandLine, nParserCount, nParserCount ) );

        //
        // Sonya: I've replaced a chain of "if (foo) bar; if (foo) bar;" with
        // a "if (foo) bar; else if (foo) bar;".  That's because the former is
        // faster -- if for instance nReturn == 5 was true, there's no need to
        // check whether nReturn == 6, nReturn == 7, etc.
        //

        //
        // These commands can only be called via the notecard reader.
        //

        if( nReturn == 0 ) { if( fn_nBase == 0 ) lgSetID();

        //
        // These commands can only be called via chat command blocks.
        //

        } else if( nReturn == 1 ) { if( fn_nBase == 3 ) lgLink( FALSE );
        } else if( nReturn == 2 ) { if( fn_nBase == 3 ) lgUnlink();
        } else if( nReturn == 3 ) { if( fn_nBase == 3 ) lgPing();
        } else if( nReturn == 4 ) { if( fn_nBase == 3 ) lgFree();

        //
        // These commands can be called anywhere, either by setting defaults
        // through the notecards or through chatblocks.
        //

        } else if( nReturn == 5 ) { lgTexture();
        } else if( nReturn == 6 ) { lgSize();
        } else if( nReturn == 7 ) { lgLife();
        } else if( nReturn == 8 ) { lgSpeed();
        } else if( nReturn == 9 ) { lgGravity();
        } else if( nReturn == 10 ){ lgColor();

        //
        // LockGuard willonly allow channel changing and unlistening if
        // nPrivateProject == TRUE.
        //

        } else if( nReturn == 11 ) {
            if( nPrivateProject ) lgUnlisten();
        } else if( nReturn == 12 ) {
            if( nPrivateProject ) lgChannelChange();
        }

        nParserCount++;

    } while( nParserCount < nCommands );

}

//==================================================
//  default
//==================================================

default
{

    //
    // The standard, "let's read the notecard" function.
    //

    state_entry()
    {

        fnLNCLine = 0;

        fnLNCQueryID = llGetNotecardLine( fnLNCFilename, fnLNCLine );

    }

    dataserver( key query_id, string data )
    {

        integer i;

        if( query_id == fnLNCQueryID )
        {

            if( data != EOF )
            {

                if( fnLNCLine > 0 )
                {

                    fnLNCFileData += " ";

                } else
                {

                    fnLNCFileDataList = [];

                }

                fnLNCFileDataList += [ data ];

                fnLNCLine++;

                fnLNCQueryID = llGetNotecardLine( fnLNCFilename, fnLNCLine );

            } else
            {

                integer len = fnLNCFileDataList!=[];
                do
                {

                    lCommandLine = llParseString2List( llToLower( llList2String( fnLNCFileDataList, i ) ), [ " " ], [] );

                    lgObey( 0 );

                    i++;

                } while( i < len );

                fnLNCFileDataList = [];

                state lockguardGo;

            }

        }

    }

    changed( integer change )
    {

        //
        // If anything in our inventory changes, reset.
        //

        if( change == CHANGED_INVENTORY )
            llResetScript();

    }

}

//==================================================
//  lockguardGo
//==================================================

state lockguardGo
{

    on_rez( integer num )
    {

        //
        // Kill any lingering chains and do a complete script reset during a new rez.
        //

        lgUnlink();

        llResetScript();

    }

    state_entry()
    {

        //
        // Load up the default chain values and listen up.
        //

        lgRestoreDefaults();

        nHandle = llListen( nChannel, "", NULL_KEY, "" );

    }

    listen( integer channel, string name, key id, string message )
    {

        //
        // Parse the command line.
        //

        lCommandLine = llParseString2List( llToLower( message ), [ " " ], [] );

        if( !lgItemCheck() )
            return;

        lgObey( 3 );

    }

    changed( integer change )
    {

        //
        // If anything in our inventory changes, reset.
        //

        if( change == CHANGED_INVENTORY )
            llResetScript();

    }

}