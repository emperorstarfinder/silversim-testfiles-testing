default
{
	state_entry()
	{
		integer a;
		integer b;
		integer c;
		vector d;
		float f;
		string s;
		s = (string)d.x;
		f=(float)c;
		d.x+=d.y+=d.z+=1;
		a = b + c * b;
		f = -d.x;
		f = -f;
		a=b*c;
		a=b*c++;
		a=b*++c;
		a=b/c;
		a=b%c;
		a=b&&c;
		a=b||c;
		a=b||!c;
		a=!b||!c;
		a=~b|~c;
		a=~b;
		a=++b;
		a=b++;
		a=--b+ ++c;
		a=--b+--c;
		a=-b+-c;
		a+=b;
		a-=b;
		a*=b;
		a/=b;
		a++;
		++a;
		d.x++;
		++d.x;
	}
}