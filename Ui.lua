--// MoonZHub UI Library
--// Visual Final | WindUI Style | PC + Android | Executor Ready

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Library = {}

--// ================= CREATE WINDOW =================
function Library:CreateWindow(config)
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "MoonZHubUI"
    Gui.ResetOnSpawn = false
    Gui.Parent = game.CoreGui

    local Main = Instance.new("Frame", Gui)
    Main.BackgroundColor3 = Color3.fromRGB(14,14,18)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

    if IsMobile then
        Main.Size = UDim2.fromScale(0.95,0.65)
        Main.Position = UDim2.fromScale(0.025,0.18)
    else
        Main.Size = UDim2.fromScale(0.5,0.6)
        Main.Position = UDim2.fromScale(0.25,0.2)
    end

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(90,255,170)
    Stroke.Transparency = 0.85

    --// TOPBAR
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1,0,0,42)
    Top.BackgroundColor3 = Color3.fromRGB(18,18,23)
    Top.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1,-50,1,0)
    Title.Position = UDim2.new(0,16,0,0)
    Title.Text = config.Title or "MoonZHub"
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(235,235,235)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 15

    local Close = Instance.new("TextButton", Top)
    Close.Size = UDim2.fromOffset(32,32)
    Close.Position = UDim2.new(1,-38,0.5,-16)
    Close.Text = "✕"
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 14
    Close.TextColor3 = Color3.fromRGB(255,90,90)
    Close.BackgroundColor3 = Color3.fromRGB(30,30,35)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

    --// SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0,150,1,-42)
    Sidebar.Position = UDim2.new(0,0,0,42)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16,16,20)
    Sidebar.BorderSizePixel = 0

    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0,8)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local SidePadding = Instance.new("UIPadding", Sidebar)
    SidePadding.PaddingTop = UDim.new(0,10)

    --// PAGES
    local Pages = Instance.new("Folder", Main)
    Pages.Name = "Pages"

    local CurrentPage

    --// WINDOW OBJECT
    local Window = {}

    --// TAB CREATE
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton", Sidebar)
        TabButton.Size = UDim2.new(1,-20,0,38)
        TabButton.Text = name
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(220,220,220)
        TabButton.BackgroundColor3 = Color3.fromRGB(25,25,30)
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,8)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1,-150,1,-42)
        Page.Position = UDim2.new(0,150,0,42)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollBarImageTransparency = 1
        Page.BackgroundTransparency = 1
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,10)

        local Padding = Instance.new("UIPadding", Page)
        Padding.PaddingTop = UDim.new(0,10)
        Padding.PaddingLeft = UDim.new(0,10)
        Padding.PaddingRight = UDim.new(0,10)

        TabButton.Activated:Connect(function()
            if CurrentPage then
                CurrentPage.Visible = false
            end
            for _,v in ipairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.fromRGB(25,25,30)
                end
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(40,255,160)
            TabButton.TextColor3 = Color3.fromRGB(20,20,20)
            Page.Visible = true
            CurrentPage = Page
        end)

        if not CurrentPage then
            TabButton:Activate()
        end

        --// TAB API
        local Tab = {}

        -- BUTTON
        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1,0,0,42)
            Btn.Text = text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = IsMobile and 16 or 14
            Btn.TextColor3 = Color3.fromRGB(230,230,230)
            Btn.BackgroundColor3 = Color3.fromRGB(22,22,27)
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
            Btn.Activated:Connect(callback)
        end

        -- TOGGLE (SWITCH)
        function Tab:AddToggle(text, default, callback)
            local State = default or false

            local Holder = Instance.new("Frame", Page)
            Holder.Size = UDim2.new(1,0,0,44)
            Holder.BackgroundColor3 = Color3.fromRGB(22,22,27)
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,8)

            local Label = Instance.new("TextLabel", Holder)
            Label.Size = UDim2.new(1,-60,1,0)
            Label.Position = UDim2.new(0,12,0,0)
            Label.Text = text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(230,230,230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14

            local Switch = Instance.new("Frame", Holder)
            Switch.Size = UDim2.fromOffset(36,20)
            Switch.Position = UDim2.new(1,-48,0.5,-10)
            Switch.BackgroundColor3 = State and Color3.fromRGB(90,255,170) or Color3.fromRGB(40,40,45)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1,0)

            local Knob = Instance.new("Frame", Switch)
            Knob.Size = UDim2.fromOffset(16,16)
            Knob.Position = State and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
            Knob.BackgroundColor3 = Color3.fromRGB(15,15,18)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

            Holder.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    State = not State
                    Switch.BackgroundColor3 = State and Color3.fromRGB(90,255,170) or Color3.fromRGB(40,40,45)
                    Knob.Position = State and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
                    callback(State)
                end
            end)
        end

        return Tab
    end

    Close.Activated:Connect(function()
        Gui:Destroy()
    end)

    return Window
end

return Library
