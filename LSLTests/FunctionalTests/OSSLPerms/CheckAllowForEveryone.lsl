//#!Enable:Testing

default
{
    state_entry()
    {
        integer val = TRUE;
        _test_Result(FALSE);
        
        if(_test_ossl_perms(OSSL_THREAT_LEVEL_SEVERE, "TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsEveryoneAllowed is not set");
        }
        
        _test_setserverparam("OSSL.TestFunction.IsEveryoneAllowed", "false");
        
        if(_test_ossl_perms(OSSL_THREAT_LEVEL_SEVERE, "TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsEveryoneAllowed = false");
        }

        _test_setserverparam("OSSL.TestFunction.IsEveryoneAllowed", "true");
        
        if(!_test_ossl_perms(OSSL_THREAT_LEVEL_SEVERE, "TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should be accessible when IsEveryoneAllowed = true");
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}