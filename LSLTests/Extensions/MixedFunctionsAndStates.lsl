integer prevar;

default
{
	state_entry()
	{
		callmyfunc2();
		state two;
	}
}

integer myvar;

callmyfunc()
{
	myvar = 5;
}

integer myvar2;

state two
{
	state_entry()
	{
		callmyfunc();
		myvar2 = 6;
	}
}

callmyfunc2()
{
}