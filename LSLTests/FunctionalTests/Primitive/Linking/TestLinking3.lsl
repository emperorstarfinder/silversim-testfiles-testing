//#!Mode:ASSL
//#!Enable:Testing
//#!Enable:PermGranter
//#!Enable:Const

integer success = TRUE;

const key ROOT_ID = "11223344-1122-1122-1122-000000000000";
const key LINK1_ID = "11223344-1122-1122-1122-000000000001";
const key LINK2_ID = "11223344-1122-1122-1122-000000000002";
const key LINK3_ID = "11223344-1122-1122-1122-000000000003";
const key LINK4_ID = "11223344-1122-1122-1122-000000000004";

/******************************************************************************/
default
{
    state_entry()
    {
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK1_ID);
		_test_GrantScriptPerm(PERMISSION_CHANGE_LINKS);
		asCreateLink(LINK1_ID, TRUE);
    }
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK1_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			state link_link2;
		}
	}
}

/******************************************************************************/
state link_link2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK2_ID);
		asCreateLink(LINK2_ID, TRUE);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK2_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				success = FALSE;
			}
			state link_link3;
		}
	}
}

/******************************************************************************/
state link_link3
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK3_ID);
		asCreateLink(LINK3_ID, TRUE);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK3_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(4) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 4 not matching expected linking rules");
				success = FALSE;
			}
			state link_link4;
		}
	}
}

/******************************************************************************/
state link_link4
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK4_ID);
		asCreateLink(LINK4_ID, TRUE);
	}
	
	changed(integer flags)
	{
		if(flags & CHANGED_LINK)
		{
			llSay(PUBLIC_CHANNEL, "Linked " + (string)LINK4_ID);
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(4) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 4 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(5) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 5 not matching expected linking rules");
				success = FALSE;
			}
			state finished;
		}
	}
}

/******************************************************************************/
state finished
{
	state_entry()
	{
		_test_Result(success);
		_test_Shutdown();
	}
}