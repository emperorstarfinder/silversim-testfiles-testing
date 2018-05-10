//#!Enable:Testing

vector v;
vector v2 = <90,90,90>;

float v2x = 90;
float v2y = 90;
float v2z = 90;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        integer result = TRUE;
        v = <90, 90, 90> / 90;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 1) > 0.01 || llFabs(v.y - 1) > 0.01 || llFabs(v.z - 1) > 0.01)
        {
            result = FALSE;
        }
        v = v2 / 90;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 1) > 0.01 || llFabs(v.y - 1) > 0.01 || llFabs(v.z - 1) > 0.01)
        {
            result = FALSE;
        }
        v = <v2x,v2y,v2z> / 90;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 1) > 0.01 || llFabs(v.y - 1) > 0.01 || llFabs(v.z - 1) > 0.01)
        {
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}