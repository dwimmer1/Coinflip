util.AddNetworkString("start")
util.AddNetworkString("Exchange")
util.AddNetworkString("BackToken")
AddCSLuaFile("cl_gambling.lua")

hook.Add("PlayerSay", "StartCommand", function(ply, text, ent)
    if text == "!g" then
        net.Start("start")
        net.Send(ply)
    end
end)

function ExchangeInit()
    net.Receive("Exchange", function(len, ply)
        local InputEndNumberInit = net.ReadUInt(8)
        local ButtonPressCheck = net.ReadBool() --Prüft ob der Button gedrückt wurde

        if (ButtonPressCheck ~= true) then
            print(InputEndNumberInit .. "")

            if not ply:canAfford(InputEndNumberInit) then
                DarkRP.notify(ply, 1, 4, string.format("Das kannst du dir nicht leisten."))
            else
                ply:addMoney(-InputEndNumberInit)
                --net.Start("BackToken")
               -- net.WriteUInt(InputEndNumberInit,8)
            end
        end
    end)
end

ExchangeInit()
