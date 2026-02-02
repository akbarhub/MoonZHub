--// UNIVERSAL UI LIBRARY (PC + ANDROID)
--// Ready Execute | Dark Theme | Touch + Mouse

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Library = {}
Library.__index = Library

--// ================= WINDOW =================
function Library:CreateWindow(config)
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "UniversalUILib"
    Gui.ResetOnSpawn = false
    Gui.Parent = game.CoreGui

    local Main = Instance.new("Frame", Gui)
    Main.BackgroundColor3 = Color3.fromRGB(15,15,18)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

    if IsMobile then
        Main.Size = UDim2.fromScale(0.95,0.65)
        Main.Position = UDim2.fromScale(0.025,0.18)
    else
        Main.Size = UDim2.fromScale(0.5,0.6)
        Main.Position = UDim2.fromScale(0.25,0.2)
    end

    -- TopBar
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1,0,0,45)
    Top.BackgroundColor3 = Color3.fromRGB(20,20,25)
    Top.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1,-50,1,0)
    Title.Position = UDim2.new(0,15,0,0)
    Title.Text = config.Title or "UI Library"
    Title.TextXAlignment = Left
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(230,230,230)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    local Close = Instance.new("TextButton", Top)
    Close.Size = UDim2.fromOffset(35,35)
    Close.Position = UDim2.new(1,-40,0.5,-17)
    Close.Text = "✕"
    Close.BackgroundColor3 = Color3.fromRGB(35,35,40)
    Close.TextColor3 = Color3.fromRGB(255,90,90)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 16
    Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

    -- Content
    local Content = Instance.new("ScrollingFrame", Main)
    Content.Position = UDim2.new(0,0,0,45)
    Content.Size = UDim2.new(1,0,1,-45)
    Content.CanvasSize = UDim2.new(0,0,0,0)
    Content.ScrollBarImageTransparency = 0.7
    Content.BackgroundTransparency = 1
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0,8)

    Close.Activated:Connect(function()
        Gui.Enabled = false
    end)

    -- Floating Button
    local Float = Instance.new("TextButton", Gui)
    Float.Size = UDim2.fromOffset(55,55)
    Float.Position = UDim2.fromScale(0.02,0.5)
    Float.Text = "≡"
    Float.BackgroundColor3 = Color3.fromRGB(60,255,120)
    Float.TextColor3 = Color3.fromRGB(10,10,10)
    Float.Font = Enum.Font.GothamBold
    Float.TextSize = 22
    Instance.new("UICorner", Float).CornerRadius = UDim.new(1,0)

    Float.Activated:Connect(function()
        Gui.Enabled = not Gui.Enabled
    end)

    local Window = {}
    Window.Container = Content

    --// ================= COMPONENTS =================
    function Window:AddButton(text, callback)
        local Btn = Instance.new("TextButton", Content)
        Btn.Size = UDim2.new(1,-16,0,IsMobile and 50 or 42)
        Btn.Position = UDim2.new(0,8,0,0)
        Btn.Text = text
        Btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        Btn.TextColor3 = Color3.fromRGB(230,230,230)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = IsMobile and 16 or 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

        Btn.Activated:Connect(callback)
    end

    function Window:AddToggle(text, default, callback)
        local State = default or false

        local Btn = Instance.new("TextButton", Content)
        Btn.Size = UDim2.new(1,-16,0,IsMobile and 50 or 42)
        Btn.Position = UDim2.new(0,8,0,0)
        Btn.Text = text
        Btn.BackgroundColor3 = State and Color3.fromRGB(60,255,120) or Color3.fromRGB(30,30,35)
        Btn.TextColor3 = Color3.fromRGB(20,20,20)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = IsMobile and 16 or 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

        Btn.Activated:Connect(function()
            State = not State
            Btn.BackgroundColor3 = State and Color3.fromRGB(60,255,120) or Color3.fromRGB(30,30,35)
            callback(State)
        end)
    end

    function Window:AddTextbox(text, placeholder, callback)
        local Box = Instance.new("TextBox", Content)
        Box.Size = UDim2.new(1,-16,0,IsMobile and 50 or 42)
        Box.Position = UDim2.new(0,8,0,0)
        Box.Text = ""
        Box.PlaceholderText = placeholder or text
        Box.BackgroundColor3 = Color3.fromRGB(25,25,30)
        Box.TextColor3 = Color3.fromRGB(230,230,230)
        Box.Font = Enum.Font.Gotham
        Box.TextSize = IsMobile and 16 or 14
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0,8)

        Box.FocusLost:Connect(function()
            callback(Box.Text)
        end)
    end

    function Window:AddDropdown(text, options, callback)
        local Btn = Instance.new("TextButton", Content)
        Btn.Size = UDim2.new(1,-16,0,IsMobile and 50 or 42)
        Btn.Position = UDim2.new(0,8,0,0)
        Btn.Text = text
        Btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        Btn.TextColor3 = Color3.fromRGB(230,230,230)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = IsMobile and 16 or 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

        Btn.Activated:Connect(function()
            callback(options[1])
        end)
    end

    function Window:AddSlider(text, min, max, default, callback)
        local Holder = Instance.new("Frame", Content)
        Holder.Size = UDim2.new(1,-16,0,55)
        Holder.Position = UDim2.new(0,8,0,0)
        Holder.BackgroundTransparency = 1

        local Bar = Instance.new("Frame", Holder)
        Bar.Size = UDim2.new(1,0,0,8)
        Bar.Position = UDim2.new(0,0,1,-12)
        Bar.BackgroundColor3 = Color3.fromRGB(35,35,40)
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        Fill.BackgroundColor3 = Color3.fromRGB(60,255,120)
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

        local Dragging = false

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if Dragging then
                local Percent = math.clamp(
                    (input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                    0,1
                )
                Fill.Size = UDim2.new(Percent,0,1,0)
                callback(math.floor(min + (max-min)*Percent))
            end
        end)
    end

    return Window
end

return Library
