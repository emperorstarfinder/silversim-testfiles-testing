//#!Enable:Testing

default
{
    state_entry()
    {
        integer val = TRUE;
        _test_Result(FALSE);
        
        if(_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsRegionOwnerAllowed is not set");
        }
        
        _test_setserverparam("OSSL.TestFunction.IsRegionOwnerAllowed", "false");
        
        if(_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsRegionOwnerAllowed = false");
        }

        _test_setserverparam("OSSL.TestFunction.IsRegionOwnerAllowed", "true");
        
        if(!_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should be accessible when IsRegionOwnerAllowed = true");
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}