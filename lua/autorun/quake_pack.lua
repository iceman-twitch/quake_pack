
-- Remake Mani Admin Plugin Quake Addon
QUAKE_PACK = QUAKE_PACK or {}
QUAKE_PACK.KillStreaks = {
    [2] = "DOUBLE KILL",
    [3] = "TRIPLE KILL",
    [5] = "MULTI KILL",
    [6] = "RAMPAGE",
    [7] = "KILLING SPREE",
    [8] = "DOMINATING",
    [9] = "IMPRESSIVE",
    [10] = "UNSTOPPABLE",
    [11] = "OUTSTANDING",
    [12] = "MEGA KILL",
    [13] = "ULTRA KILL",
    [14] = "EAGLE EYE",
    [15] = "OWNAGE",
    [16] = "COMBO KING",
    [17] = "MANIAC",
    [18] = "LUDICROUS KILL",
    [19] = "BULLSEYE",
    [20] = "EXCELLENT",
    [21] = "PANCAKE",
    [22] = "HEAD HUNTER",
    [23] = "UNREAL",
    [24] = "ASSASSIN",
    [25] = "WICKED SICK",
    [26] = "MASSACRE",
    [27] = "KILLING MACHINE",
    [28] = "MONSTER KILL",
    [29] = "HOLY SHIT",
    [30] = "G O D L I K E",
}
QUAKE_PACK.KillStreaksSound = {
    [2] = "quake/doublekill.mp3",
    [3] = "quake/triplekill.mp3",
    [5] = "quake/multikill.mp3",
    [6] = "quake/rampage.mp3",
    [7] = "quake/killingspree.mp3",
    [8] = "quake/dominating.mp3",
    [9] = "quake/impressive.mp3",
    [10] = "quake/unstoppable.mp3",
    [11] = "quake/outstanding.mp3",
    [12] = "quake/megakill.mp3",
    [13] = "quake/ultrakill.mp3",
    [14] = "quake/eagleeye.mp3",
    [15] = "quake/ownage.mp3",
    [16] = "quake/comboking.mp3",
    [17] = "quake/maniac.mp3",
    [18] = "quake/ludicrouskill.mp3",
    [19] = "quake/bullseye.mp3",
    [20] = "quake/excellent.mp3",
    [21] = "quake/pancake.mp3",
    [22] = "quake/headhunter.mp3",
    [23] = "quake/unreal.mp3",
    [24] = "quake/assassin.mp3",
    [25] = "quake/wickedsick.mp3",
    [26] = "quake/massacre.mp3",
    [27] = "quake/killingmachine.mp3",
    [28] = "quake/monsterkill.mp3",
    [29] = "quake/holyshit.mp3",
    [30] = "quake/godlike.mp3",







    
}

QUAKE_PACK.Firstblood = QUAKE_PACK.Firstblood or false

if SERVER then
    util.AddNetworkString( "QUAKE_PACK" )

    function QUAKE_PACK:Broadcast( text )
        for k, v in pairs(player.GetAll()) do
            if not v:IsBot() then
                net.Start( "QUAKE_PACK" )
                net.WriteString( text )
                net.Send(v)
            end
        end
    end

    function QUAKE_PACK:PlayerDeath( victim, inflictor, attacker )
        local victim = victim
        local attacker = attacker
        victim:SetNW2Int("Quake.KillStreak", 0)
        local killstreak = attacker:GetNW2Int("Quake.KillStreak")
        killstreak = killstreak + 1
        attacker:SetNW2Int("Quake.KillStreak", killstreak)
        if IsValid(victim) and attacker:IsPlayer() then
            -- Firstblood
            if QUAKE_PACK.Firstblood == false and victim ~= attacker then
                QUAKE_PACK:Broadcast( "quake/firstblood.mp3" )
                local message = attacker:Nick() .. " is on Firstblood"
                PrintMessage(HUD_PRINTCENTER, message)
                QUAKE_PACK.Firstblood = true
                return
            end
            -- Humilation
            if victim == attacker then
                QUAKE_PACK:Broadcast( "quake/humiliation.mp3" )
                local message = attacker:Nick() .. " is on Humilation"
                PrintMessage(HUD_PRINTCENTER, message)                
                victim:SetNW2Int("Quake.KillStreak", 0)
                return
            end
            -- Teamkiller
            if GAMEMODE.TeamBased and victim:Team() == attacker:Team() then
                QUAKE_PACK:Broadcast( "quake/teamkiller.mp3" )
                local message = attacker:Nick() .. " is on Teamkiller"
                PrintMessage(HUD_PRINTCENTER, message)
                return
            end
            -- Headshot
            if victim:LastHitGroup() == 1 then
                QUAKE_PACK:Broadcast( "quake/headshot.mp3" )
                local message = attacker:Nick() .. " is on Headshot"
                PrintMessage(HUD_PRINTCENTER, message)
                return
            end
            -- KillStreaks
            if QUAKE_PACK.KillStreaksSound[killstreak] ~= nil then
                QUAKE_PACK:Broadcast( QUAKE_PACK.KillStreaksSound[killstreak] )
                local message = attacker:Nick() .. " is on " .. QUAKE_PACK.KillStreaks[killstreak]
                PrintMessage(HUD_PRINTCENTER, message  )
                return
            end

        end
    end

    hook.Add( "PlayerDeath", "QUAKE_PACK.PlayerDeath", function( victim, inflictor, attacker )
        QUAKE_PACK:PlayerDeath( victim, inflictor, attacker )
    end )
else
    net.Receive( "QUAKE_PACK", function( len, ply )
		local message = net.ReadString()
        RunConsoleCommand( "play", message )
	end )
end