-- Catalog.lua
local Catalog = {}

-- scriptsTable kann von außen gesetzt werden, falls dynamisch
Catalog.scripts = {
    {Name = "SanderXV4.2.2 Brookhaven", Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/New.lua'))()"},
    {Name = "SanderXY Brookhaven", Code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/kigredns/testUIDK/refs/heads/main/panel.lua'))()"},
    {Name = "EMPTY 1", Code = "print('Script 3 ausgeführt!')"},
    {Name = "EMPTY 2", Code = "print('Script 4 ausgeführt!')"},
    {Name = "EMPTY 3", Code = "print('Script 5 ausgeführt!')"},
    {Name = "EMPTY 4", Code = "print('Script 6 ausgeführt!')"},
    {Name = "EMPTY 5", Code = "print('Script 7 ausgeführt!')"},
    {Name = "EMPTY 6", Code = "print('Script 8 ausgeführt!')"},
    {Name = "EMPTY 7", Code = "print('Script 9 ausgeführt!')"},
    {Name = "EMPTY 8", Code = "print('Script 10 ausgeführt!')"},
}

Catalog.catalogs = {
    {Name = "Main", Info = "Willkommen bei JoHub! Dieser Hub wurde von Joshy erstellt und wird jederzeit geupdatet."},
    {Name = "Scripts", Info = "Hier findest du Scripts."},
    {Name = "Settings", Info = "Hier kannst du Einstellungen vornehmen."}
}

function Catalog.createCatalogButtons(args)
    -- args: {catalogs, catalogBar, currentTheme, getBrightTextColor, getHoverColor, getPressedColor, catalogButtons, showCatalogContent, currentCatalog}
    local catalogs = args.catalogs
    local catalogBar = args.catalogBar
    local currentTheme = args.currentTheme
    local getBrightTextColor = args.getBrightTextColor
    local getHoverColor = args.getHoverColor
    local getPressedColor = args.getPressedColor
    local catalogButtons = args.catalogButtons
    local showCatalogContent = args.showCatalogContent
    local currentCatalog = args.currentCatalog
    local TweenService = game:GetService("TweenService")

    for _,btn in ipairs(catalogButtons) do btn:Destroy() end
    table.clear(catalogButtons)
    local total = #catalogs
    local spacing = 150
    local btnWidth = 140
    local barWidth = 650 - 40
    local totalWidth = total * btnWidth + (total-1) * (spacing - btnWidth)
    local startX = math.floor((barWidth - totalWidth)/2)
    for i,cat in ipairs(catalogs) do
        local btn = Instance.new("TextButton")
        btn.Text = cat.Name
        btn.Size = UDim2.new(0, btnWidth, 0, 38)
        btn.Position = UDim2.new(0, startX + (i-1)*spacing, 0, 5)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.BackgroundColor3 = currentTheme.Color
        btn.TextColor3 = getBrightTextColor()
        btn.BackgroundTransparency = 1
        btn.TextTransparency = 1
        btn.AutoButtonColor = false
        btn.Parent = catalogBar
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 16)
        table.insert(catalogButtons, btn)
        TweenService:Create(btn, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = getHoverColor(currentTheme.Color)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Color}):Play()
        end)
        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = getPressedColor(currentTheme.Color)}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = getHoverColor(currentTheme.Color)}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            if currentCatalog[1] ~= i then
                currentCatalog[1] = i
                showCatalogContent(i)
            end
        end)
    end
end

function Catalog.showCatalogContent(args)
    -- args: {index, catalogContainer, catalogContentRef, currentTheme, getBrightTextColor, showNotify, themes, setTheme, screenGui, disableJoHubBlur}
    local index = args.index
    local catalogContainer = args.catalogContainer
    local catalogContentRef = args.catalogContentRef
    local currentTheme = args.currentTheme
    local getBrightTextColor = args.getBrightTextColor
    local showNotify = args.showNotify
    local themes = args.themes
    local setTheme = args.setTheme
    local screenGui = args.screenGui
    local disableJoHubBlur = args.disableJoHubBlur
    local TweenService = game:GetService("TweenService")

    -- clear previous content
    if catalogContentRef[1] then
        catalogContentRef[1]:Destroy()
        catalogContentRef[1] = nil
    end
    if index == 1 then
        local infoText = Instance.new("TextLabel")
        infoText.Text = Catalog.catalogs[1].Info
        infoText.Size = UDim2.new(1,-20,1,-20)
        infoText.Position = UDim2.new(0,10,0,10)
        infoText.BackgroundTransparency = 1
        infoText.TextColor3 = Color3.fromRGB(255,255,255)
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 22
        infoText.TextWrapped = true
        infoText.TextTransparency = 1
        infoText.Parent = catalogContainer
        catalogContentRef[1] = infoText
        TweenService:Create(infoText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    elseif index == 2 then
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1,0,1,0)
        scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
        scrollFrame.ScrollBarThickness = 8
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.Parent = catalogContainer
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        catalogContentRef[1] = scrollFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = scrollFrame
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 10)
        local padding = Instance.new("UIPadding")
        padding.Parent = scrollFrame
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 16)
        padding.PaddingRight = UDim.new(0, 16)
        for i,script in ipairs(Catalog.scripts) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 38)
            btn.BackgroundColor3 = currentTheme.Color
            btn.TextColor3 = getBrightTextColor()
            btn.Text = script.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 18
            btn.BackgroundTransparency = 1
            btn.TextTransparency = 1
            btn.Parent = scrollFrame
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 10)
            delay(0.1*i, function()
                TweenService:Create(btn, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
            end)
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Color:lerp(Color3.new(1,1,1),0.2)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Color}):Play()
            end)
            btn.MouseButton1Down:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.Color:lerp(Color3.new(0,0,0),0.2)}):Play()
            end)
            btn.MouseButton1Up:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.Color:lerp(Color3.new(1,1,1),0.2)}):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                local success, err = pcall(function()
                    loadstring(script.Code)()
                end)
                if success then
                    showNotify("Script ausgeführt!", Color3.fromRGB(0,200,100))
                else
                    showNotify("Fehler im Script!", Color3.fromRGB(255,60,60))
                end
            end)
        end
    elseif index == 3 then
        local settingsFrame = Instance.new("Frame")
        settingsFrame.Size = UDim2.new(1,0,1,0)
        settingsFrame.BackgroundTransparency = 1
        settingsFrame.Parent = catalogContainer
        catalogContentRef[1] = settingsFrame
        local themeLabel = Instance.new("TextLabel")
        themeLabel.Text = "Theme wählen:"
        themeLabel.Size = UDim2.new(0,160,0,28)
        themeLabel.Position = UDim2.new(0,20,0,20)
        themeLabel.BackgroundTransparency = 1
        themeLabel.TextColor3 = getBrightTextColor()
        themeLabel.Font = Enum.Font.Gotham
        themeLabel.TextSize = 18
        themeLabel.TextTransparency = 1
        themeLabel.Parent = settingsFrame
        TweenService:Create(themeLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        for i,th in ipairs(themes) do
            local tbtn = Instance.new("TextButton")
            tbtn.Text = th.Name
            tbtn.Size = UDim2.new(0,90,0,28)
            tbtn.Position = UDim2.new(0,20 + (i-1)*100,0,60)
            tbtn.BackgroundColor3 = th.Color
            tbtn.TextColor3 = getBrightTextColor()
            tbtn.Font = Enum.Font.GothamBold
            tbtn.TextSize = 16
            tbtn.BackgroundTransparency = 1
            tbtn.TextTransparency = 1
            tbtn.Parent = settingsFrame
            local tbtnCorner = Instance.new("UICorner", tbtn)
            tbtnCorner.CornerRadius = UDim.new(0, 8)
            TweenService:Create(tbtn, TweenInfo.new(0.4), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
            tbtn.MouseButton1Click:Connect(function()
                setTheme(th)
            end)
        end
        local removeBtn = Instance.new("TextButton")
        removeBtn.Text = "JoHub entfernen"
        removeBtn.Size = UDim2.new(0,160,0,32)
        removeBtn.Position = UDim2.new(0,20,0,110)
        removeBtn.BackgroundColor3 = Color3.fromRGB(255,60,60)
        removeBtn.TextColor3 = getBrightTextColor()
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 16
        removeBtn.BackgroundTransparency = 1
        removeBtn.TextTransparency = 1
        removeBtn.Parent = settingsFrame
        local removeBtnCorner = Instance.new("UICorner", removeBtn)
        removeBtnCorner.CornerRadius = UDim.new(0, 8)
        TweenService:Create(removeBtn, TweenInfo.new(0.4), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
        removeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
            if disableJoHubBlur then disableJoHubBlur() end
        end)
    end
end

return Catalog
