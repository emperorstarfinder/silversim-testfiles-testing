//#!Enable:Testing

default
{
    state_entry()
    {
	_test_Result(FALSE);
        llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, <0.6, 1.0, 1.0>, 1., 5.0, 1.0]); // Set prim light
	_test_Result(TRUE);
	_test_Shutdown();
    }
}