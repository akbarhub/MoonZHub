local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer:WaitForChild("Backpack")

--helper function
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local BrainrotsFolder = workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
local EquipBestRemote = Remotes:WaitForChild("EquipBestBrainrots")


local AutoEB = false
local AutoEBRunning = false
local AutoCollect = false
local AutoCollectRunning = false

local AutoFarm = false
local autoClicking = false
local AutoCollectDelay = 20
local ClickInterval = 0.25

local AntiAFKEnabled = false

local SellBrainrot = false
local SellPlant = false
local SellEverything = false

local HeldToolNames = {
    "Basic Bat",
    "Leather Grip Bat",
    "Iron Plate Bat",
    "Iron Core Bat",
    "Aluminum Bat"
}

local serverStartTime = os.time()


local shop = {
    seedList = {
        "Cactus Seed",
        "Strawberry Seed",
        "Pumpkin Seed",
        "Sunflower Seed",
        "Dragon Seed",
        "Eggplant Seed",
        "Watermelon Seed",
        "Cocotank Seed",
        "Carnivorous Plant Seed",
        "Mr Carrot Seed",
        "Tomatrio Seed",
        "Shroombino Seed",
        "Mango Seed",
        "King Limone Seed"
    },

    gearList = {
        "Water Bucket",
        "Frost Grenade",
        "Banana Gun",
        "Frost Blower",
        "Carrot Launcher"
    }
}

local selectedSeeds = {}
local selectedGears = {}
local AutoBuySelectedSeed = false
local AutoBuySelectedGear = false
local AutoBuyAllSeed = false
local AutoBuyAllGear = false


local function GetMyPlot()
    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        local playerSign = plot:FindFirstChild("PlayerSign")
        if playerSign then
            local bg = playerSign:FindFirstChild("BillboardGui")
            local textLabel = bg and bg:FindFirstChild("TextLabel")
            if textLabel and (textLabel.Text == LocalPlayer.Name or textLabel.Text == LocalPlayer.DisplayName) then
                return plot
            end
        end
    end
    return nil
end

local function GetMyPlotName()
    local plot = GetMyPlot()
    return plot and plot.Name or "No Plot"
end

local function GetMoney()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    return leaderstats and leaderstats:FindFirstChild("Money") and leaderstats.Money.Value or 0
end

local function GetRebirth()
    local gui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
    if gui and gui:FindFirstChild("Rebirth") then
        local text = gui.Rebirth.Frame.Title.Text or "Rebirth 0"
        local n = tonumber(text:match("%d+")) or 0
        return math.max(0, n - 1)
    end
    return 0
end

local function FormatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- safe remote getters
local function GetBridgeNet2()
    return ReplicatedStorage:FindFirstChild("BridgeNet2")
end

local function GetRemotesFolder()
    return ReplicatedStorage:FindFirstChild("Remotes")
end

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://136505615779937",
    IconThemed = true,
    Author = "Anonymous | Plants Vs Brainrot",
    Folder = "SeraphinOnTop",
    Size = UDim2.new(0, 380, 0, 260), 
    Transparent = true,
    BackgroundImageTransparency = 0.8,
    Theme = "Indigo"
})  


WindUI:Notify({
    Title = "Plants Vs Brainrot",
    Content = "Loaded",
    Duration = 14, -- 3 seconds
})


Window:EditOpenButton({ Enabled = false })
Window:SetToggleKey(nil)

local nnielx = Instance.new('ScreenGui')
local Button = Instance.new('ImageButton')
local Corner = Instance.new('UICorner')
local Scale = Instance.new('UIScale')
local Stroke = Instance.new("UIStroke")
local Gradient = Instance.new("UIGradient")

nnielx.Name = 'Seraphin'
nnielx.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
nnielx.ResetOnSpawn = false
nnielx.Parent = game:GetService('CoreGui')

Button.Name = 'seraphinOnTop'
Button.Parent = nnielx
Button.BackgroundTransparency = 0
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.Size = UDim2.new(0, 40, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 50)
Button.Image = 'rbxassetid://136505615779937'
Button.Draggable = true

Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Button
Scale.Scale = 1
Scale.Parent = Button

local TweenService = game:GetService("TweenService")
Button.MouseEnter:Connect(function()
    TweenService:Create(Scale, TweenInfo.new(0.1), { Scale = 1.2 }):Play()
end)
Button.MouseLeave:Connect(function()
    TweenService:Create(Scale, TweenInfo.new(0.1), { Scale = 1 }):Play()
end)

Stroke.Thickness = 4
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.LineJoinMode = Enum.LineJoinMode.Round
Stroke.Color = Color3.fromRGB(145, 110, 255)
Stroke.Parent = Button

Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(90, 0, 130)),
    ColorSequenceKeypoint.new(0.15, Color3.fromRGB(70, 0, 110)),
    ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 0, 80)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(30, 0, 50)),
    ColorSequenceKeypoint.new(0.70, Color3.fromRGB(10, 0, 20)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 0, 130))
})

Gradient.Rotation = 0
Gradient.Parent = Stroke

local isWindowOpen = true
Button.MouseButton1Click:Connect(function()
    if isWindowOpen then
        Window:Close()
    else
        Window:Open()
    end
    isWindowOpen = not isWindowOpen
end)

Window:OnDestroy(function()
    if nnielx then
        nnielx:Destroy()
    end
end)


local Tabs = {}

Tabs.Home = Window:Tab({
    Title = "Home",
    Icon = "house", -- optional
    Locked = false,
})
Tabs.Main = Window:Tab({
    Title = "Main",
    Icon = "sword", -- optional
    Locked = false,
})
Tabs.Collect = Window:Tab({
    Title = "Collect",
    Icon = "dollar-sign", -- optional
    Locked = false,
})
Tabs.Shop = Window:Tab({
    Title = "Shop",
    Icon = "shopping-basket", -- optional
    Locked = false,
})
Tabs.Player = Window:Tab({
    Title = "Player",
    Icon = "person-standing", -- optional
    Locked = false,
})
Tabs.Visual = Window:Tab({
    Title = "Visual",
    Icon = "eye", -- optional
    Locked = false,
})




Tabs.Home:Section({ 
    Title = "Home",
})

Tabs.Home:Button({
    Title = "Coy Discord Invite Link",
    Locked = false,
    Callback = function()
        setclipboard("discord.gg/getseraphin")
    end
})




Tabs.Main:Section({ 
    Title = "Combat",
})


-- function Auto Farm
local BrainrotsCache = {}

local function UpdateBrainrotsCache()
    local ok, folder = pcall(function()
        return Workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
    end)
    if not ok or not folder then return end
    BrainrotsCache = {}
    for _, b in ipairs(folder:GetChildren()) do
        if b:FindFirstChild("BrainrotHitbox") then
            table.insert(BrainrotsCache, b)
        end
    end
end

local function GetNearestBrainrot()
    local nearest = nil
    local minDist = math.huge
    for _, b in ipairs(BrainrotsCache) do
        local hitbox = b:FindFirstChild("BrainrotHitbox")
        if hitbox then
            local dist = (HumanoidRootPart.Position - hitbox.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = b
            end
        end
    end
    return nearest
end


local HeldToolName = nil

local function EquipBat()
    for _, toolName in ipairs(HeldToolNames) do
        local tool = Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName)
        if tool then
            tool.Parent = Character
            HeldToolName = toolName
            return true
        end
    end
    return false
end

local function InstantWarpToBrainrot(brainrot)
    local hitbox = brainrot and brainrot:FindFirstChild("BrainrotHitbox")
    if hitbox then
        local offset = Vector3.new(0, 0.69, 2.5)
        HumanoidRootPart.CFrame = CFrame.new(hitbox.Position + offset, hitbox.Position)
    end
end

local function DoClick()
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(0, 0))
        task.wait(0.05) 
        VirtualUser:Button1Up(Vector2.new(0, 0))
    end)
end


Tabs.Main:Toggle({
    Title = "Auto Attack Brainrot",
    Default = false,
    Callback = function(state)
        AutoFarm = state
        autoClicking = state

        if state then
            EquipBat()
            UpdateBrainrotsCache()

            
            task.spawn(function()
                while autoClicking do
                    if Character and Character:FindFirstChild(HeldToolName) then
                        DoClick()
                    end
                    task.wait(ClickInterval)
                end
            end)

            
            task.spawn(function()
                while AutoFarm do
                    if Character and not Character:FindFirstChild(HeldToolName) then
                        EquipBat()
                    end
                    task.wait(0.25)
                end
            end)

          
            task.spawn(function()
                while AutoFarm do
                    UpdateBrainrotsCache()
                    task.wait(0.25)
                end
            end)

           
            task.spawn(function()
                while AutoFarm do
                    local currentTarget = GetNearestBrainrot()
                    if currentTarget and currentTarget:FindFirstChild("BrainrotHitbox") then
                        InstantWarpToBrainrot(currentTarget)
                        pcall(function()
                            local remotes = GetRemotesFolder()
                            if remotes and remotes:FindFirstChild("AttacksServer") and remotes.AttacksServer:FindFirstChild("WeaponAttack") then
                                remotes.AttacksServer.WeaponAttack:FireServer({ { target = currentTarget.BrainrotHitbox } })
                            else
                                local ok, _ = pcall(function()
                                    ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer({ { target = currentTarget.BrainrotHitbox } })
                                end)
                            end
                        end)
                    end
                    task.wait(ClickInterval)
                end
            end)

        else
            autoClicking = false
        end
    end
})

--funcition Auto Attack Brainrot V2 + Tambahan function auto collect dan lain lain
local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function teleportToMob(hrp, mob)
	local rootPart = mob:FindFirstChild("RootPart")
	if rootPart then
		hrp.CFrame = rootPart.CFrame * CFrame.new(0, -1, 0)
	end
end

local function attackMobWithVirtualUser()
	VirtualUser:Button1Down(Vector2.new(0, 0))
end


local farming, autoCollect, autoSell = false, false, false
local lastAttack, lastCollect, lastSell = 0, 0, 0
local attackDelay = 0.2
local collectDelay = 2
local sellDelay = 2


RunService.Heartbeat:Connect(function()
	local char = getCharacter()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local now = tick()

	if farming and now - lastAttack >= attackDelay then
		for _, mob in ipairs(BrainrotsFolder:GetChildren()) do
			if mob:IsA("Model") and mob:FindFirstChild("RootPart") then
				teleportToMob(hrp, mob)
				attackMobWithVirtualUser()
				lastAttack = now
				break
			end
		end
	end
	if autoCollect and now - lastCollect >= collectDelay then
		EquipBestRemote:FireServer()
		lastCollect = now
	end
	if autoSell and now - lastSell >= sellDelay then
		Remotes:WaitForChild("ItemSell"):FireServer()
		lastSell = now
	end
end)

Tabs.Main:Toggle({
    Title = "Auto Attack Brainrot V2 ( Private Server Only )",
    Default = false,
    Callback = function(state) 
        farming = state
    end
})


Tabs.Main:Section({ 
    Title = "Equip",
})

Tabs.Main:Toggle({
    Title = "Auto Equip Best Brainrot",
    Description = "Automatically Equip Best Brainrot",
    Default = false,
    Callback = function(state)
        AutoEB = state
        if state and not AutoEBRunning then
            AutoEBRunning = true
            task.spawn(function()
                while AutoEB do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EquipBestBrainrots"):FireServer()
                    task.wait(5)
                end
                AutoEBRunning = false
            end)
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Equip Brainrot ( 30 Sec )",
    Default = false,
    Callback = function(v) 
    getgenv().brainrot = v
    while true do
    if not getgenv().brainrot then return end
        local EquipBest = ReplicatedStorage.Remotes.EquipBest
        EquipBest:Fire()
        task.wait(30)
    end
 end
})

Tabs.Main:Button({
    Title = "Equip Best Brainrot",
    Locked = false,
    Callback = function()
local EquipBest = ReplicatedStorage.Remotes.EquipBest
EquipBest:Fire()
    end
})


Tabs.Collect:Section({ 
    Title = "Auto Collect Money",
})

local function GetNearestPlot()
    local nearestPlot = nil
    local minDist = math.huge
    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        if plot:IsA("Folder") then
            local center = plot:FindFirstChild("Center") or plot:FindFirstChildWhichIsA("BasePart")
            if center then
                local dist = (HumanoidRootPart.Position - center.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPlot = plot
                end
            end
        end
    end
    return nearestPlot
end

local function CollectFromPlot(plot)
    if not plot then return end
    local brainrotsFolder = plot:FindFirstChild("Brainrots")
    if not brainrotsFolder then return end

    for i = 1, 17 do
        local slot = brainrotsFolder:FindFirstChild(tostring(i))
        if slot and slot:FindFirstChild("Brainrot") then
            local brainrot = slot:FindFirstChild("Brainrot")
            if brainrot:FindFirstChild("BrainrotHitbox") then
                local hitbox = brainrot.BrainrotHitbox
                local offset = Vector3.new(0, 1, 3)
                HumanoidRootPart.CFrame = CFrame.new(hitbox.Position + offset, hitbox.Position)
                task.wait(0.2)
                pcall(function()
                    local remotes = GetRemotesFolder()
                    if remotes and remotes:FindFirstChild("AttacksServer") and remotes.AttacksServer:FindFirstChild("WeaponAttack") then
                        remotes.AttacksServer.WeaponAttack:FireServer({ { target = hitbox } })
                    else
                        ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer({ { target = hitbox } })
                    end
                end)
            end
        end
    end
end

Tabs.Collect:Slider({
    Title = "Auto Collect Delay",
    Description = "Set delay time between collections",
    Value = {Min = 1, Max = 300, Default = 20},
    Step = 1,
    Callback = function(val)
        AutoCollectDelay = val
    end
})


Tabs.Collect:Toggle({
    Title = "Auto Collect Money",
    Description = "Automatically Collect Without Teleport",
    Default = false,
    Callback = function(state)
        AutoCollect1 = state
        if state and not AutoCollectRunning then
            AutoCollectRunning = true
            task.spawn(function()
                while AutoCollect1 do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EquipBestBrainrots"):FireServer()
                    task.wait(AutoCollectDelay)
                end
                AutoCollectV2Running = false
            end)
        end
    end
})


Tabs.Main:Section({ 
    Title = "Auto Sell",
})

Tabs.Main:Toggle({
    Title = "Auto Sell Brainrot",
    Default = false,
    Callback = function(state)
        SellBrainrot = state
        while SellBrainrot do
            task.wait(0.5) 
            ReplicatedStorage.Remotes.ItemSell:FireServer()
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Sell Plants",
    Default = false,
    Callback = function(state)
        SellPlant = state
        while SellPlant do
            task.wait(0.5)
            ReplicatedStorage.Remotes.ItemSell:FireServer()
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Confirm Sell",
    Default = false,
    Callback = function(v) 
        getgenv().sell = v
        while true do
        if not getgenv().sell then return end
local ConfirmSell = ReplicatedStorage.Remotes.ConfirmSell
firesignal(ConfirmSell.OnClientEvent, 
    {
        Godly = true
    }
)
task.wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConfirmSell = ReplicatedStorage.Remotes.ConfirmSell -- RemoteEvent 
firesignal(ConfirmSell.OnClientEvent, 
    {
        Limited = true
    }
)
task.wait()
end
    end
})

Tabs.Main:Section({ 
    Title = "Auto Sell Everthing",
})


Tabs.Main:Toggle({
    Title = "Auto Sell everthing",
    Default = false,
    Callback = function(state) 
         SellEverything = state
    end
})

Tabs.Main:Toggle({
    Title = "Auto Sell All Rarities",
    Default = false,
    Callback = function(v) 
        getgenv().m = v
        while true do
        if not getgenv().m then return end
local AutoSell = ReplicatedStorage.Remotes.AutoSell 
AutoSell:FireServer(
    "Rare"
)
task.wait()
local AutoSell = ReplicatedStorage.Remotes.AutoSell 
firesignal(AutoSell.OnClientEvent, 
    "Legendary"
)
task.wait()
local AutoSell = ReplicatedStorage.Remotes.AutoSell
firesignal(AutoSell.OnClientEvent,
    "Mythic"
)
task.wait()
local AutoSell = ReplicatedStorage.Remotes.AutoSell
firesignal(AutoSell.OnClientEvent, 
    "Godly"
)
task.wait()
local AutoSell = ReplicatedStorage.Remotes.AutoSell
AutoSell:FireServer(
    "Limited"
)
task.wait()
end
    end
})

Tabs.Main:Section({ 
    Title = "Rebirth",
})

Tabs.Main:Toggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(v) 
        getgenv().ama = v
        while true do 
        if not getgenv().ama then return end
        print("lol")
        end
    end
})

Tabs.Shop:Section({ 
    Title = "Auto Buy Seeds",
})

Tabs.Shop:Dropdown({
    Title = "Select Seed",
    Values = shop.seedList,
    Multi = true,
    Callback = function(values)
        selectedSeeds = values
    end
})


Tabs.Shop:Toggle({
    Title = "Auto Buy Seed",
    Default = false,
    Callback = function(state)
        AutoBuySelectedSeed = state
        if state then
            task.spawn(function()
                while AutoBuySelectedSeed do
                    if #selectedSeeds > 0 then
                        for _, seed in ipairs(selectedSeeds) do
                            if not AutoBuySelectedSeed then break end
                            local BuySeedRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyItem")
                            BuySeedRemote:FireServer(seed)
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})



Tabs.Shop:Section({ 
    Title = "Auto Buy Gear",
})

Tabs.Shop:Dropdown({
    Title = "Select Gear",
    Values = shop.gearList,
    Multi = true,
    Callback = function(values)
        selectedGears = values
    end
})

Tabs.Shop:Toggle({
    Title = "Auto Buy Gear",
    Default = false,
    Callback = function(state)
        AutoBuySelectedGear = state
        if state then
            task.spawn(function()
                while AutoBuySelectedGear do
                    if #selectedGears > 0 then
                        for _, gear in ipairs(selectedGears) do
                            if not AutoBuySelectedGear then break end
                            local BuyGearRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyGear")
                            BuyGearRemote:FireServer(gear)
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tabs.Shop:Section({ 
    Title = "Auto Buy All",
})

Tabs.Shop:Toggle({
    Title = "Auto Buy Seed All",
    Default = false,
    Callback = function(state)
        AutoBuyAllSeed = state
        if state then
            task.spawn(function()
                while AutoBuyAllSeed do
                    for _, seed in ipairs(shop.seedList) do
                        if not AutoBuyAllSeed then break end
                        local BuySeedRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyItem")
                        BuySeedRemote:FireServer(seed)
                        task.wait(0.3)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tabs.Shop:Toggle({
    Title = "Auto Buy Gear All",
    Default = false,
    Callback = function(state)
        AutoBuyAllGear = state
        if state then
            task.spawn(function()
                while AutoBuyAllGear do
                    for _, gear in ipairs(shop.gearList) do
                        if not AutoBuyAllGear then break end
                        local BuyGearRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyGear")
                        BuyGearRemote:FireServer(gear)
                        task.wait(0.3)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tabs.Player:Section({
    Title = "Player",
})

Tabs.Player:Button({
    Title = "FPS BOOST",
    Locked = false,
    Callback = function()
pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("Boost FPS Boost Applied")
    end
})


Tabs.Player:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        AntiAFKEnabled = state
        if state then
            local conn
            conn = Players.LocalPlayer.Idled:Connect(function()
                if AntiAFKEnabled then
                    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                    task.wait(0.1)
                    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                else
                    conn:Disconnect()
                end
            end)
        end
    end
})


local Players = game:GetService("Players")
local speed = 16

local function setSpeed(val)
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = val end
end


Tabs.Player:Slider({
    Title = "Speed",
    Value = { Min = 16, Max = 150, Default = 16 },
    Callback = function(value)
        speed = value
    end
})

Tabs.Player:Toggle({
    Title = "Enable Speed",
    Value = false,
    Callback = function(state)
        setSpeed(state and speed or 16)
    end
})

local noclipEnabled = false
Tabs.Player:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(state)
        noclipEnabled = state
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()

        if state then
            _G.NoclipConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            WindUI:Notify({Title="Noclip", Content="Enabled", Duration=2})
        else
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
                _G.NoclipConnection = nil
            end
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            print("Noclip")
        end
    end
})

Tabs.Player:Button({
    Title = "Tp Tools",
    Locked = false,
    Callback = function()
       local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click TP"
tool.Activated:Connect(function()
    local pos = game.Players.LocalPlayer:GetMouse().Hit + Vector3.new(0,2.5,0)
    game.Players.LocalPlayer.Character:MoveTo(pos.Position)
end)
tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

Tabs.Player:Button({
    Title = "Reset Character",
    Locked = false,
    Callback = function()
      game.Players.LocalPlayer.Character:BreakJoints()
    end
})

Tabs.Player:Button({
    Title = "Rejoin",
    Locked = false,
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

Tabs.Player:Section({ 
    Title = "Ui",
})

Tabs.Player:Button({
    Title = "Open Ui Plants Shop",
    Locked = false,
    Callback = function()
local OpenUI = ReplicatedStorage.Remotes.OpenUI
local Seeds = Players.LocalPlayer.PlayerGui.Main.Seeds
OpenUI:Fire(
    Seeds,
    true
)
    end
})

Tabs.Player:Button({
    Title = "Open Ui Gear Shop",
    Locked = false,
    Callback = function()
local OpenUI = ReplicatedStorage.Remotes.OpenUI
local Gears = Players.LocalPlayer.PlayerGui.Main.Gears
OpenUI:Fire(
    Gears,
    true
)
    end
})

Tabs.Player:Button({
    Title = "Open Ui Setting",
    Locked = false,
    Callback = function()
local OpenUI = ReplicatedStorage.Remotes.OpenUI 
local Settings = Players.LocalPlayer.PlayerGui.Main.Settings
OpenUI:Fire(
    Settings,
    true
)
    end
})

Tabs.Player:Section({
    Title = "Visual",
})

Tabs.Visual:Button({
    Title = "Seraphin Dupe ( VISUAL ) ",
    Locked = false,
    Callback = function()
    WindUI:Notify({
    Title = "Seraphin Duper",
    Content = "Executed",
    Duration = 5, -- 3 seconds
})
 loadstring(game:HttpGet(" https://raw.githubusercontent.com/akbarhub/MoonZHub/refs/heads/main/Seraphindupevisual"))()
    end
})

--Mana Tomborio Yg Kamu janjikan itu😒😏🤪🥰😍