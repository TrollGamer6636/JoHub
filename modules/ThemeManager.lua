-- ThemeManager.lua
-- Farbwahl- und Theme-Logik für JoHub

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

return ThemeManager