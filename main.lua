local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "MyGameFlyMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Open button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.fromOffset(110, 45)
openButton.Position = UDim2.new(0, 15, 0.5, -22)
openButton.Text = "OPEN MENU"
openButton.TextScaled = true
openButton.Parent = gui

-- Main menu
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(230, 230)
menu.Position = UDim2.new(0.5, -115, 0.5, -115)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "FLY / SPEED"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = menu

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -20, 0, 45)
flyButton.Position = UDim2.fromOffset(10, 55)
flyButton.Text = "FLY: OFF"
flyButton.TextScaled = true
flyButton.Parent = menu

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -20, 0, 45)
speedButton.Position = UDim2.fromOffset(10, 110)
speedButton.Text = "SPEED: 16"
speedButton.TextScaled = true
speedButton.Parent = menu

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(1, -20, 0, 45)
hideButton.Position = UDim2.fromOffset(10, 165)
hideButton.Text = "HIDE MENU"
hideButton.TextScaled = true
hideButton.Parent = menu

local flying = false
local speed = 16
local flyConnection

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function setSpeed()
    local character = getCharacter()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function stopFly()
    flying = false
    flyButton.Text = "FLY: OFF"

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local velocity = root:FindFirstChild("GitHubFlyVelocity")
            if velocity then
                velocity:Destroy()
            end
        end
    end
end

local function startFly()
    local character = getCharacter()
    local root = character:WaitForChild("HumanoidRootPart")

    flying = true
    flyButton.Text = "FLY: ON"

    local velocity = Instance.new("BodyVelocity")
    velocity.Name = "GitHubFlyVelocity"
    velocity.MaxForce = Vector3.new(100000, 100000, 100000)
    velocity.Velocity = Vector3.zero
    velocity.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        local direction = camera.CFrame.LookVector

        velocity.Velocity = direction * speed
    end)
end

flyButton.Activated:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

speedButton.Activated:Connect(function()
    speed = speed + 10

    if speed > 100 then
        speed = 10
    end

    speedButton.Text = "SPEED: " .. speed
    setSpeed()
end)

hideButton.Activated:Connect(function()
    menu.Visible = false
    openButton.Visible = true
end)

openButton.Activated:Connect(function()
    menu.Visible = true
    openButton.Visible = false
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    setSpeed()

    if flying then
        stopFly()
    end
end)

setSpeed()
