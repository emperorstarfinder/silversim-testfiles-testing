vector current_rotation = < 0.0 , - 2.3 , 0.0 >;
vector current_position = < - 1.98 , 00.00 , 0.45 >;
vector reset_rotation = < 0.0 , - 2.3 , 0.0 >;
vector reset_position = < - 1.98 , 00.00 , 0.45 >;
list sit_target;
integer listen_handler;
integer SIT_ADJUST = 50;
string sitmenu_text = " --- ";
list buttons_position = [ "Position" , "Rotation" , "Main" , "P_BACK" , "P_RIGHT" , "P_DOWN" , "P_FWD" , "P_LEFT" , "P_UP" , "Reset Pos" , "Reset Rot" , "Reset Both" ];
list buttons_rotation = [ "Position" , "Rotation" , "Main" , "R_DOWN" , "R_RIGHT" , "R_LEAN_R" , "R_UP" , "R_LEFT" , "R_LEAN_L" , "Reset Pos" , "Reset Rot" , "Reset Both" ];
list position = [ "P_FWD" , < 0.01 , 0 , 0 > , "P_RIGHT" , < 0 , - 0.01 , 0 > , "P_DOWN" , < 0 , 0 , - 0.01 > , "P_BACK" , < - 0.01 , 0 , 0 > , "P_LEFT" , < 0 , 0.01 , 0 > , "P_UP" , < 0 , 0 , 0.01 > ];
list rotat = [ "R_LEAN_L" , < - 1 , 0 , 0 > , "R_RIGHT" , < 0 , 0 , - 1 > , "R_UP" , < 0 , - 1 , 0 > , "R_LEAN_R" , < 1 , 0 , 0 > , "R_LEFT" , < 0 , 0 , 1 > , "R_DOWN" , < 0 , 1 , 0 > ];
integer sitmenu_handler;
integer sitmenu_channel;

void set_pos_sitmenu_text ( )
{
  sitmenu_text = "\n\nAdjust Sitting\nP O S I T I O N\n" + "Forward " + "          Left" + "            Up" + "\n" + "Back    " + "         Right" + "          Down" + "\n" ;
}

void set_rot_sitmenu_text ( )
{
  sitmenu_text = "\n\nAdjust Sitting\nR O T A T I O N\n" + "Lean Forward " + "        Spin Left " + "      Lean Left" + "\n" + "Lean Back    " + "        Spin Right" + "      Lear Right" + "\n" ;
}

void sitmenu ( key user , string title , list buttons )
{
  llListenRemove ( sitmenu_handler ) ;
  sitmenu_channel = ( integer ) ( llFrand ( 2400000 ) + 1 ) ;
  sitmenu_handler = llListen ( sitmenu_channel , "" , "" , "" ) ;
  llDialog ( llGetOwner ( ) , title , buttons , sitmenu_channel ) ;
  llSetTimerEvent ( 60 ) ;
}

void UpdateSitTarget ( vector pos , vector rotter )
{
  rotation rot = llEuler2Rot ( rotter * DEG_TO_RAD ) ;
  llSitTarget ( current_position , llEuler2Rot ( current_rotation * DEG_TO_RAD ) ) ;
  key user = llAvatarOnSitTarget ( ) ;
  if ( user )
  {
    vector size = llGetAgentSize ( user ) ;
    if ( size )
    {
      rotation localrot = ZERO_ROTATION ;
      vector localpos = ZERO_VECTOR ;
      if ( llGetLinkNumber ( ) > 1 )
      {
        localrot = llGetLocalRot ( ) ;
        localpos = llGetLocalPos ( ) ;
      }

      pos . z += 0.4 ;
      integer linkNum = llGetNumberOfPrims ( ) ;
      do
      {
        if ( user == llGetLinkKey ( linkNum ) )
        {
          llSetLinkPrimitiveParams ( linkNum , [ PRIM_POSITION , ( ( pos - ( llRot2Up ( rot ) * size . z * 0.02638 ) ) * localrot ) + localpos , PRIM_ROTATION , rot * localrot / llGetRootRotation ( ) ] ) ;
          jump end ;
        }
      }

      while ( -- linkNum )
      ;
    }

    else
    {
      llUnSit ( user ) ;
    }
  }

  @ end ;
}

default
{
  state_entry ( )
  {
    llSitTarget ( current_position , llEuler2Rot ( current_rotation * 0.017453 ) ) ;
  }
  changed ( integer b )
  {
    if ( b & 32 )
    {
      if ( llAvatarOnSitTarget ( ) != NULL_KEY )
      {
        listen_handler = llListen ( sitmenu_channel , "" , "" , "" ) ;
      }

      else if ( llAvatarOnSitTarget ( ) == NULL_KEY )
      {
        llListenRemove ( listen_handler ) ;
      }
    }
  }
  timer ( )
  {
    llSetTimerEvent ( 60.0 ) ;
    llListenRemove ( sitmenu_handler ) ;
  }
  link_message ( integer snd , integer num , string msg , key id )
  {
    if ( msg == "sitadjust" )
    {
      set_pos_sitmenu_text ( ) ;
      sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_position ) ;
      return ;
    }
  }
  listen ( integer g , string h , key i , string j )
  {
    if ( ( llGetOwner ( ) == i ) || ( llDetectedKey ( 0 ) == llGetKey ( ) ) )
    {
      if ( j == "Main" )
      {
        llMessageLinked ( LINK_SET , 0 , "mainmenu" , NULL_KEY ) ;
      }

      if ( j == "Position" )
      {
        set_pos_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_position ) ;
        return ;
      }

      if ( j == "Rotation" )
      {
        set_rot_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_rotation ) ;
        return ;
      }

      if ( j == "Reset Pos" )
      {
        current_position = current_position ;
        UpdateSitTarget ( current_position , current_rotation ) ;
        llOwnerSay ( "Position Reset" ) ;
        set_pos_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_position ) ;
        return ;
      }

      if ( j == "Reset Rot" )
      {
        current_rotation = < 0.00000 , 0.00000 , 0.00000 > ;
        UpdateSitTarget ( current_position , current_rotation ) ;
        set_rot_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_rotation ) ;
        return ;
      }

      if ( j == "Reset Both" )
      {
        current_rotation = reset_rotation ;
        current_position = reset_position ;
        UpdateSitTarget ( current_position , current_rotation ) ;
        llOwnerSay ( "Position and Rotation Reset" ) ;
        set_pos_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_position ) ;
        return ;
      }

      if ( llGetSubString ( j , 0 , 0 ) == "P" )
      {
        integer k = llListFindList ( position , [ j ] ) ;
        k += 1 ;
        current_position += llList2Vector ( position , k ) ;
        UpdateSitTarget ( current_position , current_rotation ) ;
        set_pos_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_position ) ;
        return ;
      }

      else if ( llGetSubString ( j , 0 , 0 ) == "R" )
      {
        integer l = llListFindList ( rotat , [ j ] ) ;
        l += 1 ;
        current_rotation += llList2Vector ( rotat , l ) ;
        UpdateSitTarget ( current_position , current_rotation ) ;
        set_rot_sitmenu_text ( ) ;
        sitmenu ( llGetOwner ( ) , sitmenu_text , buttons_rotation ) ;
        return ;
      }
    }
  }
}
