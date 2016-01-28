//#!Enable:Testing

float f = 1.;
vector v = <1,1,1>;
integer i = 2;
rotation r = <0,0,0,1>;
string s = "Hello";
key k = NULL_KEY;

list l = [f, i, s, v, r, k];

default
{
    state_entry()
    {
	_test_Result(FALSE);
	llSay(PUBLIC_CHANNEL, "llList2Float");
	llSleep(0.1);
	llSay(PUBLIC_CHANNEL, (string)llList2Float(l, 0));
	llSay(PUBLIC_CHANNEL, "llList2Integer");
	llSleep(0.1);
	llSay(PUBLIC_CHANNEL, (string)llList2Integer(l, 1));
	llSay(PUBLIC_CHANNEL, "llList2String");
	llSleep(0.1);
	llSay(PUBLIC_CHANNEL, llList2String(l, 2));
	llSay(PUBLIC_CHANNEL, "llList2Vector");
	llSleep(0.1);
	llSay(PUBLIC_CHANNEL, (string)llList2Vector(l, 3));
	llSay(PUBLIC_CHANNEL, "llList2Rot");
	llSleep(0.1);
	llSay(PUBLIC_CHANNEL, (string)llList2Rot(l, 4));
	llSay(PUBLIC_CHANNEL, "llList2Key");
	llSleep(0.1);
	llSay(PUBLIC_CHANNEL, llList2Key(l, 5));
	_test_Result(TRUE);
	_test_Shutdown();
    }
}