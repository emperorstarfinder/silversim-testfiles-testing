//#!Enable:Testing

integer ensureEqual(vector expected, float rate)
{
    llSay(PUBLIC_CHANNEL, "Testing axis=" + expected + " rate="+rate);
    llTargetOmega(expected, rate, 1);
    vector actual = llGetOmega();
    expected *= rate;
    integer result = llFabs(actual.x - expected.x) < 0.001 && llFabs(actual.y - expected.y) < 0.001 && llFabs(actual.z - expected.z) < 0.001;
    if(!result)
    {
        llSay(PUBLIC_CHANNEL, "Not equal! Expected=" + expected + " Actual=" + actual);
    }
    return result;
}

default
{
    state_entry()
    {
        integer result = TRUE;
        
        result = result && ensureEqual(<1, 0, 0>, 1);
        result = result && ensureEqual(<0, 1, 0>, 1);
        result = result && ensureEqual(<0, 0, 1>, 1);
        result = result && ensureEqual(<1, 1, 1>, 1);
        result = result && ensureEqual(<0, 0, 0>, 1);
        result = result && ensureEqual(<1, 0, 0>, 2);
        result = result && ensureEqual(<0, 1, 0>, 2);
        result = result && ensureEqual(<0, 0, 1>, 2);
        result = result && ensureEqual(<1, 1, 1>, 2);
        result = result && ensureEqual(<1, 1, 1>, 0);

        result = result && ensureEqual(<-1, 0, 0>, 1);
        result = result && ensureEqual(<0, -1, 0>, 1);
        result = result && ensureEqual(<0, 0, -1>, 1);
        result = result && ensureEqual(<-1, -1, -1>, 1);
        result = result && ensureEqual(<0, 0, 0>, 1);
        result = result && ensureEqual(<-1, 0, 0>, 2);
        result = result && ensureEqual(<0, -1, 0>, 2);
        result = result && ensureEqual(<0, 0, -1>, 2);
        result = result && ensureEqual(<-1, -1, -1>, 2);
        result = result && ensureEqual(<-1, -1, -1>, 0);
        
        result = result && ensureEqual(<1, 0, 0>, -1);
        result = result && ensureEqual(<0, 1, 0>, -1);
        result = result && ensureEqual(<0, 0, 1>, -1);
        result = result && ensureEqual(<1, 1, 1>, -1);
        result = result && ensureEqual(<0, 0, 0>, -1);
        result = result && ensureEqual(<1, 0, 0>, -2);
        result = result && ensureEqual(<0, 1, 0>, -2);
        result = result && ensureEqual(<0, 0, 1>, -2);
        result = result && ensureEqual(<1, 1, 1>, -2);
        result = result && ensureEqual(<1, 1, 1>, 0);

        result = result && ensureEqual(<-1, 0, 0>, -1);
        result = result && ensureEqual(<0, -1, 0>, -1);
        result = result && ensureEqual(<0, 0, -1>, -1);
        result = result && ensureEqual(<-1, -1, -1>, -1);
        result = result && ensureEqual(<0, 0, 0>, -1);
        result = result && ensureEqual(<-1, 0, 0>, -2);
        result = result && ensureEqual(<0, -1, 0>, -2);
        result = result && ensureEqual(<0, 0, -1>, -2);
        result = result && ensureEqual(<-1, -1, -1>, -2);
        result = result && ensureEqual(<-1, -1, -1>, 0);
        
        _test_Result(result);
        _test_Shutdown();
    }
}