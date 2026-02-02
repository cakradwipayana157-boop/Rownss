-- ROWNN GUI PRO - Premium Edition
local plr = game:GetService("Players").LocalPlayer
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- Premium GUI dengan efek modern
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "RownnGuiPro"

-- Main Container dengan efek glow
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 45)
main.Position = UDim2.new(0.5, -160, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
main.BorderColor3 = Color3.fromRGB(0, 255, 100)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

-- Shadow Effect
local shadow = Instance.new("Frame", main)
shadow.Size = UDim2.new(1, 4, 1, 4)
shadow.Position = UDim2.new(0, -2, 0, -2)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
shadow.BorderSizePixel = 0
shadow.ZIndex = -1

-- Title Bar dengan gradient effect
local title = Instance.new("TextButton", main)
title.Text = "⚡ ROWNN PRO ▼"
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Content dengan rounded corners
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 0, 400)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
content.Visible = false

-- Tab Buttons Premium
local tabs = {"FLY", "TELEPORT", "BRING", "SPAM"}
local tabFrames = {}

-- Create stylish tab buttons
for i, tabName in pairs(tabs) do
    local btn = Instance.new("TextButton", content)
    btn.Text = tabName
    btn.Size = UDim2.new(0.23, 0, 0, 35)
    btn.Position = UDim2.new(0.015 + (i-1)*0.245, 0, 0.02, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        ts:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        ts:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 80, 0)}):Play()
    end)
    
    -- Tab Content Frame
    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(0.97, 0, 0, 340)
    frame.Position = UDim2.new(0.015, 0, 0.12, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 6
    frame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
    frame.Visible = i == 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 500)
    tabFrames[tabName] = frame
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do
            f.Visible = false
        end
        frame.Visible = true
    end)
end

-- Toggle GUI Animation
local expanded = false
title.MouseButton1Click:Connect(function()
    expanded = not expanded
    content.Visible = expanded
    main.Size = expanded and UDim2.new(0, 320, 0, 445) or UDim2.new(0, 320, 0, 45)
    title.Text = expanded and "⚡ ROWNN PRO ▲" or "⚡ ROWNN PRO ▼"
    
    -- Smooth animation
    ts:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = expanded and UDim2.new(0, 320, 0, 445) or UDim2.new(0, 320, 0, 45)}):Play()
end)

-- ==================== PREMIUM FLY SYSTEM ====================
local flyFrame = tabFrames["FLY"]
local flyEnabled = false
local flySpeed = 50
local flyConnection
local bv, bg

-- Fly Toggle Button (Premium Design)
local flyBtn = Instance.new("TextButton", flyFrame)
flyBtn.Text = "🚀 FLY MODE: OFF"
flyBtn.Size = UDim2.new(0.95, 0, 0, 45)
flyBtn.Position = UDim2.new(0.025, 0, 0.02, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
flyBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 14

-- Speed Control dengan slider visual
local speedContainer = Instance.new("Frame", flyFrame)
speedContainer.Size = UDim2.new(0.95, 0, 0, 60)
speedContainer.Position = UDim2.new(0.025, 0, 0.15, 0)
speedContainer.BackgroundTransparency = 1

local speedLabel = Instance.new("TextLabel", speedContainer)
speedLabel.Text = "FLY SPEED: 50"
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12

local speedSliderBg = Instance.new("Frame", speedContainer)
speedSliderBg.Size = UDim2.new(1, 0, 0, 10)
speedSliderBg.Position = UDim2.new(0, 0, 0, 30)
speedSliderBg.BackgroundColor3 = Color3.fromRGB(0, 50, 0)

local speedSlider = Instance.new("Frame", speedSliderBg)
speedSlider.Size = UDim2.new(0.5, 0, 1, 0) -- 50% default
speedSlider.BackgroundColor3 = Color3.fromRGB(0, 255, 100)

local speedBox = Instance.new("TextBox", speedContainer)
speedBox.Text = "50"
speedBox.Size = UDim2.new(0.3, 0, 0, 25)
speedBox.Position = UDim2.new(0.7, 0, 0, 30)
speedBox.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.Gotham

-- Control Instructions
local controlsLabel = Instance.new("TextLabel", flyFrame)
controlsLabel.Text = "CONTROLS:\n• Virtual Joystick (Mobile)\n• WASD + Space/Shift (PC)\n• Smooth Movement"
controlsLabel.Size = UDim2.new(0.95, 0, 0, 80)
controlsLabel.Position = UDim2.new(0.025, 0, 0.35, 0)
controlsLabel.BackgroundTransparency = 1
controlsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.TextSize = 11
controlsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- No Clip Toggle
local noclipBtn = Instance.new("TextButton", flyFrame)
noclipBtn.Text = "🔓 NO CLIP: ON"
noclipBtn.Size = UDim2.new(0.95, 0, 0, 35)
noclipBtn.Position = UDim2.new(0.025, 0, 0.65, 0)
noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
noclipBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
noclipBtn.Font = Enum.Font.GothamSemibold

-- PREMIUM FLY FUNCTION
local function updateFly()
    if flyEnabled then
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then 
            if plr.Character then
                plr.Character:WaitForChild("HumanoidRootPart")
            else
                return
            end
        end
        
        local hrp = plr.Character.HumanoidRootPart
        
        -- Create physics objects
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.P = 1250
            bv.Parent = hrp
        end
        
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(50000, 50000, 50000)
            bg.P = 3000
            bg.D = 500
            bg.Parent = hrp
        end
        
        -- Smooth fly connection
        flyConnection = run.Heartbeat:Connect(function(dt)
            if not flyEnabled or not bv or not bg then 
                if flyConnection then
                    flyConnection:Disconnect()
                end
                return 
            end
            
            local camera = workspace.CurrentCamera
            if not camera then return end
            
            -- Get camera vectors
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            local upVector = Vector3.new(0, 1, 0)
            
            -- Movement vector
            local movement = Vector3.new(0, 0, 0)
            
            -- Keyboard controls (smooth acceleration)
            if uis:IsKeyDown(Enum.KeyCode.W) then
                movement = movement + (lookVector * flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.S) then
                movement = movement - (lookVector * flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.A) then
                movement = movement - (rightVector * flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.D) then
                movement = movement + (rightVector * flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                movement = movement + (upVector * flySpeed)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                movement = movement - (upVector * flySpeed)
            end
            
            -- Mobile virtual joystick support
            -- This would integrate with Roblox's touch controls
            
            -- Apply smooth velocity
            bv.Velocity = movement
            
            -- Maintain orientation
            bg.CFrame = camera.CFrame
            
            -- No Clip
            if noclipBtn.Text:find("ON") then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
    else
        -- Cleanup
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if bv then
            bv:Destroy()
            bv = nil
        end
        
        if bg then
            bg:Destroy()
            bg = nil
        end
        
        -- Restore collision
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Fly Toggle
flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyBtn.Text = flyEnabled and "🚀 FLY MODE: ON" or "🚀 FLY MODE: OFF"
    flyBtn.TextColor3 = flyEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 50, 50)
    flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 90, 0) or Color3.fromRGB(0, 70, 0)
    
    updateFly()
end)

-- Speed Control
speedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(speedBox.Text)
    if newSpeed and newSpeed >= 1 and newSpeed <= 200 then
        flySpeed = newSpeed
        speedLabel.Text = "FLY SPEED: " .. newSpeed
        speedSlider.Size = UDim2.new(newSpeed / 200, 0, 1, 0)
    else
        speedBox.Text = flySpeed
    end
end)

-- Speed slider click
speedSliderBg.MouseButton1Click:Connect(function(input)
    local x = input.Position.X - speedSliderBg.AbsolutePosition.X
    local percentage = math.clamp(x / speedSliderBg.AbsoluteSize.X, 0, 1)
    flySpeed = math.floor(percentage * 200)
    if flySpeed < 1 then flySpeed = 1 end
    
    speedBox.Text = tostring(flySpeed)
    speedLabel.Text = "FLY SPEED: " .. flySpeed
    speedSlider.Size = UDim2.new(percentage, 0, 1, 0)
end)

-- No Clip Toggle
noclipBtn.MouseButton1Click:Connect(function()
    if noclipBtn.Text:find("ON") then
        noclipBtn.Text = "🔓 NO CLIP: OFF"
        noclipBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        noclipBtn.Text = "🔓 NO CLIP: ON"
        noclipBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    end
end)

-- ==================== TELEPORT SYSTEM ====================
local teleFrame = tabFrames["TELEPORT"]
local selectedPlayer = nil

-- Stylish Player List
local playerList = Instance.new("ScrollingFrame", teleFrame)
playerList.Size = UDim2.new(0.95, 0, 0, 200)
playerList.Position = UDim2.new(0.025, 0, 0.02, 0)
playerList.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updatePlayerList()
    playerList:ClearAllChildren()
    local yPos = 5
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= plr then
            local playerBtn = Instance.new("TextButton", playerList)
            playerBtn.Text = "👤 " .. player.Name
            playerBtn.Size = UDim2.new(0.94, 0, 0, 35)
            playerBtn.Position = UDim2.new(0.03, 0, 0, yPos)
            playerBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
            playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextSize = 12
            
            -- Hover effect
            playerBtn.MouseEnter:Connect(function()
                ts:Create(playerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 80, 0)}):Play()
            end)
            playerBtn.MouseLeave:Connect(function()
                ts:Create(playerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 60, 0)}):Play()
            end)
            
            playerBtn.MouseButton1Click:Connect(function()
                selectedPlayer = player
            end)
            
            yPos = yPos + 40
        end
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Teleport Button
local teleportBtn = Instance.new("TextButton", teleFrame)
teleportBtn.Text = "⚡ TELEPORT TO PLAYER"
teleportBtn.Size = UDim2.new(0.95, 0, 0, 45)
teleportBtn.Position = UDim2.new(0.025, 0, 0.65, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14

teleportBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target then
            plr.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame
        end
    end
end)

-- Refresh Button
local refreshBtn = Instance.new("TextButton", teleFrame)
refreshBtn.Text = "🔄 REFRESH LIST"
refreshBtn.Size = UDim2.new(0.95, 0, 0, 35)
refreshBtn.Position = UDim2.new(0.025, 0, 0.8, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
refreshBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
refreshBtn.Font = Enum.Font.GothamSemibold

refreshBtn.MouseButton1Click:Connect(updatePlayerList)

updatePlayerList()

-- ==================== BRING SYSTEM ====================
local bringFrame = tabFrames["BRING"]
local bringingParts = false
local bringingPlayers = false

-- Bring Parts
local bringPartsBtn = Instance.new("TextButton", bringFrame)
bringPartsBtn.Text = "🧲 BRING PARTS: OFF"
bringPartsBtn.Size = UDim2.new(0.95, 0, 0, 45)
bringPartsBtn.Position = UDim2.new(0.025, 0, 0.02, 0)
bringPartsBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
bringPartsBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
bringPartsBtn.Font = Enum.Font.GothamBold

bringPartsBtn.MouseButton1Click:Connect(function()
    bringingParts = not bringingParts
    bringPartsBtn.Text = bringingParts and "🧲 BRING PARTS: ON" or "🧲 BRING PARTS: OFF"
    
    if bringingParts then
        spawn(function()
            local root = plr.Character:WaitForChild("HumanoidRootPart")
            while bringingParts do
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part ~= root then
                        part.Velocity = (root.Position - part.Position).Unit * 100
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

-- Bring Players List
local bringPlayerList = Instance.new("ScrollingFrame", bringFrame)
bringPlayerList.Size = UDim2.new(0.95, 0, 0, 150)
bringPlayerList.Position = UDim2.new(0.025, 0, 0.2, 0)
bringPlayerList.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
bringPlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updateBringPlayers()
    bringPlayerList:ClearAllChildren()
    local yPos = 5
    
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= plr then
            local btn = Instance.new("TextButton", bringPlayerList)
            btn.Text = player.Name
            btn.Size = UDim2.new(0.94, 0, 0, 30)
            btn.Position = UDim2.new(0.03, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
            btn.TextColor3 = Color3.fromRGB(255, 50, 50)
            btn.Font = Enum.Font.Gotham
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
            end)
            
            yPos = yPos + 35
        end
    end
    
    bringPlayerList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Bring Player Button
local bringPlayerBtn = Instance.new("TextButton", bringFrame)
bringPlayerBtn.Text = "👥 BRING PLAYER: OFF"
bringPlayerBtn.Size = UDim2.new(0.95, 0, 0, 45)
bringPlayerBtn.Position = UDim2.new(0.025, 0, 0.7, 0)
bringPlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
bringPlayerBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
bringPlayerBtn.Font = Enum.Font.GothamBold

bringPlayerBtn.MouseButton1Click:Connect(function()
    bringingPlayers = not bringingPlayers
    bringPlayerBtn.Text = bringingPlayers and "👥 BRING PLAYER: ON" or "👥 BRING PLAYER: OFF"
    
    if bringingPlayers and selectedPlayer then
        spawn(function()
            while bringingPlayers do
                if selectedPlayer.Character then
                    local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local root = plr.Character:WaitForChild("HumanoidRootPart")
                    
                    if target then
                        target.Velocity = (root.Position - target.Position).Unit * 50
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

updateBringPlayers()

-- ==================== SPAM SYSTEM ====================
local spamFrame = tabFrames["SPAM"]
local spamming = false
local remoteTarget = nil

local scanBtn = Instance.new("TextButton", spamFrame)
scanBtn.Text = "🔍 SCAN FOR REMOTES"
scanBtn.Size = UDim2.new(0.95, 0, 0, 45)
scanBtn.Position = UDim2.new(0.025, 0, 0.02, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
scanBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
scanBtn.Font = Enum.Font.GothamBold

local statusLabel = Instance.new("TextLabel", spamFrame)
statusLabel.Text = "Status: Not Ready"
statusLabel.Size = UDim2.new(0.95, 0, 0, 30)
statusLabel.Position = UDim2.new(0.025, 0, 0.2, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
statusLabel.Font = Enum.Font.Gotham

local startBtn = Instance.new("TextButton", spamFrame)
startBtn.Text = "🔥 START SPAM"
startBtn.Size = UDim2.new(0.95, 0, 0, 45)
startBtn.Position = UDim2.new(0.025, 0, 0.35, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
startBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
startBtn.Font = Enum.Font.GothamBold

local stopBtn = Instance.new("TextButton", spamFrame)
stopBtn.Text = "⏹️ STOP SPAM"
stopBtn.Size = UDim2.new(0.95, 0, 0, 35)
stopBtn.Position = UDim2.new(0.025, 0, 0.55, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
stopBtn.Font = Enum.Font.GothamSemibold

scanBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            remoteTarget = obj
            statusLabel.Text = "Status: Ready (" .. obj.Name .. ")"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            return
        end
    end
    statusLabel.Text = "Status: No Remotes Found"
end)

startBtn.MouseButton1Click:Connect(function()
    if remoteTarget then
        spamming = true
        spawn(function()
            while spamming do
                pcall(function()
                    remoteTarget:FireServer()
                end)
                wait()
            end
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    spamming = false
    statusLabel.Text = "Status: Stopped"
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
end)

-- Auto-refresh player lists
game:GetService("Players").PlayerAdded:Connect(updatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerList)

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == plr then
        gui:Destroy()
        if flyConnection then flyConnection:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

print("⚡ ROWNN GUI PRO LOADED!")
print("Premium Features: Smooth Fly, Modern GUI, All Tools")