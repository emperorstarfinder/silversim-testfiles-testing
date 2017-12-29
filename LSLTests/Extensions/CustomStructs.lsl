//#!Enable:Structs

struct MyStruct
{
	integer Type;
	string Data;
}

default
{
	state_entry()
	{
		MyStruct struct;
		struct.Type = 5;
		struct.Data = "Hello";
		llSay(0, struct.Data);
	}
}