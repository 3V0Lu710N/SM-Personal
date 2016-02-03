#include <morecolors>
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#undef REQUIRE_PLUGIN
#include <adminmenu>

new Handle:hAdminMenu = INVALID_HANDLE

new Handle:Cvar_SlapDmg = INVALID_HANDLE
new Handle:g_Target[MAXPLAYERS+1]

#define PLUGIN_VERSION "1.0.102"

// Functions
public Plugin:myinfo =
{
	name = "Uberslap (Modded by 3V0Lu710N)",
	author = "eva-dog",
	description = "Uberslap",
	version = PLUGIN_VERSION,
	url = ""
}

public OnPluginStart()
{
	CreateConVar("sm_uberslap_version", PLUGIN_VERSION, " UberSlap Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY)
	Cvar_SlapDmg = CreateConVar("sm_uberslap_dmg", "5", " Amount of damage to inflict each time a player is uberslapped", FCVAR_PLUGIN)
	RegAdminCmd("sm_uberslap", Command_UberSlap, ADMFLAG_UNBAN, "sm_uberslap <#userid|name>")
	
	LoadTranslations("common.phrases")
	
	new Handle:topmenu
	if (LibraryExists("adminmenu") && ((topmenu = GetAdminTopMenu()) != INVALID_HANDLE))
	{
		OnAdminMenuReady(topmenu)
	}
}

public Action:Command_UberSlap(client, args)
{
	decl String:target[65]
	decl String:target_name[MAX_TARGET_LENGTH]
	decl target_list[MAXPLAYERS]
	decl target_count
	decl bool:tn_is_ml
	
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_uberslap <#userid|name>");
		return Plugin_Handled
	}
	
	GetCmdArg(1, target, sizeof(target))
	
	if ((target_count = ProcessTargetString(
			target,
			client,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count)
		return Plugin_Handled
	}
		
	for (new i = 0; i < target_count; i++)
	{
		if (IsClientInGame(target_list[i]) && IsPlayerAlive(target_list[i]))
		{
			PerformUberSlap(client, target_list[i])
		}
	}
	return Plugin_Handled
}

PerformUberSlap(client, target)
{
	if (g_Target[target] == INVALID_HANDLE)
	{
		CreateUberSlap(target)
		LogAction(client, target, "\"%L\" uberslapped \"%L\"", client, target)
		ShowActivity(client, "uberslapped %N", target)
		new String:name[MAX_NAME_LENGTH];
		GetClientName(target, name, sizeof(name));
		CPrintToChatAll("{collectors}[HG] {fuchsia}%s {default}- {darkviolet}GOT {legendary}BITCH {valve}SLAPPED", name)
	}
	else
	{
		KillUberSlap(target)
		LogAction(client, target, "\"%L\" stopped uberslapping \"%L\"", client, target)
		ShowActivity(client, "stopped uberslapping %N", target) 
	}			
}

CreateUberSlap(client)
{
	g_Target[client] = CreateTimer(0.2, Timer_UberSlap, client, TIMER_REPEAT)
}

KillUberSlap(client)
{
	KillTimer(g_Target[client])
	g_Target[client] = INVALID_HANDLE
}


public Action:Timer_UberSlap(Handle:timer, any:client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		KillUberSlap(client)
		return Plugin_Handled
	}
	
	new damage = GetConVarInt(Cvar_SlapDmg)
	SlapPlayer(client, damage, true)
			
	return Plugin_Handled
}


public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "adminmenu")) 
	{
		hAdminMenu = INVALID_HANDLE;
	}
}

public OnAdminMenuReady(Handle:topmenu)
{
	if (topmenu == hAdminMenu)
	{
		return;
	}
	
	hAdminMenu = topmenu

	new TopMenuObject:player_commands = FindTopMenuCategory(hAdminMenu, ADMINMENU_PLAYERCOMMANDS)

	if (player_commands != INVALID_TOPMENUOBJECT)
	{
		AddToTopMenu(hAdminMenu,
			"sm_uberslap",
			TopMenuObject_Item,
			AdminMenu_UberSlap, 
			player_commands,
			"sm_uberslap",
			ADMFLAG_UNBAN)
	}
}

public AdminMenu_UberSlap( Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, param, String:buffer[], maxlength )
{
	if (action == TopMenuAction_DisplayOption)
	{
		Format(buffer, maxlength, "Evo's UberSlap")
	}
	else if( action == TopMenuAction_SelectOption)
	{
		DisplayPlayerMenu(param)
	}
}

DisplayPlayerMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandler_Players)
	
	decl String:title[100]
	Format(title, sizeof(title), "Choose Player:")
	SetMenuTitle(menu, title)
	SetMenuExitBackButton(menu, true)
	
	AddTargetsToMenu(menu, client, true, true)
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER)
}

public MenuHandler_Players(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu)
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack && hAdminMenu != INVALID_HANDLE)
		{
			DisplayTopMenu(hAdminMenu, param1, TopMenuPosition_LastCategory);
		}
	}
	else if (action == MenuAction_Select)
	{
		decl String:info[32]
		new userid, target
		
		GetMenuItem(menu, param2, info, sizeof(info))
		userid = StringToInt(info)

		if ((target = GetClientOfUserId(userid)) == 0)
		{
			PrintToChat(param1, "[SM] %s", "Player no longer available")
		}
		else if (!CanUserTarget(param1, target))
		{
			PrintToChat(param1, "[SM] %s", "Unable to target")
		}
		else
		{					
			PerformUberSlap(param1, target)
		}
		
		/* Re-draw the menu if they're still valid */
		if (IsClientInGame(param1) && !IsClientInKickQueue(param1))
		{
			DisplayPlayerMenu(param1);
		}
	}
}