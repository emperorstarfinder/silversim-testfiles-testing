integer i;
float f;
key k;
string s;
rotation r;
vector v;
list l;

default
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, s + i);
		llSay(PUBLIC_CHANNEL, s + f);
		llSay(PUBLIC_CHANNEL, s + k);
		llSay(PUBLIC_CHANNEL, s + s);
		llSay(PUBLIC_CHANNEL, s + r);
		llSay(PUBLIC_CHANNEL, s + v);
		
		llSay(PUBLIC_CHANNEL, i + s);
		llSay(PUBLIC_CHANNEL, f + s);
		llSay(PUBLIC_CHANNEL, k + s);
		llSay(PUBLIC_CHANNEL, s + s);
		llSay(PUBLIC_CHANNEL, r + s);
		llSay(PUBLIC_CHANNEL, v + s);
	}
}