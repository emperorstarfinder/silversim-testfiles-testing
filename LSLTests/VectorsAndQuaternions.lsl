default
{
	state_entry()
	{
		rotation r;
		vector v;
		list l;
		v = <1,2,3>+<2,3,4<5>;
		r = <1,2,3,4>*<1,2,3,4>;
		v = (<1,2,3>);
		r = (<1,2,3,4>);
		l = [<1,2,3>,<1,2,3,4>];
		integer b;
		b = v != <0,0,0>;
		b = r != <1,1,1,1>;
	}
}
