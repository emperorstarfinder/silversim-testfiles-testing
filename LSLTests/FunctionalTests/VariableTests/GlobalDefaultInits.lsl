//#!Enable:Testing

float f;
integer i;
string s;
vector v;
rotation r;
key k;
list l;

default
{
    state_entry()
    {
	_test_Result(TRUE);
	_test_Shutdown();
    }
}