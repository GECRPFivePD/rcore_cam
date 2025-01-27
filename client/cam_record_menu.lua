local closestCamDist = nil
local closestCamGroupId = nil
local closestCamCoord = nil

local isOpeningRecordings = false
local useQtarget = false

Citizen.CreateThread(function()
    if not useQtarget then 
        return 
    end

    local models = {}

    for m, _ in pairs(Config.CameraModels) do
        table.insert(models, m)
    end

    exports.qtarget:AddTargetModel(models, {
        options = {
            {
                event = "rcore_cam:openCamMenu",
                icon = "fas fa-box-circle-check",
                label = string.gsub(Config.Text.OPEN_RECORDINGS, '~INPUT_PICKUP~ ', ''),
                num = 1
            },
        },
        distance = 8
    })
end)

AddEventHandler('rcore_cam:openCamMenu', function()
    isOpeningRecordings = true
    Citizen.SetTimeout(1000, function() isOpeningRecordings = false end)

    TriggerServerEvent('rcore_cam:openRecordings', 'cam_' .. closestCamGroupId)
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)

        local coords = GetEntityCoords(PlayerPedId())

        local newClosestCamDist = nil
        local newClosestCamGroupId = nil
        local newClosestCamCoord = nil

        local timeout = 10

        for _, camId in pairs(NearCameraGroups) do
            local groupCams = AllCameras[camId]

            for _, cam in pairs(groupCams) do
                if timeout < 0 then
                    Wait(0)
                    timeout = 10
                else
                    timeout = timeout - 1
                end

                local camDist = #(cam.pos - coords)

                if camDist < 50.0 then
                    if not newClosestCamDist or camDist < newClosestCamDist then
                        newClosestCamDist = camDist
                        newClosestCamGroupId = camId
                        newClosestCamCoord = cam.pos
                    end
                end
            end
        end

        closestCamDist = newClosestCamDist
        closestCamGroupId = newClosestCamGroupId
        closestCamCoord = newClosestCamCoord
    end
end)

local curRecordings = {}
local selectedRecording = nil
local isMenuOpen = false
local vidProcessingUntil = nil

function CheckHasAccessToCam(closestCamGroupId)
    if AllCameras[closestCamGroupId] then
        local tags = ''

        for _, c in pairs(AllCameras[closestCamGroupId]) do
            if c.tags then
                tags = c.tags
            end
        end

        if tags == '' then
            return IsCop
        end

        if Config.TaggedAccess and Config.TaggedAccess[tags] then
            local allowedJobs = Config.TaggedAccess[tags]
            local playerJob, _ = GetPlayersJobName()

            if playerJob then
                return allowedJobs[playerJob]
            end
        end
    end
end

Citizen.CreateThread(function()
    AddTextEntry('RC_CAM_OP', Config.Text.OPEN_RECORDINGS)

    WarMenu.CreateMenu('recordings', Config.Text.CAM_RECORDINGS)
    WarMenu.CreateSubMenu('recordingItem', 'recordings', '')
    
    WarMenu.CreateMenu('playerRecordings', Config.Text.CAM_RECORDINGS)
    WarMenu.CreateSubMenu('playerRecordingItem', 'playerRecordings', '')
    WarMenu.CreateSubMenu('playerRecordingItemGive', 'playerRecordingItem', '')

    while true do
        if closestCamGroupId then
            local hasAccessToCam = CheckHasAccessToCam(closestCamGroupId)

            if not IsPlayingBack and closestCamCoord and hasAccessToCam then
                local coords = GetEntityCoords(PlayerPedId())
                local distToClosestCam = #(coords.xy - closestCamCoord.xy)

                local maxDistToClosestCam = 1.9
                local maxZDist = 7.0

                if useQtarget then
                    maxDistToClosestCam = 9.0
                    maxZDist = 13.0
                end

                if distToClosestCam < 20.0 then
                    if distToClosestCam < maxDistToClosestCam and math.abs(coords.z - closestCamCoord.z) < maxZDist then

                        if not useQtarget then
                            DisplayHelpTextThisFrame('RC_CAM_OP', false)
                        end

                        if WarMenu.IsMenuOpened('recordings') then
                            if not vidProcessingUntil and GlobalState.activeCams[tostring(closestCamGroupId)] then
                                if WarMenu.Button(Config.Text.STOP_RECORDING) then
                                    vidProcessingUntil = GetGameTimer() + 7000
                                    TriggerServerEvent('rcore_cam:stopRecording', closestCamGroupId)
                                end
                            end

                            if vidProcessingUntil then
                                if GetGameTimer() < vidProcessingUntil then
                                    WarMenu.Button(Config.Text.RECORDING_PROCESSING)
                                else
                                    TriggerServerEvent('rcore_cam:openRecordings', 'cam_' .. closestCamGroupId)
                                    vidProcessingUntil = nil
                                end
                            end
        
                            for _, rec in pairs(curRecordings) do
                                if WarMenu.MenuButton(rec.recordedAt, 'recordingItem') then
                                    WarMenu.SetSubTitle('recordingItem', rec.id)
                                    selectedRecording = rec
                                end
                            end

                            WarMenu.Display()
                        elseif WarMenu.IsMenuOpened('recordingItem') then
                            if WarMenu.Button(Config.Text.PLAY) then
                                TriggerServerEvent('rcore_cam:requestPlayRecording', selectedRecording.id)
                                WarMenu.CloseMenu()
                            elseif WarMenu.Button(Config.Text.TAKE) then
                                TriggerServerEvent('rcore_cam:transferRecording', selectedRecording.id, 'me')
                                WarMenu.CloseMenu()
                            end

                            WarMenu.Display()
                        elseif not useQtarget and (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) then
                            isOpeningRecordings = true
                            Citizen.SetTimeout(1000, function() isOpeningRecordings = false end)

                            TriggerServerEvent('rcore_cam:openRecordings', 'cam_' .. closestCamGroupId)
                        end
                    elseif isMenuOpen then
                        isMenuOpen = false
                        WarMenu.CloseMenu()
                        WarMenu.Display()
                    end

                    Wait(0)
                else
                    Wait(500)
                end
            else
                Wait(500)
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent('rcore_cam:openRecordingsMenu', function(recordings)
    curRecordings = recordings

    if curRecordings[1] then
        WarMenu.SetSubTitle('recordings', Config.Text.SECURITY_GROUP .. ' #' .. curRecordings[1].groupId)
    else
        WarMenu.SetSubTitle('recordings', Config.Text.NO_RECORDINGS)
    end

    if not WarMenu.IsMenuOpened('recordings') then
        WarMenu.OpenMenu('recordings')
    end
    isMenuOpen = true
end)

RegisterNetEvent('rcore_cam:openPlayerRecordings', function(recordings)
    WarMenu.OpenMenu('playerRecordings')

    local playersNear = {}

    while true do
        Wait(0)

        if WarMenu.IsMenuOpened('playerRecordings') then
            for _, rec in pairs(recordings) do
                if WarMenu.MenuButton(rec.recordedAt, 'playerRecordingItem') then
                    WarMenu.SetSubTitle('playerRecordingItem', rec.id)
                    WarMenu.SetSubTitle('playerRecordingItemGive', Config.Text.GIVE .. ' ' .. rec.id)
                    selectedRecording = rec
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerRecordingItem') then
            if WarMenu.MenuButton(Config.Text.GIVE, 'playerRecordingItemGive') then
                local newPlayers = {}
                local meCoords = GetEntityCoords(PlayerPedId())
                local meServerId = GetPlayerServerId(PlayerId())

                for _, player in pairs(GetActivePlayers()) do
                    local playerCoords = GetEntityCoords(GetPlayerPed(player))

                    if #(meCoords - playerCoords) < 10.0 then
                        local targetServerId = GetPlayerServerId(player)

                        if targetServerId ~= meServerId then
                            table.insert(newPlayers, targetServerId)
                        end
                    end
                end

                playersNear = newPlayers
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerRecordingItemGive') then

            for idx, serverId in pairs(playersNear) do
                if WarMenu.Button(Config.Text.PLAYER .. ' #' .. serverId) then
                    TriggerServerEvent('rcore_cam:transferRecording', selectedRecording.id, 'player', serverId)
                    WarMenu.CloseMenu()
                end
            end
            
            local curOption = WarMenu.CurrentOption()
            
            if curOption and playersNear[curOption] then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(playersNear[curOption]))
                local targetCoords = GetEntityCoords(targetPed)
                if targetPed > 0 then
                    DrawMarker(
                        2, 
                        targetCoords.x, targetCoords.y, targetCoords.z + 1.2, 
                        0.0, 0.0, 0.0, 
                        180.0, 0.0, 0.0, 
                        0.3, 0.3, 0.3, 
                        44, 109, 184, 200, 
                        true, false, nil, false, nil, nil, false
                    )
                end
            end

            WarMenu.Display()
        else
            return
        end
    end
end)