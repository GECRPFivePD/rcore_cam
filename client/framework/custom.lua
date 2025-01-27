CreateThread(function()
    if Config.Framework == 3 then
        function IsPlayerCop()
            return true
        end
        
        GetPlayersJobName = function()
            return nil, nil
        end

        GetPlayersJobGrade = function()
            return nil
        end
    end
end)