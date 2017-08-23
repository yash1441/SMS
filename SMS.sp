#pragma semicolon 1

#include <sourcemod>
#include <steamcore>

#define PLUGIN_URL "yash1441@yahoo.com"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_NAME "Steam Message Sender"
#define PLUGIN_AUTHOR "Simon"

public Plugin myinfo = 
{
	name = PLUGIN_NAME, 
	author = PLUGIN_AUTHOR, 
	description = "Sends message to all players in the friends list.", 
	version = PLUGIN_VERSION, 
	url = PLUGIN_URL
}

ConVar SMS_Enable;
bool ChatAvailable = false;
char ChatMessage[192];

public void OnPluginStart()
{
	CreateConVar("sms_version", PLUGIN_VERSION, "Steam Inviter Version", FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);
	SMS_Enable = CreateConVar("sms_enable", "1", "Enable or Disable send message feature.", 0, true, 0.0, true, 1.0);
	RegAdminCmd("sm_message", Cmd_Message, ADMFLAG_ROOT, "Usage: sm_message <message>");
}

public int OnChatConnected(int errorCode)
{
	switch(errorCode)
	{
		case 0x00:	PrintToServer("General: No error, request successful.");
		case 0x01:	PrintToServer("General: Logged out, plugin will attempt to login.");
		case 0x02:	PrintToServer("General: Connection timed out.");
		case 0x03:	PrintToServer("General: Steam servers down.");
		case 0x40:	PrintToServer("Chat Connect Error: Failed http chat connect request.");
		case 0x41:	PrintToServer("Chat Connect Error: Incorrect chat connect response.");
		case 0x42:	PrintToServer("Chat Connect Error: Chat not allowed for limited accounts. Only full Steam accounts can use chat.");
		case 0x43:	PrintToServer("Chat Disconnect Error: Failed http poll request.");
		case 0x44:	PrintToServer("Chat Disconnect Error: Message poller timed out, plugin will automatically reconnect.");
		case 0x45:	PrintToServer("Chat Send Message Error: Failed http send message request.");
		case 0x46:	PrintToServer("Chat Send Message Error: Diconnected from chat, plugin will automatically reconnect.");
		default:	PrintToServer("There was an error \x010x%02x while sending your invite :(", errorCode);
	}
	PrintToServer("Steam chat connected.");
	ChatAvailable = true;
}

public int OnChatDisconnected(int errorCode)
{
	switch(errorCode)
	{
		case 0x00:	PrintToServer("General: No error, request successful.");
		case 0x01:	PrintToServer("General: Logged out, plugin will attempt to login.");
		case 0x02:	PrintToServer("General: Connection timed out.");
		case 0x03:	PrintToServer("General: Steam servers down.");
		case 0x40:	PrintToServer("Chat Connect Error: Failed http chat connect request.");
		case 0x41:	PrintToServer("Chat Connect Error: Incorrect chat connect response.");
		case 0x42:	PrintToServer("Chat Connect Error: Chat not allowed for limited accounts. Only full Steam accounts can use chat.");
		case 0x43:	PrintToServer("Chat Disconnect Error: Failed http poll request.");
		case 0x44:	PrintToServer("Chat Disconnect Error: Message poller timed out, plugin will automatically reconnect.");
		case 0x45:	PrintToServer("Chat Send Message Error: Failed http send message request.");
		case 0x46:	PrintToServer("Chat Send Message Error: Diconnected from chat, plugin will automatically reconnect.");
		default:	PrintToServer("There was an error \x010x%02x while sending your invite :(", errorCode);
	}
	PrintToServer("Steam chat disconnected.");
}

public int OnChatMessageSent(const char[] friend, const char[] message, int errorCode, any data)
{
	switch(errorCode)
	{
		case 0x00:	PrintToServer("General: No error, request successful.");
		case 0x01:	PrintToServer("General: Logged out, plugin will attempt to login.");
		case 0x02:	PrintToServer("General: Connection timed out.");
		case 0x03:	PrintToServer("General: Steam servers down.");
		case 0x40:	PrintToServer("Chat Connect Error: Failed http chat connect request.");
		case 0x41:	PrintToServer("Chat Connect Error: Incorrect chat connect response.");
		case 0x42:	PrintToServer("Chat Connect Error: Chat not allowed for limited accounts. Only full Steam accounts can use chat.");
		case 0x43:	PrintToServer("Chat Disconnect Error: Failed http poll request.");
		case 0x44:	PrintToServer("Chat Disconnect Error: Message poller timed out, plugin will automatically reconnect.");
		case 0x45:	PrintToServer("Chat Send Message Error: Failed http send message request.");
		case 0x46:	PrintToServer("Chat Send Message Error: Diconnected from chat, plugin will automatically reconnect.");
		default:	PrintToServer("There was an error \x010x%02x while sending your invite :(", errorCode);
	}
	PrintToServer("Steam chat \"%s\" sent to %s.", message, friend);
}

public int OnChatMessageReceived(const char[] friend, const char[] message)
{
	PrintToServer("Steam chat \"%s\" received by %s.", message, friend);
}

public int OnSteamAccountLoggedIn()
{
	PrintToServer("Steam account logged in successfully.");
}

stock bool IsValidClient(int client)
{
	if (client <= 0)return false;
	if (client > MaxClients)return false;
	if (!IsClientConnected(client))return false;
	return IsClientInGame(client);
}

public int OnChatFriendStateChange(const char[] friend, const char[] name, SteamChatState state)
{
	if (state == SteamChatStateONLINE && !ChatAvailable)
	{
		SteamChatSendMessage(friend, ChatMessage);
	}
}

public Action Cmd_Message(int client, int args)
{
	if (!SMS_Enable || !IsValidClient(client)) return Plugin_Handled;
	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_message <message>");
		return Plugin_Handled;	
	}	
	char text[192], arg[64], message[192];
	GetCmdArgString(text, sizeof(text));
	int len = BreakString(text, arg, sizeof(arg));
	BreakString(text[len], message, sizeof(message));
	strcopy(ChatMessage, sizeof(ChatMessage), message);
	if (SteamChatIsConnected())
		SteamChatConnect(SteamChatModeWEB);
	return Plugin_Handled;	
}