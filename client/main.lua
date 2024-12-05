local isinzone = false
local ESX = nil
local processing = false

CreateThread(function()
    while not ESX do
        ESX = exports["es_extended"]:getSharedObject()
        Wait(500)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        isinzone = false
        
        if vehicle ~= 0 then
            for _, v in pairs(Config.Stations) do
                local distance = #(coords - v.EnterPoint.Coords)
                
                if distance < 10.0 then
                    isinzone = true
                    
                    if Config.Debug == true then
                        DrawMarker(1, v.EnterPoint.Coords.x, v.EnterPoint.Coords.y, v.EnterPoint.Coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 0, 150, 255, 100, false, true, 2, false, nil, nil, false)
                    end
                    
                    if distance < 1.5 then
                        local allowed = false

                        if v.ActivateWhitelist == true then
                            if Config.Debug == true and not processing then
                                print("\n^0[^3DEBUG^0] ^4tg_carwash^0: Whitelist ^2activated^0.")
                            end

                            if PlayerData == nil then
                                PlayerData = ESX.GetPlayerData()
                            end

                            for _, v in pairs(v.Whitelist) do
                                if v == PlayerData.job.name then
                                    if Config.Debug == true and not processing then
                                        print("^0[^3DEBUG^0] ^4tg_carwash^0: Allowed: "..v..".")
                                    end

                                    allowed = true

                                    break
                                else
                                    if Config.Debug == true and not processing then
                                        print("^0[^3DEBUG^0] ^4tg_carwash^0: ^1Not Allowed^0: "..PlayerData.job.name..".")
                                    end

                                    allowed = false
                                end
                            end
                        else
                            if Config.Debug == true and not processing then
                                print("^0[^3DEBUG^0] ^4tg_carwash^0: Whitelist ^1not activated^0.")
                            end

                            allowed = true
                        end

                        if allowed == true then
                            if Config.Debug == true and not processing then
                                print("^0[^3DEBUG^0] ^4tg_carwash^0: Allowed set ^2true^0.")
                            end
                            
                            allowed = false
                            ESX.ShowHelpNotification(Translate('press_to_use'))
                            
                            if IsControlJustReleased(0, 38) and not processing then
                                local playermoney = nil

                                ESX.TriggerServerCallback('tg_carwash:checkmoney', function(cb)
                                    if cb == false then
                                        ESX.ShowNotification(Translate('check_error'),"error")
                                    end

                                    if Config.Debug == true then
                                        if cb ~= nil then
                                            print("\n^0[^3DEBUG^0] ^4tg_carwash^0: Server Returned: Account: ^4"..Config.Account.."^0 - ^4Balance: ^2"..cb.."^0.")
                                        else
                                            print("\n^0[^3DEBUG^0] ^4tg_carwash^0: Server Returned: Account: ^4"..Config.Account.."^0 - ^4Balance: ^2nil^0.")
                                        end
                                    end
                                    
                                    playermoney = cb

                                    if Config.Debug == true then
                                        print("^0[^3DEBUG^0] ^4tg_carwash^0: ^4cb^0: ^2"..cb.."^0 - ^4playermoney^0: ^2"..playermoney.."^0.")
                                        print("^0[^3DEBUG^0] ^4tg_carwash^0: ^4playermoney >= v.Price^0: ^3",playermoney >= v.Price,"^0.")
                                    end
    
                                    if playermoney ~= nil and playermoney >= v.Price then
                                        if Config.Debug == true then
                                            print("^0[^3DEBUG^0] ^4tg_carwash^0: ^2Enough^0 Money: ^2"..playermoney.."^0.")
                                        end

                                        processing = true
                                        
                                        TriggerServerEvent('tg_carwash:removemoney', v.Price)

                                        if v.Automatic then
                                            autocarwash(vehicle, v.FinishPoint.Coords)
                                        else
                                            carwash(vehicle, v.EnterPoint.Coords)
                                        end
                                    else
                                        if Config.Debug == true then
                                            if playermoney ~= nil then
                                                print("^0[^3DEBUG^0] ^4tg_carwash^0: ^1Not Enough^0 Money: ^2"..playermoney.."^0.")
                                            else
                                                print("^0[^3DEBUG^0] ^4tg_carwash^0: ^1Not Enough^0 Money: ^2nil^0.")
                                            end
                                        end

                                        ESX.ShowNotification(Translate('not_enough_money',v.Price,v.Price - (playermoney or 0)),"error")
                                    end
                                end)
                            end
                        else
                            if Config.Debug == true then
                                print("^0[^3DEBUG^0] ^4tg_carwash^0: Allowed set ^1false^0.")
                            end

                            ESX.ShowHelpNotification(Translate('not_allowed'))
                        end
                    end
                end
            end
        end

        for _, v in pairs(Config.Stations) do
            local distance = #(coords - v.FinishPoint.Coords)
            
            if distance < 10.0 then
                isinzone = true

                if Config.Debug == true then
                    DrawMarker(1, v.FinishPoint.Coords.x, v.FinishPoint.Coords.y, v.FinishPoint.Coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
                end
            end
        end

        if not isinzone then
            Wait(1000)
        else
            Wait(5)
        end
    end
end)

function autocarwash(vehicle, finishpoint)
    SetVehicleDirtLevel(vehicle, 15)
    ESX.ShowNotification(Translate('vehicle_locked'),"error",5000)

    local x, y, z = table.unpack(finishpoint)

    TaskVehicleDriveToCoordLongrange(PlayerPedId(), vehicle, x, y, z, 2.0, 16777216, 0.2)

    ActivateWaterParticles(vehicle, finishpoint, true)

    while true do
        Wait(0)
        local distance = #(GetEntityCoords(PlayerPedId()) - finishpoint)

        if (distance < 2.5) then
            break
        end
    end

    SetVehicleDirtLevel(vehicle, 0.1)
    WashDecalsFromVehicle(vehicle, 1.0)
    StopParticleFxLooped(particleFx, false)

    ESX.ShowNotification(Translate('vehicle_unlocked'),"success",5000)
end

function carwash(vehicle, enterpoint)
    SetVehicleDirtLevel(vehicle, 15)

    ActivateWaterParticles(vehicle, enterpoint, false)

    SetVehicleDirtLevel(vehicle, 0.1)
    WashDecalsFromVehicle(vehicle, 1.0)
    StopParticleFxLooped(particleFx, false)
end

-- // TODO: Add Sound Mechanism
function ActivateWaterParticles(vehicle, targetCoords, automatic)
    Citizen.CreateThread(function()
        local particleFx = nil
        local particleActive = false

        while true do
            Citizen.Wait(0)

            if automatic then
                local coords = GetEntityCoords(vehicle)
                local distanceToTarget = #(coords - targetCoords)

                if Config.Debug == true then
                    print("\n^0[^3DEBUG^0] ^4tg_carwash^0: Distance to target: ^4"..distanceToTarget.."^0.")
                    print("^0[^3DEBUG^0] ^4tg_carwash^0: Distance to target < 2.1: ^4",distanceToTarget < 2.1,"^0.")
                    print("^0[^3DEBUG^0] ^4tg_carwash^0: Distance to target > 2.1: ^4",distanceToTarget > 2.1,"^0.")
                end

                if distanceToTarget > 2.5 then
                    if not particleActive then
                        particleActive = true
                        UseParticleFxAssetNextCall("core")
                        particleFx = StartNetworkedParticleFxLoopedOnEntity("ent_amb_int_waterfall_splash", vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
                        if Config.Debug == true then
                            print("^0[^3DEBUG^0] ^4tg_carwash^0: Started Particles^0.")
                        end
                    end
                    if Config.Debug == true then
                        print("^0[^3DEBUG^0] ^4tg_carwash^0: Particles running^0.")
                    end
                else
                    if Config.Debug == true then
                        print("^0[^3DEBUG^0] ^4tg_carwash^0: Particles should stop^0.")
                    end
                    if particleActive then
                        if Config.Debug == true then
                            print("^0[^3DEBUG^0] ^4tg_carwash^0: Particles stopped^0.")
                        end
                        particleActive = false
                        StopParticleFxLooped(particleFx, false)
                        break
                    end
                end
            else
                FreezeEntityPosition(vehicle, true)
                for i = 1,500 do
                    if not particleActive then
                        particleActive = true
                        UseParticleFxAssetNextCall("core")
                        particleFx = StartNetworkedParticleFxLoopedOnEntity("ent_amb_int_waterfall_splash", vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
                        if Config.Debug == true then
                            print("^0[^3DEBUG^0] ^4tg_carwash^0: Started Particles^0.")
                        end
                    end
                    if Config.Debug == true then
                        print("^0[^3DEBUG^0] ^4tg_carwash^0: Particles running^0.")
                    end
                    Wait(1)
                end

                if Config.Debug == true then
                    print("^0[^3DEBUG^0] ^4tg_carwash^0: Particles should stop^0.")
                end
                if particleActive then
                    if Config.Debug == true then
                        print("^0[^3DEBUG^0] ^4tg_carwash^0: Particles stopped^0.")
                    end
                    particleActive = false
                    FreezeEntityPosition(vehicle, false)
                    StopParticleFxLooped(particleFx, false)
                    break
                end
            end
        end

        processing = false
    end)
end

CreateThread(function()
    if not Config.DisableBlips then
        for _, v in pairs(Config.Stations) do
            if v.Blip then
                local blip = AddBlipForCoord(v.EnterPoint.Coords)

                SetBlipSprite(blip, 100)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.9)
                SetBlipColour(blip, 3)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(Config.Blipname)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)