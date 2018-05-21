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
        v = <1, 1, 1> * 90;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 90) > 0.01 || llFabs(v.y - 90) > 0.01 || llFabs(v.z - 90) > 0.01)
        {
            llSay(PUBLIC_CHANNEL, "FAIL: A");
            result = FALSE;
        }
        v = v2 * 90;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 90) > 0.01 || llFabs(v.y - 90) > 0.01 || llFabs(v.z - 90) > 0.01)
        {
            llSay(PUBLIC_CHANNEL, "FAIL: B");
            result = FALSE;
        }
        v = <v2x,v2y,v2z> * 90;
        llSay(PUBLIC_CHANNEL, (string)v);
        if(llFabs(v.x - 90) > 0.01 || llFabs(v.y - 90) > 0.01 || llFabs(v.z - 90) > 0.01)
        {
            llSay(PUBLIC_CHANNEL, "FAIL: C");
            result = FALSE;
        }
        _test_Result(result);
        _test_Shutdown();
    }
}