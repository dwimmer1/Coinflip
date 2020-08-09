--[[


surface.CreateFont("MainFont", {
    font = "Comic Sans MS",
    size = 40,
    weight = 500,
})
]]
function MainUI()
    net.Receive("start", function(len, ply)
        frame = vgui.Create("DFrame")
        frame:SetSize(600, 430)
        frame:Center()
        frame:SetVisible(true)
        frame:MakePopup()
        --frame:ShowCloseButton(false)
        frame:SetTitle("Coinflip")

        frame.Paint = function(s, w, h)
            draw.RoundedBox(12, 0, 0, w, h, Color(105, 105, 105, 230))
            draw.RoundedBox(12, 2, 2, w - 4, h - 4, Color(0, 0, 0, 100))
        end

        local MainSheet = vgui.Create("DPropertySheet", frame)
        MainSheet:Dock(FILL)
        local List1 = vgui.Create("DPanelList")
        List1:SetSize(475, 355)
        List1:SetPos(5, 15)
        local List2 = vgui.Create("DPanelList")
        List2:SetSize(475, 355)
        List2:SetPos(5, 15)
        MainSheet:AddSheet("Coinflip", List1, "icon16/heart.png", false, false, "Flip it")
        MainSheet:AddSheet("Exchange", List2, "icon16/shield.png", false, false, "??")
        local PanelCash = vgui.Create("DPanel", List2)
        PanelCash:SetSize(108, 23)
        PanelCash:SetPos(470, 5)
        local PanelCash1 = vgui.Create("DPanel", List1)
        PanelCash1:SetSize(108, 23)
        PanelCash1:SetPos(470, 5)
        --function CurrTokens()
        --[[


        net.Receive("BackToken", function()
            
            local TokensAdd = net.ReadUInt(8)
            print(TokensAdd .. "")
            ]]
        local TokenInfo = vgui.Create("DLabel", PanelCash)
        local TokensCurr = 1000 --+ TokensAdd --                 Dezeitige Tokens + Gekaufte Tokens
        TokenInfo:SetPos(473, -11)
        TokenInfo:SetSize(150, 57)
        TokenInfo:SetTextColor(Color(0, 0, 0))
        TokenInfo:SetParent(List2)
        TokenInfo:SetText("Deine Tokens: " .. TokensCurr)
        local TokenInfo1 = vgui.Create("DLabel", PanelCash1)
        TokenInfo1:SetPos(473, -11)
        TokenInfo1:SetSize(150, 57)
        TokenInfo1:SetTextColor(Color(0, 0, 0))
        TokenInfo1:SetParent(List1)
        TokenInfo1:SetText("Deine Tokens: " .. TokensCurr)
        local Einsatz = vgui.Create("DLabel", List1)
        Einsatz:SetText("Dein Einsatz: 100 Tokens")
        Einsatz:SetPos(5, 90)
        Einsatz:SetSize(150, 57)
        Einsatz:SetTextColor(Color(0, 0, 0))

        --end)
        function CoinflipTab()
            local ImageButtonKopf = vgui.Create("DImageButton", List1)
            ImageButtonKopf:SetMaterial("vgui/kopf.png")
            ImageButtonKopf:SizeToContents()
            ImageButtonKopf:SetMouseInputEnabled(false)
            ImageButtonKopf:CenterHorizontal(0.5)
            ImageButtonKopf:SetPos(149, 0)
            --[[
            local ImageButtonZahl = vgui.Create("DImageButton", List1)
            ImageButtonZahl:SetMaterial("vgui/kopf.png")
            ImageButtonZahl:SizeToContents()
            ImageButtonZahl:SetMouseInputEnabled(false)
            ImageButtonZahl:CenterHorizontal(0.5)
            ImageButtonZahl:SetPos(8, -26)
            ]]
            local AuswahlBox = vgui.Create("DComboBox", List1)
            AuswahlBox:SetPos(5, 30)
            AuswahlBox:SetSize(100, 20)
            AuswahlBox:SetValue("Auswahl")
            AuswahlBox:AddChoice("Kopf")
            AuswahlBox:AddChoice("Zahl")

            AuswahlBox.OnSelect = function(self, index, value)
                if value == "Kopf" then
                    ImageButtonKopf:SetMaterial("vgui/kopf.png")
                else
                    ImageButtonKopf:SetMaterial("vgui/zahl.png")
                end

                print(value .. "aaaaaaaaaaaaa")
                local FlipButton = vgui.Create("DButton", List1)
                FlipButton:SetPos(137, 280)
                FlipButton:SetSize(290, 50)
                FlipButton:SetText("FLIP IT")
                FlipButton:SetMouseInputEnabled(true)

                FlipButton.DoClick = function()
                    local RandomNumber = math.random(1, 10)
                    print("Random Number: " .. RandomNumber)

                    for i = 1, 5 do
                        timer.Simple(0.1, function()
                            ImageButtonKopf:SetMaterial("vgui/zahl.png")
                        end)
                    end

                    if RandomNumber > 5 then
                        if value == "Kopf" or value == "Zahl" then
                            chat.AddText("GEWONNEN")
                            TokensCurr = TokensCurr + 10
                        else
                            chat.AddText("Verloren")
                        end
                    end
                end
            end

            -- end
            --CurrTokens()
            function ExchangeTab()
                local NumberInput = vgui.Create("DTextEntry", List2)
                NumberInput:SetPos(210, 25)
                NumberInput:SetSize(80, 26)
                NumberInput:SetNumeric(true)

                --  NumberInput:SetValue( "Only Numbers" )
                while NumberInput:IsEditing() == true do
                    NumberInput.OnChange = function(self)
                        local InputEndNumber = NumberInput:GetInt() -- InputEndNumber = Nummer die in die Box eingegeben wurde (Enter)
                        net.Start("Exchange")
                        net.WriteUInt(InputEndNumber, 8)
                        net.SendToServer()
                    end
                end

                local ButtonNumber = vgui.Create("DButton", List2)
                ButtonNumber:SetPos(200, 50)
                ButtonNumber:SetSize(120, 43)
                --ButtonNumber:SetParent(NumberInput)
                ButtonNumber:SetText("Umwandeln")
                ButtonNumber:SetMouseInputEnabled(true)

                ButtonNumber.DoClick = function()
                    --  chat.AddText(InputEndNumber .. "")
                    net.Start("Exchange")
                    net.WriteBool(false)
                    net.SendToServer()
                end
            end

            ExchangeTab()
        end

        CoinflipTab()
    end)
end

MainUI()