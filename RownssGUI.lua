-- ROWNN GUI ULTRA
local plr = game:GetService("Players").LocalPlayer
local run = game:GetService("RunService")
local ws = game:GetService("Workspace")

-- Create GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 40)
main.Position = UDim2.new(0.5, -150, 0, 10)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true
main.Draggable = true

-- Title Bar
local title = Instance.new("TextButton", main)
title.Text = "ROWNN GUI ▼"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.SciFi

-- Content (Initially hidden)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 0, 400)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
content.Visible = false

-- Toggle GUI visibility
local expanded = false
title.MouseButton1Click:Connect(function()
    expanded = not expanded
    content.Visible = expanded
    main.Size = expanded and UDim2.new(0, 300, 0, 440) or UDim2.new(0, 300, 0, 40)
    title.Text = expanded and "ROWNN GUI ▲" or "ROWNN GUI ▼"
end)

-- Create Tab Buttons
local tabs = {"Fly", "Goto", "BringP", "BringPl", "Spam"}
local tabFrames = {}

for i, tabName in pairs(tabs) do
    local btn = Instance.new("TextButton", content)
    btn.Text = tabName
    btn.Size = UDim2.new(0.18, 0, 0, 30)
    btn.Position = UDim2.new(0.02 + (i-1)*0.2, 0, 0.02, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SciFi
    
    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(0.96, 0, 0, 350)
    frame.Position = UDim2.new(0.02, 0, 0.1, 0)
    frame.BackgroundTransparency = 1
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

-- ========== FLY SYSTEM ==========
local flyFrame = tabFrames["Fly"]
local flyEnabled = false
local flySpeed = 50
local bv, bg

-- Fly Toggle
local flyBtn = Instance.new("TextButton", flyFrame)
flyBtn.Text = "🚀 FLY: OFF"
flyBtn.Size = UDim2.new(0.96, 0, 0, 40)
flyBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
flyBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
flyBtn.Font = Enum.Font.SciFi

-- Speed
local speedBox = Instance.new("TextBox", flyFrame)
speedBox.Text = "50"
speedBox.Size = UDim2.new(0.96, 0, 0, 30)
speedBox.Position = UDim2.new(0.02, 0, 0.15, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Info
local info = Instance.new("TextLabel", flyFrame)
info.Text = "PAKAI VIRTUAL JOYSTICK ROBLOX\n↑↓←→ untuk gerak"
info.Size = UDim2.new(0.96, 0, 0, 60)
info.Position = UDim2.new(0.02, 0, 0.25, 0)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(0, 255, 255)

-- Fly Function
local function updateFly()
    if flyEnabled then
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = plr.Character.HumanoidRootPart
        
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.P = 1250
            bv.Parent = hrp
        end
        
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(50000, 50000, 50000)
            bg.P = 3000
            bg.Parent = hrp
        end
        
        local conn
        conn = run.Heartbeat:Connect(function()
            if not flyEnabled then conn:Disconnect() return end
            
            local cam = ws.CurrentCamera
            local lv = cam.CFrame.LookVector
            local rv = cam.CFrame.RightVector
            
            local move = Vector3.new(0, 0, 0)
            
            -- Virtual Joystick Controls
            local vJoy = game:GetService("VirtualInputManager")
            -- Note: Virtual joystick input detection would go here
            
            -- Keyboard fallback for testing
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                move = move + (lv * flySpeed)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                move = move - (lv * flySpeed)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                move = move - (rv * flySpeed)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                move = move + (rv * flySpeed)
            end
            
            bv.Velocity = move
            bg.CFrame = cam.CFrame
            
            -- No clip
            for _, v in pairs(plr.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
end

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyBtn.Text = flyEnabled and "🚀 FLY: ON" or "🚀 FLY: OFF"
    flyBtn.TextColor3 = flyEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    updateFly()
end)

speedBox.FocusLost:Connect(function()
    local s = tonumber(speedBox.Text)
    if s and s > 0 and s < 200 then
        flySpeed = s
    else
        speedBox.Text = flySpeed
    end
end)

-- ========== GOTO PLAYER ==========
local gotoFrame = tabFrames["Goto"]
local selectedPlayer = nil

-- Player List
local gotoList = Instance.new("ScrollingFrame", gotoFrame)
gotoList.Size = UDim2.new(0.96, 0, 0, 200)
gotoList.Position = UDim2.new(0.02, 0, 0.02, 0)
gotoList.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
gotoList.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Refresh
local refreshBtn = Instance.new("TextButton", gotoFrame)
refreshBtn.Text = "🔄 Refresh"
refreshBtn.Size = UDim2.new(0.96, 0, 0, 40)
refreshBtn.Position = UDim2.new(0.02, 0, 0.55, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

-- Teleport
local tpBtn = Instance.new("TextButton", gotoFrame)
tpBtn.Text = "⚡ Teleport"
tpBtn.Size = UDim2.new(0.96, 0, 0, 40)
tpBtn.Position = UDim2.new(0.02, 0, 0.7, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 0)

local function updateGotoList()
    gotoList:ClearAllChildren()
    local y = 5
    
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= plr then
            local btn = Instance.new("TextButton", gotoList)
            btn.Text = p.Name
            btn.Size = UDim2.new(0.94, 0, 0, 30)
            btn.Position = UDim2.new(0.03, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
            end)
            
            y = y + 35
        end
    end
    
    gotoList.CanvasSize = UDim2.new(0, 0, 0, y)
end

refreshBtn.MouseButton1Click:Connect(updateGotoList)
tpBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target then
            plr.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame
        end
    end
end)

updateGotoList()

-- ========== BRING PART ==========
local bringPFrame = tabFrames["BringP"]
local bringingParts = false

local bringBtn = Instance.new("TextButton", bringPFrame)
bringBtn.Text = "🧲 Bring Parts: OFF"
bringBtn.Size = UDim2.new(0.96, 0, 0, 40)
bringBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
bringBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

bringBtn.MouseButton1Click:Connect(function()
    bringingParts = not bringingParts
    bringBtn.Text = bringingParts and "🧲 Bring Parts: ON" or "🧲 Bring Parts: OFF"
    
    if bringingParts then
        spawn(function()
            local radius = 10
            local root = plr.Character:WaitForChild("HumanoidRootPart")
            
            while bringingParts do
                local parts = ws:GetDescendants()
                local count = 0
                
                for _, part in pairs(parts) do
                    if part:IsA("BasePart") and part ~= root then
                        count = count + 1
                        local angle = count * (360 / math.max(1, count))
                        local offset = Vector3.new(
                            math.cos(math.rad(angle)) * radius,
                            0,
                            math.sin(math.rad(angle)) * radius
                        )
                        
                        part.Velocity = ((root.Position + offset) - part.Position).Unit * 100
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

-- ========== BRING PLAYER ==========
local bringPlFrame = tabFrames["BringPl"]
local bringingPlayer = false
local targetPlayer = nil

local bringPlList = Instance.new("ScrollingFrame", bringPlFrame)
bringPlList.Size = UDim2.new(0.96, 0, 0, 200)
bringPlList.Position = UDim2.new(0.02, 0, 0.02, 0)
bringPlList.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
bringPlList.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updateBringPlList()
    bringPlList:ClearAllChildren()
    local y = 5
    
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= plr then
            local btn = Instance.new("TextButton", bringPlList)
            btn.Text = p.Name
            btn.Size = UDim2.new(0.94, 0, 0, 30)
            btn.Position = UDim2.new(0.03, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = p
            end)
            
            y = y + 35
        end
    end
    
    bringPlList.CanvasSize = UDim2.new(0, 0, 0, y)
end

local bringPlBtn = Instance.new("TextButton", bringPlFrame)
bringPlBtn.Text = "👥 Bring Player: OFF"
bringPlBtn.Size = UDim2.new(0.96, 0, 0, 40)
bringPlBtn.Position = UDim2.new(0.02, 0, 0.55, 0)
bringPlBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

bringPlBtn.MouseButton1Click:Connect(function()
    bringingPlayer = not bringingPlayer
    bringPlBtn.Text = bringingPlayer and "👥 Bring Player: ON" or "👥 Bring Player: OFF"
    
    if bringingPlayer then
        spawn(function()
            while bringingPlayer and targetPlayer do
                if targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = plr.Character:WaitForChild("HumanoidRootPart")
                    
                    if targetRoot then
                        targetRoot.Velocity = (myRoot.Position - targetRoot.Position).Unit * 50
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

updateBringPlList()

-- ========== SPAM REMOTE ==========
local spamFrame = tabFrames["Spam"]
local spamming = false

local scanBtn = Instance.new("TextButton", spamFrame)
scanBtn.Text = "🔍 Scan Remotes"
scanBtn.Size = UDim2.new(0.96, 0, 0, 40)
scanBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local status = Instance.new("TextLabel", spamFrame)
status.Text = "Status: Not Ready"
status.Size = UDim2.new(0.96, 0, 0, 30)
status.Position = UDim2.new(0.02, 0, 0.15, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 50, 50)

local startBtn = Instance.new("TextButton", spamFrame)
startBtn.Text = "🔥 Start Spam"
startBtn.Size = UDim2.new(0.96, 0, 0, 40)
startBtn.Position = UDim2.new(0.02, 0, 0.3, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
startBtn.TextColor3 = Color3.fromRGB(255, 50, 50)

local stopBtn = Instance.new("TextButton", spamFrame)
stopBtn.Text = "⏹️ Stop"
stopBtn.Size = UDim2.new(0.96, 0, 0, 40)
stopBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local remoteToSpam = nil

scanBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            remoteToSpam = obj
            status.Text = "Status: Ready (" .. obj.Name .. ")"
            status.TextColor3 = Color3.fromRGB(50, 255, 50)
            return
        end
    end
    status.Text = "Status: No Remotes Found"
end)

startBtn.MouseButton1Click:Connect(function()
    if remoteToSpam then
        spamming = true
        spawn(function()
            while spamming do
                pcall(function()
                    remoteToSpam:FireServer()
                end)
                wait()
            end
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    spamming = false
end)

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == plr then
        gui:Destroy()
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

print("ROWNN GUI LOADED!")