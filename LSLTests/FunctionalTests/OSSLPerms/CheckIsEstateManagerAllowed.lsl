//#!Enable:Testing

default
{
    state_entry()
    {
        integer val = TRUE;
        _test_Result(FALSE);
        
        if(_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsEstateManagerAllowed is not set");
        }
        
        _test_setserverparam("OSSL.TestFunction.IsEstateManagerAllowed", "false");
        
        if(_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when IsEstateManagerAllowed = false");
        }

        _test_setserverparam("OSSL.TestFunction.IsEstateManagerAllowed", "true");
        
        if(!_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should be accessible when IsEstateManagerAllowed = true");
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}