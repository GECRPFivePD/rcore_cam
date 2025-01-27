local IsAdminTool = false

RegisterCommand('camadmintool', function(source, args)
    if source == 0 then
        source = args[1]
    end

    IsAdminTool = true
    TriggerClientEvent('rcore_cam:openAdminTool', source)
end, true)

RegisterNetEvent('rcore_cam:saveAdminTool', function(data)
    if IsAdminTool then
        SaveResourceFile(GetCurrentResourceName(), 'cameras.bak.json', LoadResourceFile(GetCurrentResourceName(), 'cameras.json'), -1)
        SaveResourceFile(GetCurrentResourceName(), 'cameras.json', json.encode(data), -1)
        IsAdminTool = false
    end
end)
