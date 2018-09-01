//#!Enable:Testing

default
{
    state_entry()
    {
        integer val = TRUE;
        _test_Result(FALSE);
        
        if(_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when AllowedCreators is not set");
        }
        
        _test_setserverparam("OSSL.TestFunction.AllowedCreators", "6c7abd0c-2b72-403f-a95c-a98c659680ca;http://localhost:8002/;Script Test");
        
        if(_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should not be accessible when AllowedCreators contains owner");
        }

        _test_setserverparam("OSSL.TestFunction.AllowedCreators", "6c7abd0c-2b72-403f-0000-a98c659680ca;http://localhost:8002/;Script Not");
        
        if(!_test_ossl_perms("TestFunction"))
        {
            llSay(PUBLIC_CHANNEL, "TestFunction should be accessible when AllowedCreators does not contain cowner");
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}