#include <morecolors>
#define PLUGIN_VERSION		"1.0"

public Plugin:myinfo = {
	name		= "Saxxy Awards",
	author		= "3V0Lu710N",
	description	= "Win a Saxxy Award",
	version		= PLUGIN_VERSION,
	url			= "http://hellsgamers.com/user/5094-3v0lu710n/"
};

public OnPluginStart()
{
	RegAdminCmd("sm_saxxy", Command_Saxxy, ADMFLAG_GENERIC, "Gives you a saxxy");
}

public Action:Command_Saxxy(client, args)
{
	if (args < 1)
	{
		GetClientUserId(client);
		ServerCommand("sm_givew %i 423 1", client)
		
		new String:name[32];
		GetClientName(client, name, sizeof(name));
		
		CPrintToChatAll("{gold}[SA] {orangered}%s Received a Saxxy Award!", name)
		
		// PrintToChat(client, "[SM] Usage: sm_saxxy <name>")
		return Plugin_Handled;
	}

	new String:Arg1[32];
	GetCmdArg(1, Arg1, sizeof(Arg1));
	
	
	int target = FindTarget(client, Arg1);
	if (target == -1)
	{
		return Plugin_Handled;
	}
	
	new String:sender[32];
	GetClientName(client, sender, sizeof(sender));
	new String:receiver[32]
	GetClientName(target, receiver, sizeof(receiver));
	ServerCommand("sm_givew %s 423 1", receiver);
	CPrintToChatAll("{gold}[SA] {orangered}%s Received a Saxxy Award from %s!", receiver, sender);
	
	return Plugin_Handled;
}