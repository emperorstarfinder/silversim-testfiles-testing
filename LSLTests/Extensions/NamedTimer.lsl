//#!Mode:ASSL

timer(Hello) timerfunction()
{
}

default
{
	state_entry()
	{
		Timer["Hello"].Interval = 1;
	}
}