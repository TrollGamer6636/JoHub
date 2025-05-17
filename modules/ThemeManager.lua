-- ThemeManager.lua
local ThemeManager = {}

ThemeManager.themes = {
    {
        Name = "Magenta",
        Color = Color3.fromRGB(255,0,200),
        Bg = Color3.fromRGB(30, 30, 40),
        BgAccent = Color3.fromRGB(60,0,80)
    },
    {
        Name = "Blau",
        Color = Color3.fromRGB(0,120,255),
        Bg = Color3.fromRGB(20,30,50),
        BgAccent = Color3.fromRGB(30,40,80)
    },
    {
        Name = "Grün",
        Color = Color3.fromRGB(0,200,100),
        Bg = Color3.fromRGB(20,40,30),
        BgAccent = Color3.fromRGB(30,60,40)
    },
    {
        Name = "Orange",
        Color = Color3.fromRGB(255,140,0),
        Bg = Color3.fromRGB(50,30,10),
        BgAccent = Color3.fromRGB(80,40,20)
    }
}

function ThemeManager.getBrightTextColor()
    return Color3.fromRGB(255,255,255)
end

function ThemeManager.getHoverColor(base)
    return Color3.new(
        math.min(base.R+0.2,1),
        math.min(base.G+0.2,1),
        math.min(base.B+0.2,1)
    )
end

function ThemeManager.getPressedColor(base)
    return Color3.new(
        math.max(base.R-0.2,0),
        math.max(base.G-0.2,0),
        math.max(base.B-0.2,0)
    )
end

-- applyTheme wird von Main.lua aufgerufen und bekommt alle relevanten GUI-Objekte übergeben
function ThemeManager.applyTheme(theme, guiRefs)
    -- guiRefs: table mit allen relevanten GUI-Objekten und Listen
    local getBrightTextColor = ThemeManager.getBrightTextColor
    -- Hauptfarben
    guiRefs.mainFrame.BackgroundColor3 = theme.Bg
    guiRefs.mainFrame.BackgroundTransparency = 0.25
    guiRefs.keyFrame.BackgroundColor3 = theme.Bg
    guiRefs.keyFrame.BackgroundTransparency = 0.15
    guiRefs.catalogContainer.BackgroundColor3 = theme.BgAccent
    guiRefs.catalogContainer.BackgroundTransparency = 0.15
    guiRefs.openCloseBtn.BackgroundColor3 = theme.Color
    guiRefs.openCloseBtn.BackgroundTransparency = 0.15
    guiRefs.closeBtn.BackgroundColor3 = theme.Color
    guiRefs.closeBtn.BackgroundTransparency = 0.15
    guiRefs.loginBtn.BackgroundColor3 = theme.Color
    guiRefs.loginBtn.BackgroundTransparency = 0.1
    -- Textfarben
    guiRefs.mainTitle.TextColor3 = getBrightTextColor()
    guiRefs.title.TextColor3 = getBrightTextColor()
    guiRefs.loginBtn.TextColor3 = getBrightTextColor()
    guiRefs.keyBox.TextColor3 = Color3.fromRGB(0,0,0)
    guiRefs.notify.TextColor3 = getBrightTextColor()
    guiRefs.closeBtn.TextColor3 = getBrightTextColor()
    guiRefs.openCloseBtn.TextColor3 = getBrightTextColor()
    -- Katalog-Buttons
    if guiRefs.catalogButtons then
        for _,b in ipairs(guiRefs.catalogButtons) do
            b.BackgroundColor3 = theme.Color
            b.BackgroundTransparency = 0.15
            b.TextColor3 = getBrightTextColor()
        end
    end
    -- Katalog-Inhalte
    if guiRefs.catalogContent then
        for _,child in ipairs(guiRefs.catalogContent:GetDescendants()) do
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
    for _,child in ipairs(guiRefs.mainTitle:GetChildren()) do
        if child:IsA("Frame") and child.ZIndex == 4 then
            child.BackgroundColor3 = theme.Color
        end
    end
    -- JoHub-Label im Open/Close-Button
    if guiRefs.jhLabel then
        guiRefs.jhLabel.TextColor3 = getBrightTextColor()
        guiRefs.jhLabel.TextStrokeTransparency = 0.5
        guiRefs.jhLabel.TextStrokeColor3 = theme.BgAccent
    end
end

return ThemeManager
