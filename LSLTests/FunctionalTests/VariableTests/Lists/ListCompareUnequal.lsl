//#!Enable:Testing

default
{
    state_entry()
    {
        list l1 = [1];
        list l2 = [1, 3];
        list l3 = [1, 2, 4];
        
        integer r13 = l1 != l3;
        integer r12 = l1 != l2;
        integer r23 = l2 != l3;
        integer r11 = l1 != l1;
        integer r32 = l3 != l2;
        integer r31 = l3 != l1;
        integer r21 = l2 != l1;
            
        integer okay = TRUE;
        if(r13 != -2)
            okay = FALSE;
        if(r12 != -1)
            okay = FALSE;
        if(r23 != -1)
            okay = FALSE;
        if(r11 != 0)
            okay = FALSE;
        if(r31 != 2)
            okay = FALSE;
        if(r32 != 1)
            okay = FALSE;
        if(r21 != 1)
            okay = FALSE;
        _test_Result(okay);
        _test_Shutdown();
    }
}