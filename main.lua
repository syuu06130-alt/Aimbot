-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- 通常のゲームではPlayerGui推奨
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

-- Player & GUI Parent
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomDarkUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- 2. Main Frame (Window)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Deep Black/Gray
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Corner Radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar (Header)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Darker header
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Fix bottom corners of title bar to be sharp (Visual trick)
local TitleFiller = Instance.new("Frame")
TitleFiller.Size = UDim2.new(1, 0, 0, 10)
TitleFiller.Position = UDim2.new(0, 0, 1, -10)
TitleFiller.BackgroundColor3 = TitleBar.BackgroundColor3
TitleFiller.BorderSizePixel = 0
TitleFiller.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Text = "Dark UI System"
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinButton = Instance.new("TextButton")
MinButton.Name = "MinimizeButton"
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -30, 0, 0)
MinButton.BackgroundTransparency = 1
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 18
MinButton.Parent = TitleBar

-- 3. Scroll Content
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Helper Function to Create Sections
local function createSection(name, order)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 0) -- Height determined by content
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Section.LayoutOrder = order
    Section.Parent = ScrollingFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Text = name
    SectionTitle.Size = UDim2.new(1, -10, 0, 25)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = Color3.fromRGB(150, 150, 255) -- Light Blue accent
    SectionTitle.Font = Enum.Font.GothamBlack
    SectionTitle.TextSize = 14
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 0)
    Container.Position = UDim2.new(0, 5, 0, 25)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Section
    
    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Padding = UDim.new(0, 5)
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Parent = Container
    
    -- Padding at bottom
    local Pad = Instance.new("UIPadding")
    Pad.PaddingBottom = UDim.new(0, 5)
    Pad.Parent = Container
    
    return Container
end

-- Toggles State
local toggles = {
    autoAimBot = false,
    autoAimPlayer = false,
    wallCheck = true,  -- Default on
    esp = false,
    showFOV = false,
    smoothAiming = false,
    debugInfo = false
}

-- Helper Function to Create Toggle
local function createToggle(parent, text, toggleKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Text = ""
    Button.Size = UDim2.new(0, 20, 0, 20)
    Button.Position = UDim2.new(1, -25, 0.5, -10)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Parent = ToggleFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Button
    
    -- Interaction
    Button.MouseButton1Click:Connect(function()
        toggles[toggleKey] = not toggles[toggleKey]
        if toggles[toggleKey] then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
        else
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end
        print(text .. " Toggled: " .. tostring(toggles[toggleKey]))
    end)
end

-- ITEM 1: Main Features
local MainContainer = createSection("メイン機能", 1)
createToggle(MainContainer, "Auto Aim (Bot Only)", "autoAimBot")
createToggle(MainContainer, "Auto Aim (Player Only)", "autoAimPlayer")
createToggle(MainContainer, "Wall Check (壁判定)", "wallCheck")
createToggle(MainContainer, "ESP (Visuals)", "esp")

-- ITEM 2: Settings
local SettingsContainer = createSection("設定機能", 2)
createToggle(SettingsContainer, "Show FOV Circle", "showFOV")
createToggle(SettingsContainer, "Smooth Aiming", "smoothAiming")
createToggle(SettingsContainer, "Debug Info", "debugInfo")

-- 4. Unique Drag Logic with Animation
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
    
    -- Smooth Drag using Tween
    local dragTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, dragTweenInfo, {Position = targetPos}):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        -- Start "Lift" Animation (Make it slightly transparent and larger)
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, 310, 0, 410), -- Slightly bigger
            Position = MainFrame.Position - UDim2.new(0, 5, 0, 5) -- Adjust pos to center expansion
        }):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                
                -- End "Drop" Animation (Return to normal)
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(0, 300, 0, 400),
                    Position = MainFrame.Position + UDim2.new(0, 5, 0, 5) -- Revert position fix
                }):Play()
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

-- 5. Minimize Logic
local minimized = false
local originalSize = MainFrame.Size
MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        -- Capture current size before minimizing if not already minimized
        if MainFrame.Size.Y.Offset > 50 then originalSize = MainFrame.Size end
        
        ScrollingFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 300, 0, 30)}):Play()
        MinButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = originalSize}):Play()
        task.wait(0.3)
        ScrollingFrame.Visible = true
        MinButton.Text = "-"
    end
end)

-- Adjust ScrollingFrame Size automatically
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- ESP Implementation
local espHighlights = {}
local function createESP(character)
    if espHighlights[character] then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    espHighlights[character] = highlight
end

local function removeESP(character)
    if espHighlights[character] then
        espHighlights[character]:Destroy()
        espHighlights[character] = nil
    end
end

local function updateESP()
    if not toggles.esp then
        for _, highlight in pairs(espHighlights) do
            highlight:Destroy()
        end
        espHighlights = {}
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player.Character)
        end
    end
    
    -- Assuming bots are in a folder like workspace.Bots
    if workspace:FindFirstChild("Bots") then
        for _, bot in pairs(workspace.Bots:GetChildren()) do
            if bot:IsA("Model") and bot:FindFirstChild("Humanoid") then
                createESP(bot)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if toggles.esp then
            createESP(char)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeESP(player.Character)
    end
end)

-- RunService for ESP update
RunService.Heartbeat:Connect(function()
    if toggles.esp then
        updateESP()
    end
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = 150  -- Adjustable FOV radius
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 0.5
fovCircle.Filled = false

-- Aimbot Logic
local function isVisible(targetPart)
    if not toggles.wallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result and result.Instance:IsDescendantOf(targetPart.Parent) or not result
end

local function getClosestTarget(isBot)
    local closest = nil
    local minDist = fovCircle.Radius
    local mousePos = UserInputService:GetMouseLocation()
    
    local function checkTarget(target)
        if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
            local head = target:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < minDist and isVisible(head) then
                        minDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    
    if isBot then
        -- Assuming bots in workspace.Bots
        if workspace:FindFirstChild("Bots") then
            for _, bot in pairs(workspace.Bots:GetChildren()) do
                checkTarget(bot)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                checkTarget(player.Character)
            end
        end
    end
    
    return closest
end

-- Aimbot Update
RunService.RenderStepped:Connect(function()
    if toggles.showFOV then
        fovCircle.Visible = true
        fovCircle.Position = UserInputService:GetMouseLocation()
    else
        fovCircle.Visible = false
    end
    
    local target = nil
    if toggles.autoAimBot then
        target = getClosestTarget(true)
    elseif toggles.autoAimPlayer then
        target = getClosestTarget(false)
    end
    
    if target then
        local targetPos = Camera:WorldToScreenPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        local delta = Vector2.new(targetPos.X - mousePos.X, targetPos.Y - mousePos.Y)
        
        if toggles.smoothAiming then
            delta = delta / 5  -- Smooth factor
        end
        
        mousemoverel(delta.X, delta.Y)
        
        if toggles.debugInfo then
            print("Aiming at: " .. target.Parent.Name)
        end
    end
end)
