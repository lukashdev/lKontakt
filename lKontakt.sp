#include <sourcemod>
#include <multicolors>

#define DEBUG

#pragma newdecls required
#pragma semicolon 1
#pragma tabsize 0

char kv_sSectionItem[MAXPLAYERS+1][64];

#define PLUGIN_AUTHOR "lukash"
#define PLUGIN_VERSION "2.0.0"
#define PLUGIN_NAME "lKonakt"
#define PLUGIN_DESCRIPTION "menu na kontakt"
#define PLUGIN_URL "https://steamcommunity.com/id/lukasz11772/"

#define PATH_FILE "addons/sourcemod/configs/lKontakt.cfg"

public Plugin myinfo = 
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_kontakt", Menu_Kontakt);
}

public Action Menu_Kontakt(int client, int args)
{
	Menu menu = new Menu(kontakt_Handler);
	menu.SetTitle("Wybierz osobę:");
	KeyValues kv = new KeyValues("lKontakt");
	kv.ImportFromFile(PATH_FILE);
	kv.GotoFirstSubKey();
	do
	{
		kv.GetSectionName(kv_sSectionItem[client], sizeof(kv_sSectionItem));
		menu.AddItem(kv_sSectionItem[client], kv_sSectionItem[client]);
	} while (KvGotoNextKey(kv));
	delete kv;
	menu.Display(client, 60);
}

public int kontakt_Handler(Menu menu, MenuAction action, int client, int Position)
{
	if(action == MenuAction_Select)
	{
		GetMenuItem(menu, Position, kv_sSectionItem[client], sizeof(kv_sSectionItem));
		char kv_sNick[64], kv_sRanga[64], kv_sSteam[64], kv_sForum[64], title[512];
		KeyValues kv = new KeyValues("lKontakt");
		kv.ImportFromFile(PATH_FILE);
		kv.JumpToKey(kv_sSectionItem[client]);
		kv.GetString("Nick", kv_sNick, sizeof(kv_sNick));
		kv.GetString("Ranga", kv_sRanga, sizeof(kv_sRanga));
		kv.GetString("Steam", kv_sSteam, sizeof(kv_sSteam));
		kv.GetString("Forum", kv_sForum, sizeof(kv_sForum));
		delete kv;
		Format(title, sizeof(title), "Nick : %s", kv_sNick);
		Format(title, sizeof(title), "%s\nRanga : %s", title, kv_sRanga);
		Format(title, sizeof(title), "%s\nSteam : %s", title, kv_sSteam);
		Format(title, sizeof(title), "%s\nForum : %s", title, kv_sForum);
		Menu menu1 = new Menu(Menu_Handler);
		menu1.SetTitle(title);
		menu1.AddItem("console", "Wydrukuj wyniki w konsoli");
		menu1.AddItem("chat", "Wydrukuj wyniki na czacie"); 
		menu1.Display(client, 60);
	}
	else if(action == MenuAction_End)
		delete menu;
}
 


public int Menu_Handler(Menu menu, MenuAction action, int client, int Position)
{
	if(action == MenuAction_Select)
	{
		char Item[64];
		GetMenuItem(menu, Position, Item, sizeof(Item));
		if(StrEqual(Item, "console"))
			SendKontakt(client, 1);
		if(StrEqual(Item, "chat"))
			SendKontakt(client, 2);
	}
	else if(action == MenuAction_End)
		delete menu;
}

void SendKontakt(int client, int position)
{
	char kv_sNick[64], kv_sRanga[64], kv_sSteam[64], kv_sForum[64];
	KeyValues kv = new KeyValues("lKontakt");
	kv.ImportFromFile(PATH_FILE);
	kv.JumpToKey(kv_sSectionItem[client]);
	kv.GetString("Nick", kv_sNick, sizeof(kv_sNick));
	kv.GetString("Ranga", kv_sRanga, sizeof(kv_sRanga));
	kv.GetString("Steam", kv_sSteam, sizeof(kv_sSteam));
	kv.GetString("Forum", kv_sForum, sizeof(kv_sForum));
	delete kv;
	if(position == 1)
	{
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}Wyniki znajdują się w konsoli!");
		PrintToConsole(client, "==================================");
		PrintToConsole(client, "[Kontakt] Nick: %s", kv_sNick);	
		PrintToConsole(client, "[Kontakt] Ranga: %s", kv_sRanga);
		PrintToConsole(client, "[Kontakt] Steam: %s", kv_sSteam);
		PrintToConsole(client, "[Kontakt] Forum: %s", kv_sForum);
		PrintToConsole(client, "==================================");		
	}
	else
	{
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}==================================");
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}Nick: %s", kv_sNick);
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}Ranga: %s", kv_sRanga);
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}Steam: %s", kv_sSteam);
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}Forum: %s", kv_sForum);
		CPrintToChat(client, "{darkred}[ {lightred}★{darkred} Kontakt {lightred}★ {darkred}]{default} {orange}==================================");		
	} 
}