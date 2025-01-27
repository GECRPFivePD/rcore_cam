function IsPedInvisible(ped)
    return IsEntityVisible(ped) and GetEntityAlpha(ped) > 200
end
