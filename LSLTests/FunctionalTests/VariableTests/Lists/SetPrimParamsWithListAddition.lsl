//#!Enable:Testing

list    gLight = [ <1,1,1>, 0.412, 3.8, 2.0 ];

integer gLinkNo;
Light( integer fON )
{
  if ( gLinkNo <= 0 ) return;

  if ( fON )
   llSetLinkPrimitiveParamsFast( gLinkNo, [PRIM_POINT_LIGHT, TRUE] + gLight );
  else
   llSetLinkPrimitiveParamsFast( gLinkNo, [PRIM_POINT_LIGHT, FALSE] + gLight );
}

default
{
	state_entry()
	{
		gLinkNo = LINK_THIS;
		Light(FALSE);
		_test_Result(TRUE);
		_test_Shutdown();
	}
}