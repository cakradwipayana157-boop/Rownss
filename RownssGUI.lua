-- ROWNN GUI COMPLETE v2.0
-- ALL FEATURES: Fly Mobile, Goto Player, Bring Part, Bring Player, Spam Remote
-- By: zamxs | DARK-GPT Premium

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 0.5
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SciFi
Title.Text = "ROWNN GUI v2.0 - MOBILE EDITION"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 18

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
TabButtons.Size = UDim2.new(0, 120, 0, 470)

TabContents.Name = "TabContents"
TabContents.Parent = MainFrame
TabContents.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TabContents.BorderSizePixel = 0
TabContents.Position = UDim2.new(0, 120, 0, 30)
TabContents.Size = UDim2.new(0, 380, 0, 470)

-- TABS
local Tabs = {
    "Fly",
    "Goto Player", 
    "Bring Part",
    "Bring Player",
    "Spam Remote"
}

-- CREATE ALL TAB FRAMES
local FlyTab = Instance.new("ScrollingFrame")
local GotoTab = Instance.new("ScrollingFrame")
local BringPartTab = Instance.new("ScrollingFrame")
local BringPlayerTab = Instance.new("ScrollingFrame")
local SpamTab = Instance.new("ScrollingFrame")

-- GLOBAL VARIABLES
local flyEnabled = false
local flySpeed = 50
local bodyVelocity
local bodyGyro
local flyConnection

local bringingParts = false
local bringingPlayers = false
local selectedPlayer = nil
local selectedTargetPlayer = nil
local currentRemoteSpam = nil

local joystickActive = false
local joystickStartPos = Vector2.new(0, 0)
local joystickCurrentPos = Vector2.new(0, 0)
local joystickRadius = 50
local altitudeUp = false
local altitudeDown = false

-- ==================== FLY TAB (MOBILE VERSION) ====================
FlyTab.Name = "FlyTab"
FlyTab.Parent = TabContents
FlyTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FlyTab.BorderSizePixel = 0
FlyTab.Size = UDim2.new(1, 0, 1, 0)
FlyTab.ScrollBarThickness = 5
FlyTab.ScrollingEnabled = true
FlyTab.CanvasSize = UDim2.new(0, 0, 0, 600)
FlyTab.Visible = true

-- TITLE
local FlyTitle = Instance.new("TextLabel")
FlyTitle.Parent = FlyTab
FlyTitle.Text = "🚀 FLY SYSTEM (MOBILE)"
FlyTitle.Font = Enum.Font.SciFi
FlyTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
FlyTitle.TextSize = 18
FlyTitle.BackgroundTransparency = 1
FlyTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
FlyTitle.Size = UDim2.new(0.9, 0, 0, 30)

-- FLY TOGGLE
local FlyToggle = Instance.new("TextButton")
FlyToggle.Parent = FlyTab
FlyToggle.Text = "🚀 FLY MODE: OFF"
FlyToggle.Font = Enum.Font.SciFi
FlyToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
FlyToggle.TextSize = 16
FlyToggle.Position = UDim2.new(0.05, 0, 0.08, 0)
FlyToggle.Size = UDim2.new(0.9, 0, 0, 40)
FlyToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FlyToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- JOYSTICK CONTAINER
local JoystickContainer = Instance.new("Frame")
JoystickContainer.Parent = FlyTab
JoystickContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
JoystickContainer.BorderColor3 = Color3.fromRGB(0, 255, 255)
JoystickContainer.Position = UDim2.new(0.05, 0, 0.18, 0)
JoystickContainer.Size = UDim2.new(0.9, 0, 0, 180)
JoystickContainer.ClipsDescendants = true

local JoystickBackground = Instance.new("Frame")
JoystickBackground.Parent = JoystickContainer
JoystickBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
JoystickBackground.BorderSizePixel = 0
JoystickBackground.Size = UDim2.new(1, 0, 1, 0)

local JoystickKnob = Instance.new("Frame")
JoystickKnob.Parent = JoystickBackground
JoystickKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
JoystickKnob.BorderSizePixel = 0
JoystickKnob.Size = UDim2.new(0.15, 0, 0.15, 0)
JoystickKnob.Position = UDim2.new(0.425, 0, 0.425, 0)
JoystickKnob.AnchorPoint = Vector2.new(0.5, 0.5)

-- JOYSTICK DIRECTIONS
local directions = {"↑", "↓", "←", "→"}
local directionPositions = {
    UDim2.new(0.5, 0, 0.1, 0),
    UDim2.new(0.5, 0, 0.9, 0),
    UDim2.new(0.1, 0, 0.5, 0),
    UDim2.new(0.9, 0, 0.5, 0)
}

for i = 1, 4 do
    local arrow = Instance.new("TextLabel")
    arrow.Parent = JoystickContainer
    arrow.Text = directions[i]
    arrow.Font = Enum.Font.SciFi
    arrow.TextColor3 = Color3.fromRGB(0, 255, 255, 100)
    arrow.TextSize = 24
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.new(0.2, 0, 0.2, 0)
    arrow.Position = directionPositions[i]
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
end

-- ALTITUDE CONTROLS
local AltitudeFrame = Instance.new("Frame")
AltitudeFrame.Parent = FlyTab
AltitudeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
AltitudeFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
AltitudeFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
AltitudeFrame.Size = UDim2.new(0.9, 0, 0, 80)

local UpButton = Instance.new("TextButton")
UpButton.Parent = AltitudeFrame
UpButton.Text = "⬆️ NAIK"
UpButton.Font = Enum.Font.SciFi
UpButton.TextColor3 = Color3.fromRGB(50, 255, 50)
UpButton.TextSize = 16
UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UpButton.BorderColor3 = Color3.fromRGB(0, 255, 255)
UpButton.Size = UDim2.new(0.9, 0, 0.4, 0)
UpButton.Position = UDim2.new(0.05, 0, 0.05, 0)

local DownButton = Instance.new("TextButton")
DownButton.Parent = AltitudeFrame
DownButton.Text = "⬇️ TURUN"
DownButton.Font = Enum.Font.SciFi
DownButton.TextColor3 = Color3.fromRGB(255, 50, 50)
DownButton.TextSize = 16
DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DownButton.BorderColor3 = Color3.fromRGB(0, 255, 255)
DownButton.Size = UDim2.new(0.9, 0, 0.4, 0)
DownButton.Position = UDim2.new(0.05, 0, 0.55, 0)

-- SPEED CONTROL
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = FlyTab
SpeedLabel.Text = "KE CEPATAN: 50"
SpeedLabel.Font = Enum.Font.SciFi
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.TextSize = 14
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = FlyTab
SpeedBox.Text = "50"
SpeedBox.Font = Enum.Font.SciFi
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 14
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedBox.BorderColor3 = Color3.fromRGB(0, 255, 255)
SpeedBox.Position = UDim2.new(0.05, 0, 0.79, 0)
SpeedBox.Size = UDim2.new(0.9, 0, 0, 35)
SpeedBox.PlaceholderText = "Masukkan kecepatan (1-200)"

-- NO CLIP TOGGLE
local NoClipToggle = Instance.new("TextButton")
NoClipToggle.Parent = FlyTab
NoClipToggle.Text = "🔓 NO CLIP: ON"
NoClipToggle.Font = Enum.Font.SciFi
NoClipToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
NoClipToggle.TextSize = 14
NoClipToggle.Position = UDim2.new(0.05, 0, 0.88, 0)
NoClipToggle.Size = UDim2.new(0.9, 0, 0, 40)
NoClipToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
NoClipToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- ==================== GOTO PLAYER TAB ====================
GotoTab.Name = "GotoPlayerTab"
GotoTab.Parent = TabContents
GotoTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
GotoTab.BorderSizePixel = 0
GotoTab.Size = UDim2.new(1, 0, 1, 0)
GotoTab.ScrollBarThickness = 5
GotoTab.CanvasSize = UDim2.new(0, 0, 0, 600)
GotoTab.Visible = false

local GotoTitle = Instance.new("TextLabel")
GotoTitle.Parent = GotoTab
GotoTitle.Text = "👥 TELEPORT KE PLAYER"
GotoTitle.Font = Enum.Font.SciFi
GotoTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
GotoTitle.TextSize = 18
GotoTitle.BackgroundTransparency = 1
GotoTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
GotoTitle.Size = UDim2.new(0.9, 0, 0, 30)

-- PLAYER LIST
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Parent = GotoTab
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
PlayerListFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
PlayerListFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
PlayerListFrame.Size = UDim2.new(0.9, 0, 0, 250)
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 5

-- REFRESH BUTTON
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Parent = GotoTab
RefreshBtn.Text = "🔄 REFRESH LIST"
RefreshBtn.Font = Enum.Font.SciFi
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 14
RefreshBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 40)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
RefreshBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- SELECTED PLAYER LABEL
local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Parent = GotoTab
SelectedLabel.Text = "Dipilih: TIDAK ADA"
SelectedLabel.Font = Enum.Font.SciFi
SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedLabel.TextSize = 14
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
SelectedLabel.Size = UDim2.new(0.9, 0, 0, 30)

-- GOTO BUTTON
local GotoButton = Instance.new("TextButton")
GotoButton.Parent = GotoTab
GotoButton.Text = "⚡ TELEPORT KE PLAYER"
GotoButton.Font = Enum.Font.SciFi
GotoButton.TextColor3 = Color3.fromRGB(255, 255, 0)
GotoButton.TextSize = 16
GotoButton.Position = UDim2.new(0.05, 0, 0.75, 0)
GotoButton.Size = UDim2.new(0.9, 0, 0, 45)
GotoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
GotoButton.BorderColor3 = Color3.fromRGB(255, 255, 0)

-- ==================== BRING PART TAB ====================
BringPartTab.Name = "BringPartTab"
BringPartTab.Parent = TabContents
BringPartTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
BringPartTab.BorderSizePixel = 0
BringPartTab.Size = UDim2.new(1, 0, 1, 0)
BringPartTab.ScrollBarThickness = 5
BringPartTab.CanvasSize = UDim2.new(0, 0, 0, 500)
BringPartTab.Visible = false

local BringPartTitle = Instance.new("TextLabel")
BringPartTitle.Parent = BringPartTab
BringPartTitle.Text = "🧱 TARIK SEMUA PART"
BringPartTitle.Font = Enum.Font.SciFi
BringPartTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
BringPartTitle.TextSize = 18
BringPartTitle.BackgroundTransparency = 1
BringPartTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
BringPartTitle.Size = UDim2.new(0.9, 0, 0, 30)

-- BRING TOGGLE
local BringPartToggle = Instance.new("TextButton")
BringPartToggle.Parent = BringPartTab
BringPartToggle.Text = "🧲 MULAI TARIK PART: OFF"
BringPartToggle.Font = Enum.Font.SciFi
BringPartToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
BringPartToggle.TextSize = 16
BringPartToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
BringPartToggle.Size = UDim2.new(0.9, 0, 0, 45)
BringPartToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringPartToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- UNLOCK LOCKED PARTS
local UnlockToggle = Instance.new("TextButton")
UnlockToggle.Parent = BringPartTab
UnlockToggle.Text = "🔓 BUKA PART TERKUNCI: OFF"
UnlockToggle.Font = Enum.Font.SciFi
UnlockToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
UnlockToggle.TextSize = 14
UnlockToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
UnlockToggle.Size = UDim2.new(0.9, 0, 0, 40)
UnlockToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UnlockToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- RADIUS CONTROL
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Parent = BringPartTab
RadiusLabel.Text = "JARI-JARI LINGKARAN: 10"
RadiusLabel.Font = Enum.Font.SciFi
RadiusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
RadiusLabel.TextSize = 14
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
RadiusLabel.Size = UDim2.new(0.9, 0, 0, 20)

local RadiusBox = Instance.new("TextBox")
RadiusBox.Parent = BringPartTab
RadiusBox.Text = "10"
RadiusBox.Font = Enum.Font.SciFi
RadiusBox.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusBox.TextSize = 14
RadiusBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
RadiusBox.BorderColor3 = Color3.fromRGB(0, 255, 255)
RadiusBox.Position = UDim2.new(0.05, 0, 0.45, 0)
RadiusBox.Size = UDim2.new(0.9, 0, 0, 35)

-- PART COUNTER
local PartCounterLabel = Instance.new("TextLabel")
PartCounterLabel.Parent = BringPartTab
PartCounterLabel.Text = "PART DITEMUKAN: 0"
PartCounterLabel.Font = Enum.Font.SciFi
PartCounterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PartCounterLabel.TextSize = 14
PartCounterLabel.BackgroundTransparency = 1
PartCounterLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
PartCounterLabel.Size = UDim2.new(0.9, 0, 0, 30)

-- ==================== BRING PLAYER TAB ====================
BringPlayerTab.Name = "BringPlayerTab"
BringPlayerTab.Parent = TabContents
BringPlayerTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
BringPlayerTab.BorderSizePixel = 0
BringPlayerTab.Size = UDim2.new(1, 0, 1, 0)
BringPlayerTab.ScrollBarThickness = 5
BringPlayerTab.CanvasSize = UDim2.new(0, 0, 0, 600)
BringPlayerTab.Visible = false

local BringPlayerTitle = Instance.new("TextLabel")
BringPlayerTitle.Parent = BringPlayerTab
BringPlayerTitle.Text = "👤 TARIK PLAYER"
BringPlayerTitle.Font = Enum.Font.SciFi
BringPlayerTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
BringPlayerTitle.TextSize = 18
BringPlayerTitle.BackgroundTransparency = 1
BringPlayerTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
BringPlayerTitle.Size = UDim2.new(0.9, 0, 0, 30)

-- PLAYER LIST FOR BRINGING
local BringPlayerList = Instance.new("ScrollingFrame")
BringPlayerList.Parent = BringPlayerTab
BringPlayerList.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
BringPlayerList.BorderColor3 = Color3.fromRGB(0, 255, 255)
BringPlayerList.Position = UDim2.new(0.05, 0, 0.1, 0)
BringPlayerList.Size = UDim2.new(0.9, 0, 0, 250)
BringPlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
BringPlayerList.ScrollBarThickness = 5

-- TARGET LABEL
local TargetLabel = Instance.new("TextLabel")
TargetLabel.Parent = BringPlayerTab
TargetLabel.Text = "Target: TIDAK ADA"
TargetLabel.Font = Enum.Font.SciFi
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.TextSize = 14
TargetLabel.BackgroundTransparency = 1
TargetLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
TargetLabel.Size = UDim2.new(0.9, 0, 0, 30)

-- BRING TOGGLE
local BringPlayerToggle = Instance.new("TextButton")
BringPlayerToggle.Parent = BringPlayerTab
BringPlayerToggle.Text = "👥 TARIK PLAYER: OFF"
BringPlayerToggle.Font = Enum.Font.SciFi
BringPlayerToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
BringPlayerToggle.TextSize = 16
BringPlayerToggle.Position = UDim2.new(0.05, 0, 0.65, 0)
BringPlayerToggle.Size = UDim2.new(0.9, 0, 0, 45)
BringPlayerToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringPlayerToggle.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- BRING SPEED
local BringSpeedBox = Instance.new("TextBox")
BringSpeedBox.Parent = BringPlayerTab
BringSpeedBox.Text = "50"
BringSpeedBox.Font = Enum.Font.SciFi
BringSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BringSpeedBox.TextSize = 14
BringSpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BringSpeedBox.BorderColor3 = Color3.fromRGB(0, 255, 255)
BringSpeedBox.Position = UDim2.new(0.05, 0, 0.75, 0)
BringSpeedBox.Size = UDim2.new(0.9, 0, 0, 35)
BringSpeedBox.PlaceholderText = "Kecepatan tarik (1-100)"

-- ==================== SPAM REMOTE TAB ====================
SpamTab.Name = "SpamRemoteTab"
SpamTab.Parent = TabContents
SpamTab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SpamTab.BorderSizePixel = 0
SpamTab.Size = UDim2.new(1, 0, 1, 0)
SpamTab.ScrollBarThickness = 5
SpamTab.CanvasSize = UDim2.new(0, 0, 0, 500)
SpamTab.Visible = false

local SpamTitle = Instance.new("TextLabel")
SpamTitle.Parent = SpamTab
SpamTitle.Text = "💥 SPAM REMOTE"
SpamTitle.Font = Enum.Font.SciFi
SpamTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
SpamTitle.TextSize = 18
SpamTitle.BackgroundTransparency = 1
SpamTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
SpamTitle.Size = UDim2.new(0.9, 0, 0, 30)

-- SCAN BUTTON
local ScanBtn = Instance.new("TextButton")
ScanBtn.Parent = SpamTab
ScanBtn.Text = "🔍 SCAN BACKDOOR"
ScanBtn.Font = Enum.Font.SciFi
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 16
ScanBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 45)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ScanBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- STATUS
local StatusFrame = Instance.new("Frame")
StatusFrame.Parent = SpamTab
StatusFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StatusFrame.BorderSizePixel = 0
StatusFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
StatusFrame.Size = UDim2.new(0.1, 0, 0, 20)

local StatusText = Instance.new("TextLabel")
StatusText.Parent = SpamTab
StatusText.Text = "STATUS: NOT READY"
StatusText.Font = Enum.Font.SciFi
StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusText.TextSize = 14
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0.2, 0, 0.25, 0)
StatusText.Size = UDim2.new(0.75, 0, 0, 20)

-- SPAM INTENSITY
local IntensityBox = Instance.new("TextBox")
IntensityBox.Parent = SpamTab
IntensityBox.Text = "100"
IntensityBox.Font = Enum.Font.SciFi
IntensityBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IntensityBox.TextSize = 14
IntensityBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
IntensityBox.BorderColor3 = Color3.fromRGB(0, 255, 255)
IntensityBox.Position = UDim2.new(0.05, 0, 0.35, 0)
IntensityBox.Size = UDim2.new(0.9, 0, 0, 35)
IntensityBox.PlaceholderText = "Intensitas spam (1-1000)"

-- START/STOP BUTTONS
local StartSpamBtn = Instance.new("TextButton")
StartSpamBtn.Parent = SpamTab
StartSpamBtn.Text = "🔥 START SPAM"
StartSpamBtn.Font = Enum.Font.SciFi
StartSpamBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
StartSpamBtn.TextSize = 16
StartSpamBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
StartSpamBtn.Size = UDim2.new(0.9, 0, 0, 45)
StartSpamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StartSpamBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)

local StopSpamBtn = Instance.new("TextButton")
StopSpamBtn.Parent = SpamTab
StopSpamBtn.Text = "⏹️ STOP SPAM"
StopSpamBtn.Font = Enum.Font.SciFi
StopSpamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopSpamBtn.TextSize = 14
StopSpamBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
StopSpamBtn.Size = UDim2.new(0.9, 0, 0, 40)
StopSpamBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StopSpamBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)

-- ==================== FUNCTIONS ====================

-- FLY FUNCTIONS
local function updateFly()
    if flyEnabled then
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local humanoidRootPart = Player.Character.HumanoidRootPart
        
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.P = 1250
            bodyVelocity.Parent = humanoidRootPart
        end
        
        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
            bodyGyro.P = 3000
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            bodyGyro.Parent = humanoidRootPart
        end
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not bodyVelocity or not bodyGyro then
                return
            end
            
            local camera = workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            local upVector = Vector3.new(0, 1, 0)
            
            local velocity = Vector3.new(0, 0, 0)
            
            -- Joystick Controls
            if joystickActive then
                local framePos = JoystickBackground.AbsolutePosition
                local frameSize = JoystickBackground.AbsoluteSize
                local centerX = framePos.X + frameSize.X/2
                local centerY = framePos.Y + frameSize.Y/2
                
                local joyX = (joystickCurrentPos.X - centerX) / joystickRadius
                local joyY = (joystickCurrentPos.Y - centerY) / joystickRadius
                
                joyX = math.clamp(joyX, -1, 1)
                joyY = math.clamp(joyY, -1, 1)
                
                -- Forward/Backward
                if joyY < -0.1 then
                    velocity = velocity + (lookVector * flySpeed * math.abs(joyY))
                elseif joyY > 0.1 then
                    velocity = velocity - (lookVector * flySpeed * math.abs(joyY))
                end
                
                -- Left/Right
                if joyX < -0.1 then
                    velocity = velocity - (rightVector * flySpeed * math.abs(joyX))
                elseif joyX > 0.1 then
                    velocity = velocity + (rightVector * flySpeed * math.abs(joyX))
                end
            end
            
            -- Altitude Controls
            if altitudeUp then
                velocity = velocity + (upVector * flySpeed * 0.7)
            elseif altitudeDown then
                velocity = velocity - (upVector * flySpeed * 0.7)
            end
            
            bodyVelocity.Velocity = velocity
            bodyGyro.CFrame = camera.CFrame
            
            -- No Clip
            if NoClipToggle.Text:find("ON") then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
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
        
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        -- Reset collision
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        JoystickKnob.Position = UDim2.new(0.425, 0, 0.425, 0)
    end
end

-- JOYSTICK TOUCH CONTROLS
JoystickBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
        joystickStartPos = Vector2.new(
            JoystickBackground.AbsolutePosition.X + JoystickBackground.AbsoluteSize.X/2,
            JoystickBackground.AbsolutePosition.Y + JoystickBackground.AbsoluteSize.Y/2
        )
        joystickCurrentPos = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

JoystickBackground.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and joystickActive then
        joystickCurrentPos = Vector2.new(input.Position.X, input.Position.Y)
        
        -- Update visual
        local framePos = JoystickBackground.AbsolutePosition
        local frameSize = JoystickBackground.AbsoluteSize
        local centerX = framePos.X + frameSize.X/2
        local centerY = framePos.Y + frameSize.Y/2
        
        local deltaX = joystickCurrentPos.X - centerX
        local deltaY = joystickCurrentPos.Y - centerY
        local distance = math.sqrt(deltaX^2 + deltaY^2)
        
        if distance > joystickRadius then
            deltaX = deltaX * (joystickRadius / distance)
            deltaY = deltaY * (joystickRadius / distance)
        end
        
        local newX = (deltaX / frameSize.X) + 0.425
        local newY = (deltaY / frameSize.Y) + 0.425
        
        JoystickKnob.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

JoystickBackground.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = false
        local tween = TweenService:Create(
            JoystickKnob,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.425, 0, 0.425, 0)}
        )
        tween:Play()
    end
end)

-- ALTITUDE BUTTONS
UpButton.MouseButton1Down:Connect(function()
    altitudeUp = true
    UpButton.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
end)

UpButton.MouseButton1Up:Connect(function()
    altitudeUp = false
    UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
end)

DownButton.MouseButton1Down:Connect(function()
    altitudeDown = true
    DownButton.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
end)

DownButton.MouseButton1Up:Connect(function()
    altitudeDown = false
    DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
end)

-- FLY TOGGLE
FlyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        FlyToggle.Text = "🚀 FLY MODE: ON"
        FlyToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        if not Player.Character then Player.CharacterAdded:Wait() end
        if not Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character:WaitForChild("HumanoidRootPart")
        end
        updateFly()
    else
        FlyToggle.Text = "🚀 FLY MODE: OFF"
        FlyToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
        updateFly()
        altitudeUp = false
        altitudeDown = false
        UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end
end)

-- SPEED CONTROL
SpeedBox.FocusLost:Connect(function()
    local speed = tonumber(SpeedBox.Text)
    if speed and speed >= 1 and speed <= 200 then
        flySpeed = speed
        SpeedLabel.Text = "KE CEPATAN: " .. speed
    else
        SpeedBox.Text = flySpeed
    end
end)

-- NO CLIP TOGGLE
NoClipToggle.MouseButton1Click:Connect(function()
    if NoClipToggle.Text:find("ON") then
        NoClipToggle.Text = "🔓 NO CLIP: OFF"
        NoClipToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        NoClipToggle.Text = "🔓 NO CLIP: ON"
        NoClipToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
end)

-- PLAYER LIST FUNCTIONS
local function updateGotoPlayerList()
    PlayerListFrame:ClearAllChildren()
    local yOffset = 5
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local btn = Instance.new("TextButton")
            btn.Parent = PlayerListFrame
            btn.Text = player.Name
            btn.Font = Enum.Font.SciFi
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.TextSize = 12
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            btn.BorderSizePixel = 0
            btn.Position = UDim2.new(0.05, 0, 0, yOffset)
            btn.Size = UDim2.new(0.9, 0, 0, 30)
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                SelectedLabel.Text = "Dipilih: " .. player.Name
            end)
            
            yOffset = yOffset + 35
        end
    end
    
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

local function updateBringPlayerList()
    BringPlayerList:ClearAllChildren()
    local yOffset = 5
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local btn = Instance.new("TextButton")
            btn.Parent = BringPlayerList
            btn.Text = player.Name
            btn.Font = Enum.Font.SciFi
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.TextSize = 12
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            btn.BorderSizePixel = 0
            btn.Position = UDim2.new(0.05, 0, 0, yOffset)
            btn.Size = UDim2.new(0.9, 0, 0, 30)
            
            btn.MouseButton1Click:Connect(function()
                selectedTargetPlayer = player
                TargetLabel.Text = "Target: " .. player.Name
            end)
            
            yOffset = yOffset + 35
        end
    end
    
    BringPlayerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- GOTO PLAYER FUNCTIONS
RefreshBtn.MouseButton1Click:Connect(function()
    updateGotoPlayerList()
end)

GotoButton.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target then
            Player.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame
            SelectedLabel.Text = "Berhasil teleport ke: " .. selectedPlayer.Name
        end
    end
end)

-- BRING PART FUNCTIONS
BringPartToggle.MouseButton1Click:Connect(function()
    bringingParts = not bringingParts
    
    if bringingParts then
        BringPartToggle.Text = "🧲 MULAI TARIK PART: ON"
        BringPartToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        spawn(function()
            local radius = tonumber(RadiusBox.Text) or 10
            local unlock = UnlockToggle.Text:find("ON")
            local root = Player.Character:WaitForChild("HumanoidRootPart")
            local parts = Workspace:GetDescendants()
            local partCount = 0
            
            for _, part in pairs(parts) do
                if bringingParts and part:IsA("BasePart") and part ~= root then
                    partCount = partCount + 1
                    
                    if unlock then
                        pcall(function()
                            part.Locked = false
                            local weld = part:FindFirstChildOfClass("Weld")
                            if weld then weld:Destroy() end
                        end)
                    end
                    
                    local angle = partCount * (360 / math.max(1, partCount))
                    local offset = Vector3.new(
                        math.cos(math.rad(angle)) * radius,
                        0,
                        math.sin(math.rad(angle)) * radius
                    )
                    
                    local targetPos = root.Position + offset
                    
                    spawn(function()
                        for i = 1, 50 do
                            if not bringingParts then break end
                            pcall(function()
                                part.Velocity = (targetPos - part.Position).Unit * 100
                            end)
                            wait(0.02)
                        end
                    end)
                end
            end
            
            PartCounterLabel.Text = "PART DITEMUKAN: " .. partCount
        end)
    else
        BringPartToggle.Text = "🧲 MULAI TARIK PART: OFF"
        BringPartToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

UnlockToggle.MouseButton1Click:Connect(function()
    if UnlockToggle.Text:find("OFF") then
        UnlockToggle.Text = "🔓 BUKA PART TERKUNCI: ON"
        UnlockToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        UnlockToggle.Text = "🔓 BUKA PART TERKUNCI: OFF"
        UnlockToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- BRING PLAYER FUNCTIONS
BringPlayerToggle.MouseButton1Click:Connect(function()
    bringingPlayers = not bringingPlayers
    
    if bringingPlayers then
        BringPlayerToggle.Text = "👥 TARIK PLAYER: ON"
        BringPlayerToggle.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        spawn(function()
            while bringingPlayers and selectedTargetPlayer do
                local speed = tonumber(BringSpeedBox.Text) or 50
                local target = selectedTargetPlayer.Character
                
                if target and target:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.HumanoidRootPart
                    local myRoot = Player.Character:WaitForChild("HumanoidRootPart")
                    
                    targetRoot.Velocity = (myRoot.Position - targetRoot.Position).Unit * speed
                end
                wait(0.1)
            end
        end)
    else
        BringPlayerToggle.Text = "👥 TARIK PLAYER: OFF"
        BringPlayerToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- SPAM REMOTE FUNCTIONS
local spamConnection
local function scanForBackdoors()
    StatusText.Text = "STATUS: SCANNING..."
    StatusFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    
    local found = false
    local locations = {ReplicatedStorage, Workspace, game:GetService("Lighting")}
    
    for _, location in pairs(locations) do
        pcall(function()
            for _, obj in pairs(location:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    found = true
                    currentRemoteSpam = obj
                    break
                end
            end
        end)
        if found then break end
    end
    
    if found then
        StatusText.Text = "STATUS: READY"
        StatusFrame.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        StatusText.Text = "STATUS: NOT READY"
        StatusFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end

local function startSpam()
    if not currentRemoteSpam then return end
    
    local intensity = tonumber(IntensityBox.Text) or 100
    local delay = 1 / intensity
    
    spamConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if currentRemoteSpam:IsA("RemoteEvent") then
                currentRemoteSpam:FireServer()
            elseif currentRemoteSpam:IsA("RemoteFunction") then
                currentRemoteSpam:InvokeServer()
            end
        end)
    end)
    
    StatusText.Text = "STATUS: SPAMMING..."
    StatusFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end

ScanBtn.MouseButton1Click:Connect(scanForBackdoors)
StartSpamBtn.MouseButton1Click:Connect(startSpam)

StopSpamBtn.MouseButton1Click:Connect(function()
    if spamConnection then
        spamConnection:Disconnect()
        spamConnection = nil
    end
    StatusText.Text = "STATUS: STOPPED"
    StatusFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
end)

-- ==================== TAB SYSTEM ====================
for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabButtons
    TabButton.Text = tabName
    TabButton.Font = Enum.Font.SciFi
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 60)
    TabButton.Size = UDim2.new(1, 0, 0, 60)
    
    TabButton.MouseButton1Click:Connect(function()
        FlyTab.Visible = false
        GotoTab.Visible = false
        BringPartTab.Visible = false
        BringPlayerTab.Visible = false
        SpamTab.Visible = false
        
        if tabName == "Fly" then
            FlyTab.Visible = true
        elseif tabName == "Goto Player" then
            GotoTab.Visible = true
            updateGotoPlayerList()
        elseif tabName == "Bring Part" then
            BringPartTab.Visible = true
        elseif tabName == "Bring Player" then
            BringPlayerTab.Visible = true
            updateBringPlayerList()
        elseif tabName == "Spam Remote" then
            SpamTab.Visible = true
        end
    end)
end

-- INITIALIZE
updateGotoPlayerList()
updateBringPlayerList()

-- CLEANUP
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == Player then
        if flyConnection then flyConnection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if spamConnection then spamConnection:Disconnect() end
        RownnGui:Destroy()
    end
end)

-- SUCCESS MESSAGE
print("==========================================")
print("ROWNN GUI v2.0 LOADED SUCCESSFULLY!")
print("Created by: zamxs | DARK-GPT Premium")
print("Features:")
print("1. Fly System (Mobile Controls)")
print("2. Goto Player Teleport")
print("3. Bring All Parts")
print("4. Bring Player")
print("5. Remote Spam")
print("==========================================")