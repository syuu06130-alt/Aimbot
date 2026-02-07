-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

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
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Corner Radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar (Header)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Text = "Dark UI System"
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button with Animation
local MinButton = Instance.new("TextButton")
MinButton.Name = "MinimizeButton"
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -35, 0.5, -15)
MinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinButton.BorderSizePixel = 0
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 18
MinButton.Parent = TitleBar

local MinButtonCorner = Instance.new("UICorner")
MinButtonCorner.CornerRadius = UDim.new(0, 6)
MinButtonCorner.Parent = MinButton

-- 3. Scroll Content
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Helper Function to Create Sections
local function createSection(name, order, isHorizontal)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = isHorizontal and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
    if isHorizontal then
        Section.Size = UDim2.new(1, 0, 0, 180)
    end
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Section.LayoutOrder = order
    Section.Parent = ScrollingFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Text = name
    SectionTitle.Size = UDim2.new(1, -10, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = Color3.fromRGB(100, 150, 255)
    SectionTitle.Font = Enum.Font.GothamBlack
    SectionTitle.TextSize = 14
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local Container = Instance.new(isHorizontal and "ScrollingFrame" or "Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -10, 0, isHorizontal and 130 or 0)
    Container.Position = UDim2.new(0, 5, 0, 40)
    Container.BackgroundTransparency = 1
    
    if isHorizontal then
        Container.AutomaticSize = Enum.AutomaticSize.None
        Container.ScrollBarThickness = 4
        Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        Container.CanvasSize = UDim2.new(2, 0, 0, 0)
    else
        Container.AutomaticSize = Enum.AutomaticSize.Y
    end
    
    Container.Parent = Section
    
    if isHorizontal then
        local HorizontalLayout = Instance.new("UIListLayout")
        HorizontalLayout.Padding = UDim.new(0, 10)
        HorizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
        HorizontalLayout.FillDirection = Enum.FillDirection.Horizontal
        HorizontalLayout.Parent = Container
        
        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 5)
        Padding.PaddingRight = UDim.new(0, 5)
        Padding.Parent = Container
    else
        local VerticalLayout = Instance.new("UIListLayout")
        VerticalLayout.Padding = UDim.new(0, 8)
        VerticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
        VerticalLayout.Parent = Container
        
        local Padding = Instance.new("UIPadding")
        Padding.PaddingBottom = UDim.new(0, 10)
        Padding.Parent = Container
    end
    
    return Container
end

-- Toggles State
local toggles = {
    autoAimBot = false,
    autoAimPlayer = false,
    wallCheck = true,
    esp = false,
    showFOV = false,
    smoothAiming = false,
    debugInfo = false
}

-- FOV Settings
local fovRadius = 100
local smoothFactor = 5

-- Helper Function to Create Toggle
local function createToggle(parent, text, toggleKey, isHorizontal)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = isHorizontal and UDim2.new(0, 150, 1, -10) or UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = parent:GetChildren() and #parent:GetChildren() or 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(0.7, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Text = ""
    Button.Size = UDim2.new(0, 22, 0, 22)
    Button.Position = UDim2.new(1, -27, 0.5, -11)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.BorderSizePixel = 0
    Button.Parent = ToggleFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Button
    
    -- Initial state
    if toggles[toggleKey] then
        Button.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    end
    
    -- Interaction with animation
    Button.MouseButton1Click:Connect(function()
        toggles[toggleKey] = not toggles[toggleKey]
        
        -- Button press animation
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -25, 0.5, -9)}):Play()
        task.wait(0.1)
        
        if toggles[toggleKey] then
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 180, 80),
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -27, 0.5, -11)
            }):Play()
        else
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -27, 0.5, -11)
            }):Play()
        end
        
        -- Frame highlight animation
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        task.wait(0.2)
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        
        print(text .. " Toggled: " .. tostring(toggles[toggleKey]))
    end)
    
    -- Hover effects
    ToggleFrame.MouseEnter:Connect(function()
        if not toggles[toggleKey] then
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        if not toggles[toggleKey] then
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    
    return ToggleFrame
end

-- Slider creation function for settings
local function createSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, 0, 0, 4)
    SliderTrack.Position = UDim2.new(0, 0, 0, 25)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 2)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 2)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderTrack
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = tostring(defaultVal)
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Position = UDim2.new(1, -40, 0, 25)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local isDragging = false
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local value = math.floor(minVal + (maxVal - minVal) * relativeX)
        
        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        SliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
        ValueLabel.Text = tostring(value)
        
        callback(value)
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        isDragging = true
        TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)}):Play()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isDragging then
                isDragging = false
                TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play()
            end
        end
    end)
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
            TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)}):Play()
            isDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            updateSlider(input)
        end
    end)
    
    -- Touch support for mobile
    SliderButton.TouchLongPress:Connect(function()
        isDragging = true
        TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)}):Play()
    end)
    
    return SliderFrame
end

-- ITEM 1: Main Features
local MainContainer = createSection("メイン機能", 1, false)
createToggle(MainContainer, "Auto Aim (Bot Only)", "autoAimBot", false)
createToggle(MainContainer, "Auto Aim (Player Only)", "autoAimPlayer", false)
createToggle(MainContainer, "Wall Check (壁判定)", "wallCheck", false)
createToggle(MainContainer, "ESP (Visuals)", "esp", false)

-- ITEM 2: Settings (Horizontal Scroll)
local SettingsContainer = createSection("設定機能", 2, true)
createToggle(SettingsContainer, "Show FOV Circle", "showFOV", true)
createToggle(SettingsContainer, "Smooth Aiming", "smoothAiming", true)
createToggle(SettingsContainer, "Debug Info", "debugInfo", true)

-- Add sliders to settings
createSlider(SettingsContainer, "FOV Radius", 50, 300, 100, function(value)
    fovRadius = value
end)

createSlider(SettingsContainer, "Smooth Factor", 1, 10, 5, function(value)
    smoothFactor = value
end)

-- 4. Unique Drag Logic with Animation
local dragging = false
local dragInput, dragStart, startPos
local isDraggingAnim = false

local function update(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
    
    -- Smooth Drag using Tween
    local dragTweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, dragTweenInfo, {Position = targetPos}):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingAnim then return end
        isDraggingAnim = true
        
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        -- "Lift" Animation with scaling and transparency
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 330, 0, 465),
            Position = startPos - UDim2.new(0, 5, 0, 7),
            BackgroundTransparency = 0.1
        }):Play()
        
        TweenService:Create(Shadow, TweenInfo.new(0.2), {
            ImageTransparency = 0.6
        }):Play()
        
        TweenService:Create(TitleBar, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        }):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                isDraggingAnim = false
                
                -- "Drop" Animation with bounce effect
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 320, 0, 450),
                    Position = MainFrame.Position + UDim2.new(0, 5, 0, 7),
                    BackgroundTransparency = 0
                }):Play()
                
                TweenService:Create(Shadow, TweenInfo.new(0.3), {
                    ImageTransparency = 0.8
                }):Play()
                
                TweenService:Create(TitleBar, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
    if input == dragInput and dragging and isDraggingAnim then
        update(input)
    end
end)

-- 5. Minimize Logic with Animation
local minimized = false
local originalSize = MainFrame.Size

MinButton.MouseButton1Click:Connect(function()
    if minimized then
        -- Restore with animation
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize
        }):Play()
        
        task.wait(0.2)
        ScrollingFrame.Visible = true
        MinButton.Text = "-"
        
        -- Button animation
        TweenService:Create(MinButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(0, 35, 0, 35)
        }):Play()
        task.wait(0.1)
        TweenService:Create(MinButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 30, 0, 30)
        }):Play()
    else
        -- Minimize with animation
        if MainFrame.Size.Y.Offset > 50 then 
            originalSize = MainFrame.Size 
        end
        
        ScrollingFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 35)
        }):Play()
        
        MinButton.Text = "+"
        
        -- Button animation
        TweenService:Create(MinButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Size = UDim2.new(0, 35, 0, 35)
        }):Play()
        task.wait(0.1)
        TweenService:Create(MinButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 30, 0, 30)
        }):Play()
    end
    
    minimized = not minimized
end)

-- Hover effects for minimize button
MinButton.MouseEnter:Connect(function()
    if not minimized then
        TweenService:Create(MinButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end
end)

MinButton.MouseLeave:Connect(function()
    if not minimized then
        TweenService:Create(MinButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end
end)

-- Adjust ScrollingFrame Size
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- FOV Circle for mobile compatibility (using a Frame instead of Drawing)
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
FOVCircle.Position = UDim2.new(0.5, -fovRadius, 0.5, -fovRadius)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

local CircleImage = Instance.new("ImageLabel")
CircleImage.Size = UDim2.new(1, 0, 1, 0)
CircleImage.BackgroundTransparency = 1
CircleImage.Image = "rbxassetid://9753762467" -- Circle image
CircleImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
CircleImage.ImageTransparency = 0.7
CircleImage.Parent = FOVCircle

-- ESP Implementation
local espHighlights = {}

local function createESP(character)
    if espHighlights[character] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
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
        for character, highlight in pairs(espHighlights) do
            highlight:Destroy()
        end
        espHighlights = {}
        return
    end
    
    -- Update ESP for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player.Character)
        end
    end
end

-- Player added/removed connections
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

-- Wall check function
local function isVisible(targetPart)
    if not toggles.wallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    if result then
        local targetModel = targetPart:FindFirstAncestorOfClass("Model")
        local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        return targetModel == hitModel
    end
    
    return true
end

-- Aimbot Logic
local function getClosestTarget(isBot)
    local closest = nil
    local minDist = fovRadius
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
        -- Check for bots in workspace
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                local humanoid = obj.Humanoid
                -- Simple bot detection (can be improved)
                if humanoid.DisplayName == "Bot" or obj.Name:lower():find("bot") then
                    checkTarget(obj)
                end
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

-- Mobile touch support
local touchStartPos, touchStartTime

UserInputService.TouchStarted:Connect(function(touch, processed)
    if processed then return end
    
    touchStartPos = touch.Position
    touchStartTime = tick()
end)

UserInputService.TouchEnded:Connect(function(touch, processed)
    if processed then return end
    
    if touchStartPos and tick() - touchStartTime < 0.5 then
        -- Check if touch is on a toggle button
        local touchPos = touch.Position
        for _, toggle in pairs(MainContainer:GetDescendants()) do
            if toggle:IsA("TextButton") and toggle:IsDescendantOf(ToggleFrame) then
                local absPos = toggle.AbsolutePosition
                local absSize = toggle.AbsoluteSize
                
                if touchPos.X >= absPos.X and touchPos.X <= absPos.X + absSize.X and
                   touchPos.Y >= absPos.Y and touchPos.Y <= absPos.Y + absSize.Y then
                    toggle:Fire("MouseButton1Click")
                end
            end
        end
    end
end)

-- Main update loop
RunService.RenderStepped:Connect(function(deltaTime)
    -- Update FOV Circle
    if toggles.showFOV then
        FOVCircle.Visible = true
        FOVCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
        
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = UDim2.new(0, mousePos.X - fovRadius, 0, mousePos.Y - fovRadius)
    else
        FOVCircle.Visible = false
    end
    
    -- Update ESP
    updateESP()
    
    -- Aimbot logic
    local target = nil
    if toggles.autoAimBot then
        target = getClosestTarget(true)
    elseif toggles.autoAimPlayer then
        target = getClosestTarget(false)
    end
    
    if target and (toggles.autoAimBot or toggles.autoAimPlayer) then
        local targetPos = Camera:WorldToViewportPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        local delta = Vector2.new(targetPos.X - mousePos.X, targetPos.Y - mousePos.Y)
        
        if toggles.smoothAiming then
            delta = delta / smoothFactor
        end
        
        -- Note: Direct mouse movement is restricted in Roblox
        -- This is for demonstration only
        if toggles.debugInfo then
            print("Target locked: " .. target.Parent.Name .. " | Distance: " .. delta.Magnitude)
        end
    end
end)

print("Dark UI System Loaded Successfully!")
