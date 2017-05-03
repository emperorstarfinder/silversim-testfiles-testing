//#!Enable:Testing

default
{
    state_entry()
    {
        integer val = TRUE;
        _test_Result(FALSE);
        
        if(_test_ossl_perms(OSSL_THREAT_LEVEL_SEVERE, "TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsEstateOwnerAllowed is not set");
        }
        
        _test_setserverparam("OSSL.TestFunction.IsEstateOwnerAllowed", "false");
        
        if(_test_ossl_perms(OSSL_THREAT_LEVEL_SEVERE, "TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsEstateOwnerAllowed = false");
        }

        _test_setserverparam("OSSL.TestFunction.IsEstateOwnerAllowed", "true");
        
        if(!_test_ossl_perms(OSSL_THREAT_LEVEL_SEVERE, "TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should be accessible when IsEstateOwnerAllowed = true");
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}