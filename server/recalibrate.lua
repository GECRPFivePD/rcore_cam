local IsRecalibrating = false
local CalibratedCams = {}
local LastCalibratedId = -1

RegisterCommand('camrecalibrate', function(source, args)
    IsRecalibrating = true
    
    if source == 0 then
        source = args[1]
    end

    TriggerClientEvent('rcore_cam:recalibrate', source, LastCalibratedId)
end, true)

RegisterNetEvent('rcore_cam:recalibrate', function(data, groupId)
    table.insert(CalibratedCams, data)
    LastCalibratedId = groupId
end)

RegisterNetEvent('rcore_cam:recalibrateCleanup', function()
    if IsRecalibrating then
        SaveResourceFile(GetCurrentResourceName(), 'cameras.json', json.encode(CalibratedCams), -1)
        IsRecalibrating = false
    end
end)

RegisterCommand('camdeletegroup', function(source, args)
    local groupId = args[1]

    if groupId then
        groupId = tonumber(groupId)
        local allCamerasString = LoadResourceFile(GetCurrentResourceName(), 'cameras.json')
        local allCams = json.decode(allCamerasString)

        table.remove(allCams, groupId)
        table.remove(AllCameras, groupId)

        TriggerClientEvent('rcore_cam:deleteCamGroup', -1, groupId)
        SaveResourceFile(GetCurrentResourceName(), 'cameras.json', json.encode(allCams), -1)
    end
end, true)