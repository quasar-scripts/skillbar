Skillbar = {}
Skillbar.Data = {}


Skillbar.Data = {
    Active = false,
    Data = {},
}
successCb = nil
failCb = nil

-- NUI Callback's

RegisterNUICallback('Check', function(data, cb)
    if successCb ~= nil then
        Skillbar.Data.Active = false
        TriggerEvent('progressbar:client:ToggleBusyness', false)
        if data.success then
            successCb()
        else
            failCb()
            SendNUIMessage({
                action = "stop"
            })
        end
    end
end)

Skillbar.Start = function(data, success, fail)
    if not Skillbar.Data.Active then
        Skillbar.Data.Active = true
        if success ~= nil then
            successCb = success
        end
        if fail ~= nil then
            failCb = fail
        end
        Skillbar.Data.Data = data

        SendNUIMessage({
            action = "start",
            duration = data.duration,
            pos = data.pos,
            width = data.width,
        })
        TriggerEvent('progressbar:client:ToggleBusyness', true)
    else
        --TriggerEvent('notification', 'zaten birşey yapıyon', 2)
    end
end

Skillbar.Repeat = function(data)
    Skillbar.Data.Active = true
    Skillbar.Data.Data = data
    Citizen.CreateThread(function()
        Wait(500)
        SendNUIMessage({
            action = "start",
            duration = Skillbar.Data.Data.duration,
            pos = Skillbar.Data.Data.pos,
            width = Skillbar.Data.Data.width,
        }) 
    end)
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1250
        if Skillbar.Data.Active then
            sleep = 3
            if IsControlJustPressed(0, Keys["E"]) then
                SendNUIMessage({
                    action = "check",
                    data = Skillbar.Data.Data,
                })
            end
        end
        Citizen.Wait(sleep)
    end
end)

function GetSkillbarObject()
    return Skillbar
end