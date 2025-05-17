-- Roblox Exploit Compatibility: Provide fallback for missing globals (for Synapse X, KRNL, etc.)
local _G = _G or {}
local game = rawget(_G, 'game') or rawget(_ENV or {}, 'game')
local Instance = rawget(_G, 'Instance') or rawget(_ENV or {}, 'Instance')
local Enum = rawget(_G, 'Enum') or rawget(_ENV or {}, 'Enum')
local UDim2 = rawget(_G, 'UDim2') or rawget(_ENV or {}, 'UDim2')
local UDim = rawget(_G, 'UDim') or rawget(_ENV or {}, 'UDim')
local Color3 = rawget(_G, 'Color3') or rawget(_ENV or {}, 'Color3')
local TweenInfo = rawget(_G, 'TweenInfo') or rawget(_ENV or {}, 'TweenInfo')
local RunService = rawget(_G, 'RunService') or (game and game.GetService and game:GetService('RunService'))
if not wait then wait = function(t) if RunService and RunService.Stepped then return RunService.Stepped:Wait(t) else return 0 end end end
if not tick then tick = os and os.clock or function() return 0 end end
if not spawn then spawn = function(f) coroutine.wrap(f)() end end

--[[
  █████ WARNING █████
  Dieses Script ist Eigentum von k5d6r (Discord: jxb7).
  Dies ist ein Roblox Hub mit animiertem Key-Login und Script-Katalog für viele Spiele.
  Bitte ändere dieses Script nicht ohne Erlaubnis des Eigentümers!
]]

----------------------------------------------------------------------
-- Deklarationsbereich / GUI-Objekte / Variablen
----------------------------------------------------------------------

-- JoHub Roblox Script mit animiertem Key-Login und Katalog-System
-- Services
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local isOpen = false

-- Pastebin Raw Key URL (ersetzen mit deinem eigenen Link)
local KEY_URL = "https://pastebin.com/raw/UtMFpGke"

-- Bypass-User-Liste
local BYPASS_USERS = {"k5d6r", "Roblox"} -- Hier beliebig viele Usernamen eintragen

-- Theme-Konfiguration und Color-Helper aus Modul laden
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrollGamer6636/JoHub/refs/heads/main/modules/ThemeManager.lua"))()
local themes = ThemeManager.themes
local getBrightTextColor = ThemeManager.getBrightTextColor
local getHoverColor = ThemeManager.getHoverColor
local getPressedColor = ThemeManager.getPressedColor
local currentTheme = themes[1]

-- GUI-Objekte und Variablen, die von Funktionen benötigt werden
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoHubGUI"
screenGui.Parent = game.CoreGui

local openCloseBtn = Instance.new("TextButton")
openCloseBtn.Name = "JoHubOpenClose"
openCloseBtn.Size = UDim2.new(0, 56, 0, 56)
openCloseBtn.Position = UDim2.new(0, 24, 0.5, -28)
openCloseBtn.BackgroundColor3 = Color3.fromRGB(255,0,200)
openCloseBtn.BackgroundTransparency = 0.15
openCloseBtn.ZIndex = 10
openCloseBtn.Parent = screenGui
openCloseBtn.Visible = false
openCloseBtn.AutoButtonColor = false
local btnCircle = Instance.new("UICorner", openCloseBtn)
btnCircle.CornerRadius = UDim.new(1,0)
local jhLabel = Instance.new("TextLabel")
jhLabel.Text = "JH"
jhLabel.Font = Enum.Font.GothamBlack
jhLabel.TextSize = 28
jhLabel.TextColor3 = Color3.fromRGB(255,255,255)
jhLabel.BackgroundTransparency = 1
jhLabel.Size = UDim2.new(1,0,1,0)
jhLabel.Parent = openCloseBtn
jhLabel.ZIndex = 11

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 480, 0, 200) -- Breiter gemacht
keyFrame.Position = UDim2.new(0.5, -240, 0.5, -100)
keyFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
keyFrame.BackgroundTransparency = 1 -- Startet unsichtbar für Animation
keyFrame.BorderSizePixel = 0
keyFrame.Visible = false -- Startet unsichtbar für Animation
keyFrame.Parent = screenGui
local keyCorner = Instance.new("UICorner", keyFrame)
keyCorner.CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel")
title.Text = "JoHub Key Login"
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextColor3 = Color3.fromRGB(255,0,200)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,0,0,44)
title.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.PlaceholderText = "Paste your key here..."
keyBox.Size = UDim2.new(0.88,0,0,40) -- Breiter gemacht
keyBox.Position = UDim2.new(0.06,0,0.38,0) -- Zentriert
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 20
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(0,0,0)
keyBox.BackgroundColor3 = Color3.fromRGB(255,220,255)
keyBox.BackgroundTransparency = 0.1
keyBox.Parent = keyFrame
keyBox.TextXAlignment = Enum.TextXAlignment.Left -- Links ausrichten für normales Verhalten
keyBox.ClearTextOnFocus = false
keyBox.TextWrapped = false
keyBox.ClipsDescendants = true -- Clipping aktivieren, damit Text nicht "rausläuft"
keyBox.TextEditable = true
keyBox.TextTruncate = Enum.TextTruncate.AtEnd -- Text am Ende abschneiden, falls zu lang
local keyBoxCorner = Instance.new("UICorner", keyBox)
keyBoxCorner.CornerRadius = UDim.new(0, 12)

local loginBtn = Instance.new("TextButton")
loginBtn.Text = "Login"
loginBtn.Size = UDim2.new(0.5,0,0,36)
loginBtn.Position = UDim2.new(0.25,0,0.7,0)
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 20
loginBtn.BackgroundColor3 = Color3.fromRGB(255,0,200)
loginBtn.TextColor3 = Color3.fromRGB(255,255,255)
loginBtn.BackgroundTransparency = 0.1
loginBtn.Parent = keyFrame
local loginBtnCorner = Instance.new("UICorner", loginBtn)
loginBtnCorner.CornerRadius = UDim.new(0, 10)

local notify = Instance.new("TextLabel")
notify.Text = ""
notify.Size = UDim2.new(1, -40, 0, 32)
notify.Position = UDim2.new(0, 20, 1, -38)
notify.BackgroundTransparency = 0.2
notify.BackgroundColor3 = Color3.fromRGB(60,0,80)
notify.TextColor3 = Color3.fromRGB(255,255,255)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 18
notify.Visible = false
notify.Parent = keyFrame
local notifyCorner = Instance.new("UICorner", notify)
notifyCorner.CornerRadius = UDim.new(0, 8)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 420)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 24)

local mainTitle = Instance.new("TextLabel")
mainTitle.Text = "JoHub"
mainTitle.Font = Enum.Font.GothamBlack
mainTitle.TextSize = 48
mainTitle.TextColor3 = Color3.fromRGB(255,0,200)
mainTitle.BackgroundTransparency = 1
mainTitle.Size = UDim2.new(1,0,0,70)
mainTitle.Position = UDim2.new(0,0,0,0)
mainTitle.ZIndex = 3
mainTitle.Parent = mainFrame

-- Close-Button oben rechts im JoHub (muss VOR applyTheme deklariert werden!)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Size = UDim2.new(0,36,0,36)
closeBtn.Position = UDim2.new(1,-44,0,8)
closeBtn.BackgroundColor3 = Color3.fromRGB(60,0,80)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundTransparency = 0.15
closeBtn.ZIndex = 10
closeBtn.Parent = mainFrame
local closeBtnCorner = Instance.new("UICorner", closeBtn)
closeBtnCorner.CornerRadius = UDim.new(1,0)

local catalogBar = Instance.new("Frame")
catalogBar.Size = UDim2.new(1, -40, 0, 48)
catalogBar.Position = UDim2.new(0, 20, 0, 80)
catalogBar.BackgroundTransparency = 1 -- Immer transparent, egal welches Theme
catalogBar.Parent = mainFrame

local catalogs = {
    {Name = "Main", Info = "Willkommen bei JoHub! Dieser Hub wurde von Joshy erstellt und wird jederzeit geupdatet."},
    {Name = "Scripts", Info = "Hier findest du Scripts."},
    {Name = "Settings", Info = "Hier kannst du Einstellungen vornehmen."}
}

local currentCatalog = 1
local catalogButtons = {}
local catalogContent = nil

local catalogContainer = Instance.new("Frame")
catalogContainer.Size = UDim2.new(1, -40, 1, -140)
catalogContainer.Position = UDim2.new(0, 20, 0, 130)
catalogContainer.BackgroundTransparency = 1 -- Komplett transparent
catalogContainer.BackgroundColor3 = Color3.fromRGB(40, 0, 60) -- Farbe egal, da unsichtbar
catalogContainer.Parent = mainFrame
local catalogCorner = Instance.new("UICorner", catalogContainer)
catalogCorner.CornerRadius = UDim.new(0, 18)

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Name = "WelcomeLabel"
welcomeLabel.Text = ""
welcomeLabel.Size = UDim2.new(1,-20,0,36)
welcomeLabel.Position = UDim2.new(0,10,0,10)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.TextColor3 = Color3.fromRGB(255,255,255)
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 24
welcomeLabel.TextTransparency = 1
welcomeLabel.Visible = false
welcomeLabel.Parent = catalogContainer

----------------------------------------------------------------------
-- Musik-Logik
----------------------------------------------------------------------

-- Musik-Objekte
local keyMusic = Instance.new("Sound")
keyMusic.Name = "JoHubKeyMusic"
keyMusic.SoundId = "rbxassetid://1841647093" -- Neue Key-Login Musik
keyMusic.Volume = 0.18
keyMusic.Looped = true
keyMusic.Parent = screenGui

local transitionMusic = Instance.new("Sound")
transitionMusic.Name = "JoHubTransitionMusic"
transitionMusic.SoundId = "rbxassetid://9047885144" -- Neue Übergangsmusik-ID
transitionMusic.Volume = 0.45
transitionMusic.Looped = false
transitionMusic.Parent = screenGui

local function playKeyMusic()
    if not keyMusic.IsPlaying then
        keyMusic.Volume = 0.18
        keyMusic:Play()
    end
end
local function stopKeyMusic()
    if keyMusic.IsPlaying then
        -- Fading out the key music
        local fadeTween = TweenService:Create(keyMusic, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = 0})
        fadeTween:Play()
        fadeTween.Completed:Wait()
        keyMusic:Stop()
        keyMusic.Volume = 0.18 -- Reset volume for next play
    end
end
local function playTransitionMusic()
    transitionMusic:Play()
end
local function stopTransitionMusic()
    if transitionMusic.IsPlaying then
        -- Fading out the transition music
        local fadeTween = TweenService:Create(transitionMusic, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = 0})
        fadeTween:Play()
        fadeTween.Completed:Wait()
        transitionMusic:Stop()
        transitionMusic.Volume = 0.45 -- Reset volume for next play
    end
end

----------------------------------------------------------------------
-- Button-Logik (Katalog, Scripts, Theme, etc.)
----------------------------------------------------------------------

-- Theme auf alle relevanten GUI-Elemente anwenden
-- Muss nach der Deklaration aller GUI-Objekte stehen, aber noch im Funktionsbereich!
local function applyTheme(theme)
    currentTheme = theme
    -- Hauptfarben
    mainFrame.BackgroundColor3 = theme.Bg
    mainFrame.BackgroundTransparency = 0.25
    keyFrame.BackgroundColor3 = theme.Bg
    keyFrame.BackgroundTransparency = 0.15
    catalogContainer.BackgroundColor3 = theme.BgAccent
    catalogContainer.BackgroundTransparency = 0.15
    -- catalogBar bleibt immer transparent!
    openCloseBtn.BackgroundColor3 = theme.Color
    openCloseBtn.BackgroundTransparency = 0.15
    closeBtn.BackgroundColor3 = theme.Color
    closeBtn.BackgroundTransparency = 0.15
    loginBtn.BackgroundColor3 = theme.Color
    loginBtn.BackgroundTransparency = 0.1
    -- Textfarben
    mainTitle.TextColor3 = getBrightTextColor()
    title.TextColor3 = getBrightTextColor()
    loginBtn.TextColor3 = getBrightTextColor()
    keyBox.TextColor3 = Color3.fromRGB(0,0,0)
    notify.TextColor3 = getBrightTextColor()
    closeBtn.TextColor3 = getBrightTextColor()
    openCloseBtn.TextColor3 = getBrightTextColor()
    -- Katalog-Buttons
    for _,b in ipairs(catalogButtons) do
        b.BackgroundColor3 = theme.Color
        b.BackgroundTransparency = 0.15
        b.TextColor3 = getBrightTextColor()
    end
    -- Katalog-Inhalte
    if catalogContent then
        for _,child in ipairs(catalogContent:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                child.TextColor3 = getBrightTextColor()
            end
            if child:IsA("TextButton") then
                child.BackgroundColor3 = theme.Color
                child.BackgroundTransparency = 0.15
            elseif child:IsA("Frame") then
                child.BackgroundColor3 = theme.BgAccent
                child.BackgroundTransparency = 0.15
            end
        end
    end
    -- Blitzeffekte (Frames mit ZIndex=4 im mainTitle)
    for _,child in ipairs(mainTitle:GetChildren()) do
        if child:IsA("Frame") and child.ZIndex == 4 then
            child.BackgroundColor3 = theme.Color
        end
    end
    -- JoHub-Label im Open/Close-Button
    if jhLabel then
        jhLabel.TextColor3 = getBrightTextColor()
        jhLabel.TextStrokeTransparency = 0.5
        jhLabel.TextStrokeColor3 = theme.BgAccent
    end
end

applyTheme(currentTheme)

-- Klick-Sound Setup
local clickSound = Instance.new("Sound")
clickSound.Name = "JoHubClickSound"
clickSound.SoundId = "rbxassetid://87437544236708" -- Klick-Sound (Click)
clickSound.Volume = 0.5
clickSound.Parent = screenGui

-- Hover-Sound Setup
local hoverSound = Instance.new("Sound")
hoverSound.Name = "JoHubHoverSound"
hoverSound.SoundId = "rbxassetid://18133558673" -- UI_Select Sound (Hover)
hoverSound.Volume = 0.4
hoverSound.Parent = screenGui

local function playClick()
    if clickSound.IsLoaded then
        clickSound:Play()
    else
        clickSound.Loaded:Wait()
        clickSound:Play()
    end
end

local function playHover()
    if hoverSound.IsLoaded then
        hoverSound:Play()
    else
        hoverSound.Loaded:Wait()
        hoverSound:Play()
    end
end

-- Funktionsdefinitionen (ALLE FUNKTIONEN OBEN)

local function enableJoHubBlur()
    if not Lighting:FindFirstChild("JoHubBlur") then
        local blur = Instance.new("BlurEffect")
        blur.Name = "JoHubBlur"
        blur.Size = 18
        blur.Parent = Lighting
    end
end

local function disableJoHubBlur()
    if Lighting:FindFirstChild("JoHubBlur") then
        Lighting.JoHubBlur:Destroy()
    end
end

local function setCatalogButtonsVisible(visible, animate)
    for _,btn in ipairs(catalogButtons) do
        if animate then
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = visible and 0.15 or 1, TextTransparency = visible and 0 or 1}):Play()
        else
            btn.BackgroundTransparency = visible and 0.15 or 1
            btn.TextTransparency = visible and 0 or 1
        end
        btn.Visible = visible
    end
end

local sessionStartTime = tick() -- Session-Start global merken

function createCatalogButtons()
    for _,btn in ipairs(catalogButtons) do btn:Destroy() end
    catalogButtons = {}
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
        btn.ZIndex = mainFrame.ZIndex + 1 -- ZIndex +1 für Button
        btn.Parent = catalogBar
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 16)
        -- TextLabel im Button explizit ZIndex +1
        for _,child in ipairs(btn:GetChildren()) do
            if child:IsA("TextLabel") then
                child.ZIndex = btn.ZIndex + 1
            end
        end
        table.insert(catalogButtons, btn)
        TweenService:Create(btn, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
        btn.MouseEnter:Connect(function()
            playHover()
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
        btn.MouseButton1Click:Connect(playClick)
        btn.MouseButton1Click:Connect(function()
            if currentCatalog ~= i then
                currentCatalog = i
                showCatalogContent(i)
            end
        end)
    end
end

local function clearCatalogContent(callback)
    if catalogContent then
        if catalogContent:IsA("TextLabel") then
            local tween = TweenService:Create(catalogContent, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
            tween:Play()
            tween.Completed:Wait()
            catalogContent:Destroy()
        elseif catalogContent:IsA("Frame") then
            for _,child in ipairs(catalogContent:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("TextLabel") then
                    pcall(function()
                        TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                    end)
                end
            end
            wait(0.3)
            catalogContent:Destroy()
        else
            catalogContent:Destroy()
        end
        catalogContent = nil
        if callback then callback() end
    elseif callback then
        callback()
    end
end

-- Scripts-Module laden
local Scripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrollGamer6636/JoHub/refs/heads/main/modules/Scripts.lua"))()

function showCatalogContent(index)
    clearCatalogContent()
    if index == 1 then
        -- Einheitliches 2x2-Grid für die vier Felder
        local mainPanel = Instance.new("Frame")
        mainPanel.Size = UDim2.new(1,-20,1,-20)
        mainPanel.Position = UDim2.new(0,10,0,10)
        mainPanel.BackgroundTransparency = 1
        mainPanel.ZIndex = mainFrame.ZIndex + 1
        mainPanel.Parent = catalogContainer
        catalogContent = mainPanel

        -- Grid-Konfiguration
        local gridRows, gridCols = 2, 2
        local gridPadding = 16
        local cellW = (mainPanel.AbsoluteSize.X - gridPadding * (gridCols+1)) / gridCols
        local cellH = (mainPanel.AbsoluteSize.Y - gridPadding * (gridRows+1)) / gridRows
        -- Da AbsoluteSize erst nach Parent-Set verfügbar ist, statisch setzen:
        cellW = 280
        cellH = 110

        -- Helper für Felder
        local function createField(x, y)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, cellW, 0, cellH)
            f.Position = UDim2.new(0, gridPadding + (x-1)*(cellW+gridPadding), 0, gridPadding + (y-1)*(cellH+gridPadding))
            f.BackgroundColor3 = currentTheme.BgAccent
            f.BackgroundTransparency = 0.04
            f.ZIndex = mainPanel.ZIndex + 1
            f.Parent = mainPanel
            local c = Instance.new("UICorner", f)
            c.CornerRadius = UDim.new(0, 22)
            return f
        end

        -- 1. Feld: Profilbild
        local avatarField = createField(1,1)
        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size = UDim2.new(0, 70, 0, 70)
        avatarImg.Position = UDim2.new(0, 20, 0, 20)
        avatarImg.BackgroundTransparency = 1
        avatarImg.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", player.UserId)
        avatarImg.ZIndex = avatarField.ZIndex + 1
        avatarImg.Parent = avatarField
        local avatarCorner = Instance.new("UICorner", avatarImg)
        avatarCorner.CornerRadius = UDim.new(1,0)
        avatarImg.ImageTransparency = 0.08
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = player.Name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 20
        nameLabel.TextColor3 = getBrightTextColor()
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 100, 0, 35)
        nameLabel.Size = UDim2.new(1,-110,0,30)
        nameLabel.ZIndex = avatarField.ZIndex + 1
        nameLabel.Parent = avatarField

        -- 2. Feld: Willkommen/Datum/Session
        local welcomeField = createField(2,1)
        -- Willkommen, USER! ❤️ (Herz in Rot als separates Label)
        local welcome = Instance.new("TextLabel")
        welcome.Text = "Willkommen, "..player.Name.."!"
        welcome.Font = Enum.Font.GothamBold
        welcome.TextSize = 20
        welcome.TextColor3 = getBrightTextColor()
        welcome.BackgroundTransparency = 1
        welcome.Position = UDim2.new(0,16,0,10)
        welcome.Size = UDim2.new(1,-32,0,28)
        welcome.ZIndex = welcomeField.ZIndex + 1
        welcome.Parent = welcomeField
        -- Herz-Label (rot)
        local heartLabel = Instance.new("TextLabel")
        heartLabel.Text = "❤️"
        heartLabel.Font = Enum.Font.GothamBold
        heartLabel.TextSize = 20
        heartLabel.TextColor3 = Color3.fromRGB(255,0,120)
        heartLabel.BackgroundTransparency = 1
        heartLabel.Position = UDim2.new(0, 170, 0, 10)
        heartLabel.Size = UDim2.new(0, 28, 0, 28)
        heartLabel.ZIndex = welcomeField.ZIndex + 2
        heartLabel.Parent = welcomeField
        -- Positioniere das Herz nach dem Rendern korrekt
        spawn(function()
            wait() -- Einen Frame warten, damit TextBounds stimmt
            heartLabel.Position = UDim2.new(0, welcome.TextBounds.X + 24, 0, 10)
        end)
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Text = ""
        dateLabel.Font = Enum.Font.Gotham
        dateLabel.TextSize = 16
        dateLabel.TextColor3 = getBrightTextColor()
        dateLabel.BackgroundTransparency = 1
        dateLabel.Position = UDim2.new(0,16,0,40)
        dateLabel.Size = UDim2.new(1,-32,0,20)
        dateLabel.ZIndex = welcomeField.ZIndex + 1
        dateLabel.Parent = welcomeField
        local sessionLabel = Instance.new("TextLabel")
        sessionLabel.Text = "Session: 0s"
        sessionLabel.Font = Enum.Font.Gotham
        sessionLabel.TextSize = 16
        sessionLabel.TextColor3 = getBrightTextColor()
        sessionLabel.BackgroundTransparency = 1
        sessionLabel.Position = UDim2.new(0,16,0,65)
        sessionLabel.Size = UDim2.new(1,-32,0,20)
        sessionLabel.ZIndex = welcomeField.ZIndex + 1
        sessionLabel.Parent = welcomeField
        spawn(function()
            while mainPanel.Parent do
                local now = os.date("%d.%m.%Y %H:%M:%S")
                dateLabel.Text = now
                local elapsed = math.floor(tick()-sessionStartTime)
                local min = math.floor(elapsed/60)
                local sec = elapsed%60
                sessionLabel.Text = string.format("Session: %dm %ds", min, sec)
                wait(1)
            end
        end)

        -- 3. Feld: Statistiken
        local statsField = createField(1,2)
        local statsLabel = Instance.new("TextLabel")
        -- Zeige Scripts, aktuelle Uhrzeit und Session-Dauer (statt Session-Starts)
        statsLabel.Text = string.format("Scripts: %d\nUhrzeit: %s\nDauer: 0m 0s", #Scripts.list, os.date("%H:%M:%S"))
        statsLabel.Font = Enum.Font.Gotham
        statsLabel.TextSize = 16
        statsLabel.TextColor3 = getBrightTextColor()
        statsLabel.BackgroundTransparency = 1
        statsLabel.Size = UDim2.new(1,0,1,0)
        statsLabel.TextWrapped = true
        statsLabel.TextYAlignment = Enum.TextYAlignment.Center
        statsLabel.ZIndex = statsField.ZIndex + 1
        statsLabel.Parent = statsField
        -- Live-Update für Uhrzeit und Dauer
        spawn(function()
            while mainPanel.Parent and statsLabel.Parent do
                local elapsed = math.floor(tick()-sessionStartTime)
                local min = math.floor(elapsed/60)
                local sec = elapsed%60
                statsLabel.Text = string.format("Scripts: %d\nUhrzeit: %s\nDauer: %dm %ds", #Scripts.list, os.date("%H:%M:%S"), min, sec)
                wait(1)
            end
        end)
    end
end