IsCop = false

RegisterNetEvent('rcore_cam:setAceAllowed', function(allowed)
    IsCop = allowed
end)

if not Config.UseAcePermission then
    Citizen.CreateThread(function()
        while true do
            Wait(5000)
            IsCop = IsPlayerCop()
        end
    end)
end