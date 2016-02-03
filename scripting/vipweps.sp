#include <tf2_stocks>
#define SAXXY 423 //(ALL CLASSES)
#define BATOUTTAHELL 939  //(ALL CLASSES)
#define MEMORYMAKER 954 //(ALL CLASSES)
#define BLACKROSE 727 //(SPY ONLY)
#define FESTIVEKNIFE 665 //SPY ONLY)
#define SHARPDRESSER 638 //(SPY ONLY)
#define THREERUNEBLADE 452 //(SCOUT ONLY)
#define ZOMBIEARM 572 //(SCOUT ONLY)
#define THEMAUL 466//(PYRO ONLY)

#define TAG "\x05[\x03HG\x05]\x01"

public Plugin myinfo = 
{
    name = "VIP Weapons",
    author = "Icon315",
    description = "Give them VIP weapons",
    version = "1.0.0",
    url = "hellsgamers.com/user/14668-icon315/"
}

public void OnPluginStart()
{
    RegAdminCmd("sm_vipweps", hg_weapons, ADMFLAG_GENERIC, "weapons")
}

public Action hg_weapons(int client, int args)
{
    TFClassType tfClientClass = TF2_GetPlayerClass(client);
    Menu menu = CreateMenu(Weapon_Handler);
    menu.SetTitle("Choose your weapon:");
    menu.AddItem("Saxxy", "Saxxy");
    menu.AddItem("Bat Outta Hell", "Bat Outta Hell");
    menu.AddItem("Memory Maker", "Memory Maker");
    menu.AddItem("Black Rose", "Black Rose", (tfClientClass == TFClass_Spy ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED));
    menu.AddItem("Festive Knife", "Festive Knife", (tfClientClass == TFClass_Spy ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED));
    menu.AddItem("Sharp Dresser", "Sharp Dresser", (tfClientClass == TFClass_Spy ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED));
    menu.AddItem("Three Rune Blade", "Three Rune Blade", (tfClientClass == TFClass_Scout ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED));
    menu.AddItem("Zombie Arm", "Zombie Arm", (tfClientClass == TFClass_Scout ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED));
    menu.AddItem("The Maul", "The Maul", (tfClientClass == TFClass_Pyro ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED));
    menu.ExitButton = true;
    menu.Display(client, 10);    
    return Plugin_Handled;
}

public int Weapon_Handler(Menu menu, MenuAction action, int param1, int param2)
{
    char cmdGive[256];
    int client = param1;
    Format(cmdGive, sizeof(cmdGive), "sm_givew_ex #%d", GetClientUserId(client));
    switch(action)
    {
        case MenuAction_Select:
        {
            char sWeapon[128];
            menu.GetItem(param2, sWeapon, sizeof(sWeapon));
            switch(param2)
            {
                case 0:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, SAXXY);
                case 1:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, BATOUTTAHELL);
                case 2:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, MEMORYMAKER);
                case 3:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, BLACKROSE);
                case 4:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, FESTIVEKNIFE);
                case 5:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, SHARPDRESSER);
                case 6:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, THREERUNEBLADE);
                case 7:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, ZOMBIEARM);
                case 8:
                    Format(cmdGive, sizeof(cmdGive), "%s %d", cmdGive, THEMAUL);
            }
            ServerCommand("%s 1", cmdGive);
            PrintToChat(client, "%s You recieved a \x03%s", TAG, sWeapon);
        }
        case MenuAction_Cancel:
            PrintToChat(client, "%s No weapon chosen", TAG);
    }
}