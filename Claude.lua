-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Player & Camera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Configuration
local Config = {
    FOVRadius = 150,
    SmoothFactor = 5,
    AimPart = "Head",
    UpdateRate = 0.016, -- 60 FPS
}

-- Toggles State
local Toggles = {
    autoAimBot = false,
    autoAimPlayer = false,
    wallCheck = true,
    esp = false,
    showFOV = false,
    smoothAiming = false,
    debugInfo = false
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedAimbotUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Bar Bottom Filler
local TitleFiller = Instance.new("Frame")
TitleFiller.Size = UDim2.new(1, 0, 0, 12)
TitleFiller.Position = UDim2.new(0, 0, 1, -12)
TitleFiller.BackgroundColor3 = TitleBar.BackgroundColor3
TitleFiller.BorderSizePixel = 0
TitleFiller.Parent = TitleBar

-- Accent Line
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Text = "⚡ Advanced Aimbot System"
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Status Indicator
local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 5, 0.5, -4)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = TitleBar

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusDot

-- Minimize Button
local MinButton = Instance.new("TextButton")
MinButton.Name = "MinimizeButton"
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -35, 0, 2.5)
MinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MinButton.Text = "−"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 16
MinButton.AutoButtonColor = false
MinButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

-- Scroll Container
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Helper: Create Section
local function createSection(name, order)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    Section.LayoutOrder = order
    Section.BorderSizePixel = 0
    Section.Parent = ScrollingFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Text = "📋 " .. name
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = Color3.fromRGB(120, 170, 255)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 14
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 35)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = Section
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 40)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Section
    
    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Padding = UDim.new(0, 8)
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Parent = Container
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.Parent = Container
    
    return Container
end

-- Helper: Create Toggle
local function createToggle(parent, text, toggleKey, icon)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Text = (icon or "•") .. " " .. text
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBack = Instance.new("Frame")
    ToggleBack.Size = UDim2.new(0, 44, 0, 22)
    ToggleBack.Position = UDim2.new(1, -50, 0.5, -11)
    ToggleBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleBack.BorderSizePixel = 0
    ToggleBack.Parent = ToggleFrame
    
    local ToggleBackCorner = Instance.new("UICorner")
    ToggleBackCorner.CornerRadius = UDim.new(1, 0)
    ToggleBackCorner.Parent = ToggleBack
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Size = UDim2.new(0, 18, 0, 18)
    ToggleButton.Position = UDim2.new(0, 2, 0.5, -9)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleBack
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton
    
    local ClickDetector = Instance.new("TextButton")
    ClickDetector.Size = UDim2.new(1, 0, 1, 0)
    ClickDetector.BackgroundTransparency = 1
    ClickDetector.Text = ""
    ClickDetector.Parent = ToggleFrame
    
    -- Initial state
    if Toggles[toggleKey] then
        ToggleBack.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        ToggleButton.Position = UDim2.new(1, -20, 0.5, -9)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    ClickDetector.MouseButton1Click:Connect(function()
        Toggles[toggleKey] = not Toggles[toggleKey]
        
        local targetBackColor = Toggles[toggleKey] and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(50, 50, 60)
        local targetButtonPos = Toggles[toggleKey] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local targetButtonColor = Toggles[toggleKey] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        
        TweenService:Create(ToggleBack, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            BackgroundColor3 = targetBackColor
        }):Play()
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = targetButtonPos,
            BackgroundColor3 = targetButtonColor
        }):Play()
        
        -- Feedback animation
        local pulse = TweenService:Create(ToggleFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        })
        pulse:Play()
        pulse.Completed:Wait()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        }):Play()
    end)
    
    -- Hover effect
    ClickDetector.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        }):Play()
    end)
    
    ClickDetector.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        }):Play()
    end)
end

-- Create Sections
local MainContainer = createSection("メイン機能", 1)
createToggle(MainContainer, "Auto Aim (Bot)", "autoAimBot", "🤖")
createToggle(MainContainer, "Auto Aim (Player)", "autoAimPlayer", "👤")
createToggle(MainContainer, "Wall Check", "wallCheck", "🧱")
createToggle(MainContainer, "ESP Visuals", "esp", "👁️")

local SettingsContainer = createSection("設定機能", 2)
createToggle(SettingsContainer, "Show FOV Circle", "showFOV", "⭕")
createToggle(SettingsContainer, "Smooth Aiming", "smoothAiming", "〰️")
createToggle(SettingsContainer, "Debug Info", "debugInfo", "🐛")

-- Drag Logic
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local function update(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
    TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Sine), {
        Position = targetPos
    }):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 330, 0, 430)
        }):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.15), {ImageTransparency = 0.4}):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {
                    Size = UDim2.new(0, 320, 0, 420)
                }):Play()
                TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Minimize Logic
local minimized = false
local originalSize = MainFrame.Size

MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        ScrollingFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 320, 0, 35)
        }):Play()
        TweenService:Create(MinButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Rotation = 180
        }):Play()
        MinButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize
        }):Play()
        TweenService:Create(MinButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Rotation = 0
        }):Play()
        task.wait(0.25)
        ScrollingFrame.Visible = true
        MinButton.Text = "−"
    end
end)

-- Button Hover
MinButton.MouseEnter:Connect(function()
    TweenService:Create(MinButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    }):Play()
end)

MinButton.MouseLeave:Connect(function()
    TweenService:Create(MinButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    }):Play()
end)

-- Auto-resize canvas
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- ESP System
local espCache = {}

local function createESP(character)
    if espCache[character] or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.2
    highlight.Parent = character
    espCache[character] = highlight
end

local function removeESP(character)
    if espCache[character] then
        espCache[character]:Destroy()
        espCache[character] = nil
    end
end

local function updateESP()
    if not Toggles.esp then
        for char, highlight in pairs(espCache) do
            highlight:Destroy()
        end
        espCache = {}
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player.Character)
        end
    end
    
    if workspace:FindFirstChild("Bots") then
        for _, bot in ipairs(workspace.Bots:GetChildren()) do
            if bot:IsA("Model") and bot:FindFirstChild("Humanoid") then
                createESP(bot)
            end
        end
    end
end

-- FOV Circle (Drawing API)
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = Config.FOVRadius
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(100, 150, 255)
fovCircle.Transparency = 0.7
fovCircle.NumSides = 64
fovCircle.Filled = false

-- Aimbot Functions
local function isVisible(targetPart)
    if not Toggles.wallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, rayParams)
    
    if not result then return true end
    return result.Instance:IsDescendantOf(targetPart.Parent)
end

local function getClosestTarget(targetBots)
    local closest = nil
    local minDist = Config.FOVRadius
    local mousePos = UserInputService:GetMouseLocation()
    
    local function checkTarget(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        if character.Humanoid.Health <= 0 then return end
        
        local targetPart = character:FindFirstChild(Config.AimPart)
        if not targetPart then return end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then return end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if dist < minDist and isVisible(targetPart) then
            minDist = dist
            closest = targetPart
        end
    end
    
    if targetBots and workspace:FindFirstChild("Bots") then
        for _, bot in ipairs(workspace.Bots:GetChildren()) do
            checkTarget(bot)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                checkTarget(player.Character)
            end
        end
    end
    
    return closest
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if Toggles.showFOV then
        fovCircle.Visible = true
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Radius = Config.FOVRadius
    else
        fovCircle.Visible = false
    end
    
    -- ESP Update
    if Toggles.esp then
        updateESP()
    end
    
    -- Aimbot
    local target = nil
    if Toggles.autoAimBot then
        target = getClosestTarget(true)
    elseif Toggles.autoAimPlayer then
        target = getClosestTarget(false)
    end
    
    if target then
        local targetScreenPos = Camera:WorldToViewportPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        local delta = Vector2.new(targetScreenPos.X - mousePos.X, targetScreenPos.Y - mousePos.Y)
        
        if Toggles.smoothAiming then
            delta = delta / Config.SmoothFactor
        end
        
        if mousemoverel then
            mousemoverel(delta.X, delta.Y)
        end
        
        if Toggles.debugInfo then
            print("[Aimbot] Targeting: " .. target.Parent.Name .. " | Distance: " .. math.floor(delta.Magnitude) .. "px")
        end
    end
end)

-- Cleanup on player death
LocalPlayer.CharacterAdded:Connect(function()
    for char, highlight in pairs(espCache) do
        highlight:Destroy()
    end
    espCache = {}
end)

print("✅ Advanced Aimbot UI Loaded Successfully!")
