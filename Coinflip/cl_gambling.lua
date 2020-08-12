
function MainUI()
    net.Receive("start", function(len, ply)
        frame = vgui.Create("DFrame")
        frame:SetSize(600, 430)
        frame:Center()
        frame:SetVisible(true)
        frame:MakePopup()
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
        MainSheet:AddSheet("Coinflip", List1, "icon16/coins.png", false, false, "Flip it")
        MainSheet:AddSheet("Exchange", List2, "icon16/money.png", false, false, "Exchange")
        local PanelCash = vgui.Create("DPanel", List2)
        PanelCash:SetSize(108, 23)
        PanelCash:SetPos(470, 5)
        local PanelCash1 = vgui.Create("DPanel", List1)
        PanelCash1:SetSize(108, 23)
        PanelCash1:SetPos(470, 5)

        function CoinflipTab()
            local TokenInfo = vgui.Create("DLabel", PanelCash) -- Für ExchangeTab
            local TokensCurr = 1000 --+ TokensAdd --  Dezeitige Tokens + Gekaufte Tokens
            TokenInfo:SetPos(473, -11)
            TokenInfo:SetSize(150, 57)
            TokenInfo:SetTextColor(Color(0, 0, 0))
            TokenInfo:SetParent(List2)
            TokenInfo:SetText("Deine Tokens: " .. TokensCurr) --
            local TokenInfo1 = vgui.Create("DLabel", PanelCash1) --Coinflip Tab
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
            local ImageButton = vgui.Create("DImageButton", List1)
            ImageButton:SetMaterial("vgui/kopf.png")
            ImageButton:SizeToContents()
            ImageButton:SetMouseInputEnabled(false)
            ImageButton:CenterHorizontal(0.5)
            ImageButton:SetPos(155, 0)
            local AuswahlBox = vgui.Create("DComboBox", List1)
            AuswahlBox:SetPos(5, 30)
            AuswahlBox:SetSize(100, 20)
            AuswahlBox:SetValue("Auswahl")
            AuswahlBox:AddChoice("Kopf")
            AuswahlBox:AddChoice("Zahl")
            local IKopf = "vgui/kopf.png"
            local IZahl = "vgui/zahl.png"

            AuswahlBox.OnSelect = function(self, index, value)
                if value == "Kopf" then
                    ImageButton:SetMaterial(IKopf)
                else
                    ImageButton:SetMaterial(IZahl)
                end

                local FlipButton = vgui.Create("DButton", List1)
                FlipButton:SetPos(140, 280)
                FlipButton:SetSize(290, 50)
                FlipButton:SetText("FLIP IT")
                FlipButton:SetMouseInputEnabled(true)

                FlipButton.DoClick = function()
                    local RandomNumber = math.random(1, 10)
                    TokensCurr = TokensCurr - 100
                    print("Random Number: " .. RandomNumber)

                    if value == "Kopf" and RandomNumber > 5 then
                        chat.AddText("Du hast Gewonnen")
                        ImageButton:SetMaterial(IKopf)
                        TokensCurr = TokensCurr + (100 * 2)
                    elseif value == "Kopf" and RandomNumber < 5 then
                        chat.AddText("Du hast leider Verloren")
                        ImageButton:SetMaterial(IZahl)
                    end

                    if value == "Zahl" and RandomNumber > 5 then
                        chat.AddText("Du hast Gewonnen")
                        ImageButton:SetMaterial(IZahl)
                        TokensCurr = TokensCurr + (100 * 2)
                    elseif value == "Zahl" and RandomNumber < 5 then
                        chat.AddText("Du hast leider Verloren")
                        ImageButton:SetMaterial(IKopf)
                    end

                    TokenInfo1:SetText("Deine Tokens: " .. TokensCurr)
                    TokenInfo:SetText("Deine Tokens: " .. TokensCurr)
                end
            end

            function ExchangeTab()
                local NummerInputBox = vgui.Create("DTextEntry", List2)
                NummerInputBox:SetPos(220, 45)
                NummerInputBox:SetSize(110, 26)
                NummerInputBox:SetNumeric(true)
                NummerInputBox:SetValue("Only Numbers")

                -- while NummerInputBox:IsEditing() == true do
                NummerInputBox.OnValueChange = function(self)
                    local InputEndNumber = NummerInputBox:GetInt() -- InputEndNumber = Nummer die in die Box eingegeben wurde (Enter)
                    net.Start("Exchange")
                    net.WriteUInt(InputEndNumber, 8)
                    net.SendToServer()
                end

                local UmwandelButton = vgui.Create("DButton", List2)
                UmwandelButton:SetPos(150, 110)
                UmwandelButton:SetSize(220, 43)
                UmwandelButton:SetText("Umwandeln")
                UmwandelButton:SetMouseInputEnabled(true)

                UmwandelButton.DoClick = function()
                    --  chat.AddText(InputEndNumber .. "")
                    net.Start("Exchange")
                    net.WriteBool(false)
                    net.SendToServer()
                end
            end
            net.Receive("BackToken", function ()
            local TokenBoughtCl = net.ReadUInt(8)



            end)
            ExchangeTab()
        end

        CoinflipTab()
    end)
end

MainUI()
