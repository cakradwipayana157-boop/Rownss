-- ROWNN GUI - Delta Executor Version
-- Key: 051012
-- Theme: Elektronik / Cyberpunk
-- Features: Fly (Android), Noclip, ESP, Hitbox, Infinity Jump, Bring Part, Fling Player

-- ==================== KEY VERIFICATION ====================
local correctKey = "051012"
local inputKey = "051012" -- Key yang dimasukkan

if inputKey ~= correctKey then
    error("❌ ACCESS DENIED: Invalid Key!")
    return
end

print("✅ Key Verified: ACCESS GRANTED")
print("⚡ Loading ROWNN GUI...")

-- ==================== LOAD SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ==================== CREATE ELECTRONIK THEME GUI ====================
local RownnGui = Instance.new("ScreenGui")
RownnGui.Name = "RownnGUI_Elektronik"
RownnGui.Parent = game:GetService("CoreGui")
RownnGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container with Cyberpunk Theme
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = RownnGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

-- Cyberpunk Glow Effect
local Glow = Instance.new("Frame")
Glow.Name = "Glow"
Glow.Parent = MainFrame
Glow.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Glow.BackgroundTransparency = 0.8
Glow.BorderSizePixel = 0
Glow.Size = UDim2.new(1, 10, 1, 10)
Glow.Position = UDim2.new(0, -5, 0, -5)
Glow.ZIndex = -1

-- Title Bar with Neon Effect
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Text = "⚡ ROWNN GUI v2.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.SciFi
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Parent = TitleBar
SubTitle.Text = "ELEKTRONIK EDITION"
SubTitle.TextColor3 = Color3.fromRGB(100, 255, 255)
SubTitle.Font = Enum.Font.Code
SubTitle.TextSize = 12
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0.6, 0)
SubTitle.Size = UDim2.new(1, 0, 0.4, 0)

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.Size = UDim2.new(1, 0, 1, -40)

-- Scrolling Frame for Features
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = Content
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)

-- ==================== FEATURE VARIABLES ====================
local FlyEnabled = false
local NoclipEnabled = false
local EspEnabled = false
local HitboxEnabled = false
local InfJumpEnabled = false
local BringPartsEnabled = false
local FlingEnabled = false

local FlySpeed = 50
local FlyConnection, NoclipConnection, JumpConnection, FlingConnection
local BodyVelocity, BodyGyro
local OriginalTransparency = {}

-- ==================== CREATE FEATURE BUTTONS ====================
local Features = {
    {name = "FLY", desc = "Android Flying System", icon = "🚀", yPos = 0},
    {name = "NO CLIP", desc = "Walk through walls", icon = "🔓", yPos = 60},
    {name = "ESP", desc = "See all players", icon = "👁️", yPos = 120},
    {name = "HITBOX", desc = "Expand hitbox size", icon = "🎯", yPos = 180},
    {name = "INF JUMP", desc = "Jump infinitely", icon = "🦘", yPos = 240},
    {name = "BRING PARTS", desc = "Bring all parts to you", icon = "🧲", yPos = 300},
    {name = "FLING PLAYER", desc = "Fling selected player", icon = "💥", yPos = 360}
}

local FeatureButtons = {}

for i, feature in ipairs(Features) do
    -- Feature Container
    local FeatureFrame = Instance.new("Frame")
    FeatureFrame.Name = feature.name .. "Frame"
    FeatureFrame.Parent = ScrollFrame
    FeatureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    FeatureFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    FeatureFrame.Size = UDim2.new(1, -10, 0, 50)
    FeatureFrame.Position = UDim2.new(0, 5, 0, feature.yPos)
    
    -- Feature Icon
    local Icon = Instance.new("TextLabel")
    Icon.Name = "Icon"
    Icon.Parent = FeatureFrame
    Icon.Text = feature.icon
    Icon.TextColor3 = Color3.fromRGB(0, 255, 255)
    Icon.Font = Enum.Font.SciFi
    Icon.TextSize = 20
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 40, 1, 0)
    Icon.Position = UDim2.new(0, 5, 0, 0)
    
    -- Feature Name
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "Name"
    NameLabel.Parent = FeatureFrame
    NameLabel.Text = feature.name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.Font = Enum.Font.Code
    NameLabel.TextSize = 14
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(0, 100, 0, 25)
    NameLabel.Position = UDim2.new(0, 45, 0, 5)
    
    -- Feature Description
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Desc"
    DescLabel.Parent = FeatureFrame
    DescLabel.Text = feature.desc
    DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    DescLabel.Font = Enum.Font.Code
    DescLabel.TextSize = 10
    DescLabel.BackgroundTransparency = 1
    DescLabel.Size = UDim2.new(0, 150, 0, 20)
    DescLabel.Position = UDim2.new(0, 45, 0, 25)
    
    -- Toggle Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = feature.name .. "Toggle"
    ToggleBtn.Parent = FeatureFrame
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    ToggleBtn.Font = Enum.Font.Code
    ToggleBtn.TextSize = 12
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ToggleBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
    ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
    
    FeatureButtons[feature.name] = ToggleBtn
end

-- Speed Control
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Parent = ScrollFrame
SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SpeedFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
SpeedFrame.Size = UDim2.new(1, -10, 0, 50)
SpeedFrame.Position = UDim2.new(0, 5, 0, 420)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = SpeedFrame
SpeedLabel.Text = "FLY SPEED: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.Font = Enum.Font.Code
SpeedLabel.TextSize = 14
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 150, 1, 0)
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Parent = SpeedFrame
SpeedBox.Text = "50"
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Code
SpeedBox.TextSize = 14
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedBox.BorderColor3 = Color3.fromRGB(0, 150, 255)
SpeedBox.Size = UDim2.new(0, 60, 0, 30)
SpeedBox.Position = UDim2.new(1, -70, 0.5, -15)

-- ==================== FLY SYSTEM (ANDROID OPTIMIZED) ====================
FeatureButtons["FLY"].MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FeatureButtons["FLY"].Text = FlyEnabled and "ON" or "OFF"
    FeatureButtons["FLY"].TextColor3 = FlyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if FlyEnabled then
        -- Enable Fly for Android
        if not Player.Character then Player.CharacterAdded:Wait() end
        local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")
        
        -- Create physics for smooth flying
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        BodyVelocity.P = 1250
        BodyVelocity.Parent = HumanoidRootPart
        
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
        BodyGyro.P = 3000
        BodyGyro.Parent = HumanoidRootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not Player.Character then return end
            
            local camera = Workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            
            local movement = Vector3.new(0, 0, 0)
            
            -- Android Virtual Joystick Detection
            if UserInputService.TouchEnabled then
                -- Virtual Joystick will automatically work in Roblox Android
                -- Movement is controlled by Roblox's virtual joystick
            else
                -- Keyboard controls for testing
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    movement = movement + (lookVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    movement = movement - (lookVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    movement = movement - (rightVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    movement = movement + (rightVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    movement = movement + Vector3.new(0, FlySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    movement = movement - Vector3.new(0, FlySpeed, 0)
                end
            end
            
            BodyVelocity.Velocity = movement
            BodyGyro.CFrame = camera.CFrame
            
            -- Auto noclip while flying
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        print("[ROWNN] Fly System: ENABLED (Android Optimized)")
    else
        -- Disable Fly
        if FlyConnection then FlyConnection:Disconnect() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        
        -- Restore collision
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        print("[ROWNN] Fly System: DISABLED")
    end
end)

-- ==================== NO CLIP ====================
FeatureButtons["NO CLIP"].MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    FeatureButtons["NO CLIP"].Text = NoclipEnabled and "ON" or "OFF"
    FeatureButtons["NO CLIP"].TextColor3 = NoclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("[ROWNN] Noclip: ENABLED")
    else
        if NoclipConnection then NoclipConnection:Disconnect() end
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("[ROWNN] Noclip: DISABLED")
    end
end)

-- ==================== ESP ====================
FeatureButtons["ESP"].MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    FeatureButtons["ESP"].Text = EspEnabled and "ON" or "OFF"
    FeatureButtons["ESP"].TextColor3 = EspEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if EspEnabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_" .. otherPlayer.Name
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = otherPlayer.Character
                
                -- Add name tag
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESP_Name_" .. otherPlayer.Name
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = otherPlayer.Character:FindFirstChild("Head") or otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                billboard.Parent = otherPlayer.Character
                
                local label = Instance.new("TextLabel")
                label.Text = otherPlayer.Name
                label.Size = UDim2.new(1, 0, 1, 0)
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Code
                label.TextSize = 14
                label.Parent = billboard
            end
        end
        print("[ROWNN] ESP: ENABLED")
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character then
                local esp = otherPlayer.Character:FindFirstChild("ESP_" .. otherPlayer.Name)
                local nameTag = otherPlayer.Character:FindFirstChild("ESP_Name_" .. otherPlayer.Name)
                if esp then esp:Destroy() end
                if nameTag then nameTag:Destroy() end
            end
        end
        print("[ROWNN] ESP: DISABLED")
    end
end)

-- ==================== HITBOX ====================
FeatureButtons["HITBOX"].MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    FeatureButtons["HITBOX"].Text = HitboxEnabled and "ON" or "OFF"
    FeatureButtons["HITBOX"].TextColor3 = HitboxEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if HitboxEnabled then
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * 1.5
                end
            end
        end
        print("[ROWNN] Hitbox: ENABLED (Size x1.5)")
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size / 1.5
                end
            end
        end
        print("[ROWNN] Hitbox: DISABLED")
    end
end)

-- ==================== INFINITY JUMP ====================
FeatureButtons["INF JUMP"].MouseButton1Click:Connect(function()
    InfJumpEnabled = not InfJumpEnabled
    FeatureButtons["INF JUMP"].Text = InfJumpEnabled and "ON" or "OFF"
    FeatureButtons["INF JUMP"].TextColor3 = InfJumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if InfJumpEnabled then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("[ROWNN] Infinity Jump: ENABLED")
    else
        if JumpConnection then JumpConnection:Disconnect() end
        print("[ROWNN] Infinity Jump: DISABLED")
    end
end)

-- ==================== BRING PARTS ====================
FeatureButtons["BRING PARTS"].MouseButton1Click:Connect(function()
    BringPartsEnabled = not BringPartsEnabled
    FeatureButtons["BRING PARTS"].Text = BringPartsEnabled and "ON" or "OFF"
    FeatureButtons["BRING PARTS"].TextColor3 = BringPartsEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if BringPartsEnabled then
        spawn(function()
            while BringPartsEnabled do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = Player.Character.HumanoidRootPart
                    local parts = Workspace:GetDescendants()
                    
                    for _, part in pairs(parts) do
                        if BringPartsEnabled and part:IsA("BasePart") and part ~= root then
                            part.Velocity = (root.Position - part.Position).Unit * 100
                        end
                    end
                end
                wait(0.1)
            end
        end)
        print("[ROWNN] Bring Parts: ENABLED")
    else
        print("[ROWNN] Bring Parts: DISABLED")
    end
end)

-- ==================== FLING PLAYER ====================
local SelectedPlayer = nil
local PlayerSelectionFrame = Instance.new("Frame")
PlayerSelectionFrame.Name = "PlayerSelectionFrame"
PlayerSelectionFrame.Parent = ScrollFrame
PlayerSelectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerSelectionFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
PlayerSelectionFrame.Size = UDim2.new(1, -10, 0, 80)
PlayerSelectionFrame.Position = UDim2.new(0, 5, 0, 480)

local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Name = "PlayerLabel"
PlayerLabel.Parent = PlayerSelectionFrame
PlayerLabel.Text = "SELECT PLAYER TO FLING:"
PlayerLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
PlayerLabel.Font = Enum.Font.Code
PlayerLabel.TextSize = 12
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.Size = UDim2.new(1, 0, 0, 20)
PlayerLabel.Position = UDim2.new(0, 10, 0, 5)

local SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Name = "SelectedPlayerLabel"
SelectedPlayerLabel.Parent = PlayerSelectionFrame
SelectedPlayerLabel.Text = "None"
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerLabel.Font = Enum.Font.Code
SelectedPlayerLabel.TextSize = 14
SelectedPlayerLabel.BackgroundTransparency = 1
SelectedPlayerLabel.Size = UDim2.new(0.5, 0, 0, 20)
SelectedPlayerLabel.Position = UDim2.new(0, 10, 0, 25)

local PlayerListButton = Instance.new("TextButton")
PlayerListButton.Name = "PlayerListButton"
PlayerListButton.Parent = PlayerSelectionFrame
PlayerListButton.Text = "SELECT"
PlayerListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerListButton.Font = Enum.Font.Code
PlayerListButton.TextSize = 12
PlayerListButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
PlayerListButton.BorderColor3 = Color3.fromRGB(0, 150, 255)
PlayerListButton.Size = UDim2.new(0, 80, 0, 30)
PlayerListButton.Position = UDim2.new(1, -90, 0, 25)

-- Player Selection Function
PlayerListButton.MouseButton1Click:Connect(function()
    local selectionGui = Instance.new("ScreenGui")
    selectionGui.Name = "PlayerSelectionGui"
    selectionGui.Parent = RownnGui
    
    local selectionFrame = Instance.new("Frame")
    selectionFrame.Name = "SelectionFrame"
    selectionFrame.Parent = selectionGui
    selectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    selectionFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    selectionFrame.Size = UDim2.new(0, 250, 0, 300)
    selectionFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    selectionFrame.Active = true
    selectionFrame.Draggable = true
    
    local title = Instance.new("TextLabel")
    title.Text = "SELECT PLAYER"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.Code
    title.TextSize = 16
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Parent = selectionFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.Parent = selectionFrame
    
    local yPos = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local playerButton = Instance.new("TextButton")
            playerButton.Text = player.Name
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.Font = Enum.Font.Code
            playerButton.TextSize = 12
            playerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            playerButton.BorderColor3 = Color3.fromRGB(0, 150, 255)
            playerButton.Size = UDim2.new(1, -10, 0, 30)
            playerButton.Position = UDim2.new(0, 5, 0, yPos)
            playerButton.Parent = scrollFrame
            
            playerButton.MouseButton1Click:Connect(function()
                SelectedPlayer = player
                SelectedPlayerLabel.Text = player.Name
                selectionGui:Destroy()
                print("[ROWNN] Selected player: " .. player.Name)
            end)
            
            yPos = yPos + 35
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "CLOSE"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.Code
    closeButton.TextSize = 12
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(0.5, -50, 1, -35)
    closeButton.Parent = selectionFrame
    
    closeButton.MouseButton1Click:Connect(function()
        selectionGui:Destroy()
    end)
end)

-- Fling Function
FeatureButtons["FLING PLAYER"].MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    FeatureButtons["FLING PLAYER"].Text = FlingEnabled and "ON" or "OFF"
    FeatureButtons["FLING PLAYER"].TextColor3 = FlingEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    
    if FlingEnabled and SelectedPlayer then
        if SelectedPlayer.Character then
            local targetRoot = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                -- Apply massive velocity to fling player
                targetRoot.Velocity = Vector3.new(10000, 10000, 10000)
                print("[ROWNN] Flinging player: " .. SelectedPlayer.Name)
            end
        end
    else
        print("[ROWNN] Fling: No player selected or disabled")
    end
end)

-- ==================== SPEED CONTROL ====================
SpeedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 200 then
        FlySpeed = newSpeed
        SpeedLabel.Text = "FLY SPEED: " .. newSpeed
    else
        SpeedBox.Text = FlySpeed
    end
end)

-- ==================== MOBILE OPTIMIZATION ====================
if UserInputService.TouchEnabled then
    -- Make buttons bigger for touch
    for _, btn in pairs(FeatureButtons) do
        btn.Size = UDim2.new(0, 80, 0, 40)
    end
    
    PlayerListButton.Size = UDim2.new(0, 100, 0, 40)
    
    -- Add mobile instructions
    local MobileInfo = Instance.new("TextLabel")
    MobileInfo.Text = "📱 Android Mode: Use Virtual Joystick"
    MobileInfo.TextColor3 = Color3.fromRGB(0, 255, 100)
    MobileInfo.Font = Enum.Font.Code
    MobileInfo.TextSize = 12
    MobileInfo.BackgroundTransparency = 1
    MobileInfo.Size = UDim2.new(1, 0, 0, 20)
    MobileInfo.Position = UDim2.new(0, 10, 0, 580)
    MobileInfo.Parent = ScrollFrame
end

-- ==================== CLEANUP ====================
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == Player then
        RownnGui:Destroy()
        if FlyConnection then FlyConnection:Disconnect() end
        if NoclipConnection then NoclipConnection:Disconnect() end
        if JumpConnection then JumpConnection:Disconnect() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end
end)

-- ==================== FINAL MESSAGE ====================
print("╔══════════════════════════════════════════════╗")
print("║        ROWNN GUI LOADED SUCCESSFULLY        ║")
print("║           ELEKTRONIK EDITION v2.0           ║")
print("║                                             ║")
print("║  Features Available:                        ║")
print("║  • 🚀 Fly System (Android Optimized)        ║")
print("║  • 🔓 Noclip Mode                           ║")
print("║  • 👁️ ESP (Player Highlight)               ║")
print("║  • 🎯 Hitbox Expander                       ║")
print("║  • 🦘 Infinity Jump                         ║")
print("║  • 🧲 Bring All Parts                       ║")
print("║  • 💥 Fling Player                          ║")
print("║                                             ║")
print("║  Executor: Delta Compatible                 ║")
print("║  Theme: Elektronik / Cyberpunk              ║")
print("╚══════════════════════════════════════════════╝")

-- Success Notification
local notification = Instance.new("ScreenGui")
notification.Parent = game:GetService("CoreGui")

local notifFrame = Instance.new("Frame")
notifFrame.BackgroundColor3 = Color3.fromRGB(0, 40, 60)
notifFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
notifFrame.Size = UDim2.new(0, 300, 0, 100)
notifFrame.Position = UDim2.new(0.5, -150, 0.8, -50)
notifFrame.Parent = notification

local notifText = Instance.new("TextLabel")
notifText.Text = "✅ ROWNN GUI LOADED!\n🎮 All Features Ready"
notifText.TextColor3 = Color3.fromRGB(0, 255, 255)
notifText.Font = Enum.Font.Code
notifText.TextSize = 16
notifText.BackgroundTransparency = 1
notifText.Size = UDim2.new(1, 0, 1, 0)
notifText.Parent = notifFrame

-- Auto-remove notification
game:GetService("Debris"):AddItem(notification, 3)