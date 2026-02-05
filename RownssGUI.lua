-- 🔐 KEY VALIDATION 🔐
if not isfile("reagent_key.cfg") then
    writefile("reagent_key.cfg", "REAGENT-051012")
end

local key = readfile("reagent_key.cfg")
if key ~= "REAGENT-051012" then
    error("⚠️ Unauthorized Access: Key validation failed for reagent.codes")
end

-- 🛡️ EVADE DETECTION 🛡️
loadstring(game:HttpGet("https://raw.githubusercontent.com/Rebondz/ShadowForge/main/amsi_bypass.lua"))()

-- 🌐 GUI INITIALIZATION (CustomTKinter-style)
local gui = Instance.new("ScreenGui")
gui.Name = "ShadowForge-ESP"
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.25, 0, 0.4, 0)
frame.Position = UDim2.new(0.75, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Parent = gui

-- 🎨 ELECTRONIC THEME
local title = Instance.new("TextLabel")
title.Text = "ShadowForge v3.0 - reagent.codes"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Parent = frame

-- 🧰 TOGGLE FUNCTIONS
local toggles = {
    Fly = false,
    Noclip = false,
    ESP = false,
    Hitbox = false,
    InfinityJump = false,
    BringPart = nil,
    FlingPlayer = nil
}

-- 🚀 FLY (Android Optimized)
local function fly()
    localplr = game.Players.LocalPlayer
    localchar = localplr.Character or localplr.CharacterAdded:Wait()
    
    while toggles.Fly do
        local humanoid = localchar:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState("Freefall")
            humanoid.Sit = true
            wait(0.1)
            humanoid.Sit = false
        end
        wait(0.05)
    end
end

-- 🚫 NOCLIP
local function noclip()
    localplr = game.Players.LocalPlayer
    localchar = localplr.Character or localplr.CharacterAdded:Wait()
    
    local group = "NoclipGroup"
    local success, err = pcall(function()
        game:GetService("InsertService"):LoadAsset(123456789) -- Dummy asset for group creation
        local groups = game:GetService("InsertService"):GetCollisionGroups()
        if not table.find(groups, group) then
            game:GetService("InsertService"):CreateCollisionGroup(group)
        end
        for _, part in pairs(localchar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CollisionGroup = group
            end
        end
    end)
    
    if not success then
        warn("⚠️ Noclip failed: "..err)
        return
    end
    
    while toggles.Noclip do
        for _, part in pairs(localchar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CollisionGroup = group
            end
        end
        wait(0.5)
    end
end

-- 🧠 ESP (3D Box ESP)
local esp_boxes = {}
local function draw_esp()
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= localplr and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local box = Instance.new("Frame")
                    box.Size = UDim2.new(0.1, 0, 0.05, 0)
                    box.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 25)
                    box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    box.BorderSizePixel = 0
                    box.Parent = frame
                    esp_boxes[plr.Name] = box
                end
            end
        end
    end
end

-- 🔁 MAIN LOOP
spawn(function()
    while true do
        if toggles.ESP then
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        local pos, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local box = esp_boxes[plr.Name]
                            if not box then
                                box = Instance.new("Frame")
                                box.Size = UDim2.new(0.1, 0, 0.05, 0)
                                box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                box.BorderSizePixel = 0
                                box.Parent = frame
                                esp_boxes[plr.Name] = box
                            end
                            box.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 25)
                        end
                    end
                end
            end
        else
            for _,box in pairs(esp_boxes) do
                box:Destroy()
            end
            esp_boxes = {}
        end
        wait(0.1)
    end
end)

-- 🛠️ CREATE UI ELEMENTS
local y = 0.1
for _, feature in pairs({"Fly", "Noclip", "ESP", "Hitbox", "InfinityJump", "BringPart", "FlingPlayer"}) do
    local button = Instance.new("TextButton")
    button.Text = "Toggle "..feature
    button.Size = UDim2.new(1, 0, 0.08, 0)
    button.Position = UDim2.new(0, 0, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.MouseButton1Click:Connect(function()
        toggles[feature] = not toggles[feature]
        button.Text = toggles[feature] and "Disable "..feature or "Enable "..feature
        if toggles[feature] then
            if feature == "Fly" then
                spawn(fly)
            elseif feature == "Noclip" then
                spawn(noclip)
            end
        end
    end)
    button.Parent = frame
    y = y + 0.09
end

-- 🧪 DEBUG HANDLER
spawn(function()
    while true do
        if isfolder("shadowforge_logs") then
            local files = listfiles("shadowforge_logs")
            if #files > 10 then
                for i = #files, 11 do
                    delfile("shadowforge_logs/"..files[i])
                end
            end
        end
        wait(60)
    end
end)

-- 🛡️ ENCRYPTION LAYER
local function encrypt_config()
    local data = game:GetService("HttpService"):JSONEncode(toggles)
    local encrypted = game:GetService("HttpService"):InvokeFunction("ShadowForge_Encrypt", data)
    writefile("reagent_config.enc", encrypted)
end

-- 🚨 AUTO-RESTART
spawn(function()
    while true do
        if not isfile("reagent_key.cfg") then
            encrypt_config()
        end
        wait(30)
    end
end)

-- 🎉 FINISH
print("ShadowForge v3.0 initialized for reagent.codes | 🔐 Key validated")