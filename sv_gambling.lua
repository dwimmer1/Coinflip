--https://darkrp.miraheze.org/wiki/Main_Page
util.AddNetworkString("start")
util.AddNetworkString("Exchange")
util.AddNetworkString("BackToken")
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
        local InputEndNumberInit = net.ReadUInt(8)
        local ButtonPressCheck = net.ReadBool() --Prüft ob der Button gedrückt wurde
        local CurrCash = ply:getDarkRPVar("money")
        local TokenBoughtValue = InputEndNumberInit * 10
        if (ButtonPressCheck == false) then

            if not ply:canAfford(InputEndNumberInit) then
                DarkRP.notify(ply, 1, 4, string.format("Das kannst du dir nicht leisten."))
            else
                ply:addMoney(-InputEndNumberInit)
                net.Start("BackToken")
                net.WriteUInt(TokenBoughtValue, 8)
                DarkRP.notify(ply, 0, 4, string.format("Du hast dir für " .. InputEndNumberInit .. " Cash, " .. TokenBoughtValue .. " Tokens gekauft."  ))
                net.Send(ply)
            end
        end
    end)
end

ExchangeInit()