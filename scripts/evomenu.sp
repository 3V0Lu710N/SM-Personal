#define CHOICE1 "#choice1"
#define CHOICE2 "#choice2"
#define CHOICE3 "#choice3"
 
public OnPluginStart()
{
	LoadTranslations("menu_test.phrases");
	RegConsoleCmd("menu_test1", Menu_Test1);
}
 
public MenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	switch(action)
	{
		case MenuAction_Start:
		{
			ServerCommand("sm_givew_ex %i 423 1", GetClientUserID(client))
		}
 
		case MenuAction_Display:
		{
	 		decl String:buffer[255];
			Format(buffer, sizeof(buffer), "%T", "Vote Nextmap", param1);
 
			new Handle:panel = Handle:param2;
			SetPanelTitle(panel, buffer);
			PrintToServer("Client %d was sent menu with panel %x", param1, param2);
		}
 
		case MenuAction_Select:
		{
			decl String:info[32];
			GetMenuItem(menu, param2, info, sizeof(info));
			if (StrEqual(info, CHOICE3))
			{
				PrintToServer("Client %d somehow selected %s despite it being disabled", param1, info);
			}
			else
			{
				PrintToServer("Client %d selected %s", param1, info);
			}
		}
 
		case MenuAction_Cancel:
		{
			PrintToServer("Client %d's menu was cancelled for reason %d", param1, param2);
		}
 
		case MenuAction_End:
		{
			CloseHandle(menu);
		}
 
		case MenuAction_DrawItem:
		{
			new style;
			decl String:info[32];
			GetMenuItem(menu, param2, info, sizeof(info), style);
 
			if (StrEqual(info, CHOICE3))
			{
				return ITEMDRAW_DISABLED;
			}
			else
			{
				return style;
			}
		}
 
		case MenuAction_DisplayItem:
		{
			decl String:info[32];
			GetMenuItem(menu, param2, info, sizeof(info));
 
			decl String:display[64];
 
			if (StrEqual(info, CHOICE3))
			{
				Format(display, sizeof(display), "%T", "Choice 3", param1);
				return RedrawMenuItem(display);
			}
		}
	}
 
	return 0;
}
 
public Action:Menu_Test1(client, args)
{
	new Handle:menu = CreateMenu(MenuHandler1, MENU_ACTIONS_ALL);
	SetMenuTitle(menu, "%T", "Menu Title", LANG_SERVER);
	AddMenuItem(menu, CHOICE1, "Choice 1");
	AddMenuItem(menu, CHOICE2, "Choice 2");
	AddMenuItem(menu, CHOICE3, "Choice 3");
	SetMenuExitButton(menu, false);
	DisplayMenu(menu, client, 20);
 
	return Plugin_Handled;
}