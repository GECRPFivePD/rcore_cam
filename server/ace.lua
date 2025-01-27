if Config.UseAcePermission then
    local CamAllowList = {}

    function UpdateAceStatus(serverId)
        local isAllowed = not not IsPlayerAceAllowed(serverId, Config.UseAcePermission)

        if CamAllowList[serverId] ~= isAllowed then
            CamAllowList[serverId] = isAllowed
            TriggerClientEvent('rcore_cam:setAceAllowed', serverId, isAllowed)
        end
    end

    AddEventHandler('playerDropped', function()
        local Source = source

        if CamAllowList[Source] then
            CamAllowList[Source] = nil
        end
    end)

    AddEventHandler('playerJoining', function()
        local Source = source
        UpdateAceStatus(Source)
        Wait(20000)
        UpdateAceStatus(Source)
    end)

    Citizen.CreateThread(function()
        Wait(1000)

        while true do
            for _, player in ipairs(GetPlayers()) do
                local serverId = tonumber(player)

                UpdateAceStatus(serverId)
                
                Wait(1000)
            end

            Wait(60000)
        end
    end)
end