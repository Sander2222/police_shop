local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    ESX.TriggerServerCallback('police_shop:fetchItems', function(items)
        for key, value in pairs(items) do
            AddItem(value.name, value.display, value.price)
        end
    end)
end)

local laden = {

    {x= 25.384355545044,y= -1355.2346191406,z= 29.341281890869}
}

local enableField = false

function toggleField(enable)
    SetNuiFocus(enable, enable)
    enableField = enable

    if enable then
        SendNUIMessage({
            action = 'open'
        }) 
    else
        SendNUIMessage({
            action = 'close'
        }) 
    end
end

AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() ~= name then
        return
    end

    toggleField(false)
end)

RegisterNUICallback('escape', function(data, cb)
    toggleField(false)
    SetNuiFocus(false, false)

    cb('ok')
end)

RegisterNUICallback('buy', function(data, cb)
    local warenkorb = data.warenkorb
    local totalprice = 0

    for key, value in pairs(warenkorb) do
        totalprice = totalprice + value.price
    end

    local itemPrice = totalprice
    
    ESX.TriggerServerCallback('police_shop:canAfford', function(bool)
        if bool then
            ESX.ShowNotification(("Du hast einen Einkauf für $%s getätigt"):format(itemPrice))
        else
            ESX.ShowNotification(("Du kannst dir den Einkauf für $%s nicht leisten!"):format(itemPrice))
        end
    end, itemPrice, warenkorb)

    cb('ok')
end)

function AddItem(name, display, price)
    SendNUIMessage({
        action = 'add',
        name = name,
        display = display,
        price = price
    })
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for key, value in pairs(laden) do
            DrawMarker(20, vector3(value.x, value.y, value.z + 1), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, true, false, false, false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        local xPlayer = ESX.GetPlayerData()

        for key, value in pairs(laden) do
            local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vector3(value.x, value.y, value.z))

            if dist <= 2.0 and xPlayer.job.name == 'police' then
                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um auf den LSPD-Shop zuzugreifen")

                if IsControlJustReleased(0, 38) then
                    toggleField(true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, coords in pairs(laden) do
        local blip = AddBlipForCoord(vector3(coords.x, coords.y, coords.z))

        SetBlipSprite(blip, 52)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 52)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("24/7 Store")
        EndTextCommandSetBlipName(blip)
        end
end)