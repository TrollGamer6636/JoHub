-- KeySystem.lua
local KeySystem = {}

-- checkKeyAndLogin prüft Key und Bypass, ruft bei Erfolg finishLoginAndShowHub auf
function KeySystem.checkKeyAndLogin(args)
    -- args: {player, BYPASS_USERS, KEY_URL, loginBtn, keyBox, notify, showNotify, finishLoginAndShowHub}
    local player = args.player
    local BYPASS_USERS = args.BYPASS_USERS
    local KEY_URL = args.KEY_URL
    local loginBtn = args.loginBtn
    local keyBox = args.keyBox
    local notify = args.notify
    local showNotify = args.showNotify
    local finishLoginAndShowHub = args.finishLoginAndShowHub

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
    loginBtn.MouseButton1Click:Connect(function()
        notify.Visible = false
        local key = keyBox.Text
        if key == "" then
            showNotify("Bitte Key eingeben!", Color3.fromRGB(255,140,0))
            return
        end
        showNotify("Prüfe Key...", Color3.fromRGB(0,120,255))
        local success, result = pcall(function()
            return game:HttpGet(KEY_URL)
        end)
        if success and result and string.find(result, key) then
            showNotify("Key korrekt!", Color3.fromRGB(0,200,100))
            wait(0.7)
            finishLoginAndShowHub()
        else
            showNotify("Key falsch!", Color3.fromRGB(255,60,60))
        end
    end)
end

-- finishLoginAndShowHub: Animation und Callback für nach Login
function KeySystem.finishLoginAndShowHub(args)
    -- args: {keyFrame, screenGui, getBrightTextColor, mainFrame, createCatalogButtons, showCatalogContent, setJoHubVisible, showWelcome}
    local keyFrame = args.keyFrame
    local screenGui = args.screenGui
    local getBrightTextColor = args.getBrightTextColor
    local mainFrame = args.mainFrame
    local createCatalogButtons = args.createCatalogButtons
    local showCatalogContent = args.showCatalogContent
    local setJoHubVisible = args.setJoHubVisible
    local showWelcome = args.showWelcome
    local TweenService = game:GetService("TweenService")

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

    animateKeyFrameOut(function()
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
        mainFrame.Visible = true
        createCatalogButtons()
        showCatalogContent()
        setJoHubVisible(true)
        showWelcome()
    end)
end

return KeySystem
