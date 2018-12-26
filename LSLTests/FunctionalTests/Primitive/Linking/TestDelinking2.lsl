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
key getrootkey(key id)
{
	return llList2Key(llGetObjectDetails(id, [OBJECT_ROOT]), 0);
}

/******************************************************************************/
default
{
    state_entry()
    {
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK4_ID);
		_test_GrantScriptPerm(PERMISSION_CHANGE_LINKS);
		llCreateLink(LINK4_ID, TRUE);
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
			if(llGetLinkKey(2) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
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
		llCreateLink(LINK3_ID, TRUE);
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
			if(llGetLinkKey(2) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
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
		llCreateLink(LINK2_ID, TRUE);
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
			if(llGetLinkKey(2) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(4) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 4 not matching expected linking rules");
				success = FALSE;
			}
			state link_link1;
		}
	}
}

/******************************************************************************/
state link_link1
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Linking " + (string)LINK1_ID);
		llCreateLink(LINK1_ID, TRUE);
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
			state unlink2;
		}
	}
}

/******************************************************************************/
state unlink2
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2");
		llBreakLink(2);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				success = FALSE;
			}
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(4) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 4 not matching expected linking rules");
				success = FALSE;
			}
			
			state unlink2a;
		}
	}
}


/******************************************************************************/
state unlink2a
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2a");
		llBreakLink(2);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				success = FALSE;
			}
			if(getrootkey(LINK2_ID) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link2 not correctly unlinked");
				success = FALSE;
			}
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(3) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 3 not matching expected linking rules");
				success = FALSE;
			}
			
			state unlink2b;
		}
	}
}

/******************************************************************************/
state unlink2b
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2b");
		llBreakLink(2);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				success = FALSE;
			}
			if(getrootkey(LINK2_ID) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link2 not correctly unlinked");
				success = FALSE;
			}
			if(getrootkey(LINK3_ID) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link3 not correctly unlinked");
				success = FALSE;
			}
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetLinkKey(2) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 2 not matching expected linking rules");
				success = FALSE;
			}
			
			state unlink2c;
		}
	}
}

/******************************************************************************/
state unlink2c
{
	state_entry()
	{
		llSay(PUBLIC_CHANNEL, "Unlink 2c");
		llBreakLink(2);
	}
	
	changed(integer flags)
	{
		if((flags & CHANGED_LINK))
		{
			if(getrootkey(LINK1_ID) != LINK1_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link1 not correctly unlinked");
				success = FALSE;
			}
			if(getrootkey(LINK2_ID) != LINK2_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link2 not correctly unlinked");
				success = FALSE;
			}
			if(getrootkey(LINK3_ID) != LINK3_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link3 not correctly unlinked");
				success = FALSE;
			}
			if(getrootkey(LINK4_ID) != LINK4_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link4 not correctly unlinked");
				success = FALSE;
			}
			if(llGetLinkKey(1) != ROOT_ID)
			{
				llSay(PUBLIC_CHANNEL, "Link 1 not matching expected linking rules");
				success = FALSE;
			}
			if(llGetNumberOfPrims() != 1)
			{
				llSay(PUBLIC_CHANNEL, "Number of links wrong");
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