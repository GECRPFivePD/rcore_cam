OGIdents = GetPlayerIdentifier

CreateThread(function()
    if Config.Framework == 3 then

        function GetPlayerIdentifier(serverId)
            local ids = parsePlayerIdentifiers(
                {},
                CustomGetPlayerIdentifiers(serverId)
            )

            return ids.license
        end

        function SendNotification(serverId, text)
            TriggerClientEvent('rcore_cam:showNotification', serverId, text)
        end

        function parsePlayerIdentifiers(ids, identifiers)
            for k,v in ipairs(identifiers)do
                if string.sub(v, 1, string.len("steam:")) == "steam:" then
                    ids.steam = v
                elseif string.sub(v, 1, string.len("license:")) == "license:" then
                    ids.license = v
                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                    ids.discord = v
                elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                    ids.ip = v
                elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
                    ids.fivem = v
                end
            end
            
            return ids
        end


        function CustomGetPlayerIdentifiers(player)
            if player then
                local numIds = GetNumPlayerIdentifiers(player)
                local t = {}
                
                for i = 0, numIds - 1 do
                    table.insert(t, OGIdents(player, i))
                end
                
                return t
            else
                error("COULD NOT GET PLAYER IDENTIFIERS, NO PLAYER PROVIDED")
            end
        end
    end
end)