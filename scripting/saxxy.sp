#include <morecolors>

#define PLUGIN_VERSION		"1.5.0"

public Plugin:myinfo = {
	name		= "[TF2] Kartify",
	author		= "Dr. McKay",
	description	= "Put players into karts!",
	version		= PLUGIN_VERSION,
	url			= "http://www.doctormckay.com"
};

public OnPluginStart()
{
	RegAdminCmd("sm_saxxy", Command_Saxxy, ADMFLAG_GENERIC, "Gives you a saxxy");
}

public Action:Command_Saxxy(client)
{
ServerCommand("sm_givew_ex #%i 423 1", GetClientUserId(client))

new String:name[MAX_NAME_LENGTH];
GetClientName(client, name, sizeof(name));
CPrintToChatAll("{collectors}[HG] {selfmade}%s got a {gold}Saxxy!", name)
}