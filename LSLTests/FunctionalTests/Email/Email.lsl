//#!Mode:ASSL
//#!Enable:Testing

default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Local Domain: " + asGetLocalLslEmailDomain());
        llEmail(llGetKey()+"@"+asGetLocalLslEmailDomain(), "Subject", "Message");
        llGetNextEmail("", "");
        _test_Result(FALSE);
    }
    
    email(string time, string address, string subject, string body, integer num_left)
    {
        string message = llDeleteSubString(body, 0, llSubStringIndex(body, "\n\n") + 1);
        llSay(PUBLIC_CHANNEL, "Time: " + time);
        llSay(PUBLIC_CHANNEL, "Address: " + address);
        llSay(PUBLIC_CHANNEL, "Subject: " + subject);
        llSay(PUBLIC_CHANNEL, "Message: " + message);
        llSay(PUBLIC_CHANNEL, "Num Left: " + (string)num_left);
        if(num_left == 0 && address == llGetKey()+"@"+asGetLocalLslEmailDomain() && subject == "Subject" && message == "Message")
        {
            _test_Result(TRUE);
        }
        _test_Shutdown();
    }
}