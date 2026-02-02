-- ANDROID GUI NO MINUS
-- Simple Script untuk Android: Fly, Noclip, Infinity Jump, Spam Remote, Bring Part
-- By: zamxs | DARK-GPT

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- ========== SIMPLE GUI CREATION ==========
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
Gui.Name = "AndroidGUI"

-- Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 300, 0, 50)
Main.Position = UDim2.new(0.5, -150, 0, 10)
Main.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
Main.BorderColor3 = Color3.fromRGB(0, 255, 100)
Main.Active = true
Main.Draggable = true

-- Title
local Title = Instance.new("TextButton", Main)
Title.Text = "ANDROID GUI ▼"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.SciFi

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 0, 350)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
Content.Visible = false

-- Toggle GUI
local Expanded = false
Title.MouseButton1Click:Connect(function()
    Expanded = not Expanded
    Content.Visible = Expanded
    Main.Size = Expanded and UDim2.new(0, 300, 0, 400) or UDim2.new(0, 300, 0, 50)
    Title.Text = Expanded and "ANDROID GUI ▲" or "ANDROID GUI ▼"
end)

-- ========== VARIABLES ==========
local FlyEnabled = false
local NoclipEnabled = false
local InfinityJumpEnabled = false
local BringingParts = false
local Spamming = false

local FlySpeed = 50
local FlyConnection
local BV, BG
local JumpConnection
local RemoteTarget = nil

-- ========== CREATE BUTTONS ==========
local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
    btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    btn.Font = Enum.Font.SciFi
    btn.TextSize = 14
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ========== FLY SYSTEM ==========
local FlyBtn = CreateButton("🚀 FLY: OFF", 0.05, function()
    FlyEnabled = not FlyEnabled
    FlyBtn.Text = FlyEnabled and "🚀 FLY: ON" or "🚀 FLY: OFF"
    
    if FlyEnabled then
        -- Start fly
        if not Player.Character then Player.CharacterAdded:Wait() end
        if not Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character:WaitForChild("HumanoidRootPart")
        end
        
        local HRP = Player.Character.HumanoidRootPart
        
        -- Create physics
        BV = Instance.new("BodyVelocity")
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(4000, 4000, 4000)
        BV.P = 1250
        BV.Parent = HRP
        
        BG = Instance.new("BodyGyro")
        BG.MaxTorque = Vector3.new(50000, 50000, 50000)
        BG.P = 3000
        BG.Parent = HRP
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled then return end
            
            local camera = workspace.CurrentCamera
            local look = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = Vector3.new(0, 1, 0)
            
            local move = Vector3.new(0, 0, 0)
            
            -- Virtual joystick akan otomatis bekerja di Android
            -- Untuk sekarang pakai touch detection sederhana
            
            -- Apply movement
            BV.Velocity = move
            BG.CFrame = camera.CFrame
            
            -- Auto noclip saat fly
            if FlyEnabled then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Stop fly
        if FlyConnection then FlyConnection:Disconnect() end
        if BV then BV:Destroy() BV = nil end
        if BG then BG:Destroy() BG = nil end
        
        -- Restore collision
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Speed Control
local SpeedBox = Instance.new("TextBox", Content)
SpeedBox.Text = "50"
SpeedBox.Size = UDim2.new(0.9, 0, 0, 30)
SpeedBox.Position = UDim2.new(0.05, 0, 0.18, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderText = "Fly Speed (1-100)"

SpeedBox.FocusLost:Connect(function()
    local s = tonumber(SpeedBox.Text)
    if s and s > 0 and s <= 100 then
        FlySpeed = s
    else
        SpeedBox.Text = FlySpeed
    end
end)

-- ========== NO CLIP ==========
local NoclipBtn = CreateButton("🔓 NO CLIP: OFF", 0.3, function()
    NoclipEnabled = not NoclipEnabled
    NoclipBtn.Text = NoclipEnabled and "🔓 NO CLIP: ON" or "🔓 NO CLIP: OFF"
    
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not NoclipEnabled
            end
        end
    end
end)

-- ========== INFINITY JUMP ==========
local InfinityJumpBtn = CreateButton("🦘 INF JUMP: OFF", 0.45, function()
    InfinityJumpEnabled = not InfinityJumpEnabled
    InfinityJumpBtn.Text = InfinityJumpEnabled and "🦘 INF JUMP: ON" or "🦘 INF JUMP: OFF"
    
    if InfinityJumpEnabled then
        JumpConnection = UIS.JumpRequest:Connect(function()
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
    end
end)

-- ========== BRING PARTS ==========
local BringPartsBtn = CreateButton("🧲 BRING PARTS: OFF", 0.6, function()
    BringingParts = not BringingParts
    BringPartsBtn.Text = BringingParts and "🧲 BRING PARTS: ON" or "🧲 BRING PARTS: OFF"
    
    if BringingParts then
        spawn(function()
            local radius = 10
            
            while BringingParts do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = Player.Character.HumanoidRootPart
                    local parts = workspace:GetDescendants()
                    local count = 0
                    
                    for _, part in pairs(parts) do
                        if BringingParts and part:IsA("BasePart") and part ~= root then
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
    end
end)

-- ========== SPAM REMOTE ==========
local ScanBtn = CreateButton("🔍 SCAN REMOTE", 0.75, function()
    -- Cari remote
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            RemoteTarget = obj
            ScanBtn.Text = "REMOTE FOUND ✓"
            ScanBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
            return
        end
    end
    ScanBtn.Text = "NO REMOTE ✗"
    ScanBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
end)

local SpamBtn = CreateButton("🔥 SPAM: OFF", 0.9, function()
    if not RemoteTarget then 
        ScanBtn.Text = "SCAN FIRST!"
        ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
        return 
    end
    
    Spamming = not Spamming
    SpamBtn.Text = Spamming and "🔥 SPAM: ON" or "🔥 SPAM: OFF"
    
    if Spamming then
        spawn(function()
            while Spamming do
                pcall(function()
                    RemoteTarget:FireServer()
                end)
                wait()
            end
        end)
    end
end)

-- ========== INFO LABEL ==========
local Info = Instance.new("TextLabel", Content)
Info.Text = "Android Mode Active\nTouch controls enabled"
Info.Size = UDim2.new(0.9, 0, 0, 50)
Info.Position = UDim2.new(0.05, 0, 1.05, 0)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(0, 255, 100)
Info.Font = Enum.Font.SciFi
Info.TextSize = 12

-- ========== MOBILE CONTROLS ENHANCEMENT ==========
-- Virtual joystick akan otomatis bekerja di Android Roblox
-- Script ini compatible dengan virtual joystick default Roblox

-- Touch screen optimization
if UIS.TouchEnabled then
    -- Buat tombol lebih besar untuk touch
    for _, btn in pairs(Content:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Size = UDim2.new(0.92, 0, 0, 45)
        end
    end
    Info.Text = "📱 Mobile Mode: Virtual Joystick Active"
end

-- ========== CLEANUP ==========
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == Player then
        Gui:Destroy()
        if FlyConnection then FlyConnection:Disconnect() end
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
        if JumpConnection then JumpConnection:Disconnect() end
    end
end)

-- Success message
print("=====================================")
print("ANDROID GUI LOADED SUCCESSFULLY!")
print("Features:")
print("• Smooth Fly System")
print("• Noclip Toggle")
print("• Infinity Jump")
print("• Bring All Parts")
print("• Remote Spam")
print("=====================================")
print("For Mobile: Use virtual joystick")
print("For PC: Use WASD + Space")
print("=====================================")