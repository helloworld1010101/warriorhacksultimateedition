-- GUI Script for Warrior Cats: Ultimate Edition (All features enabled)

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FeatureGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 400)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Parent = screenGui

-- Speed & Jump Boost Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 200, 0, 50)
speedButton.Position = UDim2.new(0, 0, 0, 0)
speedButton.Text = "Speed & Jump Boost"
speedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedButton.Parent = mainFrame

-- Admin Detection Button
local adminButton = Instance.new("TextButton")
adminButton.Size = UDim2.new(0, 200, 0, 50)
adminButton.Position = UDim2.new(0, 0, 0, 60)
adminButton.Text = "Admin Detection"
adminButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
adminButton.Parent = mainFrame

-- No-Clip / Invisible Button
local noClipButton = Instance.new("TextButton")
noClipButton.Size = UDim2.new(0, 200, 0, 50)
noClipButton.Position = UDim2.new(0, 0, 0, 120)
noClipButton.Text = "No-Clip / Invisible"
noClipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noClipButton.Parent = mainFrame

-- Orbit Player Button (with attached .mp3)
local orbitButton = Instance.new("TextButton")
orbitButton.Size = UDim2.new(0, 200, 0, 50)
orbitButton.Position = UDim2.new(0, 0, 0, 180)
orbitButton.Text = "Orbit Player"
orbitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
orbitButton.Parent = mainFrame

-- Features enabled variables
local isNoClipping = false
local orbiting = false
local targetPlayer = nil

-- Functions for features
local function applySpeedBoost()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character:FindFirstChild("Humanoid")
        humanoid.WalkSpeed = 100 -- Speed boost (adjust as needed)
        humanoid.JumpPower = 100 -- Jump boost (adjust as needed)
    end
end

local function detectAdmins()
    -- Example of admin detection (can be expanded with more logic)
    local player = game.Players.LocalPlayer
    local admins = {"Admin1", "Admin2"} -- Replace with actual admin names or roles
    if table.find(admins, player.Name) then
        print(player.Name .. " is an admin!")
    else
        print(player.Name .. " is not an admin.")
    end
end

local function noClip()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Set the character's collision to nil to allow movement through walls
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        isNoClipping = true
    end
end

local function stopNoClip()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Restore collision and movement
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        isNoClipping = false
    end
end

-- Orbit Player Function with Floating Effect and Collision Disabled
local function orbitPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        -- Check if there are any players to orbit
        local otherPlayers = game.Players:GetPlayers()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, otherPlayer in pairs(otherPlayers) do
            if otherPlayer ~= player then
                local otherCharacter = otherPlayer.Character
                if otherCharacter then
                    local distance = (character.PrimaryPart.Position - otherCharacter.PrimaryPart.Position).magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
        
        if closestPlayer then
            targetPlayer = closestPlayer
            orbiting = true
            local audio = Instance.new("Sound")
            audio.SoundId = "rbxassetid://130102532759473"  -- Set audio asset ID
            audio.Parent = character
            audio:Play()

            -- Disable collision for all parts of the character
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- Smooth orbiting logic with floating
            local orbitRadius = 5  -- Orbit distance from the target
            local orbitSpeed = 0.1  -- Speed of the orbit (lower is slower)
            local orbitAngle = 0  -- Initial angle for the orbit
            local floatHeight = 3  -- Height to float above the target

            while orbiting and targetPlayer do
                if character and targetPlayer.Character then
                    local targetPosition = targetPlayer.Character.PrimaryPart.Position
                    orbitAngle = orbitAngle + orbitSpeed
                    
                    -- Calculate the new position with smooth orbit
                    local orbitOffset = Vector3.new(math.sin(orbitAngle) * orbitRadius, floatHeight, math.cos(orbitAngle) * orbitRadius)
                    local newPosition = targetPosition + orbitOffset
                    
                    -- Smoothly move the character to the new position using lerp
                    character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame:Lerp(CFrame.new(newPosition), 0.1))
                end
                wait(0.03) -- Orbit update frequency (adjust for smoothness)
            end

            -- Restore collision when orbiting is stopped
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Button Events
speedButton.MouseButton1Click:Connect(applySpeedBoost)
adminButton.MouseButton1Click:Connect(detectAdmins)
noClipButton.MouseButton1Click:Connect(function()
    if isNoClipping then
        stopNoClip()
    else
        noClip()
    end
end)
orbitButton.MouseButton1Click:Connect(function()
    if orbiting then
        orbiting = false -- Stop orbiting
    else
        orbitPlayer() -- Start orbiting
    end
end)
