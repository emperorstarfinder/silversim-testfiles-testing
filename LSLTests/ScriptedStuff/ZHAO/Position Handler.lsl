vector brOffset = <0.0,  0.05,  0.10>;
vector bmOffset = <0.0,  0.00,  0.10>;
vector blOffset = <0.0, -0.05,  0.10>;
vector trOffset = <0.0,  0.05, -0.05>;
vector tmOffset = <0.0,  0.00, -0.05>;
vector tlOffset = <0.0, -0.05, -0.05>;

default
{
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            integer attachPoint = llGetAttached();

            // Nasty if else block

            if (attachPoint == 32) // HUD Top Right
            {
                llSetPos(trOffset);
                llMessageLinked(LINK_SET, 0, "Top Row", NULL_KEY);
            }
            else if (attachPoint == 33) // HUD Top
            {
                llSetPos(tmOffset);
                llMessageLinked(LINK_SET, 0, "Top Row", NULL_KEY);
            }
            else if (attachPoint == 34) // HUD Top Left
            {
                llSetPos(tlOffset);
                llMessageLinked(LINK_SET, 0, "Top Row", NULL_KEY);
            }
            else if (attachPoint == 36) // HUD Bottom Left
            {
                llSetPos(blOffset);
                llMessageLinked(LINK_SET, 0, "Bottom Row", NULL_KEY);
            }
            else if (attachPoint == 37) // HUD Bottom
            {
                llSetPos(bmOffset);
                llMessageLinked(LINK_SET, 0, "Bottom Row", NULL_KEY);
            }
            else if (attachPoint == 38) // HUD Bottom Right
            {
                llSetPos(brOffset);
                llMessageLinked(LINK_SET, 0, "Bottom Row", NULL_KEY);
            }
        }
    }
}
