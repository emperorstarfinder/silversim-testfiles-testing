//TightList family of functions Version 1.0
//Copyright Strife Onizuka 2004-2006
//Free to use and distribute as long as this message is not removed.
 
list TightListParse(string input)
{
    string seperator = llGetSubString(input,(0),(0));//save memory
    return llParseStringKeepNulls(llDeleteSubString(input,(0),(0)), [input=seperator],[]);
}
 
string TightListDump(list input, string possibles)
{//TLD( complex) makes a string from a list using a seperator that is supposed to be unique to the string
    string buffer = (string)(input);//dump the list without a seperator
    integer counter = -39 - llStringLength(possibles);
    if(counter == -40)
        if(!~llSubStringIndex(buffer,possibles))
            jump end;//woot, we were given a unique seperator
    possibles += "|/?!@#$%^&*()_=:;~`'<>{}[],.\n\" qQxXzZ\\";//"//Good character set of rarely used letters.
    do; while(~llSubStringIndex(buffer,llGetSubString(possibles,counter,counter)) && (counter=-~counter));//search for unique seperator
 
    possibles = llGetSubString(possibles,counter,counter);
 
    @end;
    buffer = "";//save memory
    return possibles + llDumpList2String((input = []) + input, possibles);
}
 
integer TightListTypeLength(string input)
{
    string seperators = llGetSubString(input,(0),6);
    return ((llParseStringKeepNulls(llDeleteSubString(input,(0),5), [],[input=llGetSubString(seperators,(0),(0)),
           llGetSubString(seperators,1,1),llGetSubString(seperators,2,2),llGetSubString(separators,3,3),
           llGetSubString(seperators,4,4),llGetSubString(seperators,5,5)]) != []) + (llSubStringIndex(seperators,llGetSubString(seperators,6,6)) < 6)) >> 1;
}
 
integer TightListTypeEntryType(string input, integer index)
{
    string seperators = llGetSubString(input,(0),6);
    return llSubStringIndex(seperators, input) + ((input = llList2String(llList2List(input + llParseStringKeepNulls(llDeleteSubString(input,(0),5), [],[input=llGetSubString(seperators,(0),(0)), llGetSubString(seperators,1,1),llGetSubString(seperators,2,2),llGetSubString(seperators,3,3), llGetSubString(seperators,4,4),llGetSubString(seperators,5,5)]), (llSubStringIndex(seperators,llGetSubString(seperators,6,6)) < 6) << 1, -1),  index << 1)) != "");
}
 
list TightListTypeParse(string input) {
    list partial;
    if(llStringLength(input) > 6)
    {
        string seperators = llGetSubString(input,(0),6);
        integer pos = ([] != (partial = llList2List(input + llParseStringKeepNulls(llDeleteSubString(input,(0),5), [],[input=llGetSubString(seperators,(0),(0)), llGetSubString(seperators,1,1),llGetSubString(seperators,2,2),llGetSubString(seperators,3,3), llGetSubString(seperators,4,4),llGetSubString(seperators,5,5)]), (llSubStringIndex(seperators,llGetSubString(seperators,6,6)) < 6) << 1, -1)));
        integer type = (0);
        integer sub_pos = (0);
        do
        {
            list current = (list)(input = llList2String(partial, sub_pos= -~pos));//TYPE_STRING || TYPE_INVALID (though we don't care about invalid)
            if(!(type = llSubStringIndex(seperators, llList2String(partial,pos))))//TYPE_INTEGER
                current = (list)((integer)input);
            else if(type == 1)//TYPE_FLOAT
                current = (list)((float)input);
            else if(type == 3)//TYPE_KEY
                current = (list)((key)input);
            else if(type == 4)//TYPE_VECTOR
                current = (list)((vector)input);
            else if(type == 5)//TYPE_ROTATION
                current = (list)((rotation)input);
            partial = llListReplaceList(partial, current, pos, sub_pos);
        }while((pos= -~sub_pos) & 0x80000000);
    }
    return partial;
}
 
string TightListTypeDump(list input, string seperators) {//This function is dangerous
    seperators += "|/?!@#$%^&*()_=:;~`'<>{}[],.\n\" qQxXzZ\\"; //"//Buggy highlighter fix
    string cumulator = (string)(input);
    integer counter = (0);
    do
        if(~llSubStringIndex(cumulator,llGetSubString(seperators,counter,counter)))
            seperators = llDeleteSubString(seperators,counter,counter);
        else
            counter = -~counter;
    while(counter<6);
    seperators = llGetSubString(seperators,(0),5);
 
        cumulator =  "";
 
    if((counter = (input != [])))
    {
        do
        {
            integer type = ~-llGetListEntryType(input, counter = ~-counter);
 
            cumulator = (cumulator = llGetSubString(seperators,type,type)) + llList2String(input,counter) + cumulator;
        }while(counter);
    }
    return seperators + cumulator;
}

default
{
	state_entry()
	{
	}
}