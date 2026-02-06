#include <a_samp>
#include <foreach>

#define MAX_SPEED 25.0
#define MAX_TP_DIST 40.0
#define MAX_HP 1500
#define MAX_ARMOR 1500
#define MAX_AMMO 9999
#define MAX_FLY_HEIGHT 25.0
#define DELAY_KICK 300

new Float:posLama[MAX_PLAYERS][3];
new tickTerakhir[MAX_PLAYERS];
new jumlahPeringatan[MAX_PLAYERS];
new Float:groundLevel[MAX_PLAYERS];
new bool:pendingKick[MAX_PLAYERS];

forward periksaAntiCheat(playerid);
public periksaAntiCheat(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!IsPlayerSpawned(playerid)) return 1;
    if(pendingKick[playerid]) return 1;
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    new Float:jarak = floatsqroot((x - posLama[playerid][0]) * (x - posLama[playerid][0]) + (y - posLama[playerid][1]) * (y - posLama[playerid][1]) + (z - posLama[playerid][2]) * (z - posLama[playerid][2]));
    
    new selisihTick = GetTickCount() - tickTerakhir[playerid];
    if(selisihTick < 1) selisihTick = 1;
    
    new Float:kecepatan = (jarak / selisihTick) * 1000.0;
    
    posLama[playerid][0] = x;
    posLama[playerid][1] = y;
    posLama[playerid][2] = z;
    tickTerakhir[playerid] = GetTickCount();
    
    if(!IsPlayerInAnyVehicle(playerid))
    {
        if(kecepatan > MAX_SPEED && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
        {
            jumlahPeringatan[playerid]++;
            if(jumlahPeringatan[playerid] >= 3)
            {
                new nama[MAX_PLAYER_NAME + 1];
                GetPlayerName(playerid, nama, sizeof(nama));
                new str[128];
                format(str, sizeof(str), "Kicked: speedhack (%.1f m/s) - %s", kecepatan, nama);
                SendClientMessageToAll(0xFF0000FF, str);
                SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena speedhack!");
                pendingKick[playerid] = true;
                SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                return 1;
            }
        }
        else
        {
            jumlahPeringatan[playerid] = 0;
        }
    }
    
    if(jarak > MAX_TP_DIST && !IsPlayerInAnyVehicle(playerid))
    {
        new state = GetPlayerState(playerid);
        if(state != PLAYER_STATE_DRIVER && state != PLAYER_STATE_PASSENGER && !IsPlayerAdmin(playerid))
        {
            new nama[MAX_PLAYER_NAME + 1];
            GetPlayerName(playerid, nama, sizeof(nama));
            new str[128];
            format(str, sizeof(str), "Kicked: teleport hack (%.1fm) - %s", jarak, nama);
            SendClientMessageToAll(0xFF0000FF, str);
            SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena teleport hack!");
            pendingKick[playerid] = true;
            SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
            return 1;
        }
    }
    
    if(z > groundLevel[playerid] + MAX_FLY_HEIGHT && !IsPlayerInAnyVehicle(playerid))
    {
        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_PARACHUTE)
        {
            new interior = GetPlayerInterior(playerid);
            new virtualWorld = GetPlayerVirtualWorld(playerid);
            
            if(interior == 0 && virtualWorld == 0 && z > 50.0)
            {
                new nama[MAX_PLAYER_NAME + 1];
                GetPlayerName(playerid, nama, sizeof(nama));
                new str[128];
                format(str, sizeof(str), "Kicked: fly hack (z=%.1f) - %s", z, nama);
                SendClientMessageToAll(0xFF0000FF, str);
                SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena fly hack!");
                pendingKick[playerid] = true;
                SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                return 1;
            }
        }
    }
    
    if(z < -50.0)
    {
        new nama[MAX_PLAYER_NAME + 1];
        GetPlayerName(playerid, nama, sizeof(nama));
        new str[128];
        format(str, sizeof(str), "Kicked: underground hack (z=%.1f) - %s", z, nama);
        SendClientMessageToAll(0xFF0000FF, str);
        SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena underground hack!");
        pendingKick[playerid] = true;
        SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
        return 1;
    }
    
    new Float:hp;
    GetPlayerHealth(playerid, hp);
    if(hp > MAX_HP)
    {
        new nama[MAX_PLAYER_NAME + 1];
        GetPlayerName(playerid, nama, sizeof(nama));
        new str[128];
        format(str, sizeof(str), "Kicked: health hack (%.0f) - %s", hp, nama);
        SendClientMessageToAll(0xFF0000FF, str);
        SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena health hack!");
        pendingKick[playerid] = true;
        SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
        return 1;
    }
    
    new Float:armor;
    GetPlayerArmour(playerid, armor);
    if(armor > MAX_ARMOR)
    {
        new nama[MAX_PLAYER_NAME + 1];
        GetPlayerName(playerid, nama, sizeof(nama));
        new str[128];
        format(str, sizeof(str), "Kicked: armor hack (%.0f) - %s", armor, nama);
        SendClientMessageToAll(0xFF0000FF, str);
        SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena armor hack!");
        pendingKick[playerid] = true;
        SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
        return 1;
    }
    
    new senjata, peluru;
    for(new i = 0; i < 13; i++)
    {
        GetPlayerWeaponData(playerid, i, senjata, peluru);
        if(senjata > 0)
        {
            if(senjata < 1 || senjata > 46)
            {
                new nama[MAX_PLAYER_NAME + 1];
                GetPlayerName(playerid, nama, sizeof(nama));
                new str[128];
                format(str, sizeof(str), "Kicked: weapon hack (invalid ID %d) - %s", senjata, nama);
                SendClientMessageToAll(0xFF0000FF, str);
                SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena weapon hack!");
                pendingKick[playerid] = true;
                SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                return 1;
            }
            
            if(peluru > MAX_AMMO)
            {
                new nama[MAX_PLAYER_NAME + 1];
                GetPlayerName(playerid, nama, sizeof(nama));
                new str[128];
                format(str, sizeof(str), "Kicked: weapon hack (ammo %d) - %s", peluru, nama);
                SendClientMessageToAll(0xFF0000FF, str);
                SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena ammo hack!");
                pendingKick[playerid] = true;
                SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                return 1;
            }
            
            if(senjata == 22 || senjata == 23 || senjata == 24)
            {
                if(peluru > 150)
                {
                    new nama[MAX_PLAYER_NAME + 1];
                    GetPlayerName(playerid, nama, sizeof(nama));
                    new str[128];
                    format(str, sizeof(str), "Kicked: weapon hack (pistol ammo %d) - %s", peluru, nama);
                    SendClientMessageToAll(0xFF0000FF, str);
                    SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena pistol ammo hack!");
                    pendingKick[playerid] = true;
                    SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                    return 1;
                }
            }
            
            if(senjata == 25 || senjata == 26 || senjata == 27 || senjata == 28 || senjata == 32)
            {
                if(peluru > 300)
                {
                    new nama[MAX_PLAYER_NAME + 1];
                    GetPlayerName(playerid, nama, sizeof(nama));
                    new str[128];
                    format(str, sizeof(str), "Kicked: weapon hack (SMG ammo %d) - %s", peluru, nama);
                    SendClientMessageToAll(0xFF0000FF, str);
                    SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena SMG ammo hack!");
                    pendingKick[playerid] = true;
                    SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                    return 1;
                }
            }
            
            if(senjata == 29 || senjata == 30 || senjata == 31)
            {
                if(peluru > 150)
                {
                    new nama[MAX_PLAYER_NAME + 1];
                    GetPlayerName(playerid, nama, sizeof(nama));
                    new str[128];
                    format(str, sizeof(str), "Kicked: weapon hack (shotgun ammo %d) - %s", peluru, nama);
                    SendClientMessageToAll(0xFF0000FF, str);
                    SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena shotgun ammo hack!");
                    pendingKick[playerid] = true;
                    SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                    return 1;
                }
            }
            
            if(senjata == 33 || senjata == 34)
            {
                if(peluru > 200)
                {
                    new nama[MAX_PLAYER_NAME + 1];
                    GetPlayerName(playerid, nama, sizeof(nama));
                    new str[128];
                    format(str, sizeof(str), "Kicked: weapon hack (AK ammo %d) - %s", peluru, nama);
                    SendClientMessageToAll(0xFF0000FF, str);
                    SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena rifle ammo hack!");
                    pendingKick[playerid] = true;
                    SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                    return 1;
                }
            }
            
            if(senjata == 35 || senjata == 36)
            {
                if(peluru > 150)
                {
                    new nama[MAX_PLAYER_NAME + 1];
                    GetPlayerName(playerid, nama, sizeof(nama));
                    new str[128];
                    format(str, sizeof(str), "Kicked: weapon hack (sniper ammo %d) - %s", peluru, nama);
                    SendClientMessageToAll(0xFF0000FF, str);
                    SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena sniper ammo hack!");
                    pendingKick[playerid] = true;
                    SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                    return 1;
                }
            }
            
            if(senjata == 38)
            {
                if(peluru > 50)
                {
                    new nama[MAX_PLAYER_NAME + 1];
                    GetPlayerName(playerid, nama, sizeof(nama));
                    new str[128];
                    format(str, sizeof(str), "Kicked: weapon hack (minigun ammo %d) - %s", peluru, nama);
                    SendClientMessageToAll(0xFF0000FF, str);
                    SendClientMessage(playerid, 0xFF0000FF, "Kamu di-kick karena minigun ammo hack!");
                    pendingKick[playerid] = true;
                    SetTimerEx("delayKick", DELAY_KICK, false, "i", playerid);
                    return 1;
                }
            }
        }
    }
    
    return 1;
}

forward delayKick(playerid);
public delayKick(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        Kick(playerid);
    }
    pendingKick[playerid] = false;
    return 1;
}

public OnPlayerSpawn(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    posLama[playerid][0] = x;
    posLama[playerid][1] = y;
    posLama[playerid][2] = z;
    groundLevel[playerid] = z;
    tickTerakhir[playerid] = GetTickCount();
    jumlahPeringatan[playerid] = 0;
    pendingKick[playerid] = false;
    SetTimerEx("periksaAntiCheat", 800, true, "i", playerid);
    return 1;
}

public OnPlayerConnect(playerid)
{
    jumlahPeringatan[playerid] = 0;
    pendingKick[playerid] = false;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    pendingKick[playerid] = false;
    return 1;
}

public OnGameModeInit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        jumlahPeringatan[i] = 0;
        pendingKick[i] = false;
    }
    return 1;
}
