-- Ensure PlayerGui is available
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui for UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FeatureGUI"
screenGui.Parent = playerGui

-- Create Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 250, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Warrior Cats GUI"
titleLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = mainFrame

-- Orbit Button
local orbitButton = Instance.new("TextButton")
orbitButton.Size = UDim2.new(0, 200, 0, 40)
orbitButton.Position = UDim2.new(0, 25, 0, 50)
orbitButton.Text = "Start Orbit"
orbitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
orbitButton.Parent = mainFrame

-- Speed Increase Button
local orbitSpeedUp = Instance.new("TextButton")
orbitSpeedUp.Size = UDim2.new(0, 100, 0, 30)
orbitSpeedUp.Position = UDim2.new(0, 25, 0, 100)
orbitSpeedUp.Text = "Increase Speed"
orbitSpeedUp.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
orbitSpeedUp.Parent = mainFrame

-- Speed Decrease Button
local orbitSpeedDown = Instance.new("TextButton")
orbitSpeedDown.Size = UDim2.new(0, 100, 0, 30)
orbitSpeedDown.Position = UDim2.new(0, 125, 0, 100)
orbitSpeedDown.Text = "Decrease Speed"
orbitSpeedDown.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
orbitSpeedDown.Parent = mainFrame

-- Orbit Variables
local orbiting = false
local orbitSpeed = 0.1
local targetPlayer = nil

-- Find Closest Player
local function getClosestPlayer()
    local character = player.Character
    if not character then return nil end

    local players = game:GetService("Players"):GetPlayers()
    local closest = nil
    local minDist = math.huge

    for _, p in pairs(players) do
        if p ~= player and p.Character and p.Character.PrimaryPart then
            local dist = (character.PrimaryPart.Position - p.Character.PrimaryPart.Position).magnitude
            if dist < minDist then
                minDist = dist
                closest = p
            end
        end
    end
    return closest
end

-- Smooth Orbit Function (Syncs Vertical Position Smoothly)
local function startOrbit()
    if orbiting then return end
    orbiting = true
    targetPlayer = getClosestPlayer()
    if not targetPlayer then return end

    local character = player.Character
    if not character then return end

    -- Play Audio
    local audio = Instance.new("Sound")
    audio.SoundId = "rbxassetid://130102532759473"
    audio.Looped = true
    audio.Parent = character
    audio:Play()

    -- Disable collision
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Orbit Variables
    local angle = 0
    local radius = 5
    local targetHeight = 0

    while orbiting and targetPlayer and targetPlayer.Character do
        if character and targetPlayer.Character then
            local targetPos = targetPlayer.Character.PrimaryPart.Position
            targetHeight = targetPos.Y  -- Get player's height
            angle = angle + orbitSpeed

            -- Ensure smooth vertical transition
            local currentHeight = character.PrimaryPart.Position.Y
            local smoothHeight = currentHeight + (targetHeight - currentHeight) * 0.1  -- Smooth lerp for vertical movement

            -- Orbit around player while matching their height smoothly
            local newPos = Vector3.new(
                targetPos.X + math.sin(angle) * radius, 
                smoothHeight, -- Smoothly sync vertical position
                targetPos.Z + math.cos(angle) * radius
            )
            character:SetPrimaryPartCFrame(CFrame.new(newPos)) 
        end
        wait(0.03)
    end

    -- Restore collision after stopping orbit
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Button Click Functions
orbitButton.MouseButton1Click:Connect(function()
    if orbiting then
        orbiting = false
        orbitButton.Text = "Start Orbit"
    else
        startOrbit()
        orbitButton.Text = "Stop Orbit"
    end
end)

orbitSpeedUp.MouseButton1Click:Connect(function()
    orbitSpeed = orbitSpeed + 0.05
end)

orbitSpeedDown.MouseButton1Click:Connect(function()
    orbitSpeed = orbitSpeed - 0.05
end)
