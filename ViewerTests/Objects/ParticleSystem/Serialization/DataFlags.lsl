//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

list partdataflags = [
    PSYS_PART_BOUNCE_MASK, PSYS_PART_EMISSIVE_MASK, PSYS_PART_FOLLOW_SRC_MASK, PSYS_PART_FOLLOW_VELOCITY_MASK, PSYS_PART_INTERP_COLOR_MASK,
    PSYS_PART_INTERP_SCALE_MASK, PSYS_PART_RIBBON_MASK, PSYS_PART_TARGET_LINEAR_MASK, PSYS_PART_TARGET_POS_MASK, PSYS_PART_WIND_MASK];
    
default
{
	state_entry()
	{
        particlesystemdata ps;
        integer result = TRUE;
        integer successcnt = 0;
        integer failcnt = 0;
        _test_Result(FALSE);
        
        foreach(partdataflag in partdataflags)
        {
            llSay(PUBLIC_CHANNEL, "Testing " + partdataflag);
            ps.PartDataFlags = partdataflag;

            particlesystemdata cmp;
            cmp.PSBlock = ps.PSBlock;
            
            if(cmp.PartDataFlags != ps.PartDataFlags)
            {
                llSay(PUBLIC_CHANNEL, "PS: exp=" + ps.PartDataFlags + " cur=" + cmp.PartDataFlags);
                result = FALSE;
                ++failcnt;
            }
            else
            {
                ++successcnt;
            }
        }
        
        llSay(PUBLIC_CHANNEL, "Success Count: " + successcnt);
        llSay(PUBLIC_CHANNEL, "Fail Count: " + failcnt);
        _test_Result(result);
        
		_test_Shutdown();
	}
}
