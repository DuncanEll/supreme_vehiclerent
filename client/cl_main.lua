local QBCore = exports['qb-core']:GetCoreObject()
local ox_target = exports.ox_target
local vehicleSpawned = false

local vehicleOptions = {
    {
        type = Config.TargetType,
        event = Config.TargetEvent,
        icon = Config.TargetIcon,
        label = Config.VehicleRentText,
    },
}

local function createVehiclePed()
	local genderNumber
	local model = Config.DoorPed
	local gend = "male"
	local coords = vector3(395.72, -635.67, 28.71)
	local heading = 263.66
	local animDict = "amb@code_human_cross_road@male@idle_a"
	local animName = "idle_c"

	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end

	if gend == 'male' then
		genderNumber = 4
	elseif gend == 'female' then 
		genderNumber = 5
	else
		print("No gender has been provided! Check your the configuration!")
	end	

    local x, y, z = table.unpack(coords)
    local ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
	SetEntityAlpha(ped, 0, false)
    FreezeEntityPosition(ped, true) 
    SetEntityInvincible(ped, true) 
    SetBlockingOfNonTemporaryEvents(ped, true)

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(1)
    end
    TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	
    for i = 0, 255, 51 do
        Citizen.Wait(50)
        SetEntityAlpha(ped, i, false)
    end
	ox_target:addLocalEntity(ped, vehicleOptions)
	return ped
	
end

CreateThread(function()
    createVehiclePed()
    RentalPlace = AddBlipForCoord(vector3(396.86, -635.68, 28.5))
    SetBlipSprite (RentalPlace, Config.BlipSprite)
    SetBlipDisplay(RentalPlace, Config.BlipDisplay)
    SetBlipScale  (RentalPlace, Config.BlipScale)
    SetBlipAsShortRange(RentalPlace, false)
    SetBlipColour(RentalPlace, 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.BlipName)
    EndTextCommandSetBlipName(RentalPlace)
end)

RegisterNetEvent("supreme_vehiclerent:VehicleMenu", function()
    lib.registerContext({
        id = 'vehicle_menu',
        title = 'Rentals',
        options = {
            {
                title = "Return Vehicle",
                description = 'Rent for $100',
                event = "supreme_vehiclerent:returnVehicle",
            },
            {
                title = Config.Vehicle1,
                description = 'Rent for $100',
                event = "supreme_vehiclerent:SpawnCar",
                args = {
                    model = Config.Vehicle1Model,
                    price = 100
                }
            },
            {
                title = Config.Vehicle2,
                description = 'Rent for $200',
                event = "supreme_vehiclerent:SpawnCar",
                args = {
                    model = Config.Vehicle2Model,
                    price = 100
                }
            },
        },
    })
    lib.showContext('vehicle_menu')
end)

RegisterNetEvent('supreme_vehiclerent:SpawnCar')
AddEventHandler('supreme_vehiclerent:SpawnCar', function(data)
    local price = data.price
    local vehicleModel = data.model
    local player = PlayerPedId()
    QBCore.Functions.SpawnVehicle(vehicleModel, function(veh)
        SetEntityHeading(veh, 87.76)
        TaskWarpPedIntoVehicle(player, veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        vehicleSpawned = true
    end, vector4(408.65, -638.59, 28.5, 87.76), true)
    Wait(1000)
    local vehicle = GetVehiclePedIsIn(player, false)
    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    vehicleLabel = GetLabelText(vehicleLabel)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('supreme_vehiclerent:server:GetPapers', plate, vehicleLabel, price)
end)

RegisterNetEvent('supreme_vehiclerent:returnVehicle')
AddEventHandler('supreme_vehiclerent:returnVehicle', function()
    if vehicleSpawned then
        local Player = QBCore.Functions.GetPlayerData()
        QBCore.Functions.Notify('Returned vehicle!', 'success')
        TriggerServerEvent('supreme_vehiclerent:server:removePapers')
        local carIsIn = GetVehiclePedIsIn(PlayerPedId(),true)
        NetworkFadeOutEntity(car, true,false)
        Citizen.Wait(2000)
        QBCore.Functions.DeleteVehicle(carIsIn)
    else 
        QBCore.Functions.Notify("No vehicle to return", "error")
    end
    vehicleSpawned = false
end)