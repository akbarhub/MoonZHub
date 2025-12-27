local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


--// Services //--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

--// Player Variables //--
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")


LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    task.wait(0.5)
    if PlayerMods and PlayerMods.Speed then
        Humanoid.WalkSpeed = PlayerMods.Speed
    end
    if PlayerMods and PlayerMods.JumpPower then
        Humanoid.JumpPower = PlayerMods.JumpPower
    end
end)


local Window = WindUI:CreateWindow({
    Title = "Solar Hub | Murder Mystery 2",
    Icon = "door-open", -- lucide icon
    Author = "by .ftgs and .ftgs",
    Folder = "hello",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(500, 350),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    
    --       remove this all, 
    -- !  ↓  if you DON'T need the key system
    KeySystem = { 
        -- ↓ Optional. You can remove it.
        Key = { "SolarHubXX_XYYZz", "Developer Access" },
        
        Note = "Example Key System.",
        
        -- ↓ Optional. You can remove it.
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "Thumbnail",
        },
        
        -- ↓ Optional. You can remove it.
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)",
        
        -- ↓ Optional. You can remove it.
        SaveKey = true, -- automatically save and load the key.
        
        -- ↓ Optional. You can remove it.
        -- API = {} ← Services. Read about it below ↓
    },
})


local roles = {}
local Murder, Sheriff, Hero = nil, nil, nil
local mapPaths = {
    "Factory", 
    "Hospital3", 
    "MilBase", 
    "House2", 
    "Workplace", 
    "Mansion2", 
    "BioLab", 
    "Hotel", 
    "Bank2", 
    "PoliceStation", 
    "ResearchFacility",
    "Library2",
    "Office2",
    "School2",
    "Mall",
    "Ancient",
}


local function UpdateRoles()
    local success, result = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    if success and result then
        roles = result
        Murder, Sheriff, Hero = nil, nil, nil
        for name, data in pairs(roles) do
            if data.Role == "Murderer" then 
                Murder = name
            elseif data.Role == "Sheriff" then 
                Sheriff = name
            elseif data.Role == "Hero" then 
                Hero = name 
            end
        end
    end
end

local function IsAlive(player)
    for name, data in pairs(roles) do
        if player.Name == name then
            return not data.Killed and not data.Dead
        end
    end
    return false
end

local function GetRole(player)
    local character = player.Character
    if not character then return nil end
    local backpack = player:FindFirstChild("Backpack")
    if character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then 
        return "Murderer" 
    end
    if character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then 
        return "Sheriff" 
    end
    return "Innocent"
end

local function GetMap()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:GetAttribute("MapID") and obj:FindFirstChild("CoinContainer") then
            return obj
        end
    end
    return nil
end

local function GetCurrentMapName()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:GetAttribute("MapID") then
            return obj.Name
        end
    end
    return "Lobby"
end

local function GetPlayerList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    return list
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.5,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

WindUI:Notify({
    Title = "Solar Hub | Murder Mystery 2",
    Content = "Loaded",
    Duration = 6, -- 3 seconds
    Icon = "bird",
})

-- Tabs

local Tabs = {}

Tabs.Home = Window:Tab({
    Title = "Home",
    Icon = "bird", -- optional
    Locked = false,
})

Tabs.Combat = Window:Tab({
    Title = "Combat",
    Icon = "bird", -- optional
    Locked = false,
})

-- Tabs Toggle
Tabs.Home:Button({
    Title = "Join Discord Now!",
    Desc = "Copy Link Invite Discord",
    Locked = false,
    Callback = function()
        setclipboard("i")
    end
})

Tabs.Combat:Section({ 
    Title = "Combat",
})

--// Auto-refresh player list //--
Players.PlayerAdded:Connect(function()
    task.wait(1)
    pcall(function()
        teleportDropdown:Refresh(GetPlayerList())
    end)
end)

Players.PlayerRemoving:Connect(function()
    pcall(function()
        teleportDropdown:Refresh(GetPlayerList())
    end)
end)


local AimbotConfig = {
    Enabled = false,
    LockCamera = false,
    SpectateMode = false,
    TargetRole = "None",
    SilentAim = false,
    Prediction = 0.14,
    Smoothness = 0.5,
    TargetPart = "Head",
    FOV = 500,
    ShowFOV = false,
}

local originalCameraType = Enum.CameraType.Custom
local originalCameraSubject = nil
local fovCircle = nil

Tabs.Combat:Section({ 
    Title = "Setinggs",
})

Tabs.Combat:Dropdown({
    Title = "Target Role",
    Desc = "Select which role to aim at",
    Values = {"None", "Murderer", "Sheriff", "Closest"},
    Value = "None",
    Callback = function(selected)
        AimbotConfig.TargetRole = selected
    end
})

Tabs.Combat:Dropdown({
    Title = "Target Part",
    Desc = "Which body part to aim at",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Value = "Head",
    Callback = function(selected)
        AimbotConfig.TargetPart = selected
    end
})

Tabs.Combat:Section({ 
    Title = "Camera Lock",
    TextSize = 20,
})

Tabs.Combat:Toggle({
    Title = "Lock Camera",
    Desc = "Lock your camera to face the target",
    Icon = "lock",
    Default = false,
    Callback = function(state)
        AimbotConfig.LockCamera = state
        if not state and not AimbotConfig.SpectateMode then
            CurrentCamera.CameraType = originalCameraType
            CurrentCamera.CameraSubject = originalCameraSubject
        end
    end
})

Tabs.Combat:Slider({
    Title = "Smoothness",
    Desc = "How smooth the camera lock is (lower = snappier)",
    Step = 0.05,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.5,
    },
    Callback = function(value)
        AimbotConfig.Smoothness = value
    end
})

Tabs.Combat:Section({ 
    Title = "Silent Aim",
    TextSize = 20,
})

Tabs.Combat:Toggle({
    Title = "Silent Aim",
    Desc = "Automatically hit murderer when you shoot (Sheriff only)",
    Icon = "crosshair",
    Default = false,
    Callback = function(state)
        AimbotConfig.SilentAim = state
    end
})

Tabs.Combat:Slider({
    Title = "Prediction",
    Desc = "Predict target movement (higher = more prediction)",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 0.5,
        Default = 0.14,
    },
    Callback = function(value)
        AimbotConfig.Prediction = value
    end
})

Tabs.Combat:Section({ 
    Title = "FOV",
    TextSize = 20,
})

Tabs.Combat:Toggle({
    Title = "Show FOV Circle",
    Desc = "Display the aimbot FOV on screen",
    Icon = "circle",
    Default = false,
    Callback = function(state)
        AimbotConfig.ShowFOV = state
        if fovCircle then
            fovCircle.Visible = state
        else
            fovCircle = Drawing.new("Circle")
            fovCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
            fovCircle.Radius = AimbotConfig.FOV
            fovCircle.Color = Color3.new(1, 1, 1)
            fovCircle.Thickness = 1
            fovCircle.Filled = false
            fovCircle.Visible = state
        end
    end
})

Tabs.Combat:Slider({
    Title = "FOV Size",
    Desc = "Size of the aimbot field of view",
    Step = 10,
    Value = {
        Min = 50,
        Max = 1000,
        Default = 500,
    },
    Callback = function(value)
        AimbotConfig.FOV = value
        if fovCircle then
            fovCircle.Radius = value
        end
    end
})

local function GetAimbotTarget()
    if AimbotConfig.TargetRole == "None" then return nil end
    
    if AimbotConfig.TargetRole == "Closest" then
        local closest = nil
        local minDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and IsAlive(player) then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = GetDistance(HumanoidRootPart.Position, hrp.Position)
                    if dist < minDist then
                        minDist = dist
                        closest = player
                    end
                end
            end
        end
        return closest
    end
    
    local targetName = AimbotConfig.TargetRole == "Sheriff" and Sheriff or Murder
    if not targetName then return nil end
    local player = Players:FindFirstChild(targetName)
    if not player or not IsAlive(player) then return nil end
    return player
end

local function GetMurderer()
    UpdateRoles()
    if Murder then
        return Players:FindFirstChild(Murder)
    end
    return nil
end

task.defer(function()
    pcall(function()
        if not (hookmetamethod and getnamecallmethod and checkcaller) then return end
        
        local oldNC
        oldNC = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if not checkcaller() and AimbotConfig.SilentAim and self.Name == "HitPart" and method == "InvokeServer" then
                local murderer = GetMurderer()
                if murderer and murderer.Character then
                    local head = murderer.Character:FindFirstChild("Head")
                    local root = murderer.Character:FindFirstChild("HumanoidRootPart")
                    if head and root then
                        local humanoid = murderer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local predictedPos = root.Position + (root.Velocity * AimbotConfig.Prediction)
                            args[1] = predictedPos
                            args[2] = head
                        end
                    end
                end
            end
            
            return oldNC(self, unpack(args))
        end)
    end)
end)

--// Aimbot Update Loop //--
RunService.RenderStepped:Connect(function()
    if AimbotConfig.LockCamera and AimbotConfig.TargetRole ~= "None" then
        local target = GetAimbotTarget()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(AimbotConfig.TargetPart) or target.Character:FindFirstChild("Head")
            if targetPart then
                local currentPos = CurrentCamera.CFrame.Position
                local targetPos = targetPart.Position
                local newCFrame = CFrame.new(currentPos, targetPos)
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(newCFrame, 1 - AimbotConfig.Smoothness)
            end
        end
    end
    
    if AimbotConfig.SpectateMode and AimbotConfig.TargetRole ~= "None" then
        local target = GetAimbotTarget()
        if target and target.Character then
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local offset = CFrame.new(0, 2, AimbotConfig.SpectateDistance)
                CurrentCamera.CFrame = root.CFrame * offset
            end
        end
    end
    
    if fovCircle and AimbotConfig.ShowFOV then
        fovCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
    end
end)


Tabs.Combat:Section({ 
    Title = "Spectate Mode",
    TextSize = 20,
})

Tabs.Combat:Button({
    Title = "Auto-Equip Weapon",
    Desc = "Equip your knife or gun based on your role",
    Icon = "package",
    Color = Colors.Blue,
    Justify = "Center",
    Callback = function()
        UpdateRoles()
        local playerRole = roles[LocalPlayer.Name]
        if playerRole then
            local weaponType = (playerRole.Role == "Sheriff" or playerRole.Role == "Hero") and "Gun" or "Knife"
            pcall(function()
                ReplicatedStorage.Remotes.Inventory.Equip:FireServer(weaponType)
            end)
            WindUI:Notify({
                Title = "Equipped",
                Content = "Equipped " .. weaponType,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Could not detect your role",
                Duration = 2,
            })
        end
    end
})

Tabs.Combat:Section({ 
    Title = "Murderer (ONLY)",
    TextSize = 20,
})

Tabs.Combat:Button({
    Title = "Kill Nearest Player",
    Desc = "Attack the closest player to you",
    Icon = "skull",
    Color = Colors.Red,
    Justify = "Center",
    Callback = function()
        local nearestPlayer, minDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = GetDistance(player.Character.HumanoidRootPart.Position, HumanoidRootPart.Position)
                if dist < minDist then
                    nearestPlayer = player
                    minDist = dist
                end
            end
        end
        
        if nearestPlayer then
            pcall(function()
                ReplicatedStorage.Remotes.Gameplay.KnifeKill:FireServer(nearestPlayer.Character.HumanoidRootPart.Position)
            end)
            WindUI:Notify({
                Title = "Attack",
                Content = "Attacked " .. nearestPlayer.Name .. " (" .. math.floor(minDist) .. " studs)",
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "No players nearby",
                Duration = 2,
            })
        end
    end
})

Tabs.Combat:Button({
    Title = "Kill Sheriff",
    Desc = "Attack the sheriff directly",
    Icon = "shield-off",
    Color = Colors.Orange,
    Justify = "Center",
    Callback = function()
        UpdateRoles()
        if Sheriff then
            local sheriffPlayer = Players:FindFirstChild(Sheriff)
            if sheriffPlayer and sheriffPlayer.Character then
                local hrp = sheriffPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        ReplicatedStorage.Remotes.Gameplay.KnifeKill:FireServer(hrp.Position)
                    end)
                    WindUI:Notify({
                        Title = "Attack",
                        Content = "Attacked Sheriff: " .. Sheriff,
                        Duration = 2,
                    })
                end
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "No sheriff found",
                Duration = 2,
            })
        end
    end
})

Tabs.Combat:Section({ 
    Title = "Sheriff (ONLY)",
    TextSize = 20,
})

Tabs.Combat:Button({
    Title = "Shoot Murderer",
    Desc = "Attempt to shoot the murderer",
    Icon = "target",
    Color = Colors.Blue,
    Justify = "Center",
    Callback = function()
        UpdateRoles()
        if Murder then
            local murderPlayer = Players:FindFirstChild(Murder)
            if murderPlayer and murderPlayer.Character then
                local head = murderPlayer.Character:FindFirstChild("Head")
                if head then
                    pcall(function()
                        ReplicatedStorage.Remotes.Gameplay.HitPart:InvokeServer(head.Position, head)
                    end)
                    WindUI:Notify({
                        Title = "Shot",
                        Content = "Shot at Murderer: " .. Murder,
                        Duration = 2,
                    })
                end
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Murderer not found",
                Duration = 2,
            })
        end
    end
})

Tabs.Combat:Section({ 
    Title = "Auto Combat",
    TextSize = 20,
})

local CombatConfig = {
    AutoKill = false,
    AutoShoot = false,
    AutoMurderer = false,
    KillDelay = 0.5,
}

Tabs.Combat:Toggle({
    Title = "Auto Kill (Murderer)",
    Desc = "Automatically kill nearby players",
    Icon = "skull",
    Default = false,
    Callback = function(state)
        CombatConfig.AutoKill = state
        if state then
            task.spawn(function()
                while CombatConfig.AutoKill do
                    local playerRole = roles[LocalPlayer.Name]
                    if playerRole and playerRole.Role == "Murderer" then
                        local nearestPlayer, minDist = nil, math.huge
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = GetDistance(player.Character.HumanoidRootPart.Position, HumanoidRootPart.Position)
                                if dist < 15 and dist < minDist then
                                    nearestPlayer = player
                                    minDist = dist
                                end
                            end
                        end
                        if nearestPlayer then
                            pcall(function()
                                ReplicatedStorage.Remotes.Gameplay.KnifeKill:FireServer(nearestPlayer.Character.HumanoidRootPart.Position)
                            end)
                        end
                    end
                    task.wait(CombatConfig.KillDelay)
                end
            end)
        end
    end
})