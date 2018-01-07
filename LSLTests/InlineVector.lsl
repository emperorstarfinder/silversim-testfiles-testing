list shapeParams;
vector taper;

default
{
    state_entry()
    {
        shapeParams += <1.0,1.0,0> - taper;
        llSay(0, (string) shapeParams);
    }

}