surface.CreateFont("MainFont", {
    font = "Arial",
    size = 30,
    weight = 300,
})

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

        MainSheet.Paint = function(s, w, h)
            surface.SetDrawColor(105, 105, 105, 230)
            surface.DrawRect(12, 0, 0, w, h)
        end

        local List1 = vgui.Create("DPanelList")
        List1:SetSize(475, 355)
        List1:SetPos(5, 15)
        local List2 = vgui.Create("DPanelList")
        List2:SetSize(475, 355)
        List2:SetPos(5, 15)
        local List3 = vgui.Create("DPanelList")
        List3:SetSize(475, 355)
        List3:SetPos(5, 15)
        MainSheet:AddSheet("Coinflip", List1, "icon16/coins.png", false, false, "Flip it")
        MainSheet:AddSheet("Crash", List2, "icon16/coins.png", false, false, "Moin")
        MainSheet:AddSheet("Exchange", List3, "icon16/money.png", false, false, "Exchange")
        local PanelCash = vgui.Create("DPanel", List3)
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
            TokenInfo:SetParent(List3)
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
            ImageButton:SetMaterial("img/kopf.png")
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
            local IKopf = "img/kopf.png"
            local IZahl = "img/zahl.png"

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

            local TokensNew = TokensCurr --Tokens die durch den BackToken net. gekommen sind 

            function GuessTab()
            --Crash???
                function ExchangeTab()
                    local NumberInputBox = vgui.Create("DTextEntry", List3)
                    NumberInputBox:SetPos(240, 85)
                    NumberInputBox:SetSize(110, 26)
                    NumberInputBox:SetNumeric(true)
                    NumberInputBox:SetValue("Max. 25")

                    -- while NumberInputBox:IsEditing() == true do
                    NumberInputBox.OnValueChange = function()
                        local InputEndNumber = NumberInputBox:GetInt() -- InputEndNumber = Nummer die in die Box eingegeben wurde (Enter)
                        net.Start("Exchange")
                        net.WriteUInt(InputEndNumber, 8)
                        net.SendToServer()
                    end

                    local NumberInputBoxTokens = vgui.Create("DTextEntry", List3) --2 Für Token to Cash
                    NumberInputBoxTokens:SetPos(240, 170)
                    NumberInputBoxTokens:SetSize(110, 26)
                    NumberInputBoxTokens:SetNumeric(true)
                    NumberInputBoxTokens:SetValue("Min. 10")

                    NumberInputBoxTokens.OnValueChange = function()
                        local InputEndTokensNumber = NumberInputBoxTokens:GetInt()

                        if InputEndTokensNumber >= 10 then
                            TokensNew = TokensNew - InputEndTokensNumber
                            net.Start("ExchangeToCash")
                            net.WriteUInt(InputEndTokensNumber, 8)
                            net.SendToServer()
                            TokenInfo1:SetText("Deine Tokens: " .. TokensNew)
                            TokenInfo:SetText("Deine Tokens: " .. TokensNew)
                        end
                    end

                    local InfoKurs = vgui.Create("DLabel", List3)
                    InfoKurs:SetText("Kurs: 1€ = 10 Tokens")
                    InfoKurs:SetPos(10, 10)
                    InfoKurs:SetSize(300, 29)
                    InfoKurs:SetTextColor(Color(255, 250, 250))
                    InfoKurs:SetFont("MainFont")
                    local InfoCashToToken = vgui.Create("DLabel", List3)
                    InfoCashToToken:SetText("Cash to Tokens:")
                    InfoCashToToken:SetPos(50, -5)
                    InfoCashToToken:SetSize(3000, 200)
                    InfoCashToToken:SetTextColor(Color(0, 0, 0))
                    InfoCashToToken:SetFont("MainFont")
                    local InfoTokensToCash = vgui.Create("DLabel", List3) -- N
                    InfoTokensToCash:SetText("Tokens to Cash:")
                    InfoTokensToCash:SetPos(50, 80)
                    InfoTokensToCash:SetSize(3000, 200)
                    InfoTokensToCash:SetTextColor(Color(0, 0, 0))
                    InfoTokensToCash:SetFont("MainFont")
                    local TestButton = vgui.Create("DButton", List2)
                    TestButton:SetPos(1, 1)
                    TestButton:SetSize(60, 13)
                    TestButton:SetText("test")
                    TestButton:SetMouseInputEnabled(true)

                    /*


                    TestButton.DoClick = function()
                        net.Start("Exchange")
                        net.WriteBool(true)
                        net.SendToServer()
                    end
                    */
                end

                ExchangeTab()

                net.Receive("BackToken", function()
                    local TokenBoughtCl = net.ReadUInt(8)
                    TokensNew = TokensNew + TokenBoughtCl
                    TokenInfo1:SetText("Deine Tokens: " .. TokensNew)
                    TokenInfo:SetText("Deine Tokens: " .. TokensNew)
                end)
            end

            GuessTab()
        end

        CoinflipTab()
    end)
end

MainUI()