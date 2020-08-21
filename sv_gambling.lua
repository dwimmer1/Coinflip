--https://darkrp.miraheze.org/wiki/Main_Page
util.AddNetworkString("start")
util.AddNetworkString("Exchange")
util.AddNetworkString("BackToken")
util.AddNetworkString("ExchangeToCash")
AddCSLuaFile("cl_gambling.lua")

hook.Add("PlayerSay", "StartCommand", function(ply, text, ent)
    if string.lower(text) == "!c" then
        --ply:ChangeTeam( "TEAM_COINFLIPPER", true )
        net.Start("start")
        net.Send(ply)
    end
end)

function ExchangeInit()
    net.Receive("Exchange", function(len, ply)
        --local CurrTokens = net.ReadUInt(12)
        local InputEndToTokensNumber = net.ReadUInt(8) -- = Box Input
        local TokenBoughtValue = InputEndToTokensNumber * 10

        --local CurrCash = ply:getDarkRPVar("money")
        if not ply:canAfford(InputEndToTokensNumber) then
            DarkRP.notify(ply, 1, 4, string.format("Das kannst du dir nicht leisten."))
        else
            ply:addMoney(-InputEndToTokensNumber)
            net.Start("BackToken")
            net.WriteUInt(TokenBoughtValue, 8)
            DarkRP.notify(ply, 0, 4, string.format("Du hast dir für " .. InputEndToTokensNumber .. " Cash, " .. TokenBoughtValue .. " Tokens gekauft."))
            net.Send(ply)
        end
    end)

    net.Receive("ExchangeToCash", function(len, ply)
        local InputEndToCashNumber = net.ReadUInt(8)
        local OutPay = InputEndToCashNumber / 10
        print(InputEndToCashNumber .. "")

        if InputEndToCashNumber < 10 then
            DarkRP.notify(ply, 1, 4, string.format("Die Zahl muss größer als 10 sein."))
        else
            DarkRP.notify(ply, 0, 4, string.format("Du hast dir für " .. InputEndToCashNumber .. " Tokens, " .. OutPay .. " Cash auszahlen lassen."))
            ply:addMoney(OutPay)
        end
    end)
end

ExchangeInit()