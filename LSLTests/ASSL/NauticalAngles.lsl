//#!Mode:ASSL

default
{
	state_entry()
	{
		rotation r;
		vector v;
		r = asNautical2Rot(v);
		v = asRot2Nautical(r);
	}
}