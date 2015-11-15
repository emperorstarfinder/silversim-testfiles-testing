vector bOffset = <0.0, 0.0,  0.3>;
vector tOffset = <0.0, 0.0, -0.3>;

vector myOffset;

default
{
    link_message(integer sender, integer num, string message, key id)
    {
        if (message == "Menu")
        {
            llSetPos(myOffset);
        }
        else if (message == "Hide")
        {
            llSetPos(<0.05, 0.0, 0.0>);
        }
        else if (message == "Top Row")
        {
            myOffset = tOffset;
        }
        else if (message == "Bottom Row")
        {
            myOffset = bOffset;
        }
    }
}
