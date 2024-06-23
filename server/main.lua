ESX = nil

ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('tg_carwash:checkmoney')
AddEventHandler('tg_carwash:checkmoney', function(amount)
    
end)

ESX.RegisterServerCallback('tg_carwash:checkmoney', function(player, cb)
    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer then
        local account = xPlayer.getAccount(Config.Account)
        local balance = account.money

        cb(balance)
    else
        if Config.Debug == true then
            print("^0[^3DEBUG^0] ^4tg_carwash^0: Server: Player not found - ID: ^4"..player.."^0.")
        end

        cb(false)
    end
end)

RegisterServerEvent('tg_carwash:removemoney')
AddEventHandler('tg_carwash:removemoney', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        xPlayer.removeAccountMoney(Config.Account, amount)

        if Config.Reciever ~= "" then
            TriggerEvent('esx_addonaccount:getSharedAccount', Config.Reciever, function(account)
                account.addMoney(amount)
            end)
            if Config.Debug == true then
                print("^0[^3DEBUG^0] ^4tg_carwash^0: Removed ^2"..amount.."^0 from ID: ^4"..source.."^0 and added it to: ^4"..Config.Reciever.."^0")
            end
        else
            if Config.Debug == true then
                print("^0[^3DEBUG^0] ^4tg_carwash^0: Removed ^2"..amount.."^0 from ID: ^4"..source.."^0")
            end
        end
    else
        print('^0[^1ERROR^0] ^4tg_carwash^0: Player not found or invalid player ID:', source)
    end
end)