// When the state is off, the button says 'Off', and vice versa

key onTexture = "6633a4b9-acc0-9db6-276c-d8d6a2a0cab1";
key offTexture = "234bc39d-9008-2c7a-8ec8-31815acb65df";

vector onColor = <0.25, 1.0, 0.25>;
vector offColor = <1.0, 0.25, 0.25>;

default
{
    state_entry()
    {
        llSetTexture(onTexture, 4);
    }

    link_message(integer sender, integer num, string message, key id)
    {
        if (message == "On")
        {
            llSetColor(onColor, 4);
            llSetTexture(onTexture, 4);
        }
        else if (message == "Off")
        {
            llSetColor(offColor, 4);
            llSetTexture(offTexture, 4);
        }
    }
}
