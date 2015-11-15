// When the state is off, the button says 'Off', and vice versa

integer myState = 0; // Off

default
{
    state_entry()
    {
        myState = 1;
        llMessageLinked(LINK_SET, 0, "On", NULL_KEY);
    }

    touch_start(integer total_number)
    {
        if (llDetectedKey(0) != llGetOwner())
        {
            return;
        }

        if (myState == 0)
        {
            myState = 1;
            llMessageLinked(LINK_SET, 0, "On", NULL_KEY);
        }
        else
        {
            myState = 0;
            llMessageLinked(LINK_SET, 0, "Off", NULL_KEY);
        }
    }
}
