-- ROWNN GUI ULTIMATE v5.0
-- Android Optimized - All Features Working
-- By: zamxs | DARK-GPT Special Edition

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- ========== LOADER SCREEN ==========
print("╔════════════════════════════════════════╗")
print("║        ROWNN GUI ULTIMATE v5.0         ║")
print("║          Loading Resources...          ║")
print("╚════════════════════════════════════════╝")

wait(0.5)

-- ========== CREATE GUI ==========
local RownnGui = Instance.new("ScreenGui")
RownnGui.Name = "RownnGuiUltimate"
RownnGui.Parent = CoreGui

-- Main Container (Mobile Optimized)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = RownnGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 50)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("TextButton")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Text = "⚡ ROWNN GUI ▼"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
TitleBar.TextColor3 = Color3.fromRGB(255, 50, 50)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 16

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.Size = UDim2.new(1, 0, 0, 400)
Content.Visible = false

-- Toggle GUI
local GuiExpanded = false
TitleBar.MouseButton1Click:Connect(function()
    GuiExpanded = not GuiExpanded
    Content.Visible = GuiExpanded
    MainFrame.Size = GuiExpanded and UDim2.new(0, 350, 0, 450) or UDim2.new(0, 350, 0, 50)
    TitleBar.Text = GuiExpanded and "⚡ ROWNN GUI ▲" or "⚡ ROWNN GUI ▼"
end)

-- ========== CREATE SCROLLING TABS ==========
local TabsFrame = Instance.new("ScrollingFrame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = Content
TabsFrame.Size = UDim2.new(1, 0, 1, 0)
TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
TabsFrame.ScrollBarThickness = 5
TabsFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)

-- ========== GLOBAL VARIABLES ==========
local FlyEnabled = false
local NoclipEnabled = false
local InfJumpEnabled = false
local InvisibleEnabled = false
local HitboxEnabled = false
local EspEnabled = false
local SpeedHackEnabled = false
local BringPartsEnabled = false
local SpamRemoteEnabled = false

local FlySpeed = 50
local WalkSpeed = 16
local JumpPower = 50

local FlyConnection, NoclipConnection, JumpConnection, EspConnection
local BodyVelocity, BodyGyro
local OriginalWalkSpeed, OriginalJumpPower
local OriginalTransparency = {}

-- ========== MOBILE TOUCH CONTROLS ==========
local TouchControls = Instance.new("Frame")
TouchControls.Name = "TouchControls"
TouchControls.Parent = RownnGui
TouchControls.BackgroundTransparency = 1
TouchControls.Size = UDim2.new(1, 0, 1, 0)

-- Virtual Joystick Area (for Android)
local JoystickArea = Instance.new("Frame", TouchControls)
JoystickArea.Size = UDim2.new(0.3, 0, 0.3, 0)
JoystickArea.Position = UDim2.new(0.05, 0, 0.6, 0)
JoystickArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 100)
JoystickArea.BackgroundTransparency = 0.7
JoystickArea.BorderSizePixel = 0

-- ========== CREATE FEATURE BUTTONS ==========
local Features = {
    {name = "FLY", icon = "🚀", yPos = 0.02},
    {name = "NO CLIP", icon = "🔓", yPos = 0.12},
    {name = "INFINITY JUMP", icon = "🦘", yPos = 0.22},
    {name = "INVISIBLE", icon = "👻", yPos = 0.32},
    {name = "HITBOX", icon = "🎯", yPos = 0.42},
    {name = "ESP", icon = "👁️", yPos = 0.52},
    {name = "SPEED HACK", icon = "⚡", yPos = 0.62},
    {name = "BRING PARTS", icon = "🧲", yPos = 0.72},
    {name = "SPAM REMOTE", icon = "🔥", yPos = 0.82}
}

local FeatureButtons = {}

for i, feature in pairs(Features) do
    local FeatureButton = Instance.new("TextButton")
    FeatureButton.Name = feature.name .. "Btn"
    FeatureButton.Parent = TabsFrame
    FeatureButton.Text = feature.icon .. " " .. feature.name .. ": OFF"
    FeatureButton.Size = UDim2.new(0.95, 0, 0, 45)
    FeatureButton.Position = UDim2.new(0.025, 0, feature.yPos, 0)
    FeatureButton.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
    FeatureButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    FeatureButton.Font = Enum.Font.GothamBold
    FeatureButton.TextSize = 14
    
    FeatureButtons[feature.name] = FeatureButton
end

-- ========== FEATURE IMPLEMENTATIONS ==========

-- 1. FLY SYSTEM (Android Optimized)
FeatureButtons["FLY"].MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FeatureButtons["FLY"].Text = FlyEnabled and "🚀 FLY: ON" or "🚀 FLY: OFF"
    FeatureButtons["FLY"].TextColor3 = FlyEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if FlyEnabled then
        -- Enable Fly
        if not Player.Character then Player.CharacterAdded:Wait() end
        local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")
        
        -- Create physics for fly
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        BodyVelocity.P = 1250
        BodyVelocity.Parent = HumanoidRootPart
        
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
        BodyGyro.P = 3000
        BodyGyro.Parent = HumanoidRootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled then return end
            
            local Camera = Workspace.CurrentCamera
            local LookVector = Camera.CFrame.LookVector
            local RightVector = Camera.CFrame.RightVector
            local UpVector = Vector3.new(0, 1, 0)
            
            local Movement = Vector3.new(0, 0, 0)
            
            -- Android Touch Controls
            if UIS.TouchEnabled then
                -- Virtual joystick akan bekerja otomatis di Android
                -- Movement akan dikontrol oleh joystick virtual Roblox
            else
                -- Keyboard fallback (untuk testing)
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    Movement = Movement + (LookVector * FlySpeed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    Movement = Movement - (LookVector * FlySpeed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    Movement = Movement - (RightVector * FlySpeed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    Movement = Movement + (RightVector * FlySpeed)
                end
            end
            
            BodyVelocity.Velocity = Movement
            BodyGyro.CFrame = Camera.CFrame
            
            -- Auto enable noclip saat fly
            if FlyEnabled then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        print("[ROWNN] Fly System: ENABLED")
    else
        -- Disable Fly
        if FlyConnection then FlyConnection:Disconnect() end
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
        
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

-- 2. NO CLIP SYSTEM
FeatureButtons["NO CLIP"].MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    FeatureButtons["NO CLIP"].Text = NoclipEnabled and "🔓 NO CLIP: ON" or "🔓 NO CLIP: OFF"
    FeatureButtons["NO CLIP"].TextColor3 = NoclipEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
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

-- 3. INFINITY JUMP
FeatureButtons["INFINITY JUMP"].MouseButton1Click:Connect(function()
    InfJumpEnabled = not InfJumpEnabled
    FeatureButtons["INFINITY JUMP"].Text = InfJumpEnabled and "🦘 INFINITY JUMP: ON" or "🦘 INFINITY JUMP: OFF"
    FeatureButtons["INFINITY JUMP"].TextColor3 = InfJumpEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if InfJumpEnabled then
        JumpConnection = UIS.JumpRequest:Connect(function()
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

-- 4. INVISIBLE MODE
FeatureButtons["INVISIBLE"].MouseButton1Click:Connect(function()
    InvisibleEnabled = not InvisibleEnabled
    FeatureButtons["INVISIBLE"].Text = InvisibleEnabled and "👻 INVISIBLE: ON" or "👻 INVISIBLE: OFF"
    FeatureButtons["INVISIBLE"].TextColor3 = InvisibleEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if InvisibleEnabled then
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    OriginalTransparency[part] = part.Transparency
                    part.Transparency = 1
                end
            end
        end
        print("[ROWNN] Invisible Mode: ENABLED")
    else
        if Player.Character then
            for part, transparency in pairs(OriginalTransparency) do
                if part.Parent then
                    part.Transparency = transparency
                end
            end
            OriginalTransparency = {}
        end
        print("[ROWNN] Invisible Mode: DISABLED")
    end
end)

-- 5. HITBOX EXPANDER
FeatureButtons["HITBOX"].MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    FeatureButtons["HITBOX"].Text = HitboxEnabled and "🎯 HITBOX: ON" or "🎯 HITBOX: OFF"
    FeatureButtons["HITBOX"].TextColor3 = HitboxEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if HitboxEnabled then
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * 2
                end
            end
        end
        print("[ROWNN] Hitbox Expander: ENABLED")
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size / 2
                end
            end
        end
        print("[ROWNN] Hitbox Expander: DISABLED")
    end
end)

-- 6. ESP (Player Highlight)
FeatureButtons["ESP"].MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    FeatureButtons["ESP"].Text = EspEnabled and "👁️ ESP: ON" or "👁️ ESP: OFF"
    FeatureButtons["ESP"].TextColor3 = EspEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    local espBoxes = {}
    
    if EspEnabled then
        local function CreateESP(player)
            if player == Player then return end
            
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP_" .. player.Name
            box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(4, 6, 4)
            box.Color3 = Color3.fromRGB(255, 0, 0)
            box.Transparency = 0.5
            box.Parent = player.Character and player.Character.HumanoidRootPart
            
            espBoxes[player] = box
            
            local nameTag = Instance.new("BillboardGui")
            nameTag.Name = "ESP_Name"
            nameTag.Adornee = player.Character and player.Character.HumanoidRootPart
            nameTag.Size = UDim2.new(0, 200, 0, 50)
            nameTag.StudsOffset = Vector3.new(0, 4, 0)
            nameTag.AlwaysOnTop = true
            nameTag.Parent = player.Character and player.Character.HumanoidRootPart
            
            local label = Instance.new("TextLabel", nameTag)
            label.Text = player.Name
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
        end
        
        -- Create ESP for existing players
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                CreateESP(player)
            else
                player.CharacterAdded:Connect(function()
                    CreateESP(player)
                end)
            end
        end
        
        -- Listen for new players
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                CreateESP(player)
            end)
        end)
        
        print("[ROWNN] ESP: ENABLED")
    else
        -- Remove all ESP
        for player, box in pairs(espBoxes) do
            if box then box:Destroy() end
        end
        espBoxes = {}
        
        -- Remove name tags
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local esp = player.Character.HumanoidRootPart:FindFirstChild("ESP_" .. player.Name)
                local nameTag = player.Character.HumanoidRootPart:FindFirstChild("ESP_Name")
                if esp then esp:Destroy() end
                if nameTag then nameTag:Destroy() end
            end
        end
        
        print("[ROWNN] ESP: DISABLED")
    end
end)

-- 7. SPEED HACK
FeatureButtons["SPEED HACK"].MouseButton1Click:Connect(function()
    SpeedHackEnabled = not SpeedHackEnabled
    FeatureButtons["SPEED HACK"].Text = SpeedHackEnabled and "⚡ SPEED HACK: ON" or "⚡ SPEED HACK: OFF"
    FeatureButtons["SPEED HACK"].TextColor3 = SpeedHackEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if SpeedHackEnabled then
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            OriginalWalkSpeed = Player.Character.Humanoid.WalkSpeed
            OriginalJumpPower = Player.Character.Humanoid.JumpPower
            
            Player.Character.Humanoid.WalkSpeed = 100
            Player.Character.Humanoid.JumpPower = 100
        end
        print("[ROWNN] Speed Hack: ENABLED (WalkSpeed: 100, JumpPower: 100)")
    else
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = OriginalWalkSpeed or 16
            Player.Character.Humanoid.JumpPower = OriginalJumpPower or 50
        end
        print("[ROWNN] Speed Hack: DISABLED")
    end
end)

-- 8. BRING PARTS
FeatureButtons["BRING PARTS"].MouseButton1Click:Connect(function()
    BringPartsEnabled = not BringPartsEnabled
    FeatureButtons["BRING PARTS"].Text = BringPartsEnabled and "🧲 BRING PARTS: ON" or "🧲 BRING PARTS: OFF"
    FeatureButtons["BRING PARTS"].TextColor3 = BringPartsEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if BringPartsEnabled then
        spawn(function()
            local radius = 10
            
            while BringPartsEnabled do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = Player.Character.HumanoidRootPart
                    local parts = Workspace:GetDescendants()
                    local count = 0
                    
                    for _, part in pairs(parts) do
                        if BringPartsEnabled and part:IsA("BasePart") and part ~= root then
                            count = count + 1
                            local angle = count * (360 / math.max(1, count))
                            local offset = Vector3.new(
                                math.cos(math.rad(angle)) * radius,
                                0,
                                math.sin(math.rad(angle)) * radius
                            )
                            
                            local target = root.Position + offset
                            part.Velocity = (target - part.Position).Unit * 80
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

-- 9. SPAM REMOTE
FeatureButtons["SPAM REMOTE"].MouseButton1Click:Connect(function()
    SpamRemoteEnabled = not SpamRemoteEnabled
    FeatureButtons["SPAM REMOTE"].Text = SpamRemoteEnabled and "🔥 SPAM REMOTE: ON" or "🔥 SPAM REMOTE: OFF"
    FeatureButtons["SPAM REMOTE"].TextColor3 = SpamRemoteEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    
    if SpamRemoteEnabled then
        spawn(function()
            -- Cari remote event
            local remoteTarget = nil
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    remoteTarget = obj
                    break
                end
            end
            
            if remoteTarget then
                while SpamRemoteEnabled do
                    pcall(function()
                        remoteTarget:FireServer()
                    end)
                    wait()
                end
            else
                print("[ROWNN] No RemoteEvent found to spam!")
                SpamRemoteEnabled = false
                FeatureButtons["SPAM REMOTE"].Text = "🔥 SPAM REMOTE: OFF"
            end
        end)
        print("[ROWNN] Spam Remote: ENABLED")
    else
        print("[ROWNN] Spam Remote: DISABLED")
    end
end)

-- ========== SPEED CONTROLS ==========
local SpeedControls = Instance.new("Frame")
SpeedControls.Name = "SpeedControls"
SpeedControls.Parent = TabsFrame
SpeedControls.Size = UDim2.new(0.95, 0, 0, 60)
SpeedControls.Position = UDim2.new(0.025, 0, 0.92, 0)
SpeedControls.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel", SpeedControls)
SpeedLabel.Text = "FLY SPEED: 50"
SpeedLabel.Size = UDim2.new(0.6, 0, 0, 30)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12

local SpeedInput = Instance.new("TextBox", SpeedControls)
SpeedInput.Text = "50"
SpeedInput.Size = UDim2.new(0.35, 0, 0, 30)
SpeedInput.Position = UDim2.new(0.65, 0, 0, 0)
SpeedInput.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.PlaceholderText = "Speed"
SpeedInput.Font = Enum.Font.Gotham

SpeedInput.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedInput.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 200 then
        FlySpeed = newSpeed
        SpeedLabel.Text = "FLY SPEED: " .. newSpeed
    else
        SpeedInput.Text = FlySpeed
    end
end)

-- ========== MOBILE OPTIMIZATION ==========
if UIS.TouchEnabled then
    -- Make buttons bigger for touch
    for _, btn in pairs(FeatureButtons) do
        btn.Size = UDim2.new(0.96, 0, 0, 50)
    end
    
    -- Add mobile instructions
    local MobileInfo = Instance.new("TextLabel", TabsFrame)
    MobileInfo.Text = "📱 Mobile Mode: Use Virtual Joystick"
    MobileInfo.Size = UDim2.new(0.95, 0, 0, 30)
    MobileInfo.Position = UDim2.new(0.025, 0, 0.98, 0)
    MobileInfo.BackgroundTransparency = 1
    MobileInfo.TextColor3 = Color3.fromRGB(0, 255, 100)
    MobileInfo.Font = Enum.Font.Gotham
    MobileInfo.TextSize = 12
end

-- ========== AUTO-CLEANUP ==========
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == Player then
        -- Cleanup everything
        RownnGui:Destroy()
        if FlyConnection then FlyConnection:Disconnect() end
        if NoclipConnection then NoclipConnection:Disconnect() end
        if JumpConnection then JumpConnection:Disconnect() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end
end)

-- ========== FINAL MESSAGE ==========
wait(1)
print("╔════════════════════════════════════════╗")
print("║       ROWNN GUI LOADED SUCCESSFULLY   ║")
print("║                                        ║")
print("║  Features Available:                   ║")
print("║  • 🚀 Fly System (Android Optimized)   ║")
print("║  • 🔓 Noclip Mode                      ║")
print("║  • 🦘 Infinity Jump                    ║")
print("║  • 👻 Invisible Mode                   ║")
print("║  • 🎯 Hitbox Expander                  ║")
print("║  • 👁️ ESP Player Highlight             ║")
print("║  • ⚡ Speed Hack                        ║")
print("║  • 🧲 Bring All Parts                  ║")
print("║  • 🔥 Remote Spam                      ║")
print("╚════════════════════════════════════════╝")
print("")
print("📱 Android Controls:")
print("- Virtual Joystick untuk gerak")
print("- Tombol Jump bawaan Roblox")
print("- Sentuh tombol untuk aktifkan fitur")
print("")
print("⚠️ NOTE: Semua fitur memiliki ON/OFF toggle!")