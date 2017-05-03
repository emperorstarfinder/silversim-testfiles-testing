//#!Enable:Testing

integer val;
list threatlevels = ["none", "nuisance", "verylow", "low", "moderate", "high", "veryhigh", "severe"];

check_threat_level(integer activelevel, string function)
{
    _test_setserverparam("OSSL.ThreatLevel", llList2String(threatlevels, activelevel));
    integer expectedlevel;
    for(expectedlevel = 0; expectedlevel <= OSSL_THREAT_LEVEL_SEVERE; ++expectedlevel)
    {
        llSay(PUBLIC_CHANNEL, "Testing ThreatLevel perms Active=" + llList2String(threatlevels, activelevel) + " Expected=" + llList2String(threatlevels, expectedlevel));
        if(_test_ossl_perms(expectedlevel, "TestFunction"))
        {
            if(expectedlevel > activelevel)
            {
                val = FALSE;
                llSay(PUBLIC_CHANNEL, "Test(" + llList2String(threatlevels, expectedlevel) + ") failed. Should be not ok to access but it is.");
            }
        }
        else
        {
            if(expectedlevel <= activelevel)
            {
                val = FALSE;
                llSay(PUBLIC_CHANNEL, "Test(" + llList2String(threatlevels, expectedlevel) + ") failed. Should be ok to access but it is not.");
            }
        }
    }
}

default
{
    state_entry()
    {
        val = TRUE;
        _test_Result(FALSE);
        
        integer level;
        for(level = 0; level <= OSSL_THREAT_LEVEL_SEVERE; ++level)
        {
            llSay(PUBLIC_CHANNEL, "Testing OSSL.ThreatLevel = " + llList2String(threatlevels, level));
            check_threat_level(level, "TestFunction");
        }
        
        _test_Result(val);
        _test_Shutdown();
    }
}