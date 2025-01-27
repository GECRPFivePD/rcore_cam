RegisterCommand('recordings', function(Source)
    local place = 'char_' .. GetPlayerIdentifier(Source)
    local dbRecs = DbGetRecordings(place)

    TriggerClientEvent('rcore_cam:openPlayerRecordings', Source, dbRecs)
end)