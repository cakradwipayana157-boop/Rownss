-- Rownn Gui - Ultimate Control Panel (FULL VERSION)
-- By: zamxs | DARK-GPT Special Edition
-- Semua Fitur Lengkap: Fly, Goto Player, Bring Part, Bring Player, Spam Remote

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI UTAMA
local RownnGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local TabButtons = Instance.new("Frame")
local TabContents = Instance.new("Frame")

-- PROPERTIES GUI
RownnGui.Name = "RownnGui"
RownnGui.Parent = CoreGui
RownnGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = RownnGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 0.5
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SciFi
Title.Text = "ROWNN GUI - DARK CONTROL v4.5"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 20

-- MINIMIZE SYSTEM
local minimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 500, 0, 30)

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = MainFrame
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
MinimizeBtn.Position = UDim2.new(0.95, -25, 0, 5)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.SciFi
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextSize = 18

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = minimizedSize
        TabContents.Visible = false
        TabButtons.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame.Size = originalSize
        TabContents.Visible = true
        TabButtons.Visible = true
        MinimizeBtn.Text = "_"
    end
end)

-- TAB SYSTEM
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.Size = UDim2.new(0, 100, 0, 420)

TabContents.Name = "TabContents"
TabContents.Parent = MainFrame
TabContents.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TabContents.BorderSizePixel = 0
TabContents.Position = UDim2.new(0, 100, 0, 30)
TabContents.Size = UDim2.new(0, 400, 0, 420)

-- TABS
local Tabs = {
    "Fly",
    "Goto Player", 
    "Bring Part",
    "Bring Player",
    "Spam Remote"
}

-- CREATE ALL TABS FIRST
local FlyTab = Instance.new("ScrollingFrame")
local GotoTab = Instance.new("ScrollingFrame")
local BringPartTab = Instance.new("ScrollingFrame")
local BringPlayerTab = Instance.new("ScrollingFrame")
local SpamTab = Instance.new("ScrollingFrame")

-- GLOBAL VARIABLES
local flyEnabled = false
local flySpeed = 50
local bodyVelocity
local flyConnection
local bringingParts = false
local bringingPlayers = false
local currentRemoteSpam = nil

-- ==================== FLY TAB ====================
FlyTab.Name = "FlyTab"
FlyTab.Parent = TabContents
FlyTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FlyTab.BorderSizePixel = 0
FlyTab.Size = UDim2.new(1, 0, 1, 0)
FlyTab.ScrollBarThickness = 0
FlyTab.CanvasSize = UDim2.new(0, 0, 0, 500)

-- TITLE
local FlyTitle = Instance.new("TextLabel")
FlyTitle.Parent = FlyTab
FlyTitle.Text = "🚀 ADVANCED FLY SYSTEM"
FlyTitle.Font = Enum.Font.SciFi
FlyTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
FlyTitle.TextSize = 18
FlyTitle.Position = UDim2.new(0.1, 0, 0.02, 0)
FlyTitle.Size = UDim2.new(0.8, 0, 0, 30)

-- FLY TOGGLE
local FlyToggle = Instance.new("TextButton")
FlyToggle.Parent = FlyTab
FlyToggle.Text = "🚀 FLY MODE: OFF"
FlyToggle.Font = Enum.Font.SciFi
FlyToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
FlyToggle.TextSize = 16
FlyToggle.Position = UDim2.new(0.1, 0, 0.1, 0)
FlyToggle.Size = UDim2.new(0.8, 0, 0, 40)
FlyToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FlyToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- JOYSTICK
local JoystickFrame = Instance.new("Frame")
JoystickFrame.Parent = FlyTab
JoystickFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
JoystickFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
JoystickFrame.Position = UDim2.new(0.1, 0, 0.22, 0)
JoystickFrame.Size = UDim2.new(0.8, 0, 0, 150)

local JoystickBackground = Instance.new("Frame")
JoystickBackground.Parent = JoystickFrame
JoystickBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
JoystickBackground.BorderSizePixel = 0
JoystickBackground.Position = UDim2.new(0.1, 0, 0.1, 0)
JoystickBackground.Size = UDim2.new(0.8, 0, 0.8, 0)

local Joystick = Instance.new("Frame")
Joystick.Parent = JoystickBackground
Joystick.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Joystick.BorderSizePixel = 0
Joystick.Size = UDim2.new(0, 30, 0, 30)
Joystick.Position = UDim2.new(0.5, -15, 0.5, -15)
Joystick.ZIndex = 2

-- SPEED CONTROL
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = FlyTab
SpeedLabel.Text = "FLY SPEED: 50"
SpeedLabel.Font = Enum.Font.SciFi
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.TextSize = 14
SpeedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Parent = FlyTab
SpeedSlider.Text = "50"
SpeedSlider.Font = Enum.Font.SciFi
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.TextSize = 14
SpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedSlider.BorderColor3 = Color3.fromRGB(0, 255, 255)
SpeedSlider.Position = UDim2.new(0.1, 0, 0.65, 0)
SpeedSlider.Size = UDim2.new(0.8, 0, 0, 30)

-- NO CLIP OPTION
local NoClipToggle = Instance.new("TextButton")
NoClipToggle.Parent = FlyTab
NoClipToggle.Text = "🔓 NO CLIP: ENABLED"
NoClipToggle.Font = Enum.Font.SciFi
NoClipToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
NoClipToggle.TextSize = 14
NoClipToggle.Position = UDim2.new(0.1, 0, 0.75, 0)
NoClipToggle.Size = UDim2.new(0.8, 0, 0, 35)
NoClipToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
NoClipToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- ==================== GOTO PLAYER TAB ====================
GotoTab.Name = "Goto PlayerTab"
GotoTab.Parent = TabContents
GotoTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
GotoTab.BorderSizePixel = 0
GotoTab.Size = UDim2.new(1, 0, 1, 0)
GotoTab.ScrollBarThickness = 0
GotoTab.CanvasSize = UDim2.new(0, 0, 0, 500)
GotoTab.Visible = false

local GotoTitle = Instance.new("TextLabel")
GotoTitle.Parent = GotoTab
GotoTitle.Text = "👥 GOTO PLAYER SYSTEM"
GotoTitle.Font = Enum.Font.SciFi
GotoTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
GotoTitle.TextSize = 18
GotoTitle.Position = UDim2.new(0.1, 0, 0.02, 0)
GotoTitle.Size = UDim2.new(0.8, 0, 0, 30)

-- PLAYER LIST
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Parent = GotoTab
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
PlayerListFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
PlayerListFrame.Position = UDim2.new(0.1, 0, 0.12, 0)
PlayerListFrame.Size = UDim2.new(0.8, 0, 0, 200)
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- REFRESH BUTTON
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Parent = GotoTab
RefreshBtn.Text = "🔄 REFRESH PLAYER LIST"
RefreshBtn.Font = Enum.Font.SciFi
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 14
RefreshBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
RefreshBtn.Size = UDim2.new(0.8, 0, 0, 35)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
RefreshBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- GOTO BUTTON
local GotoBtn = Instance.new("TextButton")
GotoBtn.Parent = GotoTab
GotoBtn.Text = "⚡ TELEPORT TO SELECTED PLAYER"
GotoBtn.Font = Enum.Font.SciFi
GotoBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
GotoBtn.TextSize = 16
GotoBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
GotoBtn.Size = UDim2.new(0.8, 0, 0, 40)
GotoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
GotoBtn.BorderColor3 = Color3.fromRGB(255, 255, 0)

-- SELECTED PLAYER LABEL
local SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Parent = GotoTab
SelectedPlayerLabel.Text = "Selected: NONE"
SelectedPlayerLabel.Font = Enum.Font.SciFi
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerLabel.TextSize = 14
SelectedPlayerLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
SelectedPlayerLabel.Size = UDim2.new(0.8, 0, 0, 30)

local selectedPlayer = nil

-- ==================== BRING PART TAB ====================
BringPartTab.Name = "Bring PartTab"
BringPartTab.Parent = TabContents
BringPartTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
BringPartTab.BorderSizePixel = 0
BringPartTab.Size = UDim2.new(1, 0, 1, 0)
BringPartTab.ScrollBarThickness = 0
BringPartTab.CanvasSize = UDim2.new(0, 0, 0, 500)
BringPartTab.Visible = false

local BringPartTitle = Instance.new("TextLabel")
BringPartTitle.Parent = BringPartTab
BringPartTitle.Text = "🧱 BRING PART SYSTEM"
BringPartTitle.Font = Enum.Font.SciFi
BringPartTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
BringPartTitle.TextSize = 18
BringPartTitle.Position = UDim2.new(0.1, 0, 0.02, 0)
BringPartTitle.Size = UDim2.new(0.8, 0, 0, 30)

-- BRING TOGGLE
local BringPartToggle = Instance.new("TextButton")
BringPartToggle.Parent = BringPartTab
BringPartToggle.Text = "🧲 BRING ALL PARTS: OFF"
BringPartToggle.Font = Enum.Font.SciFi
BringPartToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
BringPartToggle.TextSize = 16
BringPartToggle.Position = UDim2.new(0.1, 0, 0.1, 0)
BringPartToggle.Size = UDim2.new(0.8, 0, 0, 40)
BringPartToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringPartToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- UNLOCK LOCKED PARTS OPTION
local UnlockToggle = Instance.new("TextButton")
UnlockToggle.Parent = BringPartTab
UnlockToggle.Text = "🔓 UNLOCK LOCKED PARTS: OFF"
UnlockToggle.Font = Enum.Font.SciFi
UnlockToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
UnlockToggle.TextSize = 14
UnlockToggle.Position = UDim2.new(0.1, 0, 0.25, 0)
UnlockToggle.Size = UDim2.new(0.8, 0, 0, 35)
UnlockToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UnlockToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- FORMATION OPTIONS
local FormationLabel = Instance.new("TextLabel")
FormationLabel.Parent = BringPartTab
FormationLabel.Text = "FORMATION: CIRCLE"
FormationLabel.Font = Enum.Font.SciFi
FormationLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
FormationLabel.TextSize = 14
FormationLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
FormationLabel.Size = UDim2.new(0.8, 0, 0, 20)

local RadiusSlider = Instance.new("TextBox")
RadiusSlider.Parent = BringPartTab
RadiusSlider.Text = "10"
RadiusSlider.Font = Enum.Font.SciFi
RadiusSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusSlider.TextSize = 14
RadiusSlider.PlaceholderText = "Circle Radius"
RadiusSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
RadiusSlider.BorderColor3 = Color3.fromRGB(0, 255, 255)
RadiusSlider.Position = UDim2.new(0.1, 0, 0.45, 0)
RadiusSlider.Size = UDim2.new(0.8, 0, 0, 30)

-- BRING SPEED
local BringSpeedSlider = Instance.new("TextBox")
BringSpeedSlider.Parent = BringPartTab
BringSpeedSlider.Text = "100"
BringSpeedSlider.Font = Enum.Font.SciFi
BringSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
BringSpeedSlider.TextSize = 14
BringSpeedSlider.PlaceholderText = "Bring Speed"
BringSpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringSpeedSlider.BorderColor3 = Color3.fromRGB(0, 255, 255)
BringSpeedSlider.Position = UDim2.new(0.1, 0, 0.55, 0)
BringSpeedSlider.Size = UDim2.new(0.8, 0, 0, 30)

-- PART COUNTER
local PartCounter = Instance.new("TextLabel")
PartCounter.Parent = BringPartTab
PartCounter.Text = "Parts Found: 0"
PartCounter.Font = Enum.Font.SciFi
PartCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
PartCounter.TextSize = 14
PartCounter.Position = UDim2.new(0.1, 0, 0.65, 0)
PartCounter.Size = UDim2.new(0.8, 0, 0, 30)

-- ==================== BRING PLAYER TAB ====================
BringPlayerTab.Name = "Bring PlayerTab"
BringPlayerTab.Parent = TabContents
BringPlayerTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
BringPlayerTab.BorderSizePixel = 0
BringPlayerTab.Size = UDim2.new(1, 0, 1, 0)
BringPlayerTab.ScrollBarThickness = 0
BringPlayerTab.CanvasSize = UDim2.new(0, 0, 0, 600)
BringPlayerTab.Visible = false

local BringPlayerTitle = Instance.new("TextLabel")
BringPlayerTitle.Parent = BringPlayerTab
BringPlayerTitle.Text = "👤 BRING PLAYER SYSTEM"
BringPlayerTitle.Font = Enum.Font.SciFi
BringPlayerTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
BringPlayerTitle.TextSize = 18
BringPlayerTitle.Position = UDim2.new(0.1, 0, 0.02, 0)
BringPlayerTitle.Size = UDim2.new(0.8, 0, 0, 30)

-- PLAYER LIST FOR BRINGING
local BringPlayerList = Instance.new("ScrollingFrame")
BringPlayerList.Parent = BringPlayerTab
BringPlayerList.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
BringPlayerList.BorderColor3 = Color3.fromRGB(0, 255, 255)
BringPlayerList.Position = UDim2.new(0.1, 0, 0.12, 0)
BringPlayerList.Size = UDim2.new(0.8, 0, 0, 200)
BringPlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)

-- BRING TOGGLE
local BringPlayerToggle = Instance.new("TextButton")
BringPlayerToggle.Parent = BringPlayerTab
BringPlayerToggle.Text = "👥 BRING PLAYER MODE: OFF"
BringPlayerToggle.Font = Enum.Font.SciFi
BringPlayerToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
BringPlayerToggle.TextSize = 16
BringPlayerToggle.Position = UDim2.new(0.1, 0, 0.6, 0)
BringPlayerToggle.Size = UDim2.new(0.8, 0, 0, 40)
BringPlayerToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringPlayerToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- SELECTED PLAYER FOR BRINGING
local SelectedBringPlayerLabel = Instance.new("TextLabel")
SelectedBringPlayerLabel.Parent = BringPlayerTab
SelectedBringPlayerLabel.Text = "Target: NONE"
SelectedBringPlayerLabel.Font = Enum.Font.SciFi
SelectedBringPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedBringPlayerLabel.TextSize = 14
SelectedBringPlayerLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
SelectedBringPlayerLabel.Size = UDim2.new(0.8, 0, 0, 30)

-- BRING SPEED CONTROL
local BringPlayerSpeed = Instance.new("TextBox")
BringPlayerSpeed.Parent = BringPlayerTab
BringPlayerSpeed.Text = "50"
BringPlayerSpeed.Font = Enum.Font.SciFi
BringPlayerSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
BringPlayerSpeed.TextSize = 14
BringPlayerSpeed.PlaceholderText = "Bring Speed"
BringPlayerSpeed.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringPlayerSpeed.BorderColor3 = Color3.fromRGB(0, 255, 255)
BringPlayerSpeed.Position = UDim2.new(0.1, 0, 0.7, 0)
BringPlayerSpeed.Size = UDim2.new(0.8, 0, 0, 30)

-- ==================== SPAM REMOTE TAB ====================
SpamTab.Name = "Spam RemoteTab"
SpamTab.Parent = TabContents
SpamTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SpamTab.BorderSizePixel = 0
SpamTab.Size = UDim2.new(1, 0, 1, 0)
SpamTab.ScrollBarThickness = 0
SpamTab.CanvasSize = UDim2.new(0, 0, 0, 500)
SpamTab.Visible = false

local SpamTitle = Instance.new("TextLabel")
SpamTitle.Parent = SpamTab
SpamTitle.Text = "💥 REMOTE SPAM SYSTEM"
SpamTitle.Font = Enum.Font.SciFi
SpamTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
SpamTitle.TextSize = 18
SpamTitle.Position = UDim2.new(0.1, 0, 0.02, 0)
SpamTitle.Size = UDim2.new(0.8, 0, 0, 30)

-- SCAN BUTTON
local ScanBtn = Instance.new("TextButton")
ScanBtn.Parent = SpamTab
ScanBtn.Text = "🔍 SCAN FOR BACKDOORS"
ScanBtn.Font = Enum.Font.SciFi
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 14
ScanBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
ScanBtn.Size = UDim2.new(0.8, 0, 0, 40)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ScanBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- STATUS INDICATOR
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Parent = SpamTab
StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StatusIndicator.BorderSizePixel = 0
StatusIndicator.Position = UDim2.new(0.15, 0, 0.25, 0)
StatusIndicator.Size = UDim2.new(0.1, 0, 0, 20)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = SpamTab
StatusLabel.Text = "STATUS: NOT READY"
StatusLabel.Font = Enum.Font.SciFi
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.TextSize = 14
StatusLabel.Position = UDim2.new(0.3, 0, 0.25, 0)
StatusLabel.Size = UDim2.new(0.6, 0, 0, 20)

-- SPAM INTENSITY
local SpamIntensity = Instance.new("TextBox")
SpamIntensity.Parent = SpamTab
SpamIntensity.Text = "1000"
SpamIntensity.Font = Enum.Font.SciFi
SpamIntensity.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamIntensity.TextSize = 14
SpamIntensity.PlaceholderText = "Spam Intensity (Requests/sec)"
SpamIntensity.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpamIntensity.BorderColor3 = Color3.fromRGB(0, 255, 255)
SpamIntensity.Position = UDim2.new(0.1, 0, 0.35, 0)
SpamIntensity.Size = UDim2.new(0.8, 0, 0, 30)

-- START SPAM
local StartSpamBtn = Instance.new("TextButton")
StartSpamBtn.Parent = SpamTab
StartSpamBtn.Text = "🔥 START REMOTE SPAM"
StartSpamBtn.Font = Enum.Font.SciFi
StartSpamBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
StartSpamBtn.TextSize = 16
StartSpamBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
StartSpamBtn.Size = UDim2.new(0.8, 0, 0, 40)
StartSpamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StartSpamBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)

-- STOP SPAM
local StopSpamBtn = Instance.new("TextButton")
StopSpamBtn.Parent = SpamTab
StopSpamBtn.Text = "⏹️ STOP SPAM"
StopSpamBtn.Font = Enum.Font.SciFi
StopSpamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopSpamBtn.TextSize = 14
StopSpamBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
StopSpamBtn.Size = UDim2.new(0.8, 0, 0, 35)
StopSpamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StopSpamBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)

-- LOG OUTPUT
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Parent = SpamTab
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
LogFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
LogFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
LogFrame.Size = UDim2.new(0.8, 0, 0, 120)
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 200)

-- ==================== FUNCTIONS ====================

-- FLY SYSTEM FUNCTIONS
local function updateFly()
    if flyEnabled then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.P = 9e9
            bodyVelocity.Parent = Player.Character:WaitForChild("HumanoidRootPart")
        end
        
        local camera = workspace.CurrentCamera
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if flyEnabled and bodyVelocity then
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                local upVector = camera.CFrame.UpVector
                
                local velocity = Vector3.new(0, 0, 0)
                
                -- Keyboard Controls
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity - Vector3.new(0, 1, 0)
                end
                
                -- Apply velocity
                if velocity.Magnitude > 0 then
                    bodyVelocity.Velocity = velocity.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
                
                -- No Clip
                if NoClipToggle.Text:find("ENABLED") then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end

-- GOTO PLAYER FUNCTIONS
local function updatePlayerList()
    PlayerListFrame:ClearAllChildren()
    local yOffset = 5
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Parent = PlayerListFrame
            PlayerButton.Text = player.Name
            PlayerButton.Font = Enum.Font.SciFi
            PlayerButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            PlayerButton.TextSize = 12
            PlayerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            PlayerButton.BorderSizePixel = 0
            PlayerButton.Position = UDim2.new(0.05, 0, 0, yOffset)
            PlayerButton.Size = UDim2.new(0.9, 0, 0, 30)
            
            PlayerButton.MouseButton1Click:Connect(function()
                selectedPlayer = player
                SelectedPlayerLabel.Text = "Selected: " .. player.Name
            end)
            
            yOffset = yOffset + 35
        end
    end
    
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- BRING PART FUNCTIONS
local function bringAllParts()
    if not bringingParts then return end
    
    local radius = tonumber(RadiusSlider.Text) or 10
    local speed = tonumber(BringSpeedSlider.Text) or 100
    local unlock = UnlockToggle.Text:find("ON")
    
    local root = Player.Character:WaitForChild("HumanoidRootPart")
    local parts = Workspace:GetDescendants()
    local partCount = 0
    
    for _, part in pairs(parts) do
        if part:IsA("BasePart") and part ~= root then
            partCount = partCount + 1
            
            if unlock then
                pcall(function()
                    part.Locked = false
                    if part:FindFirstChildOfClass("Weld") then
                        part:FindFirstChildOfClass("Weld"):Destroy()
                    end
                end)
            end
            
            local angle = partCount * (360 / math.max(1, partCount))
            local offset = Vector3.new(
                math.cos(math.rad(angle)) * radius,
                0,
                math.sin(math.rad(angle)) * radius
            )
            
            local targetPosition = root.Position + offset
            
            spawn(function()
                for i = 1, speed do
                    if not bringingParts then break end
                    pcall(function()
                        part.Velocity = (targetPosition - part.Position).Unit * 100
                        part.CFrame = CFrame.new(part.Position, targetPosition)
                    end)
                    wait(0.01)
                end
            end)
        end
    end
    
    PartCounter.Text = "Parts Found: " .. partCount
end

-- BRING PLAYER FUNCTIONS
local function bringSelectedPlayer()
    if not bringingPlayers or not selectedPlayer then return end
    
    local speed = tonumber(BringPlayerSpeed.Text) or 50
    local target = selectedPlayer.Character
    
    if target and target:FindFirstChild("HumanoidRootPart") then
        local targetRoot = target.HumanoidRootPart
        local myRoot = Player.Character:WaitForChild("HumanoidRootPart")
        
        targetRoot.Velocity = (myRoot.Position - targetRoot.Position).Unit * speed
    end
end

-- SPAM REMOTE FUNCTIONS
local function scanForBackdoors()
    StatusLabel.Text = "STATUS: SCANNING..."
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    
    local foundRemote = false
    
    -- Scan common remote locations
    local locations = {
        ReplicatedStorage,
        Workspace,
        game:GetService("Lighting"),
        game:GetService("StarterPack"),
        game:GetService("StarterGui")
    }
    
    for _, location in pairs(locations) do
        pcall(function()
            for _, obj in pairs(location:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    foundRemote = true
                    currentRemoteSpam = obj
                    break
                end
            end
        end)
        
        if foundRemote then break end
    end
    
    if foundRemote then
        StatusLabel.Text = "STATUS: READY"
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Add to log
        local logEntry = Instance.new("TextLabel")
        logEntry.Parent = LogFrame
        logEntry.Text = "[+] Found remote: " .. currentRemoteSpam.Name
        logEntry.Font = Enum.Font.Code
        logEntry.TextColor3 = Color3.fromRGB(50, 255, 50)
        logEntry.TextSize = 12
        logEntry.BackgroundTransparency = 1
        logEntry.Size = UDim2.new(0.95, 0, 0, 20)
        logEntry.Position = UDim2.new(0, 5, 0, LogFrame.CanvasSize.Y.Offset)
        
        LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogFrame.CanvasSize.Y.Offset + 25)
    else
        StatusLabel.Text = "STATUS: NOT READY"
        StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end

local spamConnection
local function startSpam()
    if not currentRemoteSpam then
        StatusLabel.Text = "STATUS: NO REMOTE FOUND"
        return
    end
    
    local intensity = tonumber(SpamIntensity.Text) or 1000
    
    spamConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if currentRemoteSpam:IsA("RemoteEvent") then
                currentRemoteSpam:FireServer()
            elseif currentRemoteSpam:IsA("RemoteFunction") then
                currentRemoteSpam:InvokeServer()
            end
        end)
    end)
    
    StatusLabel.Text = "STATUS: SPAMMING..."
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end

-- ==================== EVENT CONNECTIONS ====================

-- FLY EVENTS
FlyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        FlyToggle.Text = "🚀 FLY MODE: ON"
        FlyToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        FlyToggle.Text = "🚀 FLY MODE: OFF"
        FlyToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
    updateFly()
end)

SpeedSlider.FocusLost:Connect(function()
    local speed = tonumber(SpeedSlider.Text)
    if speed and speed > 0 and speed <= 500 then
        flySpeed = speed
        SpeedLabel.Text = "FLY SPEED: " .. speed
    else
        SpeedSlider.Text = flySpeed
    end
end)

NoClipToggle.MouseButton1Click:Connect(function()
    if NoClipToggle.Text:find("ENABLED") then
        NoClipToggle.Text = "🔓 NO CLIP: DISABLED"
        NoClipToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        NoClipToggle.Text = "🔓 NO CLIP: ENABLED"
        NoClipToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
end)

-- GOTO PLAYER EVENTS
RefreshBtn.MouseButton1Click:Connect(function()
    updatePlayerList()
end)

GotoBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target then
            Player.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame
            SelectedPlayerLabel.Text = "Teleported to: " .. selectedPlayer.Name
        end
    end
end)

-- BRING PART EVENTS
BringPartToggle.MouseButton1Click:Connect(function()
    bringingParts = not bringingParts
    if bringingParts then
        BringPartToggle.Text = "🧲 BRING ALL PARTS: ON"
        BringPartToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        spawn(bringAllParts)
    else
        BringPartToggle.Text = "🧲 BRING ALL PARTS: OFF"
        BringPartToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

UnlockToggle.MouseButton1Click:Connect(function()
    if UnlockToggle.Text:find("OFF") then
        UnlockToggle.Text = "🔓 UNLOCK LOCKED PARTS: ON"
        UnlockToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        UnlockToggle.Text = "🔓 UNLOCK LOCKED PARTS: OFF"
        UnlockToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- BRING PLAYER EVENTS
BringPlayerToggle.MouseButton1Click:Connect(function()
    bringingPlayers = not bringingPlayers
    if bringingPlayers then
        BringPlayerToggle.Text = "👥 BRING PLAYER MODE: ON"
        BringPlayerToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        spawn(function()
            while bringingPlayers do
                bringSelectedPlayer()
                wait(0.1)
            end
        end)
    else
        BringPlayerToggle.Text = "👥 BRING PLAYER MODE: OFF"
        BringPlayerToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- SPAM REMOTE EVENTS
ScanBtn.MouseButton1Click:Connect(function()
    scanForBackdoors()
end)

StartSpamBtn.MouseButton1Click:Connect(function()
    startSpam()
end)

StopSpamBtn.MouseButton1Click:Connect(function()
    if spamConnection then
        spamConnection:Disconnect()
        spamConnection = nil
    end
    StatusLabel.Text = "STATUS: STOPPED"
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
end)

-- ==================== JOYSTICK CONTROLS ====================
local dragging = false
local function updateJoystick(input)
    local backgroundPos = JoystickBackground.AbsolutePosition
    local backgroundSize = JoystickBackground.AbsoluteSize
    local joystickSize = Joystick.AbsoluteSize
    
    local pos = Vector2.new(
        math.clamp(input.Position.X, backgroundPos.X, backgroundPos.X + backgroundSize.X),
        math.clamp(input.Position.Y, backgroundPos.Y, backgroundPos.Y + backgroundSize.Y)
    )
    
    Joystick.Position = UDim2.new(
        0,
        pos.X - backgroundPos.X - joystickSize.X/2,
        0,
        pos.Y - backgroundPos.Y - joystickSize.Y/2
    )
end

Joystick.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

Joystick.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        local tween = TweenService:Create(
            Joystick,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -15, 0.5, -15)}
        )
        tween:Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateJoystick(input)
    end
end)

-- ==================== TAB CREATION ====================
for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabButtons
    TabButton.Text = tabName
    TabButton.Font = Enum.Font.SciFi
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 50)
    TabButton.Size = UDim2.new(1, 0, 0, 50)
    
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        FlyTab.Visible = false
        GotoTab.Visible = false
        BringPartTab.Visible = false
        BringPlayerTab.Visible = false
        SpamTab.Visible = false
        
        -- Show selected tab
        if tabName == "Fly" then
            FlyTab.Visible = true
        elseif tabName == "Goto Player" then
            GotoTab.Visible = true
            updatePlayerList()
        elseif tabName == "Bring Part" then
            BringPartTab.Visible = true
        elseif tabName == "Bring Player" then
            BringPlayerTab.Visible = true
        elseif tabName == "Spam Remote" then
            SpamTab.Visible = true
        end
    end)
end

-- ==================== INITIALIZATION ====================
-- Initial update
updatePlayerList()

-- Security bypass
local function bypassAntiCheat()
    pcall(function()
        game:GetService("ScriptContext"):SetTimeout(0)
    end)
end

bypassAntiCheat()

-- Success message
print("==========================================")
print("ROWNN GUI LOADED SUCCESSFULLY!")
print("Version: 4.5 | Created by: zamxs")
print("Features:")
print("1. Advanced Fly System with Joystick")
print("2. Goto Player Teleport")
print("3. Bring All Parts System")
print("4. Bring Player System")
print("5. Remote Spam System")
print("==========================================")

-- Show first tab
FlyTab.Visible = true

-- Cleanup on player leaving
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == Player then
        if flyConnection then flyConnection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if spamConnection then spamConnection:Disconnect() end
        RownnGui:Destroy()
    end
end)