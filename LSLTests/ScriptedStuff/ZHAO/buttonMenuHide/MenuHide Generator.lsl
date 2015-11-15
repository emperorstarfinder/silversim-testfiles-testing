// Default state is menu visible

integer myState = 1; // Visible

default
{
    state_entry()
    {
        myState = 1;
        llMessageLinked(LINK_SET, 0, "Menu", NULL_KEY);
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
            llMessageLinked(LINK_SET, 0, "Menu", NULL_KEY);
        }
        else
        {
            myState = 0;
            llMessageLinked(LINK_SET, 0, "Hide", NULL_KEY);
        }
    }
}
