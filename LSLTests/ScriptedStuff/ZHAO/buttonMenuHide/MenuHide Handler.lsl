// When the state is off, the button says 'Off', and vice versa

key menuTexture = "c843e727-b383-9f45-d5d7-bc07ed276277";
key hideTexture = "b22993fb-10c6-4b08-d054-b5828bfb074a";

vector bOffset = <0.0, 0.0,  0.05>;
vector tOffset = <0.0, 0.0, -0.05>;

default
{
    state_entry()
    {
        llSetTexture(hideTexture, 4);
    }

    link_message(integer sender, integer num, string message, key id)
    {
        if (message == "Menu")
        {
            llSetTexture(hideTexture, 4);
        }
        else if (message == "Hide")
        {
            llSetTexture(menuTexture, 4);
        }
        else if (message == "Top Row")
        {
            llSetPos(tOffset);
        }
        else if (message == "Bottom Row")
        {
            llSetPos(bOffset);
        }
    }
}
