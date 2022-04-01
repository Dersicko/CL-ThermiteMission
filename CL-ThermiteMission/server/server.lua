local QBCore = exports['qb-core']:GetCoreObject()

local LastRob = 0

local isActive = false

discord = {
    ['webhook'] = 'https://discord.com/api/webhooks/958817316626391082/mWkDVZi3XqDWtNDZz2BvS3g0WUJVyGqxMra2QXMFazih3FobGT4gmJBGbpeFSweBBBrB',
    ['name'] = 'CL-ThermiteMission',
    ['image'] = "https://cdn.discordapp.com/attachments/926465631770005514/958817128788660274/CloudDevv.png"
}

function DiscordLog(name, message, color)
    local embed = {
        {
            ["color"] = 000, 
            ["title"] = "CloudDevelopment Thermite Mission",
            ["description"] = message,
            ["url"] = "https://discord.gg/e4AYS3VE",
            ["footer"] = {
            ["text"] = "By CloudDevelopment",
            ["icon_url"] = "https://cdn.discordapp.com/attachments/926465631770005514/958817128788660274/CloudDevv.png"
        },
            ["thumbnail"] = {
                ["url"] = "https://cdn.discordapp.com/attachments/926465631770005514/958817128788660274/CloudDevv.png",
            },
    }
}
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = embed, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('CL-ThermiteMission:server:policeAlert')
AddEventHandler('CL-ThermiteMission:server:policeAlert', function(coords)
    local src = source
    local Players = QBCore.Functions.GetPlayers()

    for i = 1, #Players do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.PlayerData.job.name == Config.PoliceJob then
            TriggerClientEvent('CL-ThermiteMission:client:policeAlert', Players[i], coords)
        end
    end
end)

QBCore.Functions.CreateCallback('CL-ThermiteMission:CheckTime', function(source, cb)
    local src = source
    
    if (os.time() - LastRob) < Config.NextRob and LastRob ~= 0 then
        local seconds = Config.NextRob - (os.time() - LastRob)
        TriggerClientEvent('QBCore:Notify', src, 'You Have To Wait' .. ' ' .. math.floor(seconds / 60) .. ' ' .. 'Minutes Before Starting The Heist Again !', 'error')
        cb(false)
    else
        LastRob = os.time()
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('CL-ThermiteMission:CheckForPolice', function(source, cb)
    local src = source
    local Players = QBCore.Functions.GetPlayers()
    local PoliceCount = 0
    local steamname = GetPlayerName(src)

    for i = 1, #Players do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.PlayerData.job.name == Config.PoliceJob then
            PoliceCount = PoliceCount + 1
        end
    end

    if PoliceCount >= Config.RequiredPolice then
        DiscordLog(discord['webhook'], 'Thermite Mission Started By: **'..steamname..'** ID: **' ..src, 14177041)
        cb(true)
    else
        cb(false)
        TriggerClientEvent("QBCore:Notify", src, "Not Enough Police !", "error")
    end
end)

RegisterServerEvent("CL-ThermiteMission:Server:GuardsSync", function() 
    TriggerClientEvent("CL-ThermiteMission:GuardsSync", -1)
end) 

RegisterNetEvent('CL-ThermiteMission:server:SetActive', function(status)
    if status ~= nil then
        isActive = status
        TriggerClientEvent('CL-ThermiteMission:client:SetActive', -1, isActive)
    else
        TriggerClientEvent('CL-ThermiteMission:client:SetActive', -1, isActive)
    end
end)