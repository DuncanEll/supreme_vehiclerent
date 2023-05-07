local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('supreme_vehiclerent:server:GetPapers')
AddEventHandler('supreme_vehiclerent:server:GetPapers', function(plate, model, money)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local metadata = {
        label = "Veh Papers",
        type = string.format('%s %s', Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname),
        description = string.format('Plate: %s  \nModel: %s',
        plate, model, Player.PlayerData.charinfo.birthdate, Player.PlayerData.charinfo.nationality),
    }
    exports.ox_inventory:AddItem(source, Config.PaperItem, 1, metadata)
    Wait(2000)
    Player.Functions.RemoveMoney('bank', money, "Vehicle Rent")
end)

RegisterServerEvent('supreme_vehiclerent:server:removePapers')
AddEventHandler('supreme_vehiclerent:server:removePapers', function(plate, model, money)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.ox_inventory:RemoveItem(source, Config.PaperItem, 1, metadata)
end)