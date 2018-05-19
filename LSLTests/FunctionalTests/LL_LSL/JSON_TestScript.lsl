//#!Enable:Testing
// This test script verifies expected behavior or LSL JSON functions
 
integer tests;
integer fails;
 
string typeName(string type)
{
    if (type == JSON_NUMBER) return "JSON_NUMBER";
    if (type == JSON_INVALID) return "JSON_INVALID";
    if (type == JSON_OBJECT) return "JSON_OBJECT";
    if (type == JSON_ARRAY) return "JSON_ARRAY";
    if (type == JSON_TRUE) return "JSON_TRUE";
    if (type == JSON_FALSE) return "JSON_FALSE";
    if (type == JSON_STRING) return "JSON_STRING";
    if (type == JSON_NULL) return "JSON_NULL";
    return type;
}
 
string listEntryTypeName(integer type)
{
    list list_type_names = ["TYPE_INVALID", "TYPE_INTEGER", "TYPE_FLOAT", "TYPE_STRING", "TYPE_KEY", "TYPE_VECTOR", "TYPE_ROTATION"];
    if(type >= llGetListLength(list_type_names)) return "UNKNOWN_LIST_TYPE";
    return llList2String(list_type_names, type);
}
 
integer max(integer x, integer y) {
    if( y > x ) return y;
    return x;
}
 
 
integer verify(string message, string result, string expected)
{
    ++tests;
    if (expected != result)
    {
        llSay(PUBLIC_CHANNEL, "FAIL test " + message  + ", expected: " + typeName(expected) + ", result: " + typeName(result));
        ++fails;
        return 0;
    }
    return 1;
}
 
verify_list(string message, list result, list expected)
{
    // First verify that the list lengths match before looking at the data types
    verify(message + ": list length", (string)llGetListLength(result), (string)llGetListLength(expected));
 
   // the CSV string comparison is probably enough to verify that the values stored are correct, but I want to check data type too.
   integer i = max(llGetListLength(expected), llGetListLength(result));
   while(--i >= 0)
   {
        verify(message + ": on list entry type comparison on index " + (string)i, listEntryTypeName(llGetListEntryType(result, i)),
            listEntryTypeName(llGetListEntryType(expected, i)));
        verify(message + ": on list value comparison on index " + (string)i, typeName(llList2String(result, i)), typeName(llList2String(expected, i)));
    }
    verify(message + ": llList2CSV comparison",llList2CSV(result),llList2CSV(expected));
}
 
test_types()
{
    verify("A01: Type of string",llJsonValueType("\"test\"",[]),JSON_STRING);
    verify("A02: Type of string, unquoted",llJsonValueType("test",[]),JSON_INVALID);
    verify("A03: Type of invalid",llJsonValueType("test",[]),JSON_INVALID);
    verify("A04: Type of integer",llJsonValueType((string)12,[]),JSON_NUMBER);
    verify("A05: Type of float",llJsonValueType((string)12.3,[]),JSON_NUMBER);
    verify("A06: Type of Inf (is unsupported by JSON standard)",llJsonValueType("Inf",[]),JSON_INVALID);
    verify("A07: Type of NaN (is unsupported by JSON standard)",llJsonValueType("NaN",[]),JSON_INVALID);
    verify("A08: Type of number",llJsonValueType("-123.4e-5",[]),JSON_NUMBER);
    verify("A09: Type of object",llJsonValueType("{\"a\":\"b\"}",[]),JSON_OBJECT);
    // Expected to be OBJECT, since we don't do deep validation on input
    //verify("A10: Type of object, invalid/unquoted key",llJsonValueType("{a:\"b\"}",[]),JSON_INVALID);
    // Expected to be OBJECT, since we don't do deep validation on input
    //verify("A11: Type of object, invalid/unquoted value",llJsonValueType("{\"a\":b}",[]),JSON_INVALID);
    verify("A12: Type of array",llJsonValueType("[1,2,3]",[]),JSON_ARRAY);
    verify("A13: Type of array padded front",llJsonValueType(" [1,2,3]",[]),JSON_ARRAY);
    verify("A14: Type of array padded back",llJsonValueType("[1,2,3] ",[]),JSON_ARRAY);
    verify("A15: Type of array padded",llJsonValueType(" [1,2,3] ",[]),JSON_ARRAY);
    verify("A16: Type of true",llJsonValueType("true",[]),JSON_TRUE);
    verify("A17: Type of false",llJsonValueType("false",[]),JSON_FALSE);
    verify("A18: Type of null",llJsonValueType("null",[]),JSON_NULL);
 
    // test traversal of llJsonValueType
    string json = "[[1,2,3],{\"a\":3,\"b\":[true,\"test\",6],\"c\":\"true\",\"d\":false}]";
    verify("A19: Type of [0]",llJsonValueType(json,[0]),JSON_ARRAY);
    verify("A20: Type of [0,1]",llJsonValueType(json,[0,1]),JSON_NUMBER);
    verify("A21: Type of [1]",llJsonValueType(json,[1]),JSON_OBJECT);
    verify("A22: Type of [1,\"b\"]",llJsonValueType(json,[1,"b"]),JSON_ARRAY);
    verify("A23: Type of [1,\"b\",0]",llJsonValueType(json,[1,"b",0]),JSON_TRUE);
    verify("A24: Type of [1,\"b\",1]",llJsonValueType(json,[1,"b",1]),JSON_STRING);
    verify("A25: Type of [1,\"b\",2]",llJsonValueType(json,[1,"b",2]),JSON_NUMBER);
    verify("A26: Type of [1,\"c\"]",llJsonValueType(json,[1,"c"]),JSON_STRING);
    verify("A27: Type of [1,\"d\"]",llJsonValueType(json,[1,"d"]),JSON_FALSE);
    verify("A28: Type of [3] (invalid index at level 0)",llJsonValueType(json,[3]),JSON_INVALID);
    verify("A29: Type of [-1] (invalid index at level 0)",llJsonValueType(json,[-1]),JSON_INVALID);
    verify("A30: Type of [1,\"c\",3] (invalid index at level 1), MAINT-2670",llJsonValueType(json,[1,"c",3]),JSON_INVALID);
    verify("A31: Type of [1,\"b\",3] (invalid index at level 2)",llJsonValueType(json,[1,"b",3]),JSON_INVALID);
    verify("A32: Type of [1,\"b\",2,0,1] (invalid index at level 3) MAINT-2670",llJsonValueType(json,[1,"b",2, 0, 1]),JSON_INVALID);
 
    // some invalid cases where keys are uncoded
    json = "[[1,2,3],{a:3,b:[true,\"test\",6],c:\"true\",\"d\":false}]";
    verify("A33: Type of [1,\"a\"] where key is unquoted",llJsonValueType(json,[1,"a"]),JSON_INVALID);
    verify("A34: Type of [1,\"b\"] where key is unquoted",llJsonValueType(json,[1,"b"]),JSON_INVALID);
    verify("A35: Type of [1,\"c\"] where key is unquoted",llJsonValueType(json,[1,"c"]),JSON_INVALID);
}
 
test_get_value()
{
    string json = "[[1,2,3,4.0],{\"a\":3,\"b\":[true,\"test\",6]}]";
    verify("B01: llJsonGetValue [0]",llJsonGetValue(json,[0]),"[1,2,3,4.0]");
    verify("B02: llJsonGetValue [0,1]",llJsonGetValue(json,[0,1]),"2");
    verify("B03: llJsonGetValue [1]",llJsonGetValue(json,[1]),"{\"a\":3,\"b\":[true,\"test\",6]}");
    verify("B04: llJsonGetValue [1,\"b\"]",llJsonGetValue(json,[1,"b"]),"[true,\"test\",6]");
    verify("B05: llJsonGetValue [1,\"b\",0]",llJsonGetValue(json,[1,"b",0]),JSON_TRUE);
    verify("B06: llJsonGetValue [1,\"b\",1]",llJsonGetValue(json,[1,"b",1]),"test");
    verify("B07: llJsonGetValue [1,\"b\",2]",llJsonGetValue(json,[1,"b",2]),"6");
    verify("B08: llJsonGetValue [0,3]",llJsonGetValue(json,[0,3]), "4.0");
    verify("B09:llJsonGetValue [2] (invalid index at level 0)",llJsonGetValue(json,[2]),JSON_INVALID);
    verify("B10: llJsonGetValue [-1] (invalid index at level 0)",llJsonGetValue(json,[-1]),JSON_INVALID);
    verify("B11: llJsonGetValue [0,4] (invalid index within array)",llJsonGetValue(json,[0,4]),JSON_INVALID);
    verify("B12: llJsonGetValue [\"f\"] (look for missing object within array, depth=0) MAINT-2671",llJsonGetValue(json,["f"]),JSON_INVALID);
    verify("B13: llJsonGetValue [0,\"f\"] (look for missing object within array, depth=1) MAINT-2671",llJsonGetValue(json,[0,"f"]),JSON_INVALID);
    verify("B14: llJsonGetValue [1,2] (specify index within object - disallowed)",llJsonGetValue(json,[1,2]),JSON_INVALID);
 
    // invalid input json - missing quotes around 'a' and 'test'
    json = "[[1,2,3,4.0],{a:3,\"b\":[true,test,6]}]";
    verify("B15: llJsonGetValue [1,\"b\",1], unquoted/invalid string value",llJsonGetValue(json,[1,"b",1]),JSON_INVALID);
    verify("B16: llJsonGetValue [1,\"a\"], unquoted/invalid string for key",llJsonGetValue(json,[1,"a"]),JSON_INVALID);
}
 
test_set_value()
{
    // Test building from scratch
    string json;
    json = llJsonSetValue(json,[0,0],(string)1);
    verify("C01: llJsonSetValue build json",json,"[[1]]");
    json = llJsonSetValue(json,[0,1],(string)2);
    verify("C02: llJsonSetValue build json",json,"[[1,2]]");
    json = llJsonSetValue(json,[0,2],(string)3);
    verify("C03: llJsonSetValue build json",json,"[[1,2,3]]");
    json = llJsonSetValue(json,[1,"a"],(string)3);
    verify("C04: llJsonSetValue build json",json,"[[1,2,3],{\"a\":3}]");
    json = llJsonSetValue(json,[1,"b",0],JSON_TRUE);
    verify("C05: llJsonSetValue build json",json,"[[1,2,3],{\"a\":3,\"b\":[true]}]");
    json = llJsonSetValue(json,[1,"b",1],"test");
    verify("C06: llJsonSetValue build json",json,"[[1,2,3],{\"a\":3,\"b\":[true,\"test\"]}]");
    json = llJsonSetValue(json,[1,"b",2],"6");
    verify("C07: llJsonSetValue completed json",json,"[[1,2,3],{\"a\":3,\"b\":[true,\"test\",6]}]");
 
    // Test replacing
    json = llJsonSetValue(json,[1,"b",1],"foo");
    verify("C08: llJsonSetValue completed json",json,"[[1,2,3],{\"a\":3,\"b\":[true,\"foo\",6]}]");
    json = llJsonSetValue(json,[1,"b"],JSON_TRUE);
    verify("C09: llJsonSetValue completed json, true",json,"[[1,2,3],{\"a\":3,\"b\":true}]");
    json = llJsonSetValue(json,[1,"b"],"true");
    verify("C10: llJsonSetValue completed json, alt true",json,"[[1,2,3],{\"a\":3,\"b\":true}]");
    json = llJsonSetValue(json,[1,0,0],JSON_FALSE);
    verify("C11: llJsonSetValue completed json",json,"[[1,2,3],[[false]]]");
 
    // Test appending
    json = llJsonSetValue("[[1,2,3],{\"a\":3,\"b\":[true,\"test\",6]}]",[0,JSON_APPEND], "4.0");
    verify("C12: llJsonSetValue append to first array",json,"[[1,2,3,4.0],{\"a\":3,\"b\":[true,\"test\",6]}]");
    json = llJsonSetValue(json,[1,"b",JSON_APPEND], "5.0");
    verify("C13: llJsonSetValue append to array withhin object",json,"[[1,2,3,4.0],{\"a\":3,\"b\":[true,\"test\",6,5.0]}]");
    json = llJsonSetValue(json,[JSON_APPEND], "6.0");
    verify("C14: llJsonSetValue append to outer array",json,"[[1,2,3,4.0],{\"a\":3,\"b\":[true,\"test\",6,5.0]},6.0]");
    json = llJsonSetValue("[]",[JSON_APPEND], "\"alone\"");
    verify("C15: llJsonSetValue append to empty array (MAINT-2684)",json,"[\"alone\"]");
    json = llJsonSetValue("[]",[1], "\"alone\"");
    verify("C16: llJsonSetValue append to empty array at invalid index (MAINT-2684)",json,JSON_INVALID);
    json = llJsonSetValue("[]",[0], "\"alone\"");
    verify("C17: llJsonSetValue append to empty array at first index (MAINT-2684)",json,"[\"alone\"]");
 
    // Test deleting
    json = "[[1,2,3],{\"a\":3,\"b\":[true,\"test\",6,null]}]";
    json = llJsonSetValue(json,[1,"b",1],JSON_DELETE);
    verify("C18: llJsonSetValue deleting string in middle of array",json,"[[1,2,3],{\"a\":3,\"b\":[true,6,null]}]");
    json = llJsonSetValue(json,[1,"b",2],JSON_DELETE);
    verify("C19: llJsonSetValue deleting null at end of array",json,"[[1,2,3],{\"a\":3,\"b\":[true,6]}]");
    json = llJsonSetValue(json,[1,"b"],JSON_DELETE);
    verify("C20: llJsonSetValue deleting key-value",json,"[[1,2,3],{\"a\":3}]");
    json = llJsonSetValue(json,[1],JSON_DELETE);
    verify("C21: llJsonSetValue deleting object in array",json,"[[1,2,3]]");
    json = "[[1,2,3],4]";
    json = llJsonSetValue(json,[0],JSON_DELETE);
    verify("C22: llJsonSetValue deleting array (which is first index in array)",json,"[4]");
    json = llJsonSetValue(json,[0],JSON_DELETE);
    verify("C23: llJsonSetValue deleting last element in array",json,"[]");
    json = "[[1]]";
    json = llJsonSetValue(json,[0,0],JSON_DELETE);
    verify("C24: llJsonSetValue deleting last element in array",json,"[[]]");
    json = llJsonSetValue(json,[0],JSON_DELETE);
    verify("C25: llJsonSetValue deleting array within array",json,"[]");
 
    // Test failures in deleting
    json = "[[1,2,3],{\"a\":3,\"b\":[true,\"test\",6,null]}]";
    verify("C26: llJsonSetValue deleting undefined key-value in object",llJsonSetValue(json,[1,"d"],JSON_DELETE),JSON_INVALID);
    verify("C27: llJsonSetValue deleting out-of-range index in array",llJsonSetValue(json,[2],JSON_DELETE),JSON_INVALID);
    verify("C28: llJsonSetValue deleting depth within object that doesn't exist",llJsonSetValue(json,[1,"a","unicorn"],JSON_DELETE),JSON_INVALID);
    verify("C29: llJsonSetValue deleting depth within array that doesn't exist",llJsonSetValue(json,[0,1,1],JSON_DELETE),JSON_INVALID);
 
    // this is the only failure mode that should exist.
    json = "[[1,2,3],{\"a\":3,\"b\":[true,\"foo\",6]}]";
    json = llJsonSetValue(json,[3],JSON_FALSE);
    verify("C30: llJsonSetValue fail to insert data into invalid array index (MAINT-2675)",json,JSON_INVALID);
 
}
 
 
 
 
test_json_to_list()
{
    list l = llJson2List("[[1,2,3],{\"a\":3,\"b\":[true,\"test\",6]}]");
    verify_list("D01: llJson2List first",l,["[1,2,3]","{\"a\":3,\"b\":[true,\"test\",6]}"]);
    list n = llJson2List(llList2String(l,0));
    verify_list("D02: llJson2List l,0",n,[1,2,3]);
    n = llJson2List(llList2String(l,1));
    verify_list("D03: llJson2List l,0",n,["a",3,"b","[true,\"test\",6]"]);
    n = llJson2List(llList2String(n,3));
    verify_list("D04: llJson2List l,0",n,[JSON_TRUE, "test", 6]);
    n = llJson2List(llList2String(n,1));
    verify_list("D05: llJson2List l,0",n,["test"]);
    n = llJson2List("");
    verify_list("D06: Empty JSON string becomes empty list",n,[]);
    n = llJson2List("[]");
    verify_list("D07: Empty JSON array becomes empty list (MAINT-2678)",n,[]);
    n = llJson2List("{}");
    verify_list("D08: Empty JSON object becomes empty list (MAINT-2678)",n,[]);
    n = llJson2List("Non-JSON string, with comma");
    verify_list("D09: llJson2List for non-JSON string is stored as a single object",n,["Non-JSON string, with comma"]);
    n = llJson2List("[malformed}");
    verify_list("D10: llJson2List, malformed input",n,["[malformed}"]);
}
 
test_list_to_json()
{
    // test objects
    string json = llList2Json(JSON_OBJECT,["a",1,"b",2.5,"c","test","d","true","e","[1,2,3]"]);
    verify("E01: llList2Json, json object",json,"{\"a\":1,\"b\":2.500000,\"c\":\"test\",\"d\":true,\"e\":[1,2,3]}");
 
    // test arrays
    json = llList2Json(JSON_ARRAY,[1,2.5,"test","true","[1,2,3]"]);
    verify("E02: llList2Json, json array",json,"[1,2.500000,\"test\",true,[1,2,3]]");
 
    // test arrays
    json = llList2Json(JSON_ARRAY,[1,2.5,"test",JSON_TRUE,"[1,2,3]"]);
    verify("E03: llList2Json, json array, alternative true representation",json,"[1,2.500000,\"test\",true,[1,2,3]]");
 
    // test objects, with empty input
    json = llList2Json(JSON_OBJECT,[]);
    verify("E04: llList2Json, json object with empty input (MAINT-2681)",json,"{}");
 
    // test arrays, with empty input
    json = llList2Json(JSON_ARRAY,[]);
    verify("E05: llList2Json, json array with empty input (MAINT-2681)",json,"[]");
 
    // test objects which are truncated
    json = llList2Json(JSON_OBJECT,["a",1,"b",2.5,"c","test","d","true","e"]);
    verify("E06: llList2Json, json object, truncated",json,JSON_INVALID);
 
    // test objects which has a non-string identifier somewhere
    json = llList2Json(JSON_OBJECT,["a",1,TRUE,2.5,"c","test","d","true","e"]);
    verify("E07: llList2Json, json object, non-string in one of the first stride values",json,JSON_INVALID);
 
    // test invalid type
    json = llList2Json("foo",["a",1,"b",2.5,"c","test","d","true","e","[1,2,3]"]);
    verify("E08: llList2Json, json invalid type",json,JSON_INVALID);
}
 
test_strings_with_escaped_chars()
{
    list escaped_pairs = [
        "funky\"string", "funky\\\"string", "quote in middle",
        "funkystr\"ing", "funkystr\\\"ing", "quote in middle, other position",
        // note that we have to double-up backslashes to assign them to strings..
        "funky\\string", "funky\\\\string", "backslashes in middle",
        "\\funkystring", "\\\\funkystring", "backslashes at beginning",
        "funky\nstring", "funky\\nstring", "newline in string",
        "funky/string", "funky\\/string", "forward slash in string",
        // TAB (\t) fails, because it seems that LSL automatically converts any tab into 4 consecutive spaces.
        // * "funky\tstring", "funky\\tstring", "tab in string",
        // these cases fail; it seems that LSL doesn't support these characters, and strips the '\'
        // * "funky\bstring", "funky\\\bstring", "backspace in middle",
        // * "funky\fstring", "funky\\\fstring", "form feed in middle",
        // * "funky\rstring", "funky\\rstring", "carriage return in string",
        // note that the following case can't be supported, since strings starting with \" can't be escaped
        // * "\"funkystring", "\\\"funkystring", "quote in beginning",
        "vanilla string", "vanilla string", "nothing that needs to be escaped.."
    ];
    integer i;
    for(i=0; i < llGetListLength(escaped_pairs); i+=3)
    {
        string funky_string = llList2String(escaped_pairs, i);
        string funky_string_escaped = llList2String(escaped_pairs, i+1);
        string escaped_desc = " '" + llList2String(escaped_pairs, i+2) + "'";
 
        verify("F01: Type of string with escaped char (for MAINT-2698),"+escaped_desc,llJsonValueType("\""+funky_string_escaped+"\"",[]),JSON_STRING);
 
        string json = "[[1,2,3,4.0],{\""+funky_string_escaped+"\":3,\"b\":\""+funky_string_escaped+"value"+"\"}]";
        verify("F02: llJsonGetValue [1,\""+funky_string_escaped+"\"] (for MAINT-2698),"+escaped_desc,
            llJsonGetValue(json,[1,funky_string]),"3");
        verify("F03: llJsonGetValue [1,\"b\"] (for MAINT-2698),"+escaped_desc,llJsonGetValue(json,[1,"b"]),funky_string+"value");
 
        //llSay(0, "DEBUG: '" + llEscapeURL(json) + "' is input for test " + escaped_desc);
        json = llJsonSetValue(json,[0],funky_string);
        verify("F04: llJsonSetValue with escaped string as value (for MAINT-2698),"+escaped_desc,json,
            "[\""+funky_string_escaped+"\",{\""+funky_string_escaped+"\":3,\"b\":\""+funky_string_escaped+"value"+"\"}]");
 
        json = llJsonSetValue(json,[0],funky_string);
        verify("F05: llJsonSetValue with escaped string as value (for MAINT-2698),"+escaped_desc,json,
            "[\""+funky_string_escaped+"\",{\""+funky_string_escaped+"\":3,\"b\":\""+funky_string_escaped+"value"+"\"}]");
 
        json = llJsonSetValue(json,[0,funky_string], funky_string+"value");
        verify("F06: llJsonSetValue with escaped string as key's value (for MAINT-2698),"+escaped_desc,json,
            "[{\""+funky_string_escaped+"\":\""+funky_string_escaped+"value\"},{\""+funky_string_escaped+"\":3,\"b\":\""+funky_string_escaped+"value"+"\"}]");
 
        list l = llJson2List(json);
        verify_list("F07: llJson2List extracting object containing escaped string (for MAINT-2698),"+escaped_desc, l,
            ["{\""+funky_string_escaped+"\":\""+funky_string_escaped+"value\"}","{\""+funky_string_escaped+"\":3,\"b\":\""+funky_string_escaped+"value"+"\"}"]);
        list n = llJson2List(llList2String(l, 0));
        verify_list("F08: llJson2List extracting escaped strings (for MAINT-2698),"+escaped_desc, n,
            [funky_string,funky_string+"value"]);
 
        json = llList2Json(JSON_ARRAY,n);
        verify("F09: llList2Json from escaped-containing string to array (for MAINT-2698),"+escaped_desc,json,
            "[\""+funky_string_escaped+"\",\""+funky_string_escaped+"value\"]");
 
        json = llList2Json(JSON_OBJECT,n);
        verify("F10: llList2Json from escaped-containing string to object (for MAINT-2698),"+escaped_desc,json,
            "{\""+funky_string_escaped+"\":\""+funky_string_escaped+"value\"}");
    }
}
 
maint3070()
{
    verify("G01: Set value 'messa[g]e'", llJsonSetValue("",["toast"],"messa[g]e"), "{\"toast\":\"messa[g]e\"}");
    verify("G02: Set value 'messag[e]'", llJsonSetValue("",["toast"],"messag[e]"), "{\"toast\":\"messag[e]\"}");
    verify("G03: Set value 'messag\[e\]'", llJsonSetValue("",["toast"],"messag\[e\]"), "{\"toast\":\"messag[e]\"}");
}
 
maint4187()
{
    verify("H01: Valid json number with + before exponent", llJsonValueType("1.0e+1", []), JSON_NUMBER);
    verify("H02: Valid json number with - before exponent", llJsonValueType("1.0e-1", []), JSON_NUMBER);
    verify("H03: Valid json number with - before exponent and mantissa", llJsonValueType("-1.0e-1", []), JSON_NUMBER);
    verify("H04: Valid json number with unsigned exponent", llJsonValueType("1.0e1", []), JSON_NUMBER);
    verify("H05: Invalid json number due to + before mantissa", llJsonValueType("+1.0e1", []), JSON_INVALID);
 
    verify("H06: Invalid json number due to leading e", llJsonValueType("e1", []), JSON_INVALID);
    verify("H07: Invalid json number due to leading 0", llJsonValueType("01", []), JSON_INVALID);
    verify("H08: Invalid json number due to leading -0", llJsonValueType("-01", []), JSON_INVALID);
    verify("H09: Valid json number with 0 immediately before .", llJsonValueType("0.01", []), JSON_NUMBER);
    verify("H10: Valid json number with -0 immediately before .", llJsonValueType("-0.01", []), JSON_NUMBER);
}
 
maint4252()
{
    verify("I01: Valid json number with 0 mantissa, '+' before exponent", llJsonValueType("0e+1", []), JSON_NUMBER);
    verify("I02: Valid json number with 0 mantissa, positive exponent", llJsonValueType("0e1", []), JSON_NUMBER);
    verify("I03: Valid json number with 0 mantissa, '-' before exponent", llJsonValueType("0e-1", []), JSON_NUMBER);
    verify("I04: Valid json number with 0 mantissa, 0 exponent", llJsonValueType("0e0", []), JSON_NUMBER);
}
 
maint3053()
{
    string jT1 = "[1, 2]"; // A JSON array
    verify("J01: llJsonSetValue(jT1,[2],\"t\")",llJsonSetValue(jT1,[2],"t"),"[1,2,\"t\"]");
    verify("J02: llJsonSetValue(jT1,[3],\"t\")",llJsonSetValue(jT1,[3],"t"),JSON_INVALID);
    verify("J03: llJsonSetValue(jT1,[0, 0],\"t\")",llJsonSetValue(jT1,[0, 0],"t"),"[[\"t\"],2]");
    verify("J04: llJsonSetValue(jT1,[0, 0, 2, \"t\", 75],\"t\")",llJsonSetValue(jT1,[0, 0, 2, "t", 75],"t"),JSON_INVALID);
    verify("J05: llJsonSetValue(jT1,[0, 1],\"t\")",llJsonSetValue(jT1,[0, 1],"t"),JSON_INVALID);
    verify("J06: llJsonSetValue(jT1,[0, 1, 2, \"t\", 75],\"t\")",llJsonSetValue(jT1,[0, 1, 2, "t", 75],"t"),JSON_INVALID);
 
    string jT2 = "[ [\"A\", \"B\", \"C\"], 2]";
    verify("J07: llJsonSetValue(jT2,[0, 3],\"t\")",llJsonSetValue(jT2,[0, 3],"t"),"[[\"A\",\"B\",\"C\",\"t\"],2]");
    verify("J08: llJsonSetValue(jT2,[0, 4],\"t\")",llJsonSetValue(jT2,[0, 4],"t"),JSON_INVALID);
    verify("J09: llJsonSetValue(jT2,[0, 1, 0],\"t\")",llJsonSetValue(jT2,[0, 1, 0],"t"),"[[\"A\",[\"t\"],\"C\"],2]");
    verify("J10: llJsonSetValue(jT2,[0, 1, 1],\"t\")",llJsonSetValue(jT2,[0, 1, 1],"t"),JSON_INVALID);
 
    string jT3 = "{\"1\":2}";
    verify("J11: llJsonSetValue(jT3,[\"1\"],\"t\")",llJsonSetValue(jT3,["1"],"t"),"{\"1\":\"t\"}");
    verify("J12: llJsonSetValue(jT3,[\"1\",0],\"t\")",llJsonSetValue(jT3,["1",0],"t"),"{\"1\":[\"t\"]}");
    verify("J13: llJsonSetValue(jT3,[\"1\",1],\"t\")",llJsonSetValue(jT3,["1",1],"t"),JSON_INVALID);
 
    string jGood = "[null, 2]";
    verify("J14: llJsonValueType(jGood, [0])",llJsonValueType(jGood, [0]),JSON_NULL);
    verify("J15: llJsonValueType(jGood, [0, 0])",llJsonValueType(jGood, [0, 0]),JSON_INVALID);
 
    string jBad = "[, 2]";
    verify("J16: llJsonValueType(jBad,[0])",llJsonValueType(jBad,[0]),JSON_INVALID);
    verify("J17: llJsonValueType(jBad,[0, 0, 2, \"t\", 75])",llJsonValueType(jBad,[0, 0, 2, "t", 75]),JSON_INVALID);
    verify("J18: llJsonGetValue(jBad,[1, 0, 2, \"t\", 75])",llJsonGetValue(jBad,[1, 0, 2, "t", 75]),JSON_INVALID);
}
 
maint3081()
{
    verify("K01: llJsonSetValue blank string",llJsonSetValue("",["test"],""),"{\"test\":\"\"}");
    verify("K02: llJsonSetValue JSON_NULL",llJsonSetValue("",["test"],JSON_NULL),"{\"test\":null}");
    verify("K03: llJsonGetValue blank string",llJsonGetValue("{\"test\":\"\"}",["test"]),"");
    verify("K04: llJsonGetValue JSON_NULL",llJsonGetValue("{\"test\":null}",["test"]),JSON_NULL);
    verify("K05: Identity (set->get) blank string",llJsonGetValue(llJsonSetValue("",["test"],""),["test"]),"");
    verify("K06: Identity (set->get) JSON_NULL",llJsonGetValue(llJsonSetValue("",["test"],JSON_NULL),["test"]),JSON_NULL);
}
 
test_jira_fixes()
{
    maint3070();
    maint4187();
    maint3053();
    maint3081();
    maint4252();
}
 
default
{
    state_entry()
    {
	_test_Result(FALSE);
        test_types();
        test_get_value();
        test_set_value();
        test_json_to_list();
        test_list_to_json();
        test_strings_with_escaped_chars();
        test_jira_fixes();
        llSay(PUBLIC_CHANNEL, "Tests complete. Ran " + (string)tests + " tests with " + (string)fails + " failures.");
	_test_Result(fails == 0);
	_test_Shutdown();
    }
 
}