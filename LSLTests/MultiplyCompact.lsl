integer XTEA_DELTA = 10;
integer xtea_num_rounds = 10;

default
{
	state_entry()
	{
		integer sum = XTEA_DELTA*xtea_num_rounds;
	}
}