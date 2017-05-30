//#!Mode:ASSL

default
{
	state_entry()
	{
		list a = [1,2,3];
		a[0] += 5;
		a[0] -= 5;
		a[0] *= 5;
		a[0] /= 5;
		integer i = 2;
		a[i] = 3;
		integer j = a[0];
		float k = a[0];
		vector l = a[0];
		rotation m = a[0];
		string n = a[0];
		key o = a[0];
		list p = a[0];
		
		llSay(0, a[0]);
	}
}