//#!Mode:ASSL
//#!Enable:testing

default
{
    state_entry()
    {
        osMakeNotecard("Notecard", "Note");
        if(llGetInventoryType("Notecard") != INVENTORY_NOTECARD)
        {
            llSay(PUBLIC_CHANNEL, "Notecard has wrong name " + llGetInventoryName(INVENTORY_NOTECARD, 0));
        }
        else if(asGetNotecard("Notecard") != "Note")
        {
            llSay(PUBLIC_CHANNEL, "Content of notecard is wrong");
        }
        else
        {
            _test_Result(TRUE);
        }
        _test_Shutdown();
    }
}
