// When the state is off, the button says 'Off', and vice versa

key sitOnTexture = "c4cce91e-ac36-763a-ec14-58a43774d815";
key sitOffTexture = "186a5d64-4dff-b255-8f03-0460c57f88c2";

vector onColor = <0.25, 1.0, 0.25>;
vector offColor = <1.0, 0.25, 0.25>;

integer myState;

default
{
    state_entry()
    {
        llSetColor(onColor, 4);
        llSetTexture(sitOnTexture, 4);
        myState = 1;
    }

    touch_start(integer total_number)
    {
        if (myState == 0)
        {
            llMessageLinked(LINK_SET, 0, "Sit On", NULL_KEY);
            myState = 1;
            llSetColor(onColor, 4);
            llSetTexture(sitOnTexture, 4);
        }
        else
        {
            llMessageLinked(LINK_SET, 0, "Sit Off", NULL_KEY);
            myState = 0;
            llSetColor(offColor, 4);
            llSetTexture(sitOffTexture, 4);
        }
    }
}
