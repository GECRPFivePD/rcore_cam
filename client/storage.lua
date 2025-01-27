local isOpenDisabled = false
local isStorageOpen = false

CP_TYPE_FULL = 'full'
CP_TYPE_PUBLIC = 'public'

ClosestCheckpoint = nil
ClosestCheckpointType = nil

Citizen.CreateThread(function()
    while true do
        Wait(1000)

        local closestCheckpoint = nil
        local closestDist = nil
        local closestType = nil
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for storageName, storageData in pairs(Config.RecordingStorages) do
            local distToCp = #(coords - storageData.pos)

            if distToCp < 100.0 then
                if not closestDist or distToCp < closestDist then
                    closestCheckpoint = storageName
                    closestDist = distToCp
                    closestType = CP_TYPE_FULL
                end
            end
        end
        
        if Config.PublicViewPlaces then
            for storageName, storageData in pairs(Config.PublicViewPlaces) do
                local distToCp = #(coords - storageData.pos)

                if distToCp < 100.0 then
                    if not closestDist or distToCp < closestDist then
                        closestCheckpoint = storageName
                        closestDist = distToCp
                        closestType = CP_TYPE_PUBLIC
                    end
                end
            end
        end

        ClosestCheckpoint = closestCheckpoint
        ClosestCheckpointType = closestType
    end
end)

function HasAccessToCamera(cpData)
    if not cpData.job then
        return IsCop
    else
        local jobName, _ = GetPlayersJobName()

        if jobName then
            return cpData.job == jobName
        end
    end

    return false
end

Citizen.CreateThread(function()
    AddTextEntry('RC_STOR_OP', Config.Text.OPEN_REC_STORAGE)

    WarMenu.CreateMenu('recStorageRoot', Config.Text.CAM_RECORDINGS)

    WarMenu.CreateSubMenu('recStoragePlayerSelectRecording', 'recStorageRoot', '')
    WarMenu.CreateSubMenu('recStoragePlayerSelectedRecordingActions', 'recStoragePlayerSelectRecording', '')
    WarMenu.CreateSubMenu('recStoragePlayerStoreSelectedRecordingInDrawer', 'recStoragePlayerSelectedRecordingActions', '')

    WarMenu.CreateSubMenu('recStoredFolderSelect', 'recStorageRoot', '')
    WarMenu.CreateSubMenu('recStoredSelectRecording', 'recStoredFolderSelect', '')
    WarMenu.CreateSubMenu('recStoredRecordingActions', 'recStoredSelectRecording', '')
    
    
    while true do
        -- and IsCop
        if not IsPlayingBack and not isStorageOpen and ClosestCheckpoint then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local cpData = Config.RecordingStorages[ClosestCheckpoint] or (Config.PublicViewPlaces and Config.PublicViewPlaces[ClosestCheckpoint])
            local distToCp = #(coords - cpData.pos)

            if distToCp < 50.0 and (ClosestCheckpointType == CP_TYPE_PUBLIC or HasAccessToCamera(cpData)) then
                DrawMarker(
                    1, 
                    cpData.pos.x, cpData.pos.y, cpData.pos.z, 
                    0.0, 0.0, 0.0, 
                    0.0, 0.0, 0.0, 
                    1.0, 1.0, 1.0, 
                    255, 0, 0, 150, 
                    false, false, nil, false, nil, nil, false
                )

                if distToCp < 1.2 then
                    if not isOpenDisabled then
                        DisplayHelpTextThisFrame('RC_STOR_OP', false)

                        if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                            isOpenDisabled = true
                            Citizen.SetTimeout(500, function() isOpenDisabled = false end)
                            TriggerServerEvent('rcore_cam:requestStorageRecordings', ClosestCheckpoint)
                        end
                    end
                end
            end

            Wait(0)
        else
            Wait(1000)
        end
    end
end)

MODE_STORED = 'stored'
MODE_PLAYER = 'player'


RegisterNetEvent('rcore_cam:openStorage', function(storageName, playerRecs, storageRecs)
    local storagePlace = Config.RecordingStorages[storageName] or (Config.PublicViewPlaces and Config.PublicViewPlaces[storageName])

    if HasAccessToCamera(storagePlace) then
        if ClosestCheckpointType == CP_TYPE_FULL then
            WarMenu.SetMenuSubTitle('recStorageRoot', 'Private Storage')
        else
            WarMenu.SetMenuSubTitle('recStorageRoot', 'Public Viewing')
        end
        WarMenu.OpenMenu('recStorageRoot')
    else
        WarMenu.SetMenuSubTitle('recStoredFolderSelect', 'Public Viewing')
        WarMenu.OpenMenu('recStoredFolderSelect')
    end

    local mode = nil
    local selectedRecording = nil
    local selectedDrawer = nil
    isStorageOpen = true


    while true do
        if #(GetEntityCoords(PlayerPedId()) - storagePlace.pos) > 2.0 then
            WarMenu.CloseMenu()
            WarMenu.Display()
            isStorageOpen = false
            return
        end

        if WarMenu.IsMenuOpened('recStorageRoot') then
            if not HasAccessToCamera(storagePlace) then
                WarMenu.CloseMenu()
                WarMenu.Display()
            end

            if WarMenu.MenuButton(Config.Text.STORED_RECORDINGS, 'recStoredFolderSelect') then
                WarMenu.SetSubTitle('recStoredFolderSelect', Config.Text.STORED_RECORDINGS)
                mode = MODE_STORED
            elseif WarMenu.MenuButton(Config.Text.YOUR_RECORDINGS, 'recStoragePlayerSelectRecording') then
                WarMenu.SetSubTitle('recStoragePlayerSelectRecording', Config.Text.YOUR_RECORDINGS)
                mode = MODE_PLAYER
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('recStoragePlayerSelectRecording') then
            local data = playerRecs

            if mode == MODE_STORED then
                data = storageRecs
            end

            for _, rec in pairs(data) do
                if WarMenu.MenuButton(rec.recordedAt, 'recStoragePlayerSelectedRecordingActions', rec.id) then
                    WarMenu.SetSubTitle('recStoragePlayerSelectedRecordingActions', rec.id)
                    WarMenu.SetSubTitle('recStoragePlayerStoreSelectedRecordingInDrawer', rec.id)
                    selectedRecording = rec
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('recStoredSelectRecording') then
            for _, rec in pairs(storageRecs) do
                if rec.stored == 'storage_' .. storageName .. '_' .. selectedDrawer.name then
                    if WarMenu.MenuButton(rec.recordedAt, 'recStoredRecordingActions', rec.id) then
                        WarMenu.SetSubTitle('recStoredRecordingActions', rec.id)
                        WarMenu.SetSubTitle('recStoragePlayerStoreSelectedRecordingInDrawer', rec.id)
                        selectedRecording = rec
                    end
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('recStoragePlayerSelectedRecordingActions') then
            if WarMenu.Button(Config.Text.PLAY) then
                TriggerServerEvent('rcore_cam:requestPlayRecording', selectedRecording.id)
                WarMenu.CloseMenu()
            end

            if WarMenu.MenuButton(Config.Text.STORE, 'recStoragePlayerStoreSelectedRecordingInDrawer') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('recStoredRecordingActions') then
            if WarMenu.Button(Config.Text.PLAY) then
                TriggerServerEvent('rcore_cam:requestPlayRecording', selectedRecording.id)
                WarMenu.CloseMenu()
            end

            if storagePlace and mode == MODE_STORED and WarMenu.Button(Config.Text.TAKE) then
                TriggerServerEvent('rcore_cam:transferRecording', selectedRecording.id, 'me')
                WarMenu.CloseMenu()
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('recStoragePlayerStoreSelectedRecordingInDrawer') then
            for _, drawerData in pairs(storagePlace.folders) do
                local canSee = true

                if drawerData.minGrade then
                    local playerGrade = GetPlayersJobGrade()

                    if drawerData.minGrade <= playerGrade then
                        canSee = true
                    else
                        canSee = false
                    end
                end

                if canSee and WarMenu.Button(drawerData.label) then
                    TriggerServerEvent('rcore_cam:transferRecording', selectedRecording.id, 'storage_' .. storageName .. '_' .. drawerData.name)
                    WarMenu.CloseMenu()
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('recStoredFolderSelect') then
            for _, drawerData in pairs(storagePlace.folders) do
                local canSee = true

                if drawerData.minGrade then
                    local playerGrade = GetPlayersJobGrade()

                    if drawerData.minGrade <= playerGrade then
                        canSee = true
                    else
                        canSee = false
                    end
                end
                if canSee and WarMenu.MenuButton(drawerData.label, 'recStoredSelectRecording') then
                    WarMenu.SetSubTitle('recStoredSelectRecording', drawerData.label)
                    selectedDrawer = drawerData
                end
            end

            WarMenu.Display()
        else
            WarMenu.CloseMenu()
            break
        end

        Wait(0)
    end

    isStorageOpen = false
end)