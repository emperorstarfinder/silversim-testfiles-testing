//#!Enable:Testing

default
{
    state_entry()
    {
        list a;
        list b;
        list o;
        o = [1,2];
        a = o;
        b = o;
        a += [3];
        b += [4];
        
        llSay(PUBLIC_CHANNEL, "A[2]: " + (string)llList2Integer(a, 2));
        llSay(PUBLIC_CHANNEL, "B[2]: " + (string)llList2Integer(b, 2));
        llSay(PUBLIC_CHANNEL, "A.LEN: " + (string)llGetListLength(a));
        llSay(PUBLIC_CHANNEL, "B.LEN: " + (string)llGetListLength(b));
        llSay(PUBLIC_CHANNEL, "O.LEN: " + (string)llGetListLength(o));
        _test_Result(llList2Integer(a, 2) == 3 && llList2Integer(b, 2) == 4 && llGetListLength(a) == 3 && llGetListLength(b) == 3 && llGetListLength(o) == 2);
        _test_Shutdown();
    }
}