if Config.DisableMySQL then
    local Recordings = {}

    function DbSaveRecording(camId, storageName)
        local generatedId = GenerateUniqueId()

        table.insert(Recordings, {
            id = generatedId,
            groupId = camId,
            stored = storageName,
            recordedAt = os.date('%Y-%m-%d  %H:%M:%S', os.time(os.date("*t"))),
        })
        
        return generatedId
    end

    function DbRecordExistsWithId(id)
        for _, d in pairs(Recordings) do
            if d.id == id then
                return true
            end
        end

        return false
    end

    function DbGetRecordById(id)
        for _, d in pairs(Recordings) do
            if d.id == id then
                return d
            end
        end
        
        return nil
    end

    function DbGetRecordings(place, placeOnlyStart)
        local toReturn = {}

        for _, d in pairs(Recordings) do
            if d.stored:find(place, 1, true) == 1 then
                table.insert(toReturn, d)
            end
        end

        return toReturn
    end

    function DbGetOldRecordings()
        return {}
    end

    function DbDeleteRecording(id)
        for idx, d in pairs(Recordings) do
            if d.id == id then
                Recordings[idx] = nil
            end
        end
    end


    function DbTransferRecording(id, newPlace)
        for idx, d in pairs(Recordings) do
            if d.id == id then
                d.stored = newPlace
            end
        end
    end
end