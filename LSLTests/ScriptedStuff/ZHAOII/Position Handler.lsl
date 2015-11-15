///////////////////////////////////////////////////////////////////////////////
// ZHAOII - A continuation of Ziggy's HUD Animation Overrider
// Based on ZHAO Version 1.0.11.2 Released September 25, 2006
// $Id: Position Handler.lsl 1 2007-01-28 05:38:29Z fennecwind $
///////////////////////////////////////////////////////////////////////////////

list offsets = [
	<0.00,  0.00,  0.10>,		// Center 2
	<0.00,  0.05, -0.05>,		// Top Right
	<0.00,  0.00, -0.05>,		// Top
	<0.00, -0.05, -0.05>,		// Top Left
	<0.00,  0.00,  0.10>,		// Center
	<0.00, -0.05,  0.10>,		// Bottom Left
	<0.00,  0.00,  0.10>,		// Bottom
	<0.00,  0.05,  0.10>		// Bottom Right
];

default
{
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            integer attachPoint = llGetAttached();

			if(attachPoint >= 31 && attachPoint <= 38)
			{
				llSetPos((vector)llList2String(offsets, attachPoint - 31));
				llMessageLinked(LINK_SET, attachPoint, "", NULL_KEY);
			}
        }
    }
}
