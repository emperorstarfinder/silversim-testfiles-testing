//#!Enable:Testing

vector v;
vector v2 = <1,1,1>;

float v2x = 1;
float v2y = 1;
float v2z = 1;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        integer result = TRUE;
        v = 90 * <1, 1, 1>;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 90) > 0.01 || llFabs(v.y - 90) > 0.01 || llFabs(v.z - 90) > 0.01)
        {
            result = FALSE;
        }
        v = 90 * v2;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 90) > 0.01 || llFabs(v.y - 90) > 0.01 || llFabs(v.z - 90) > 0.01)
        {
            result = FALSE;
        }
        v = 90 * <v2x,v2y,v2z>;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 90) > 0.01 || llFabs(v.y - 90) > 0.01 || llFabs(v.z - 90) > 0.01)
        {
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}