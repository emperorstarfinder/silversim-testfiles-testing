float curscale = 0.0;//the current scale ratio of this breed
float MIN_DIMENSION=0.01; // the minimum scale of a prim allowed, in any dimension
float MAX_DIMENSION=10.0; // the maximum scale of a prim allowed, in any dimension
list link_positions;
list link_scales;
float min_original_scale=10.0; // minimum x/y/z component of the scales in the linkset
float max_original_scale=0.0; // minimum x/y/z component of the scales in the linkset
float min_rescale_factor;
float max_rescale_factor;
 
scanLinkset()
{
   vector link_pos;
   vector link_scale;
   integer total_links=llGetNumberOfPrims();
   integer link;
   link_positions=[];
   link_scales=[];
 
   for(link=1; link<=total_links; link++)
   {
       link_pos=llList2Vector(llGetLinkPrimitiveParams(link,[PRIM_POSITION]),0);
       link_scale=llList2Vector(llGetLinkPrimitiveParams(link,[PRIM_SIZE]),0);
 
       // determine the minimum and maximum prim scales in the linkset, 
       //   so that rescaling doesn't fail due to prim scale limitations
       //   NOTE: the full linkability rules are _not_ checked by this script:
       //   http://wiki.secondlife.com/wiki/Linkability_Rules 
       if(link_scale.x<min_original_scale) min_original_scale=link_scale.x;
       else if(link_scale.x>max_original_scale) max_original_scale=link_scale.x;
       if(link_scale.y<min_original_scale) min_original_scale=link_scale.y;
       else if(link_scale.y>max_original_scale) max_original_scale=link_scale.y;
       if(link_scale.z<min_original_scale) min_original_scale=link_scale.z;
       else if(link_scale.z>max_original_scale) max_original_scale=link_scale.z;
 
       link_scales+=[link_scale];
       link_positions+=[(link_pos-llGetRootPosition())/llGetRootRotation()];
 
   }
 
   max_rescale_factor=MAX_DIMENSION/max_original_scale;
   min_rescale_factor=MIN_DIMENSION/min_original_scale;
}
 
rescaleLinkset(float scale)
{
   integer link;
   vector pos_to_set;
   vector scale_to_set;
   integer total_links=llGetListLength(link_positions);
 
   for(link=1; link<=total_links; link++)
   {
       scale_to_set=llList2Vector(link_scales,link-1)*scale;
       pos_to_set=llList2Vector(link_positions,link-1)*scale;
 
       // don't move the root prim
       if(link==1) llSetLinkPrimitiveParamsFast(link,[PRIM_SIZE,scale_to_set]);
       else
       {
           llSetLinkPrimitiveParamsFast(link,[PRIM_POSITION,pos_to_set,PRIM_SIZE,scale_to_set]);
       }
   }
}
integer age;
default
{
    state_entry()
    {
        if(llGetObjectDesc() == "Reset")
        {
            if(llGetLinkNumber()==0)
            {
            }else
            {
                scanLinkset();
            }
        }
    }
    link_message(integer s,integer r,string str,key id)
    {
        if(str == "scan_link")
        {
            if(llGetLinkNumber()==0)
            {
            }else
            {
                scanLinkset();
            }
        }else if(str == "age")
        {
            age = r;
            if(age == 0)curscale = 0.3;
            if(age == 1)curscale = 0.4;
            if(age == 2)curscale = 0.5;
            if(age == 3)curscale = 0.6;
            if(age == 4)curscale = 0.7;
            if(age == 5)curscale = 0.8;
            if(age == 6)curscale = 0.9;
            if(age == 7)curscale = 1.0;
            rescaleLinkset(curscale);
        }else if(str == "update_mode")
        {
            rescaleLinkset(1.0);
            llResetScript();
        }
    }
}