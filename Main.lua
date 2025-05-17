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
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local isOpen = false

-- Pastebin Raw Key URL (ersetzen mit deinem eigenen Link)
local KEY_URL = "https://pastebin.com/raw/UtMFpGke"

-- Bypass-User-Liste
local BYPASS_USERS = {"k5d2r", "Roblox"} -- Hier beliebig viele Usernamen eintragen

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
        btn.Parent = catalogBar
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 16)
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
        -- Neues Main-Katalog-Layout mit eigenen Feldern und dunklerem Hintergrund
        local function darker(color, percent)
            -- Prozent negativ für dunkler
            local f = 1 + percent
            return Color3.new(
                math.clamp(color.R * f, 0, 1),
                math.clamp(color.G * f, 0, 1),
                math.clamp(color.B * f, 0, 1)
            )
        end

        local mainPanel = Instance.new("Frame")
        mainPanel.Size = UDim2.new(1,-20,1,-20)
        mainPanel.Position = UDim2.new(0,10,0,10)
        mainPanel.BackgroundTransparency = 1
        mainPanel.Parent = catalogContainer
        catalogContent = mainPanel

        -- Oben links: Profilbild mit Feld
        local avatarField = Instance.new("Frame")
        avatarField.Size = UDim2.new(0, 120, 0, 120)
        avatarField.Position = UDim2.new(0, 0, 0, 0)
        avatarField.BackgroundColor3 = currentTheme.BgAccent
        avatarField.BackgroundTransparency = 0.04 -- weniger durchsichtig
        avatarField.Parent = mainPanel
        local avatarFieldCorner = Instance.new("UICorner", avatarField)
        avatarFieldCorner.CornerRadius = UDim.new(0, 22)
        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size = UDim2.new(0, 80, 0, 80)
        avatarImg.Position = UDim2.new(0, 20, 0, 20)
        avatarImg.BackgroundTransparency = 1
        avatarImg.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", player.UserId)
        avatarImg.Parent = avatarField
        local avatarCorner = Instance.new("UICorner", avatarImg)
        avatarCorner.CornerRadius = UDim.new(1,0)
        avatarImg.ImageTransparency = 0.08

        -- Oben rechts: Willkommen, Datum/Uhrzeit, Session mit Feld
        local topRightField = Instance.new("Frame")
        topRightField.Size = UDim2.new(0, 320, 0, 120)
        topRightField.Position = UDim2.new(1, -320, 0, 0)
        topRightField.BackgroundColor3 = currentTheme.BgAccent
        topRightField.BackgroundTransparency = 0.04
        topRightField.Parent = mainPanel
        local topRightCorner = Instance.new("UICorner", topRightField)
        topRightCorner.CornerRadius = UDim.new(0, 22)
        local welcome = Instance.new("TextLabel")
        welcome.Text = "Willkommen, "..player.Name
        welcome.Font = Enum.Font.GothamBold
        welcome.TextSize = 24
        welcome.TextColor3 = getBrightTextColor()
        welcome.BackgroundTransparency = 1
        welcome.Position = UDim2.new(0,16,0,10)
        welcome.Size = UDim2.new(1,-32,0,32)
        welcome.Parent = topRightField
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Text = ""
        dateLabel.Font = Enum.Font.Gotham
        dateLabel.TextSize = 18
        dateLabel.TextColor3 = getBrightTextColor()
        dateLabel.BackgroundTransparency = 1
        dateLabel.Position = UDim2.new(0,16,0,44)
        dateLabel.Size = UDim2.new(1,-32,0,24)
        dateLabel.Parent = topRightField
        local sessionLabel = Instance.new("TextLabel")
        sessionLabel.Text = "Session: 0s"
        sessionLabel.Font = Enum.Font.Gotham
        sessionLabel.TextSize = 18
        sessionLabel.TextColor3 = getBrightTextColor()
        sessionLabel.BackgroundTransparency = 1
        sessionLabel.Position = UDim2.new(0,16,0,72)
        sessionLabel.Size = UDim2.new(1,-32,0,24)
        sessionLabel.Parent = topRightField
        local startTime = tick()
        spawn(function()
            while mainPanel.Parent do
                local now = os.date("%d.%m.%Y %H:%M:%S")
                dateLabel.Text = now
                local elapsed = math.floor(tick()-startTime)
                local min = math.floor(elapsed/60)
                local sec = elapsed%60
                sessionLabel.Text = string.format("Session: %dm %ds", min, sec)
                wait(1)
            end
        end)

        -- Unten links: Statistiken mit Feld
        local statsField = Instance.new("Frame")
        statsField.Size = UDim2.new(0, 220, 0, 80)
        statsField.Position = UDim2.new(0, 0, 1, -80)
        statsField.BackgroundColor3 = currentTheme.BgAccent
        statsField.BackgroundTransparency = 0.04
        statsField.Parent = mainPanel
        local statsCorner = Instance.new("UICorner", statsField)
        statsCorner.CornerRadius = UDim.new(0, 18)
        local statsLabel = Instance.new("TextLabel")
        statsLabel.Text = string.format("Scripts: %d\nSession-Starts: 1", #Scripts.list)
        statsLabel.Font = Enum.Font.Gotham
        statsLabel.TextSize = 18
        statsLabel.TextColor3 = getBrightTextColor()
        statsLabel.BackgroundTransparency = 1
        statsLabel.Size = UDim2.new(1,0,1,0)
        statsLabel.TextWrapped = true
        statsLabel.TextYAlignment = Enum.TextYAlignment.Top
        statsLabel.Parent = statsField

        -- Unten rechts: Credits + Feedback mit Feld
        local creditsField = Instance.new("Frame")
        creditsField.Size = UDim2.new(0, 220, 0, 80)
        creditsField.Position = UDim2.new(1, -220, 1, -80)
        creditsField.BackgroundColor3 = currentTheme.BgAccent
        creditsField.BackgroundTransparency = 0.04
        creditsField.Parent = mainPanel
        local creditsCorner = Instance.new("UICorner", creditsField)
        creditsCorner.CornerRadius = UDim.new(0, 18)
        local creditsLabel = Instance.new("TextLabel")
        creditsLabel.Text = "JoHub by k5d6r\nDesign: Joshy"
        creditsLabel.Font = Enum.Font.Gotham
        creditsLabel.TextSize = 16
        creditsLabel.TextColor3 = getBrightTextColor()
        creditsLabel.BackgroundTransparency = 1
        creditsLabel.Size = UDim2.new(1,0,0,40)
        creditsLabel.TextYAlignment = Enum.TextYAlignment.Top
        creditsLabel.Parent = creditsField
        local feedbackBtn = Instance.new("TextButton")
        feedbackBtn.Text = "Feedback senden"
        feedbackBtn.Font = Enum.Font.GothamBold
        feedbackBtn.TextSize = 18
        feedbackBtn.BackgroundColor3 = currentTheme.Color
        feedbackBtn.TextColor3 = getBrightTextColor()
        feedbackBtn.BackgroundTransparency = 0.08
        feedbackBtn.Size = UDim2.new(1,0,0,32)
        feedbackBtn.Position = UDim2.new(0,0,1,-32)
        feedbackBtn.Parent = creditsField
        local feedbackBtnCorner = Instance.new("UICorner", feedbackBtn)
        feedbackBtnCorner.CornerRadius = UDim.new(0, 8)
        feedbackBtn.MouseEnter:Connect(playHover)
        feedbackBtn.MouseButton1Click:Connect(playClick)
        feedbackBtn.MouseButton1Click:Connect(function()
            -- Feedback-Modal im JoHub-Theme
            local modal = Instance.new("Frame")
            modal.Size = UDim2.new(0, 420, 0, 260)
            modal.Position = UDim2.new(0.5, -210, 0.5, -130)
            modal.BackgroundColor3 = currentTheme.BgAccent
            modal.BackgroundTransparency = 0.04
            modal.ZIndex = 1000
            modal.Parent = screenGui
            local modalCorner = Instance.new("UICorner", modal)
            modalCorner.CornerRadius = UDim.new(0, 18)
            -- User Label
            local userLabel = Instance.new("TextLabel")
            userLabel.Text = "User: "..player.Name
            userLabel.Font = Enum.Font.GothamBold
            userLabel.TextSize = 20
            userLabel.TextColor3 = getBrightTextColor()
            userLabel.BackgroundTransparency = 1
            userLabel.Position = UDim2.new(0,20,0,20)
            userLabel.Size = UDim2.new(1,-40,0,32)
            userLabel.Parent = modal
            -- Feedback Box
            local fbBox = Instance.new("TextBox")
            fbBox.PlaceholderText = "Dein Feedback (max 1000 Zeichen)..."
            fbBox.Text = ""
            fbBox.Font = Enum.Font.Gotham
            fbBox.TextSize = 18
            fbBox.TextColor3 = getBrightTextColor()
            fbBox.BackgroundColor3 = currentTheme.Bg
            fbBox.BackgroundTransparency = 0.08
            fbBox.Position = UDim2.new(0,20,0,62)
            fbBox.Size = UDim2.new(1,-40,0,90)
            fbBox.TextWrapped = true
            fbBox.TextYAlignment = Enum.TextYAlignment.Top
            fbBox.ClearTextOnFocus = false
            fbBox.ClipsDescendants = true
            fbBox.TextEditable = true
            fbBox.TextTruncate = Enum.TextTruncate.AtEnd
            fbBox.Parent = modal
            local fbBoxCorner = Instance.new("UICorner", fbBox)
            fbBoxCorner.CornerRadius = UDim.new(0, 10)
            -- Zeichenlimit
            fbBox:GetPropertyChangedSignal("Text"):Connect(function()
                if #fbBox.Text > 1000 then
                    fbBox.Text = string.sub(fbBox.Text, 1, 1000)
                end
            end)
            -- Senden-Button
            local sendBtn = Instance.new("TextButton")
            sendBtn.Text = "Senden"
            sendBtn.Font = Enum.Font.GothamBold
            sendBtn.TextSize = 20
            sendBtn.BackgroundColor3 = currentTheme.Color
            sendBtn.TextColor3 = getBrightTextColor()
            sendBtn.BackgroundTransparency = 0.08
            sendBtn.Size = UDim2.new(0.5, -16, 0, 36)
            sendBtn.Position = UDim2.new(0, 20, 1, -56)
            sendBtn.Parent = modal
            local sendBtnCorner = Instance.new("UICorner", sendBtn)
            sendBtnCorner.CornerRadius = UDim.new(0, 8)
            sendBtn.MouseEnter:Connect(playHover)
            sendBtn.MouseButton1Click:Connect(playClick)
            -- Cancel-Button
            local cancelBtn = Instance.new("TextButton")
            cancelBtn.Text = "Abbrechen"
            cancelBtn.Font = Enum.Font.Gotham
            cancelBtn.TextSize = 18
            cancelBtn.BackgroundColor3 = currentTheme.Bg
            cancelBtn.TextColor3 = getBrightTextColor()
            cancelBtn.BackgroundTransparency = 0.08
            cancelBtn.Size = UDim2.new(0.5, -16, 0, 36)
            cancelBtn.Position = UDim2.new(0.5, 12, 1, -56)
            cancelBtn.Parent = modal
            local cancelBtnCorner = Instance.new("UICorner", cancelBtn)
            cancelBtnCorner.CornerRadius = UDim.new(0, 8)
            cancelBtn.MouseEnter:Connect(playHover)
            cancelBtn.MouseButton1Click:Connect(playClick)
            cancelBtn.MouseButton1Click:Connect(function()
                modal:Destroy()
            end)
            -- Senden-Logik
            sendBtn.MouseButton1Click:Connect(function()
                local feedback = fbBox.Text
                if feedback == "" then
                    showNotify("Bitte Feedback eingeben!", Color3.fromRGB(255,140,0), modal, 1.2)
                    return
                end
                sendBtn.Active = false
                sendBtn.Text = "Sende..."
                -- Discord Webhook (hier eintragen!)
                local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1373421247051993159/DFxbh21UXjLTMrEVJWgUpif2f1jEl9KuQ8L5OoUPoM4Y9bVT3cls7GVx2REhJB55y-p-"
                local data = {
                    ["embeds"] = {
                        {
                            ["title"] = player.Name.." hat ein Feedback gesendet:",
                            ["description"] = feedback,
                            ["color"] = 16711935 -- Magenta
                        }
                    }
                }
                local json = HttpService:JSONEncode(data)
                pcall(function()
                    HttpService:PostAsync(DISCORD_WEBHOOK, json, Enum.HttpContentType.ApplicationJson)
                end)
                -- Danke-Animation
                fbBox.Visible = false
                sendBtn.Visible = false
                cancelBtn.Visible = false
                local thx = Instance.new("TextLabel")
                thx.Text = "Danke für dein Feedback <3"
                thx.Font = Enum.Font.GothamBold
                thx.TextSize = 26
                thx.TextColor3 = currentTheme.Color
                thx.BackgroundTransparency = 1
                thx.Size = UDim2.new(1,0,0,60)
                thx.Position = UDim2.new(0,0,0.5,-30)
                thx.Parent = modal
                thx.TextTransparency = 1
                TweenService:Create(thx, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
                wait(1.2)
                TweenService:Create(thx, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                wait(0.4)
                modal:Destroy()
            end)
        end)
        -- Animationen für alle Felder
        for _,obj in ipairs(mainPanel:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                obj.TextTransparency = 1
                TweenService:Create(obj, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            end
            if obj:IsA("ImageLabel") then
                obj.ImageTransparency = 1
                TweenService:Create(obj, TweenInfo.new(0.5), {ImageTransparency = 0.08}):Play()
            end
            if obj:IsA("Frame") and obj ~= mainPanel then
                obj.BackgroundTransparency = 1
                TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundTransparency = 0.04}):Play()
            end
        end
    elseif index == 2 then
        -- Script-Liste aus Modul verwenden
        local scripts = Scripts.list
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1,0,1,0)
        scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
        scrollFrame.ScrollBarThickness = 8
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.Parent = catalogContainer
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        catalogContent = scrollFrame

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

        for i,script in ipairs(scripts) do
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
        settingsFrame.BackgroundTransparency = 1 -- Transparent machen
        settingsFrame.Parent = catalogContainer
        catalogContent = settingsFrame
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
            tbtn.MouseEnter:Connect(playHover)
            tbtn.MouseButton1Click:Connect(playClick)
            tbtn.MouseButton1Click:Connect(function()
                currentTheme = th
                createCatalogButtons()
                showCatalogContent(currentCatalog)
                applyTheme(currentTheme)
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
        removeBtn.MouseEnter:Connect(playHover)
        removeBtn.MouseButton1Click:Connect(playClick)
        removeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
            disableJoHubBlur()
        end)
    end
end

----------------------------------------------------------------------
-- Restliche Logik (Notify, Welcome, Sichtbarkeit, Events, Drag, etc.)
----------------------------------------------------------------------

local function showNotify(text, color, parent, duration)
    notify.Parent = parent or keyFrame
    notify.Position = UDim2.new(0, 20, 1, -38)
    notify.Size = UDim2.new(1, -40, 0, 32)
    notify.Text = text
    notify.BackgroundColor3 = color or Color3.fromRGB(60,0,80)
    notify.Visible = true
    notify.TextTransparency = 1
    notify.BackgroundTransparency = 1
    TweenService:Create(notify, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0.2}):Play()
    wait(duration or 1.2)
    TweenService:Create(notify, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    wait(0.3)
    notify.Visible = false
end

local function showWelcomeAnimated(callback)
    -- Erstelle zentrierten Screen
    local welcomeFrame = Instance.new("Frame")
    welcomeFrame.Size = UDim2.new(1,0,1,0)
    welcomeFrame.BackgroundTransparency = 1
    welcomeFrame.ZIndex = 100
    welcomeFrame.Parent = screenGui

    -- JoHub-Logo darunter (optional, falls gewünscht)
    local logoText = Instance.new("TextLabel")
    logoText.Text = "JoHub"
    logoText.Font = Enum.Font.GothamBlack
    logoText.TextSize = 48
    logoText.TextColor3 = Color3.fromRGB(255,0,200)
    logoText.BackgroundTransparency = 1
    logoText.AnchorPoint = Vector2.new(0.5,0)
    logoText.Position = UDim2.new(0.5,0,0.5,40)
    logoText.Size = UDim2.new(0, 400, 0, 60)
    logoText.ZIndex = 101
    logoText.Parent = welcomeFrame
    logoText.TextTransparency = 1
    TweenService:Create(logoText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    local welcomeText = Instance.new("TextLabel")
    welcomeText.Text = ""
    welcomeText.Font = Enum.Font.GothamBold
    welcomeText.TextSize = 38
    welcomeText.TextColor3 = Color3.fromRGB(255,255,255)
    welcomeText.BackgroundTransparency = 1
    welcomeText.AnchorPoint = Vector2.new(0.5,0.5)
    welcomeText.Position = UDim2.new(0.5,0,0.5,-10)
    welcomeText.Size = UDim2.new(0, 500, 0, 60)
    welcomeText.Parent = welcomeFrame
    welcomeText.ZIndex = 101
    welcomeText.TextTransparency = 1
    TweenService:Create(welcomeText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    -- Schreibanimation
    local fullText = "Willkommen, "..player.Name
    for i = 1, #fullText do
        welcomeText.Text = string.sub(fullText, 1, i)
        wait(0.045)
    end

    -- Warte kurz, dann Herzen animieren
    wait(0.2)
    local textWidth = welcomeText.TextBounds.X
    local heartLeft = Instance.new("TextLabel")
    heartLeft.Text = "❤️"
    heartLeft.Font = Enum.Font.GothamBold
    heartLeft.TextSize = 38
    heartLeft.TextColor3 = Color3.fromRGB(255,0,120)
    heartLeft.BackgroundTransparency = 1
    heartLeft.AnchorPoint = Vector2.new(1,0.5)
    heartLeft.Position = UDim2.new(0.5, -textWidth/2 - 10, 0.5, -10)
    heartLeft.Size = UDim2.new(0, 40, 0, 60)
    heartLeft.TextTransparency = 1
    heartLeft.Parent = welcomeFrame
    heartLeft.ZIndex = 101

    local heartRight = Instance.new("TextLabel")
    heartRight.Text = "❤️"
    heartRight.Font = Enum.Font.GothamBold
    heartRight.TextSize = 38
    heartRight.TextColor3 = Color3.fromRGB(255,0,120)
    heartRight.BackgroundTransparency = 1
    heartRight.AnchorPoint = Vector2.new(0,0.5)
    heartRight.Position = UDim2.new(0.5, textWidth/2 + 10, 0.5, -10)
    heartRight.Size = UDim2.new(0, 40, 0, 60)
    heartRight.TextTransparency = 1
    heartRight.Parent = welcomeFrame
    heartRight.ZIndex = 101

    -- Herzen von außen nach innen animieren
    heartLeft.Position = UDim2.new(0.5, -textWidth/2 - 80, 0.5, -10)
    heartRight.Position = UDim2.new(0.5, textWidth/2 + 80, 0.5, -10)
    TweenService:Create(heartLeft, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        Position = UDim2.new(0.5, -textWidth/2 - 30, 0.5, -10)
    }):Play()
    TweenService:Create(heartRight, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        Position = UDim2.new(0.5, textWidth/2 + 30, 0.5, -10)
    }):Play()
    wait(0.6)

    -- Herzen "pulsieren" lassen
    for i=1,2 do
        TweenService:Create(heartLeft, TweenInfo.new(0.15), {TextSize = 44}):Play()
        TweenService:Create(heartRight, TweenInfo.new(0.15), {TextSize = 44}):Play()
        wait(0.15)
        TweenService:Create(heartLeft, TweenInfo.new(0.15), {TextSize = 38}):Play()
        TweenService:Create(heartRight, TweenInfo.new(0.15), {TextSize = 38}):Play()
        wait(0.12)
    end

    -- Kurz stehen lassen
    wait(1.5)

    -- Alles ausblenden (Text, Herzen, Logo)
    TweenService:Create(welcomeText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(logoText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(heartLeft, TweenInfo.new(0.5), {
        TextTransparency = 1,
        Position = UDim2.new(0.5, -textWidth/2 - 120, 0.5, -10)
    }):Play()
    TweenService:Create(heartRight, TweenInfo.new(0.5), {
        TextTransparency = 1,
        Position = UDim2.new(0.5, textWidth/2 + 120, 0.5, -10)
    }):Play()
    wait(0.6)
    welcomeFrame:Destroy()
    if callback then callback() end
end

local function setDescendantsVisible(parent, visible, animate)
    for _, child in ipairs(parent:GetChildren()) do
        -- Exclude catalogBar from transparency changes
        if child == catalogBar then
            child.Visible = visible
            -- Always keep catalogBar fully transparent
            child.BackgroundTransparency = 1
        elseif child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("Frame") then
            if animate then
                if visible then
                    child.Visible = true
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        child.TextTransparency = 1
                        TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                    end
                    if (child:IsA("Frame") or child:IsA("TextButton")) then
                        child.BackgroundTransparency = 1
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
                    end
                else
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                    end
                    if (child:IsA("Frame") or child:IsA("TextButton")) then
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    end
                    delay(0.3, function() child.Visible = false end)
                end
            else
                child.Visible = visible
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    child.TextTransparency = visible and 0 or 1
                end
                if (child:IsA("Frame") or child:IsA("TextButton")) then
                    child.BackgroundTransparency = visible and 0.15 or 1
                end
            end
            setDescendantsVisible(child, visible, false)
        end
    end
end

local function setMainGuiVisible(visible)
    if visible then
        mainFrame.Visible = true
        setDescendantsVisible(mainFrame, true, true)
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.25, Size = UDim2.new(0, 650, 0, 420)}):Play()
    else
        setDescendantsVisible(mainFrame, false, true)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.35)
        mainFrame.Visible = false
    end
end

local function setJoHubVisible(state)
    isOpen = state
    if state then
        openCloseBtn.Visible = false
        setMainGuiVisible(true)
        enableJoHubBlur()
        -- Zeige aktuellen Katalog wieder korrekt an
        showCatalogContent(currentCatalog)
    else
        setMainGuiVisible(false)
        delay(0.4, function()
            openCloseBtn.Visible = true
            openCloseBtn.BackgroundTransparency = 0.15
            openCloseBtn.Size = UDim2.new(0, 56, 0, 56)
            TweenService:Create(openCloseBtn, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15, Size = UDim2.new(0, 56, 0, 56)}):Play()
        end)
        disableJoHubBlur()
    end
end

local function animateKeyFrameOut(callback)
    TweenService:Create(keyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 100, 0, 200),
        Position = UDim2.new(0.5, -50, 0.5, -100)
    }):Play()
    delay(0.4, function()
        keyFrame.Visible = false
        if callback then callback() end
    end)
end

-- Stoppe Musik und spiele Übergangsmusik nach Key-Login
local function finishLoginAndShowHub()
    stopKeyMusic()
    animateKeyFrameOut(function()
        playTransitionMusic()
        -- Loading-Label
        local loading = Instance.new("TextLabel")
        loading.Text = "Loading..."
        loading.Size = UDim2.new(0, 220, 0, 54)
        loading.Position = UDim2.new(0.5, -110, 0.5, -27)
        loading.BackgroundTransparency = 1
        loading.TextColor3 = getBrightTextColor()
        loading.Font = Enum.Font.GothamBlack
        loading.TextSize = 32
        loading.TextTransparency = 1
        loading.Parent = screenGui
        TweenService:Create(loading, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        wait(2)
        TweenService:Create(loading, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        wait(0.3)
        loading:Destroy()
        -- Zeige neuen Welcome-Screen mit Animation
        showWelcomeAnimated(function()
            stopTransitionMusic()
            mainFrame.Visible = true
            createCatalogButtons()
            showCatalogContent(currentCatalog)
            setJoHubVisible(true)
        end)
    end)
end

-- Key-Prüfung: Exakter Vergleich pro Zeile
local function isKeyValid(result, key)
    for line in string.gmatch(result, "[^\r\n]+") do
        if line == key then
            return true
        end
    end
    return false
end

local function checkKeyAndLogin()
    local username = player.Name
    local isBypass = false
    for _,bypassName in ipairs(BYPASS_USERS) do
        if username == bypassName then isBypass = true break end
    end
    if isBypass then
        wait(0.5)
        showNotify("Bypass für "..username, Color3.fromRGB(0,200,100), nil, 1.5)
        wait(1)
        finishLoginAndShowHub()
        return
    end
    local keyChecked = false
    local keyExists = false
    local keyList = {}
    -- Prüfe, ob Key-Liste überhaupt existiert
    local success, result = pcall(function()
        return game:HttpGet(KEY_URL)
    end)
    if success and result and #result > 0 then
        for line in string.gmatch(result, "[^\r\n]+") do
            table.insert(keyList, line)
        end
        keyExists = #keyList > 0
    else
        keyExists = false
    end
    if not keyExists then
        loginBtn.AutoButtonColor = false
        loginBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
        loginBtn.Text = "Login"
        loginBtn.Active = false
        loginBtn.Selectable = false
        keyBox.TextEditable = false
        keyBox.Text = ""
        showNotify("Key zurzeit nicht existierend. Bitte später wieder ausführen.", Color3.fromRGB(255,140,0), nil, 3)
        return
    else
        loginBtn.AutoButtonColor = true
        loginBtn.BackgroundColor3 = Color3.fromRGB(255,0,200)
        loginBtn.Active = true
        loginBtn.Selectable = true
        keyBox.TextEditable = true
    end
    loginBtn.MouseButton1Click:Connect(playClick)
    loginBtn.MouseButton1Click:Connect(function()
        notify.Visible = false
        local key = keyBox.Text
        if key == "" then
            showNotify("Bitte Key eingeben!", Color3.fromRGB(255,140,0))
            return
        end
        showNotify("Prüfe Key...", Color3.fromRGB(0,120,255))
        local success2, result2 = pcall(function()
            return game:HttpGet(KEY_URL)
        end)
        if success2 and result2 and isKeyValid(result2, key) then
            showNotify("Key korrekt!", Color3.fromRGB(0,200,100))
            wait(0.7)
            finishLoginAndShowHub()
        else
            showNotify("Key falsch!", Color3.fromRGB(255,60,60))
        end
    end)
end

-- Starte Musik beim Anzeigen des Key-Login
function showKeyLoginAnimated()
    keyFrame.Visible = true
    keyFrame.BackgroundTransparency = 1
    keyFrame.Size = UDim2.new(0, 100, 0, 200)
    keyFrame.Position = UDim2.new(0.5, -50, 0.5, -100)
    TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 480, 0, 200),
        Position = UDim2.new(0.5, -240, 0.5, -100)
    }):Play()
    playKeyMusic()
end

-- Hauptlogik (ALLE EVENTS UND INITIALISIERUNG UNTEN)

-- Blitzeffekt für JoHub-Text
local function createTextLightning(parent)
    for i = 1, 3 do
        local bolt = Instance.new("Frame")
        bolt.Size = UDim2.new(0, math.random(30,60), 0, 2)
        bolt.Position = UDim2.new(0, math.random(80, 500), 0, math.random(20, 50))
        bolt.BackgroundColor3 = Color3.fromRGB(255,0,200)
        bolt.BackgroundTransparency = 0.1
        bolt.BorderSizePixel = 0
        bolt.ZIndex = 4
        bolt.Parent = parent
        local boltCorner = Instance.new("UICorner", bolt)
        boltCorner.CornerRadius = UDim.new(1,0)
        spawn(function()
            local last = tick()
            local timer = 0
            local state = 0
            local nextDelay = math.random(2,5)/10
            RunService.Heartbeat:Connect(function(dt)
                timer = timer + dt
                if state == 0 and timer >= nextDelay then
                    bolt.Size = UDim2.new(0, math.random(30,60), 0, 2)
                    bolt.Position = UDim2.new(0, math.random(80, 500), 0, math.random(20, 50))
                    bolt.BackgroundTransparency = 0.1
                    TweenService:Create(bolt, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play()
                    state = 1
                    timer = 0
                elseif state == 1 and timer >= 0.15 then
                    bolt.BackgroundTransparency = 0.1
                    state = 2
                    timer = 0
                    nextDelay = math.random(2,5)/10
                elseif state == 2 and timer >= nextDelay then
                    state = 0
                    timer = 0
                end
            end)
        end)
    end
end
createTextLightning(mainTitle)

-- Open/Close-Button öffnet GUI, wenn es geschlossen ist
openCloseBtn.MouseButton1Click:Connect(playClick)
openCloseBtn.MouseButton1Click:Connect(function()
    if not isOpen then
        setJoHubVisible(true)
    end
end)

-- Close-Button Event (nach applyTheme, aber nach Deklaration)
closeBtn.MouseButton1Click:Connect(playClick)
closeBtn.MouseButton1Click:Connect(function()
    setJoHubVisible(false)
end)

-- GUI Drag nur über obere Leiste (mainTitle)
local dragging, dragInput, dragStart, startPos
mainTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainTitle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

enableJoHubBlur()

showKeyLoginAnimated()
keyFrame.Visible = true

checkKeyAndLogin()