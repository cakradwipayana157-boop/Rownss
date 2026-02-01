-- ⚡ ROWNNHUB GUI SCRIPT - MINIMIZABLE & DRAGGABLE ⚡
-- Features: Fly, Spam Remote, Noclip, Goto Player
-- GUI bisa di-minimize & digerakkan untuk view script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- AUTO DETECT EXECUTOR
print("⚡ ROWNNHUB GUI SCRIPT LOADED ⚡")
print("Executor:", identifyexecutor and identifyexecutor() or "Unknown")
print("Key: 311089 Verified")

-- REMOVE OLD GUI
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name == "RownnHubGUI_Min" then
        gui:Destroy()
    end
end

-- CREATE MINIMIZABLE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RownnHubGUI_Min"
ScreenGui.Parent = game:GetService("CoreGui")

-- MINIMIZED STATE (default: minimized)
local isMinimized = true
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 150, 0, 40)
MinimizedFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.Visible = true
MinimizedFrame.Parent = ScreenGui

-- MINIMIZED TITLE
local MinTitle = Instance.new("TextLabel")
MinTitle.Text = "⬇ ROWNNHUB MIN ⚡"
MinTitle.Size = UDim2.new(1, 0, 1, 0)
MinTitle.BackgroundTransparency = 1
MinTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
MinTitle.Font = Enum.Font.GothamBold
MinTitle.Parent = MinimizedFrame

-- EXPAND BUTTON (di minimized frame)
local ExpandBtn = Instance.new("TextButton")
ExpandBtn.Text = "⬆"
ExpandBtn.Size = UDim2.new(0, 30, 0, 30)
ExpandBtn.Position = UDim2.new(1, -35, 0, 5)
ExpandBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
ExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandBtn.Font = Enum.Font.GothamBold
ExpandBtn.Parent = MinimizedFrame

-- MAIN EXPANDED FRAME (hidden when minimized)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- EXPANDED TITLE
local MainTitle = Instance.new("TextLabel")
MainTitle.Text = "⚡ ROWNNHUB EXPANDED ⚡"
MainTitle.Size = UDim2.new(1, 0, 0, 40)
MainTitle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainFrame

-- MINIMIZE BUTTON (di expanded frame)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "⬇"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainTitle

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -70, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainTitle

-- TOGGLE MINIMIZE/EXPAND FUNCTION
local function ToggleGUI()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize: hide main, show minimized
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        -- Simpan posisi
        MinimizedFrame.Position = MainFrame.Position
    else
        -- Expand: show main, hide minimized
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
        -- Simpan posisi
        MainFrame.Position = MinimizedFrame.Position
    end
end

-- BUTTON CLICK EVENTS
ExpandBtn.MouseButton1Click:Connect(ToggleGUI)
MinimizeBtn.MouseButton1Click:Connect(ToggleGUI)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- PLAYER SELECTION SECTION (only in expanded view)
local SelectedPlayer = nil
local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Text = "Selected: NONE"
PlayerLabel.Size = UDim2.new(0.9, 0, 0, 25)
PlayerLabel.Position = UDim2.new(0.05, 0, 0, 50)
PlayerLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
PlayerLabel.Font = Enum.Font.GothamBold
PlayerLabel.Parent = MainFrame

-- PLAYER LIST
local PlayerFrame = Instance.new("ScrollingFrame")
PlayerFrame.Size = UDim2.new(0.9, 0, 0, 120)
PlayerFrame.Position = UDim2.new(0.05, 0, 0, 80)
PlayerFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PlayerFrame.ScrollBarThickness = 6
PlayerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerFrame.Parent = MainFrame

-- UPDATE PLAYER LIST FUNCTION
local function UpdatePlayerList()
    for _, v in pairs(PlayerFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
    
    local yPos = 5
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerBtn = Instance.new("TextButton")
            PlayerBtn.Text = player.Name
            PlayerBtn.Size = UDim2.new(0.9, 0, 0, 30)
            PlayerBtn.Position = UDim2.new(0.05, 0, 0, yPos)
            PlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerBtn.Font = Enum.Font.Gotham
            PlayerBtn.Parent = PlayerFrame
            
            PlayerBtn.MouseButton1Click:Connect(function()
                SelectedPlayer = player
                PlayerLabel.Text = "Selected: " .. player.Name
                for _, btn in pairs(PlayerFrame:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    end
                end
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            end)
            
            yPos = yPos + 35
        end
    end
    
    PlayerFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- FUNCTIONS
local Functions = {}

-- FLY FUNCTION
local isFlying = false
local flyBodyVelocity

Functions.Fly = function()
    if not isFlying then
        isFlying = true
        local rootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            -- Remove old velocity
            for _, v in pairs(rootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
            
            -- Create new body velocity
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBodyVelocity.Parent = rootPart
            
            -- Fly controls connection
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if not isFlying or not rootPart then
                    flyConnection:Disconnect()
                    return
                end
                
                local direction = Vector3.new()
                local speed = 50
                
                -- Movement controls
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (rootPart.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (rootPart.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (rootPart.CFrame.RightVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (rootPart.CFrame.RightVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    direction = direction + Vector3.new(0, speed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    direction = direction - Vector3.new(0, speed, 0)
                end
                
                flyBodyVelocity.Velocity = direction
            end)
            
            print("✅ FLY ENABLED - W/A/S/D = Move, E/Q = Up/Down")
        end
    else
        isFlying = false
        local rootPart = Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, v in pairs(rootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
        print("❌ FLY DISABLED")
    end
end

-- SPAM REMOTE FUNCTION
Functions.SpamRemote = function()
    print("🔍 Searching for remote events...")
    
    local remotes = {}
    
    -- Find all remote events
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            table.insert(remotes, remote)
        end
    end
    
    if #remotes > 0 then
        local remote = remotes[1]
        local spamCount = 0
        
        for i = 1, 50 do
            pcall(function()
                remote:FireServer("RownnHub_Spam_" .. i)
                spamCount = spamCount + 1
            end)
            wait(0.05)
        end
        
        print("✅ Spammed " .. remote.Name .. " " .. spamCount .. " times")
    else
        print("❌ No remote events found")
    end
end

-- NOCLIP FUNCTION
local isNoclip = false
local noclipConnection

Functions.Noclip = function()
    if not isNoclip then
        isNoclip = true
        noclipConnection = RunService.Stepped:Connect(function()
            if not isNoclip then
                noclipConnection:Disconnect()
                return
            end
            
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("✅ NOCLIP ENABLED")
    else
        isNoclip = false
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        print("❌ NOCLIP DISABLED")
    end
end

-- GOTO PLAYER FUNCTION
Functions.GotoPlayer = function()
    if not SelectedPlayer then 
        print("❌ No player selected!") 
        return 
    end
    
    local targetChar = SelectedPlayer.Character
    local localChar = LocalPlayer.Character
    
    if targetChar and localChar then
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local localHRP = localChar:FindFirstChild("HumanoidRootPart")
        
        if targetHRP and localHRP then
            localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
            print("✅ Teleported to " .. SelectedPlayer.Name)
        end
    end
end

-- CREATE BUTTONS (in expanded frame)
local buttonY = 210
local buttons = {
    {"🚀 FLY TOGGLE", UDim2.new(0.05, 0, 0, buttonY), Functions.Fly, Color3.fromRGB(0, 100, 255)},
    {"💥 SPAM REMOTE", UDim2.new(0.55, 0, 0, buttonY), Functions.SpamRemote, Color3.fromRGB(255, 50, 0)},
    {"👻 NOCLIP TOGGLE", UDim2.new(0.05, 0, 0, buttonY + 50), Functions.Noclip, Color3.fromRGB(0, 200, 100)},
    {"📍 GOTO PLAYER", UDim2.new(0.55, 0, 0, buttonY + 50), Functions.GotoPlayer, Color3.fromRGB(255, 150, 0)},
}

for _, btnData in pairs(buttons) do
    local button = Instance.new("TextButton")
    button.Text = btnData[1]
    button.Size = UDim2.new(0.4, 0, 0, 40)
    button.Position = btnData[2]
    button.BackgroundColor3 = btnData[4]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(btnData[3])
end

-- REFRESH BUTTON
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Text = "🔄 REFRESH PLAYERS"
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 35)
RefreshBtn.Position = UDim2.new(0.05, 0, 0, 330)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Parent = MainFrame

RefreshBtn.MouseButton1Click:Connect(UpdatePlayerList)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Text = "🔐 ROWNNHUB | Minimizable GUI | Key: 311089"
Watermark.Size = UDim2.new(1, 0, 0, 25)
Watermark.Position = UDim2.new(0, 0, 1, 0)
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.TextColor3 = Color3.fromRGB(0, 255, 0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 12
Watermark.Parent = MainFrame

-- NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ROWNNHUB",
    Text = "Minimizable GUI Loaded!\nClick ⬆ to expand",
    Duration = 5
})

print("╔══════════════════════════════╗")
print("║   ROWNNHUB MINIMIZABLE GUI   ║")
print("║   Click ⬆ to expand          ║")
print("║   Click ⬇ to minimize        ║")
print("║   Drag to move anywhere      ║")
print("╚══════════════════════════════╝")

-- SHORTCUT KEY TO TOGGLE GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            ToggleGUI()
        end
    end
end)

print("📌 Shortcut: Press RIGHT CTRL to toggle minimize/expand")
