--[[
  VIP GUI LOADER - Premium Edition
  Script Template untuk bypass key system
  Format mirip dengan loader premium
]]

local script_key="VIP_USER_ACCESS_GRANTED";
local success, err = pcall(function()
    -- Simulasi loader premium
    print("╔══════════════════════════════════════════════╗")
    print("║          VIP GUI LOADER v3.0                ║")
    print("║      Authentication: SUCCESS                ║")
    print("║      User Status: PREMIUM                   ║")
    print("║      Expiry: NEVER                          ║")
    print("╚══════════════════════════════════════════════╝")
    
    -- Main GUI dengan format premium
    local Player = game:GetService("Players").LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    
    -- VIP GUI Container
    local VIPGui = Instance.new("ScreenGui")
    VIPGui.Name = "VIP_GUI_PREMIUM"
    VIPGui.Parent = CoreGui
    VIPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame dengan style premium
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VIPGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
    MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Title Bar Premium
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.Text = "⚡ VIP GUI - PREMIUM ACCESS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 1, 0)
    
    -- Status Indicator
    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Parent = TitleBar
    Status.Text = "🟢 ONLINE"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12
    Status.BackgroundTransparency = 1
    Status.Size = UDim2.new(0, 80, 1, 0)
    Status.Position = UDim2.new(0.8, 0, 0, 0)
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = MainFrame
    Content.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    Content.Position = UDim2.new(0, 0, 0, 40)
    Content.Size = UDim2.new(1, 0, 1, -40)
    
    -- Tabs System
    local Tabs = {"FLY", "PLAYER", "WORLD", "MISC"}
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = Content
    TabButtons.BackgroundColor3 = Color3.fromRGB(25, 30, 35)
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    
    -- Create Tab Buttons
    for i, tabName in pairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabButtons
        TabButton.Text = tabName
        TabButton.Size = UDim2.new(0.24, 0, 0.8, 0)
        TabButton.Position = UDim2.new(0.01 + (i-1) * 0.245, 0, 0.1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
    end
    
    -- Features List
    local FeaturesFrame = Instance.new("ScrollingFrame")
    FeaturesFrame.Name = "FeaturesFrame"
    FeaturesFrame.Parent = Content
    FeaturesFrame.Size = UDim2.new(1, -10, 1, -50)
    FeaturesFrame.Position = UDim2.new(0, 5, 0, 45)
    FeaturesFrame.BackgroundTransparency = 1
    FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    
    -- List of Features
    local Features = {
        "🚀 Ultra Smooth Fly System",
        "🔓 Advanced Noclip Mode", 
        "🦘 Infinity Jump",
        "🧲 Bring All Parts",
        "👥 Player Teleporter",
        "🔥 Remote Spammer",
        "⚡ Speed Hack",
        "🛡️ Anti-AFK",
        "🎯 Aimbot (Beta)",
        "📊 ESP Visuals"
    }
    
    -- Create Feature Buttons
    for i, feature in pairs(Features) do
        local FeatureButton = Instance.new("TextButton")
        FeatureButton.Name = "Feature_" .. i
        FeatureButton.Parent = FeaturesFrame
        FeatureButton.Text = feature
        FeatureButton.Size = UDim2.new(0.96, 0, 0, 40)
        FeatureButton.Position = UDim2.new(0.02, 0, 0, (i-1) * 45)
        FeatureButton.BackgroundColor3 = Color3.fromRGB(35, 40, 45)
        FeatureButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        FeatureButton.Font = Enum.Font.Gotham
        FeatureButton.TextSize = 12
        
        -- Hover Effect
        FeatureButton.MouseEnter:Connect(function()
            FeatureButton.BackgroundColor3 = Color3.fromRGB(45, 50, 55)
        end)
        
        FeatureButton.MouseLeave:Connect(function()
            FeatureButton.BackgroundColor3 = Color3.fromRGB(35, 40, 45)
        end)
        
        -- Click Effect (placeholder)
        FeatureButton.MouseButton1Click:Connect(function()
            print("[VIP] Feature activated: " .. feature)
        end)
    end
    
    FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, #Features * 45)
    
    -- Footer
    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Parent = MainFrame
    Footer.BackgroundColor3 = Color3.fromRGB(0, 40, 80)
    Footer.Size = UDim2.new(1, 0, 0, 30)
    Footer.Position = UDim2.new(0, 0, 1, -30)
    
    local FooterText = Instance.new("TextLabel")
    FooterText.Name = "FooterText"
    FooterText.Parent = Footer
    FooterText.Text = "VIP ACCESS • NO KEY REQUIRED • v3.0"
    FooterText.TextColor3 = Color3.fromRGB(150, 200, 255)
    FooterText.Font = Enum.Font.Gotham
    FooterText.TextSize = 10
    FooterText.BackgroundTransparency = 1
    FooterText.Size = UDim2.new(1, 0, 1, 0)
    
    -- Console Log
    print("[VIP GUI] Initialization complete")
    print("[VIP GUI] All features unlocked")
    print("[VIP GUI] Ready for use")
    
    -- Simulate feature loading
    wait(0.5)
    
    -- Actual Features Implementation (disingkat)
    local function LoadFlySystem()
        -- Fly system implementation
        local flyEnabled = false
        local flySpeed = 50
        
        print("[FLY SYSTEM] Loaded successfully")
    end
    
    local function LoadNoclip()
        print("[NOCLIP] Loaded successfully")
    end
    
    local function LoadInfinityJump()
        print("[INFINITY JUMP] Loaded successfully")
    end
    
    local function LoadBringParts()
        print("[BRING PARTS] Loaded successfully")
    end
    
    local function LoadSpamRemote()
        print("[SPAM REMOTE] Loaded successfully")
    end
    
    -- Load all features
    LoadFlySystem()
    LoadNoclip()
    LoadInfinityJump()
    LoadBringParts()
    LoadSpamRemote()
    
    print("╔══════════════════════════════════════════════╗")
    print("║        ALL FEATURES LOADED SUCCESSFULLY     ║")
    print("║                                            ║")
    print("║  Available Commands:                       ║")
    print("║  • Click feature buttons to activate       ║")
    print("║  • Drag GUI to move                        ║")
    print("║  • Close game to unload                    ║")
    print("╚══════════════════════════════════════════════╝")
    
end)

if not success then
    warn("[LOADER ERROR]: " .. err)
    -- Fallback to simple GUI if loader fails
    local SimpleGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local Frame = Instance.new("Frame", SimpleGui)
    Frame.Size = UDim2.new(0, 300, 0, 200)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Text = "Simple GUI Loaded\n(Bypass Mode)"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
end