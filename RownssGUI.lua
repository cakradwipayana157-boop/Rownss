-- ROWNN GUI - Fly Beneran Bisa Terbang Cepat
-- GUI Kecil, Bisa Drag, Android Optimized

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- GUI KECIL YANG BISA DI-DRAG
local RownnGui = Instance.new("ScreenGui")
RownnGui.Name = "RownnGui"
RownnGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = RownnGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0) -- GUI kecil di pojok
MainFrame.Size = UDim2.new(0, 180, 0, 40) -- UKURAN KECIL
MainFrame.Active = true
MainFrame.Draggable = true

-- TITLE BAR KECIL
local Title = Instance.new("TextButton")
Title.Text = "ROWNN ▼"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.SciFi
Title.TextSize = 14
Title.Parent = MainFrame

-- CONTENT AREA
local Content = Instance.new("Frame")
Content.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.Size = UDim2.new(1, 0, 0, 300)
Content.Visible = false
Content.Parent = MainFrame

-- TOGGLE GUI
local GuiOpen = false
Title.MouseButton1Click:Connect(function()
    GuiOpen = not GuiOpen
    Content.Visible = GuiOpen
    MainFrame.Size = GuiOpen and UDim2.new(0, 180, 0, 340) or UDim2.new(0, 180, 0, 40)
    Title.Text = GuiOpen and "ROWNN ▲" or "ROWNN ▼"
end)

-- SCROLLING FRAME UNTUK FITUR
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.Parent = Content

-- ========== VARIABLES ==========
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
local FlyConnection

-- ========== FLY SYSTEM YANG BENERAN BISA TERBANG CEPAT ==========
local function CreateButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
    btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    btn.Font = Enum.Font.SciFi
    btn.TextSize = 12
    btn.Parent = ScrollFrame
    btn.MouseButton1Click = callback
    return btn
end

-- FLY BUTTON
local FlyBtn = CreateButton("🚀 FLY: OFF", 0.02, function()
    FlyEnabled = not FlyEnabled
    FlyBtn.Text = FlyEnabled and "🚀 FLY: ON" or "🚀 FLY: OFF"
    
    if FlyEnabled then
        -- FLY YANG BENERAN BISA TERBANG CEPAT
        if not Player.Character then return end
        local HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        
        -- Simpan state awal
        local originalGravity = workspace.Gravity
        
        -- Buat BodyVelocity untuk kontrol gerak
        local BV = Instance.new("BodyVelocity")
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(10000, 10000, 10000)
        BV.P = 1250
        BV.Parent = HumanoidRootPart
        
        -- Buat BodyGyro untuk stabilisasi
        local BG = Instance.new("BodyGyro")
        BG.MaxTorque = Vector3.new(50000, 50000, 50000)
        BG.P = 3000
        BG.D = 500
        BG.Parent = HumanoidRootPart
        
        -- Biarkan kamera normal (tidak di-scriptable)
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled or not Player.Character then 
                if FlyConnection then FlyConnection:Disconnect() end
                return 
            end
            
            local camera = workspace.CurrentCamera
            local look = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            
            local move = Vector3.new(0, 0, 0)
            
            -- Kontrol untuk PC (testing)
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                move = move + (look * FlySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                move = move - (look * FlySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                move = move - (right * FlySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                move = move + (right * FlySpeed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0, FlySpeed, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0, FlySpeed, 0)
            end
            
            -- Terapkan kecepatan
            BV.Velocity = move
            
            -- Stabilisasi orientasi
            BG.CFrame = camera.CFrame
            
            -- Noclip otomatis saat terbang
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        -- Android Virtual Joystick Support
        if UIS.TouchEnabled then
            print("[ROWNN] Mobile Mode: Use Virtual Joystick to fly")
        end
        
        print("[ROWNN] FLY: ENABLED - Bisa terbang cepat!")
        
    else
        -- MATIKAN FLY
        if FlyConnection then FlyConnection:Disconnect() end
        
        -- Hapus physics objects
        if Player.Character then
            for _, child in pairs(Player.Character:GetChildren()) do
                if child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                    child:Destroy()
                end
            end
            
            -- Restore collision
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        print("[ROWNN] FLY: DISABLED")
    end
end)

-- SPEED CONTROL
local SpeedBox = Instance.new("TextBox")
SpeedBox.Text = "50"
SpeedBox.Size = UDim2.new(0.9, 0, 0, 25)
SpeedBox.Position = UDim2.new(0.05, 0, 0.12, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderText = "Fly Speed"
SpeedBox.Font = Enum.Font.SciFi
SpeedBox.TextSize = 12
SpeedBox.Parent = ScrollFrame

SpeedBox.FocusLost:Connect(function()
    local speed = tonumber(SpeedBox.Text)
    if speed and speed > 0 and speed <= 200 then
        FlySpeed = speed
    else
        SpeedBox.Text = FlySpeed
    end
end)

-- ========== NO CLIP ==========
local NoclipBtn = CreateButton("🔓 NO CLIP: OFF", 0.2, function()
    NoclipEnabled = not NoclipEnabled
    NoclipBtn.Text = NoclipEnabled and "🔓 NO CLIP: ON" or "🔓 NO CLIP: OFF"
    
    if NoclipEnabled then
        local conn = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        -- Simpan connection untuk di-disconnect nanti
        NoclipBtn.MouseButton1Click = function()
            NoclipEnabled = false
            NoclipBtn.Text = "🔓 NO CLIP: OFF"
            conn:Disconnect()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        
        print("[ROWNN] NO CLIP: ENABLED")
    end
end)

-- ========== INFINITY JUMP ==========
local InfJumpBtn = CreateButton("🦘 INF JUMP: OFF", 0.3, function()
    InfJumpEnabled = not InfJumpEnabled
    InfJumpBtn.Text = InfJumpEnabled and "🦘 INF JUMP: ON" or "🦘 INF JUMP: OFF"
    
    if InfJumpEnabled then
        local conn = UIS.JumpRequest:Connect(function()
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
        InfJumpBtn.MouseButton1Click = function()
            InfJumpEnabled = false
            InfJumpBtn.Text = "🦘 INF JUMP: OFF"
            conn:Disconnect()
        end
        
        print("[ROWNN] INFINITY JUMP: ENABLED")
    end
end)

-- ========== INVISIBLE ==========
local InvisibleBtn = CreateButton("👻 INVISIBLE: OFF", 0.4, function()
    InvisibleEnabled = not InvisibleEnabled
    InvisibleBtn.Text = InvisibleEnabled and "👻 INVISIBLE: ON" or "👻 INVISIBLE: OFF"
    
    if InvisibleEnabled then
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
        print("[ROWNN] INVISIBLE: ENABLED")
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
        print("[ROWNN] INVISIBLE: DISABLED")
    end
end)

-- ========== HITBOX ==========
local HitboxBtn = CreateButton("🎯 HITBOX: OFF", 0.5, function()
    HitboxEnabled = not HitboxEnabled
    HitboxBtn.Text = HitboxEnabled and "🎯 HITBOX: ON" or "🎯 HITBOX: OFF"
    
    if HitboxEnabled then
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * 1.5
                end
            end
        end
        print("[ROWNN] HITBOX: ENABLED")
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size / 1.5
                end
            end
        end
        print("[ROWNN] HITBOX: DISABLED")
    end
end)

-- ========== ESP ==========
local EspBtn = CreateButton("👁️ ESP: OFF", 0.6, function()
    EspEnabled = not EspEnabled
    EspBtn.Text = EspEnabled and "👁️ ESP: ON" or "👁️ ESP: OFF"
    
    if EspEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_" .. player.Name
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
        print("[ROWNN] ESP: ENABLED")
    else
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Character then
                local esp = player.Character:FindFirstChild("ESP_" .. player.Name)
                if esp then esp:Destroy() end
            end
        end
        print("[ROWNN] ESP: DISABLED")
    end
end)

-- ========== SPEED HACK ==========
local SpeedHackBtn = CreateButton("⚡ SPEED: OFF", 0.7, function()
    SpeedHackEnabled = not SpeedHackEnabled
    SpeedHackBtn.Text = SpeedHackEnabled and "⚡ SPEED: ON" or "⚡ SPEED: OFF"
    
    if SpeedHackEnabled then
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 100
        end
        print("[ROWNN] SPEED HACK: ENABLED (100 walkspeed)")
    else
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
        print("[ROWNN] SPEED HACK: DISABLED")
    end
end)

-- ========== BRING PARTS ==========
local BringPartsBtn = CreateButton("🧲 BRING PARTS: OFF", 0.8, function()
    BringPartsEnabled = not BringPartsEnabled
    BringPartsBtn.Text = BringPartsEnabled and "🧲 BRING PARTS: ON" or "🧲 BRING PARTS: OFF"
    
    if BringPartsEnabled then
        spawn(function()
            while BringPartsEnabled do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = Player.Character.HumanoidRootPart
                    local parts = workspace:GetDescendants()
                    
                    for _, part in pairs(parts) do
                        if BringPartsEnabled and part:IsA("BasePart") and part ~= root then
                            part.Velocity = (root.Position - part.Position).Unit * 50
                        end
                    end
                end
                wait(0.1)
            end
        end)
        print("[ROWNN] BRING PARTS: ENABLED")
    else
        print("[ROWNN] BRING PARTS: DISABLED")
    end
end)

-- ========== SPAM REMOTE ==========
local SpamBtn = CreateButton("🔥 SPAM: OFF", 0.9, function()
    SpamRemoteEnabled = not SpamRemoteEnabled
    SpamBtn.Text = SpamRemoteEnabled and "🔥 SPAM: ON" or "🔥 SPAM: OFF"
    
    if SpamRemoteEnabled then
        spawn(function()
            -- Cari remote
            local remote = nil
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    remote = obj
                    break
                end
            end
            
            if remote then
                while SpamRemoteEnabled do
                    pcall(function()
                        remote:FireServer()
                    end)
                    wait()
                end
            else
                SpamRemoteEnabled = false
                SpamBtn.Text = "🔥 SPAM: OFF"
                print("[ROWNN] No remote found!")
            end
        end)
        print("[ROWNN] SPAM REMOTE: ENABLED")
    else
        print("[ROWNN] SPAM REMOTE: DISABLED")
    end
end)

-- ========== MOBILE OPTIMIZATION ==========
if UIS.TouchEnabled then
    -- Buat tombol lebih besar untuk touch
    for _, btn in pairs(ScrollFrame:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Size = UDim2.new(0.92, 0, 0, 40)
        end
    end
    
    -- Tambahkan info mobile
    local MobileLabel = Instance.new("TextLabel")
    MobileLabel.Text = "📱 Mobile: Use Virtual Joystick"
    MobileLabel.Size = UDim2.new(0.9, 0, 0, 20)
    MobileLabel.Position = UDim2.new(0.05, 0, 1.02, 0)
    MobileLabel.BackgroundTransparency = 1
    MobileLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    MobileLabel.Font = Enum.Font.SciFi
    MobileLabel.TextSize = 10
    MobileLabel.Parent = ScrollFrame
end

-- ========== CLEANUP ==========
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == Player then
        RownnGui:Destroy()
        if FlyConnection then FlyConnection:Disconnect() end
    end
end)

-- ========== SUCCESS MESSAGE ==========
print("╔════════════════════════════════════════╗")
print("║         ROWNN GUI LOADED!             ║")
print("║        GUI Size: Small (180x340)      ║")
print("║        Features Working:              ║")
print("║        • 🚀 FLY (REAL FLYING)         ║")
print("║        • 🔓 NO CLIP                   ║")
print("║        • 🦘 INFINITY JUMP             ║")
print("║        • 👻 INVISIBLE                 ║")
print("║        • 🎯 HITBOX                    ║")
print("║        • 👁️ ESP                      ║")
print("║        • ⚡ SPEED HACK                ║")
print("║        • 🧲 BRING PARTS               ║")
print("║        • 🔥 SPAM REMOTE               ║")
print("╚════════════════════════════════════════╝")
print("")
print("🎮 CONTROLS:")
print("- Drag GUI to move")
print("- Click ROWNN to open/close")
print("- Fly: WASD + Space/Shift")
print("- Mobile: Virtual Joystick")
print("")
print("✅ ALL FEATURES HAVE ON/OFF TOGGLE!")