string myName;

default
{
    state_entry()
    {
        myName = llGetLinkName(llGetLinkNumber());
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET, 0, myName, NULL_KEY);
    }
}
