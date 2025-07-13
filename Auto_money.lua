local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local targetName = "Para" -- Paraların adı
local collecting = false

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Script Çalıştı yazısı
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptStatusGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
TextLabel.Position = UDim2.new(0.3, 0, 0.45, 0)
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.BackgroundTransparency = 0.5
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Script Çalıştı!"
TextLabel.Parent = ScreenGui

delay(3, function()
    ScreenGui:Destroy()
end)

local function getClosestMoney()
    local closest = nil
    local shortestDist = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == targetName and obj:IsA("BasePart") then
            local dist = (obj.Position - HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                closest = obj
                shortestDist = dist
            end
        end
    end

    return closest
end

local function moveToAndCollect(target)
    if not target or not target.Parent then return end
    collecting = true

    Humanoid:MoveTo(target.Position)
    local reached = Humanoid.MoveToFinished:Wait()

    if reached and target and target.Parent then
        target:Destroy() -- Toplama simülasyonu
    end

    collecting = false
end

spawn(function()
    while true do
        wait(10) -- Her 10 saniyede bir

        if not collecting then
            local target = getClosestMoney()
            if target then
                moveToAndCollect(target)
            end
        end
    end
end)
